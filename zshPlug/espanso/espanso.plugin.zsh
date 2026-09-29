# espanso zsh plugin — triggers con Tab, expansión con Espacio
#
# - `:xxx` + Tab: si hay un solo candidato lo completa (otro Tab lo expande);
#   si hay varios abre el selector inline con fzf (vía espanso-pick --print)
#   y al elegir inserta la expansión ya renderizada.
# - Trigger completo + Tab: expande el texto directamente.
# - Trigger completo + Espacio: expande el texto + un espacio (estilo espanso).
#
# El plugin expande él mismo porque espanso solo detecta teclas físicas
# (EVDEV), no inserciones del shell en el buffer.
#
# NOTA: el selector inline de varios candidatos usa espanso-pick + fzf
# en la misma terminal. En GUI se usa el buscador nativo
# de espanso (Super+Espacio). Este plugin solo vive en el prompt zsh.

typeset -ga _ESPANSO_TRIGGERS=()
typeset -gA _ESPANSO_MAP=()
typeset -gA _ESPANSO_VAR=()
# Cache de matches: recarga sola cuando cambian los YAML (sin acción manual).
typeset -g _ESPANSO_MTIME=0
typeset -g _ESPANSO_FILES=""

# Limpia la sugerencia fantasma de zsh-autosuggestions.
# Al asignar LBUFFER a mano, POSTDISPLAY queda con el valor viejo
# y se ve como "no pone algo al final" / texto pegado.
_espanso_clear_suggest() {
  POSTDISPLAY=
  (( $+functions[_zsh_autosuggest_fetch] )) && _zsh_autosuggest_fetch
}

_espanso_load() {
  local code
  code="$(espanso match list -j 2>/dev/null | python3 -c '
import glob, json, os, re, shlex, sys
try:
  data = json.load(sys.stdin)
except Exception:
  sys.exit(1)
trigs = []
pairs = []
for m in data:
  for t in m.get("triggers", []):
    trigs.append(t)
    pairs.append(shlex.quote(t) + " " + shlex.quote(m.get("replace", "")))
# Vars dinámicas (date/shell) desde los YAML, sin depender de PyYAML.
# match list -j solo trae replace crudo ({{mydate}}); esto permite
# renderizarlo en el shell igual que espanso en GUI.
specs = {}  # (trigger, var) -> "type:arg"
md = os.path.expanduser("~/.config/espanso/match")
files = glob.glob(os.path.join(md, "*.yml")) + glob.glob(os.path.join(md, "*", "*.yml"))
re_trig = re.compile(r"^\s*-\s*trigger:\s*[\"'"'"']?(.*?)[\"'"'"']?\s*$")
re_name = re.compile(r"^\s*-\s*name:\s*(\S+)\s*$")
re_type = re.compile(r"^\s*type:\s*(\S+)\s*$")
re_fmt = re.compile(r"^\s*format:\s*[\"'"'"']?(.*?)[\"'"'"']?\s*$")
re_cmd = re.compile(r"^\s*cmd:\s*(.*?)\s*$")
for f in files:
  try:
    lines = open(f, encoding="utf-8", errors="ignore").read().splitlines()
  except OSError:
    continue
  cur_t = None
  cur_v = None
  cur_ty = None
  for ln in lines:
    m = re_trig.match(ln)
    if m:
      cur_t = m.group(1).strip()
      cur_v = None
      cur_ty = None
      continue
    m = re_name.match(ln)
    if m and cur_t:
      cur_v = m.group(1).strip().strip("\"'"'"'")
      cur_ty = None
      continue
    m = re_type.match(ln)
    if m and cur_t and cur_v:
      cur_ty = m.group(1).strip().strip("\"'"'"'")
      continue
    m = re_fmt.match(ln)
    if m and cur_t and cur_v and cur_ty == "date":
      specs[(cur_t, cur_v)] = "date:" + m.group(1)
      continue
    m = re_cmd.match(ln)
    if m and cur_t and cur_v and cur_ty == "shell":
      arg = m.group(1).strip()
      if len(arg) >= 2 and arg[0] == arg[-1] and arg[0] in "\"'"'"'":
        arg = arg[1:-1]
      specs[(cur_t, cur_v)] = "shell:" + arg
      continue
sys.stdout.write("_ESPANSO_TRIGGERS=(" + " ".join(shlex.quote(t) for t in trigs) + ")\n")
sys.stdout.write("_ESPANSO_MAP=(" + " ".join(pairs) + ")\n")
vp = [shlex.quote(t + "::" + v) + " " + shlex.quote(s) for (t, v), s in specs.items()]
sys.stdout.write("_ESPANSO_VAR=(" + " ".join(vp) + ")")
')" || return 1
  [[ -z "$code" ]] && return 1
  _ESPANSO_TRIGGERS=()
  _ESPANSO_MAP=()
  _ESPANSO_VAR=()
  eval "$code"
}

# Recarga triggers solo si cambió la lista de YAML o alguno es más nuevo.
# Solo hace `stat` (barato); `espanso match list` + python solo al cambiar.
_espanso_maybe_reload() {
  local -a files
  files=(~/.config/espanso/match/*.yml(N) ~/.config/espanso/match/*/*.yml(N))
  local flist="${(j:,:)files}" latest=0 m f
  for f in "${files[@]}"; do
    m=$(stat -c %Y "$f" 2>/dev/null) || continue
    (( m > latest )) && latest=$m
  done
  if [[ "$flist" != "$_ESPANSO_FILES" ]] || (( latest > _ESPANSO_MTIME )); then
    _espanso_load || return 1
    _ESPANSO_FILES="$flist"
    _ESPANSO_MTIME=$latest
  fi
}
# Renderiza el replace crudo sustituyendo {{var}} con date/shell.
# Sin vars, devuelve el texto tal cual.
_espanso_render() {
  local trigger="$1" raw="${_ESPANSO_MAP[$1]}" out var key spec type arg val
  out="$raw"
  [[ "$out" != *'{{'*'}}'* ]] && { print -r -- "$out"; return }
  for key in "${(@k)_ESPANSO_VAR}"; do
    [[ "$key" == "${trigger}::"* ]] || continue
    var="${key##*::}"
    [[ "$out" == *'{{'"$var"'}}'* ]] || continue
    spec="${_ESPANSO_VAR[$key]}"
    type="${spec%%:*}"
    arg="${spec#*:}"
    val=""
    case "$type" in
      date) val="$(date +"$arg" 2>/dev/null)" ;;
      shell) val="$(sh -c "$arg" 2>/dev/null)" ;;
    esac
    out="${out//\{\{$var\}\}/$val}"
  done
  print -r -- "$out"
}

