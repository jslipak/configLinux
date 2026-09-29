# Espanso en Wayland: lentitud e inyección (keys vs clipboard, delays EVDEV)

Registro general de este tipo de problemas en Arch + GNOME Wayland + kitty,
layout `us+intl`. Cada caso nuevo va como entrada fechada en Historial;
las reglas y pendientes son vivos.

## El problema (tipo)

Expandir tarda segundos, pega contenido viejo del clipboard, o salen
mayúsculas/basura aleatoria. Causas típicas, en orden de sospecha:

1. `force_mode: keys` + delays altos → tipeo lento tecla por tecla (EVDEV).
2. Backend clipboard en kitty → atajo mal (`CTRL+V` vs `CTRL+SHIFT+V`) o race
   (pega lo anterior). En GUI el clipboard anda bien.
3. Sin `WaylandAppInfoProvider` en GNOME → `filter_exec`/`filter_class` no
   aplican (`config/kitty.yml` muerto). No se puede partir por app.
4. `evdev_modifier_delay` bajo → case aleatorio (`Hi theRE!`).
5. `key_delay` bajo → trigger sin borrar / teclas perdidas.
6. `pre_paste_delay` bajo → pega contenido viejo del clipboard.

## Reglas de ajuste (vivas)

- Case aleatorio: subir `evdev_modifier_delay` (40 → 60 → 80 → 100).
- Trigger sin borrar: subir `key_delay` (1 → 2 → 5).
- Clipboard viejo pegado: subir `pre_paste_delay` y `restore_clipboard_delay`
  (150 → 400).
- Cortos (`:espanso#`, etc.): `keys` (rápidos y andan en kitty).
- Largos de GUI (`:iadoc#`, `:iastatus#`): sin `force_mode` (clipboard,
  instantáneo en GUI; en kitty usar Tab/popup, no tipeo directo).
- `:text#` (1000 caracteres, `keys`): testigo para probar velocidad de tipeo.
- Referencia instantánea: plugin zsh (`:`+Tab/Espacio/`Ctrl+Y`) y popup tmux
  (`prefijo+e`) — expanden/pegan en bloque, fuera del daemon.

## GUI nativa (`Super+Espacio`) y copiado — qué vigilar

- Flujo: buscador nativo → elegir → espanso inyecta (clipboard en largos,
  `keys` en cortos). Estado 2026-09-28: ~0.3s en largos, cortos rápido.
- Si pega contenido **viejo** del clipboard: es race de `pre_paste_delay`;
  subir a 400 (ver Reglas). Anotar fecha y app donde pasó.
- Si el buscador tarda en **abrir**: no es tunable desde config (UI propia);
  anotarlo como caso aparte.
- Si un atajo global de picker vuelve a usarse, va acá con su tecla y comando.

## Historial
### 2026-09-28 — Puesta a punto de velocidad

Síntoma: nativo (`Super+Espacio`) y tipeo directo tardaban segundos en largos;
lo propio era en el acto.

Cambios en `~/.config/espanso/config/default.yml` (worker recarga solo):

| Parámetro                 | Antes | Después |
|---------------------------|-------|---------|
| `evdev_modifier_delay`    | 100   | 40      |
| `key_delay`               | 15    | 1       |
| `inject_delay`            | 15    | 1       |
| `pre_paste_delay`         | 400   | 150     |
| `restore_clipboard_delay` | 400   | 150     |

Cambios en `~/.config/espanso/match/base.yml`: `:iadoc#` y `:iastatus#` sin
`force_mode` (clipboard); resto igual; `:text#` creado como testigo.
Verificado: `:text#` íntegro (mayúsculas ok), 8 triggers, sin errores en log.

## Pendientes (vivos)

- [ ] `config/kitty.yml` muerto (sin provider no aplica): borrar o documentar.
- [ ] Si `keys` a 1/1/40 da basura en algún match, subir (son globales, afecta
  a todos).
- [ ] Mejora upstream (detección de app en GNOME, inyección rápida): sin fecha.
