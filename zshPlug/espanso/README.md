# zshPlug — plugin espanso para zsh

Autocompleta triggers de espanso con `:` + `Tab` y expande el texto en terminal.
El plugin expande él mismo porque espanso solo detecta teclas físicas (EVDEV),
no inserciones del shell en el buffer.

## Requisitos

- zsh + oh-my-zsh
- `espanso` en PATH (`espanso match list` debe listar tus triggers)
- `python3` (lee `espanso match list -j` y los YAML, sin PyYAML)
- `fzf` (selector inline cuando hay varios candidatos)
- En Wayland: `wl-copy` / `wl-paste`

## Instalación

Opción A — oh-my-zsh (recomendada):
```sh
mkdir -p ~/.oh-my-zsh/custom/plugins/espanso
cp configLinux/zshPlug/espanso/espanso.plugin.zsh ~/.oh-my-zsh/custom/plugins/espanso/
# en ~/.zshrc (o configLinux/.zshrc):
plugins=(... espanso)
exec zsh
```

Opción B — manual sin oh-my-zsh:
```sh
mkdir -p ~/.zsh-plugins/espanso
cp configLinux/zshPlug/espanso/espanso.plugin.zsh ~/.zsh-plugins/espanso/
# en ~/.zshrc:
source ~/.zsh-plugins/espanso/espanso.plugin.zsh
exec zsh
```

Verificar:
```sh
espanso match list --only-triggers
# escribe : + Tab en el prompt
```

## Uso en zsh

- `:` + `Tab`: un candidato → completa (otro `Tab` expande); varios → abre
  selector fzf inline y al elegir inserta la expansión ya renderizada
  (aceptar: `Enter` o `Ctrl+Y`, navegar: `Tab`/`Shift+Tab`).
- Trigger completo + `Tab` o + `Espacio`: expande el texto
  (ej: `:iadoc#` → la instrucción larga).
- `Ctrl+Y`: acepta. Si hay trigger espanso bajo el cursor lo expande/completa;
  si no, acepta la sugerencia de zsh-autosuggestions
  (igual que `Ctrl+Espacio`). Pisa `yank` de emacs a pedido.
- `espanso-reload`: fuerza recarga (igual es automática: el plugin detecta
  YAML nuevos o modificados con `stat` en cada Tab/Espacio/`Ctrl+Y`, sin
  acción tuya).
  (Ojo: esto cubre matches nuevos; si cambia el propio plugin, shell nueva o
  `source ~/.oh-my-zsh/custom/plugins/espanso/espanso.plugin.zsh`.)

Vars dinámicas (`:date#`, `:shell#`): el plugin las renderiza igual que
espanso en GUI (fecha con `date`, shell con `sh -c`). `match list -j` solo
trae el crudo (`{{mydate}}`); el parseo de YAML está en `_espanso_load`.

## Uso en tmux / opencode (sin GUI de espanso)

El daemon expande directo al escribir `:trigger#` también dentro de opencode.
Si no te acordás el trigger: `prefijo + e` (ej: `Ctrl+B, E`) abre el selector
fzf en popup y **pega solo** en el pane de origen (buffer tmux `espanso`,
bracketed-paste). Aceptar: `Enter` o `Ctrl+Y`; `Esc` cancela silencioso.
Definido en `configLinux/.tmux.conf` (symlink desde `~/.tmux.conf`).
Bloque exacto:

```tmux
set -ga update-environment WAYLAND_DISPLAY
set -ga update-environment XDG_RUNTIME_DIR

# espanso sin GUI: prefix + e abre el selector fzf en popup y pega
# directo en el pane de origen (opencode/terminal). Aceptar: Enter o Ctrl+Y.
# El popup guarda en el buffer `espanso` y al cerrar lo pega con bracketed-paste.
bind-key e run-shell 'P=#{pane_id}; tmux delete-buffer -b espanso 2>/dev/null; tmux display-popup -E -w 70% -h 50% "espanso-pick --print | tmux load-buffer -b espanso -" >/dev/null 2>&1; tmux show-buffer -b espanso >/dev/null 2>&1 && tmux paste-buffer -b espanso -p -t "$P" >/dev/null 2>&1; exit 0'
```

Notas: requiere tmux ≥ 3.2 (popups); `prefijo+e` estaba libre (no es default
ni lo usa ningún plugin de tpm); `Esc` en el selector cancela silencioso
(el `exit 0` evita el `returned 1`). Aplicar en vivo sin reiniciar:

```sh
tmux bind-key e run-shell 'P=#{pane_id}; tmux delete-buffer -b espanso 2>/dev/null; tmux display-popup -E -w 70% -h 50% "espanso-pick --print | tmux load-buffer -b espanso -" >/dev/null 2>&1; tmux show-buffer -b espanso >/dev/null 2>&1 && tmux paste-buffer -b espanso -p -t "$P" >/dev/null 2>&1; exit 0'
```

## Uso en GUI y otros programas

El daemon expande al escribir; el buscador nativo es `Super+Espacio`
(`search_shortcut: META+SPACE` en `~/.config/espanso/config/default.yml`).

Picker global opcional (dado de baja: era `Super+E` → quitado a pedido):
```sh
espanso-pick --copy    # elige con fzf, copia y avisa para pegar con Ctrl+V
espanso-pick --paste   # idem + auto-pega (necesita wtype: sudo pacman -S wtype)
```
Para recrear un atajo global con otra tecla:
```sh
P=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '$P']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$P name 'espanso-pick'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$P binding '<Super>e'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$P command 'kitty --class espanso-pick -e espanso-pick --copy'
```
Flujo en opencode GUI: atajo → elegís → `Ctrl+V` en el prompt.

## Archivos (en esta misma carpeta)

- `espanso.plugin.zsh`: copia fiel de `~/.oh-my-zsh/custom/plugins/espanso/espanso.plugin.zsh`
- `espanso-pick`: script fzf (symlink en `~/.local/bin/` para tenerlo en PATH).
  Renderiza vars date/shell (antes devolvía `{{...}}` crudos).