# Prefijo común más largo de un array (para completar sin fzf).
_espanso_common() {
  local prefix="$1"
  shift
  local a
  for a in "$@"; do
    while [[ "$a" != "$prefix"* ]]; do
      prefix="${prefix%?}"
      [[ -z "$prefix" ]] && { print -r -- ""; return }
    done
  done
  print -r -- "$prefix"
}

_espanso_tab() {
  _espanso_maybe_reload
  # OJO: la regex va en variable y se usa SIN comillas. Con comillas zsh la
  # trata como texto literal y nunca matchea (ese era el bug: Tab/Space no hacían nada).
  local re='(^|[[:space:];|&()])(:[A-Za-z0-9_#~-]*)$'
  if [[ $LBUFFER =~ $re ]]; then
    local prefix="${match[2]}"
    local -a matches
    if [[ "$prefix" == ":" ]]; then
      matches=("${_ESPANSO_TRIGGERS[@]}")
    else
      matches=(${(M)_ESPANSO_TRIGGERS:#${prefix}*})
    fi
    if (( ${#matches} == 0 )); then
      zle expand-or-complete
      return
    fi
    # Exacto (aunque haya otros que empiecen igual) -> expandir + espacio.
    # El espacio cierra la palabra y evita que autosuggestions
    # pegue su fantasma al final del reemplazo.
    local m _found=0
    for m in "${matches[@]}"; do
      [[ "$m" == "$prefix" ]] && { _found=1; break; }
    done
    if (( _found )) && (( ${+_ESPANSO_MAP[$prefix]} )); then
      local expansion
      expansion="$(_espanso_render "$prefix")"
      if [[ -n "$expansion" ]]; then
        LBUFFER="${LBUFFER%$prefix}${expansion} "
        _espanso_clear_suggest
      else
        zle -M "espanso: sin reemplazo para $prefix"
      fi
      return
    fi
    # Unico parcial -> completar trigger (otro Tab lo expande).
    # Sin espacio a proposito: si lo agregamos, el 2do Tab ya no
    # reconoce el trigger. Solo limpiamos el fantasma.
    if (( ${#matches} == 1 )); then
      LBUFFER="${LBUFFER%$prefix}${matches[1]}"
      _espanso_clear_suggest
      return
    fi
    # Varios -> selector inline con fzf (como antes) e inserta la
    # expansión ya renderizada. Sin espanso-pick, prefijo común o lista.
    if (( $+commands[espanso-pick] )); then
      local picked
      picked="$(espanso-pick --print --query "$prefix" 2>/dev/null)" || return
      if [[ -n "$picked" ]]; then
        LBUFFER="${LBUFFER%$prefix}${picked} "
        _espanso_clear_suggest
      fi
      return
    fi
    local common
    common="$(_espanso_common "$prefix" "${matches[@]}")"
    if [[ -n "$common" && "$common" != "$prefix" ]]; then
      LBUFFER="${LBUFFER%$prefix}${common}"
      _espanso_clear_suggest
      return
    fi
    zle -M "espanso (${#matches}): ${matches[*]}"
  else
    zle expand-or-complete
  fi
}

_espanso_space() {
  _espanso_maybe_reload
  local re='(^|[[:space:];|&()])(:[A-Za-z0-9_#~-]+)$'
  if [[ $LBUFFER =~ $re ]]; then
    local word="${match[2]}"
    if (( ${+_ESPANSO_MAP[$word]} )) && [[ -n "${_ESPANSO_MAP[$word]}" ]]; then
      local expansion
      expansion="$(_espanso_render "$word")"
      LBUFFER="${LBUFFER%$word}${expansion} "
      _espanso_clear_suggest
      return
    fi
  fi
  zle self-insert
}

# Ctrl+Y: aceptar. Si hay trigger espanso bajo el cursor lo expande o
# completa (igual que Tab); si no, acepta la sugerencia de
# zsh-autosuggestions (igual que Ctrl+Espacio en ~/.zshrc:90).
_espanso_ctrl_y() {
  _espanso_maybe_reload
  local re='(^|[[:space:];|&()])(:[A-Za-z0-9_#~-]*)$'
  if [[ $LBUFFER =~ $re ]]; then
    local prefix="${match[2]}"
    if [[ -n "$prefix" && "$prefix" != ":" ]]; then
      local -a matches
      matches=(${(M)_ESPANSO_TRIGGERS:#${prefix}*})
      if (( ${#matches} > 0 )); then
        local m _found=0
        for m in "${matches[@]}"; do
          [[ "$m" == "$prefix" ]] && { _found=1; break; }
        done
        if (( _found )) && (( ${+_ESPANSO_MAP[$prefix]} )); then
          local expansion
          expansion="$(_espanso_render "$prefix")"
          if [[ -n "$expansion" ]]; then
            LBUFFER="${LBUFFER%$prefix}${expansion} "
            _espanso_clear_suggest
            return
          fi
        elif (( ${#matches} == 1 )); then
          LBUFFER="${LBUFFER%$prefix}${matches[1]}"
          _espanso_clear_suggest
          return
        fi
      fi
    fi
  fi
  if (( $+widgets[autosuggest-accept] )); then
    zle autosuggest-accept
  elif (( $+functions[_zsh_autosuggest_accept] )); then
    _zsh_autosuggest_accept
  fi
}

zle -N _espanso_tab
zle -N _espanso_space
zle -N _espanso_ctrl_y
bindkey -M emacs '^I' _espanso_tab
bindkey -M viins '^I' _espanso_tab
bindkey -M emacs ' ' _espanso_space
bindkey -M viins ' ' _espanso_space
# Ctrl+Y acepta (pisa yank de emacs a pedido del usuario).
bindkey -M emacs '^Y' _espanso_ctrl_y
bindkey -M viins '^Y' _espanso_ctrl_y

alias espanso-reload='_ESPANSO_MTIME=0; _espanso_maybe_reload && echo "espanso: ${#_ESPANSO_TRIGGERS} triggers cargados"'
