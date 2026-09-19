# Respaldo de GNOME

Esta carpeta guarda una copia portable de la configuración de GNOME de este equipo:

- preferencias y atajos en `config/dconf.ini`;
- extensiones en `extensions/user/`, incluyendo cuáles estaban habilitadas;
- temas, iconos, fuentes y archivos de GTK;
- autostart;
- `ydotool` para gestos y atajos: módulo `uinput`, grupo `input` y servicio de usuario;
- un archivo cifrado con `age` para los inventarios privados de paquetes nativos, AUR, Flatpak, npm, pipx y Cargo.

El respaldo no incluye contraseñas, llaveros, sesiones, historial de shell ni el perfil completo de las aplicaciones. `dconf.ini` puede contener preferencias personales, pero las rutas se guardan de forma portable como `__HOME__`; revisá su contenido si querés compartir públicamente tus preferencias de GNOME.

## Hacer un backup

En la computadora cuyo entorno querés guardar:

```bash
cd ~/gnome
./scripts/backup.sh
```

El script guarda la configuración pública en `config/`, `extensions/`, `themes/`, `icons/` y `fonts/`. También genera el inventario de paquetes y lo cifra en:

```text
private/system-and-programs.tar.age
```

Durante el backup se solicita una contraseña para cifrar ese archivo. Guardá esa contraseña: será necesaria para instalar los paquetes en otra computadora. El archivo contiene inventarios de paquetes nativos, AUR, Flatpak, npm, pipx y Cargo.

La carpeta `private/` no debe subirse al repositorio público y normalmente está excluida de Git. Por eso un `git clone` copia la configuración, pero no copia el inventario privado. Transferí `private/system-and-programs.tar.age` por separado y de forma segura.

## Restaurar en otra computadora

Primero cloná o copiá la carpeta en la computadora nueva:

```bash
git clone https://github.com/jslipak/configLinux.git
cd configLinux/gnome
```

Después copiá manualmente el archivo privado desde la computadora original. Por ejemplo, usando una carpeta compartida de VirtualBox:

```bash
mkdir -p ~/configLinux/gnome/private
cp /media/sf_NOMBRE_COMPARTIDA/system-and-programs.tar.age \
  ~/configLinux/gnome/private/
```

La ruta final debe ser:

```text
~/configLinux/gnome/private/system-and-programs.tar.age
```

El restaurador detecta automáticamente `pacman`, `apt`, `dnf`, `zypper` o `apk`.

Para restaurar todo —configuración y paquetes— ejecutá:

```bash
cd ~/configLinux/gnome
./scripts/restore.sh
```

El script pide confirmación y luego la contraseña del archivo `age`. Para omitir la confirmación inicial:

```bash
./scripts/restore.sh --yes
```

Para restaurar únicamente la configuración de GNOME, sin paquetes ni contraseña:

```bash
./scripts/restore.sh --config-only
```

`--skip-packages` es un alias antiguo de `--config-only`. `--dry-run` solo muestra las acciones de configuración y no instala ni descifra paquetes.

La configuración de usuario de GNOME es portable entre distribuciones. La restauración de paquetes nativos también intenta usar el gestor detectado: las copias nuevas guardan inventarios separados para Arch/Manjaro, Debian/Ubuntu, Fedora, openSUSE y Alpine. Como los nombres de paquetes no siempre coinciden, cualquier paquete que no exista se omite y se informa al final. Los paquetes AUR solo se restauran en Arch/Manjaro.

El respaldo es portable: las rutas personales se guardan como `__HOME__` y el restaurador las adapta automáticamente al usuario de la máquina nueva. La configuración de monitores se excluye completamente porque cada equipo la configura por separado. Si falta `private/system-and-programs.tar.age`, se restaura solamente la configuración pública y se muestra un aviso.

El respaldo instala `age` si hace falta usando el gestor disponible y cifra `manifest/system.txt` junto con los inventarios de `programs/` en `private/system-and-programs.tar.age`. La contraseña se pide en la terminal y no se guarda en el repositorio. Al restaurar, si no ingresás la contraseña o `age` no está disponible, se aplica igualmente toda la configuración pública y se omite solamente la información privada.

La restauración completa pide confirmación, descifra los inventarios si proporcionás la contraseña, actualiza completamente Arch con `pacman -Syu` antes de instalar paquetes, instala los paquetes nativos y Flatpak, copia los archivos de usuario, carga `dconf`, restaura explícitamente las preferencias y el estado habilitado de las extensiones, configura `ydotool` y reconstruye la caché de fuentes. Si no proporcionás la contraseña, continúa sin instalar los paquetes privados. Los paquetes se intentan de a uno: si uno falla, se omite, se continúa y se informa al final con código de salida de error. Para una ejecución confirmada sin preguntas usa `./scripts/restore.sh --yes`.

La configuración actual usa 4 workspaces fijos: `Super`+`F1…F4` cambia de workspace, `Super`+`Shift`+`1…4` mueve la ventana, y `Super`+`,`/`.` navega entre workspaces (`Shift` también mueve la ventana). Estos atajos se restauran explícitamente desde `config/gsettings-org-gnome-desktop-wm-keybindings.txt`.

Los paquetes AUR quedan dentro del archivo privado cifrado. En Arch/Manjaro y derivados, si no existe `paru` ni `yay`, el restaurador instala `base-devel` y `git`, construye `paru-bin` desde AUR y luego instala esa lista automáticamente. En otras distribuciones los paquetes AUR se omiten porque no son compatibles con su gestor nativo. Revisá esa lista antes de instalar en hardware distinto, especialmente paquetes de kernel, firmware y drivers.

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
