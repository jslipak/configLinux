# Respaldo de GNOME

Esta carpeta guarda una copia portable de la configuración de GNOME de este equipo:

- preferencias y atajos en `config/dconf.ini`;
- extensiones en `extensions/user/`, incluyendo cuáles estaban habilitadas;
- temas, iconos, fuentes y archivos de GTK;
- autostart;
- `ydotool` para gestos y atajos: configuración de usuario y preferencias relacionadas.

El respaldo no incluye contraseñas, llaveros, sesiones, historial de shell ni el perfil completo de las aplicaciones. `dconf.ini` puede contener preferencias personales, pero las rutas se guardan de forma portable como `__HOME__`; revisá su contenido si querés compartir públicamente tus preferencias de GNOME.

## Hacer un backup

En la computadora cuyo entorno querés guardar:

```bash
cd ~/gnome
./scripts/backup.sh
```

El script guarda únicamente la configuración de GNOME en `config/`, `extensions/`, `themes/`, `icons/`, `fonts/` y `manifest/`. No instala paquetes, no recopila inventarios y no solicita contraseñas.

## Restaurar en otra computadora

Primero cloná o copiá la carpeta en la computadora nueva:

```bash
git clone https://github.com/jslipak/configLinux.git
cd configLinux/gnome
```

Para restaurar la configuración de GNOME ejecutá:

```bash
cd ~/configLinux/gnome
./scripts/restore.sh
```

El script pide confirmación. Para omitirla:

```bash
./scripts/restore.sh --yes
```

`--config-only` y `--skip-packages` se conservan por compatibilidad, pero la restauración ya no instala paquetes en ningún caso. `--dry-run` solo muestra las acciones.

La configuración actual usa 4 workspaces fijos: `Super`+`F1…F4` cambia de workspace, `Super`+`Shift`+`1…4` mueve la ventana, y `Super`+`,`/`.` navega entre workspaces (`Shift` también mueve la ventana). Estos atajos se restauran explícitamente desde `config/gsettings-org-gnome-desktop-wm-keybindings.txt`.

El respaldo es portable: las rutas personales se guardan como `__HOME__` y el restaurador las adapta automáticamente al usuario de la máquina nueva. La configuración de monitores se excluye completamente porque cada equipo la configura por separado. Después de restaurar, cerrá sesión y volvé a entrar para que GNOME Shell y las extensiones tomen el estado nuevo.

## Extensiones y atajos restaurados

El respaldo actual contiene estas extensiones de GNOME:

- `focus-changer@heartmire` — cambia el foco entre ventanas con `Super`+`H/J/K/L` (las preferencias guardadas usan `Alt`+`Super`+`H/J/K/L`);
- `copyous@boerdereinar.dev` — gestor de portapapeles;
- `hotedge@jonathan.jdoda.ca` — activa la vista general desde el borde inferior.

Las extensiones se copian desde `extensions/user/`; sus preferencias se guardan en `config/gnome-shell-extensions.ini` y la lista que debe quedar habilitada en `extensions/enabled.gvariant`. Las aplicaciones, incluido Extension Manager, se instalan aparte.

Si una extensión no aparece inmediatamente después de restaurar, cerrá sesión y volvé a entrar. Para comprobarlas:

```bash
gnome-extensions list
gsettings get org.gnome.shell enabled-extensions
```

## Si `ydotool` no arranca

El síntoma era `failed to open uinput device: Permission denied`. La corrección permanente es que el usuario pertenezca al grupo `input` y que `ydotool.service` esté activo:

```bash
id -nG
systemctl --user status ydotool.service
```

La instalación de paquetes queda fuera del alcance de este repositorio. Si falta `ydotool`, instalalo aparte según la distribución antes de aplicar la configuración correspondiente.
