# Respaldo de GNOME

Esta carpeta guarda una copia portable de la configuración de GNOME de este equipo:

- preferencias y atajos en `config/dconf.ini`;
- extensiones en `extensions/user/`, incluyendo cuáles estaban habilitadas;
- temas, iconos, fuentes y archivos de GTK;
- autostart;
- `ydotool` para gestos y atajos: módulo `uinput`, grupo `input` y servicio de usuario;
- un archivo cifrado con `age` para los inventarios privados de paquetes nativos, AUR, Flatpak, npm, pipx y Cargo.

El respaldo no incluye contraseñas, llaveros, sesiones, historial de shell ni el perfil completo de las aplicaciones. `dconf.ini` puede contener preferencias personales, pero las rutas se guardan de forma portable como `__HOME__`; revisá su contenido si querés compartir públicamente tus preferencias de GNOME.

## Actualizar el respaldo

Desde cualquier terminal de esta computadora:

```bash
cd ~/gnome
./scripts/backup.sh
```

## Restaurar en otra computadora

Primero copia esta carpeta a `~/gnome` en la computadora nueva. El restaurador detecta automáticamente `pacman`, `apt`, `dnf`, `zypper` o `apk`:

```bash
cd ~/gnome
./scripts/restore.sh --dry-run
./scripts/restore.sh --config-only
```

La configuración de usuario de GNOME es portable entre distribuciones. La restauración de paquetes nativos también intenta usar el gestor detectado: las copias nuevas guardan inventarios separados para Arch/Manjaro, Debian/Ubuntu, Fedora, openSUSE y Alpine. Como los nombres de paquetes no siempre coinciden, cualquier paquete que no exista se omite y se informa al final. Los paquetes AUR solo se restauran en Arch/Manjaro.

El respaldo es portable: las rutas personales se guardan como `__HOME__` y el restaurador las adapta automáticamente al usuario de la máquina nueva. La configuración de monitores se excluye completamente porque cada equipo la configura por separado.

`--config-only` es la opción recomendada cuando las computadoras tienen instalaciones distintas: no instala paquetes nativos ni Flatpak, omite la configuración administrativa de `ydotool` y conserva los programas propios de cada equipo. `--skip-packages` hace lo mismo con el nombre anterior.

El respaldo instala `age` si hace falta usando el gestor disponible y cifra `manifest/system.txt` junto con los inventarios de `programs/` en `private/system-and-programs.tar.age`. La contraseña se pide en la terminal y no se guarda en el repositorio. Al restaurar, si no ingresás la contraseña o `age` no está disponible, se aplica igualmente toda la configuración pública y se omite solamente la información privada.

La restauración completa pide confirmación, descifra los inventarios si proporcionás la contraseña, instala los paquetes nativos y Flatpak, copia los archivos de usuario, carga `dconf`, restaura explícitamente las preferencias y el estado habilitado de las extensiones, configura `ydotool` y reconstruye la caché de fuentes. Si no proporcionás la contraseña, continúa sin instalar los paquetes privados. Los paquetes se intentan de a uno: si uno falla, se omite, se continúa y se informa al final con código de salida de error. Para una ejecución confirmada sin preguntas usa `./scripts/restore.sh --yes`.

Con `--config-only` solo se restaura la configuración de usuario: no se instalan paquetes, no se descifra el inventario privado y no se configura `ydotool`. Esta es la opción recomendada para computadoras con instalaciones diferentes.

La configuración actual usa 4 workspaces fijos: `Super`+`F1…F4` cambia de workspace, `Super`+`Shift`+`1…4` mueve la ventana, y `Super`+`,`/`.` navega entre workspaces (`Shift` también mueve la ventana). Estos atajos se restauran explícitamente desde `config/gsettings-org-gnome-desktop-wm-keybindings.txt`.

Los paquetes AUR quedan dentro del archivo privado cifrado; para restaurarlos hace falta proporcionar la contraseña y tener `paru` o `yay` instalado en el equipo nuevo. Revisá esa lista antes de instalar en hardware distinto, especialmente paquetes de kernel, firmware y drivers.

Los paquetes que no querés restaurar se anotan en `programs/restore-exclude.txt`. Opera quedó excluido porque no se usa y había dado problemas. Para excluir otro paquete, agregá su nombre en ese archivo; el script lo salta sin marcarlo como error.

Después de una restauración completa, cerrá sesión y volvé a entrar para que GNOME Shell, el grupo `input` y todas las extensiones tomen el estado nuevo. En ese modo el script agrega el usuario al grupo `input`, carga `uinput`, aplica una ACL temporal a `/dev/uinput` para que `ydotoold` pueda arrancar en la sesión actual y habilita `ydotool.service`. Con `--config-only`, esta configuración administrativa se omite.

## Extensiones y atajos restaurados

El respaldo actual contiene estas extensiones de GNOME:

- `focus-changer@heartmire` — cambia el foco entre ventanas con `Super`+`H/J/K/L` (las preferencias guardadas usan `Alt`+`Super`+`H/J/K/L`);
- `copyous@boerdereinar.dev` — gestor de portapapeles;
- `hotedge@jonathan.jdoda.ca` — activa la vista general desde el borde inferior.

También se guarda Extension Manager (`com.mattjakeman.ExtensionManager`) como aplicación Flatpak. Las extensiones se copian desde `extensions/user/`; sus preferencias se guardan en `config/gnome-shell-extensions.ini` y la lista que debe quedar habilitada en `extensions/enabled.gvariant`.

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

Si el script se ejecutó con `--skip-packages`, instalá primero `ydotool`. Después de agregar el grupo `input`, es necesario cerrar sesión o reiniciar; no compartas la contraseña de `sudo`.
