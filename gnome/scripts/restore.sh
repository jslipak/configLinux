#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
HOME_DIR="${HOME:?No se pudo determinar HOME}"
DRY_RUN=0
CONFIRMED=0
SKIP_PACKAGES=0
FAILED_ITEMS=()
PACKAGE_LIST=()
PACKAGE_MANAGER=''
PACMAN_FULL_UPGRADE_OK=1
PRIVATE_ARCHIVE="$ROOT_DIR/private/system-and-programs.tar.age"
PRIVATE_ROOT="$ROOT_DIR"
PRIVATE_TMP_DIR=''

cleanup_private_data() {
  if [[ -n "$PRIVATE_TMP_DIR" && -d "$PRIVATE_TMP_DIR" ]]; then
    rm -rf -- "$PRIVATE_TMP_DIR"
  fi
}

trap cleanup_private_data EXIT

detect_package_manager() {
  if command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER=pacman
  elif command -v apt-get >/dev/null 2>&1; then
    PACKAGE_MANAGER=apt
  elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER=dnf
  elif command -v zypper >/dev/null 2>&1; then
    PACKAGE_MANAGER=zypper
  elif command -v apk >/dev/null 2>&1; then
    PACKAGE_MANAGER=apk
  fi
}

for argument in "$@"; do
  case "$argument" in
    --dry-run) DRY_RUN=1 ;;
    --yes) CONFIRMED=1 ;;
    --skip-packages) SKIP_PACKAGES=1 ;;
    --config-only) SKIP_PACKAGES=1 ;;
    -h|--help)
      printf 'Uso: %s [--dry-run] [--yes] [--skip-packages|--config-only]\n' "$0"
      exit 0
      ;;
    *)
      printf 'Argumento desconocido: %s\n' "$argument" >&2
      exit 2
      ;;
  esac
done

detect_package_manager

if (( DRY_RUN )); then
  printf 'Modo de prueba: no se modificará el equipo.\n'
elif (( ! CONFIRMED )); then
  printf 'Este script instalará paquetes y modificará la configuración de GNOME de %s.\n' "$HOME_DIR"
  read -r -p '¿Continuar? [y/N] ' answer
  [[ "$answer" =~ ^[Yy]$ ]] || { printf 'Restauración cancelada.\n'; exit 0; }
fi

copy_tree() {
  local source="$1"
  local destination="$2"
  [[ -d "$source" ]] || return 0
  if (( DRY_RUN )); then
    printf '+ copiar %s -> %s\n' "$source" "$destination"
  else
    mkdir -p "$destination"
    cp -a -- "$source"/. "$destination"/
  fi
}

copy_file() {
  local source="$1"
  local destination="$2"
  [[ -f "$source" ]] || return 0
  if (( DRY_RUN )); then
    printf '+ copiar %s -> %s\n' "$source" "$destination"
  else
    mkdir -p "$(dirname -- "$destination")"
    cp -a -- "$source" "$destination"
  fi
}

portable_file() {
  local source="$1"
  local destination="$2"
  [[ -f "$source" ]] || return 0
  if (( DRY_RUN )); then
    printf '+ copiar y adaptar %s -> %s\n' "$source" "$destination"
  else
    mkdir -p "$(dirname -- "$destination")"
    sed "s|__HOME__|$HOME_DIR|g" "$source" > "$destination"
  fi
}

as_root() {
  if [[ "$EUID" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

ensure_age() {
  command -v age >/dev/null 2>&1 && return 0
  [[ -n "$PACKAGE_MANAGER" ]] || return 1
  printf 'age no está instalado; se instalará para abrir el respaldo privado.\n'
  case "$PACKAGE_MANAGER" in
    pacman) as_root pacman -S --needed --noconfirm age ;;
    apt) as_root apt-get update && as_root apt-get install -y age ;;
    dnf) as_root dnf install -y age ;;
    zypper) as_root zypper --non-interactive install age ;;
    apk) as_root apk add age ;;
  esac
  command -v age >/dev/null 2>&1
}

private_path() {
  local relative_path="$1"
  if [[ -f "$PRIVATE_ROOT/$relative_path" ]]; then
    printf '%s\n' "$PRIVATE_ROOT/$relative_path"
  else
    printf '%s\n' "$ROOT_DIR/$relative_path"
  fi
}

prepare_private_data() {
  if [[ ! -s "$PRIVATE_ARCHIVE" ]]; then
    printf 'Aviso: no se encontró %s; se omiten paquetes privados y paquetes nativos.\n' "$PRIVATE_ARCHIVE" >&2
    return 0
  fi

  if (( DRY_RUN )); then
    if command -v age >/dev/null 2>&1; then
      printf '+ age -d -o <temporary-file> %s\n' "$PRIVATE_ARCHIVE"
    else
      printf '+ instalar age y descifrar %s si se proporciona la contraseña\n' "$PRIVATE_ARCHIVE"
    fi
    return 0
  fi

  if ! ensure_age; then
    printf 'Aviso: no se pudo instalar age; se continúa solo con la configuración pública.\n' >&2
    return 0
  fi

  PRIVATE_TMP_DIR="$(mktemp -d)"
  private_tar="$PRIVATE_TMP_DIR/private.tar"
  if ! age -d -o "$private_tar" "$PRIVATE_ARCHIVE"; then
    printf 'Aviso: no se pudo descifrar el respaldo privado; se continúa sin él.\n' >&2
    rm -rf -- "$PRIVATE_TMP_DIR"
    PRIVATE_TMP_DIR=''
    return 0
  fi

  if ! tar -xf "$private_tar" -C "$PRIVATE_TMP_DIR"; then
    printf 'Aviso: el respaldo privado no es válido; se continúa sin él.\n' >&2
    rm -rf -- "$PRIVATE_TMP_DIR"
    PRIVATE_TMP_DIR=''
    return 0
  fi
  PRIVATE_ROOT="$PRIVATE_TMP_DIR"
}

record_failure() {
  FAILED_ITEMS+=("$1")
}

is_excluded_package() {
  local package="$1"
  local excludes_file="$(private_path programs/restore-exclude.txt)"
  [[ -s "$excludes_file" ]] && grep -Fxiq -- "$package" "$excludes_file"
}

read_package_list() {
  local list_file="$1"
  local package=''
  PACKAGE_LIST=()

  while IFS= read -r package; do
    [[ -n "$package" ]] || continue
    if is_excluded_package "$package"; then
      printf 'Paquete excluido de la restauración: %s\n' "$package"
      continue
    fi
    PACKAGE_LIST+=("$package")
  done < <(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$list_file")
}

restore_ydotool() {
  # ydotoold necesita leer/escribir /dev/uinput. El paquete instala la regla
  # udev con grupo input, pero una instalación nueva no agrega automáticamente
  # al usuario a ese grupo ni carga el módulo del kernel.
  if ! command -v ydotool >/dev/null 2>&1 &&
    [[ ! -f /usr/lib/systemd/user/ydotool.service ]]; then
    return 0
  fi

  local restore_user="${SUDO_USER:-${USER:-$(id -un)}}"

  if ! getent group input >/dev/null 2>&1; then
    printf 'Advertencia: no existe el grupo input; no se puede configurar ydotool.\n' >&2
    record_failure 'ydotool: no existe el grupo input'
    return 0
  fi

  if ! id -nG "$restore_user" | tr ' ' '\n' | grep -Fxq input; then
    if (( DRY_RUN )); then
      printf '+ sudo usermod -aG input %s\n' "$restore_user"
    else
      if as_root usermod -aG input "$restore_user"; then
        printf 'ydotool: %s fue agregado al grupo input. Cerrá sesión o reiniciá para conservar el acceso tras reiniciar.\n' "$restore_user"
      else
        record_failure "ydotool: no se pudo agregar $restore_user al grupo input"
      fi
    fi
  fi

  if [[ ! -e /dev/uinput ]]; then
    if (( DRY_RUN )); then
      printf '+ sudo modprobe uinput\n'
    elif command -v modprobe >/dev/null 2>&1; then
      if ! as_root modprobe uinput; then
        record_failure 'ydotool: no se pudo cargar el módulo uinput'
      fi
    else
      printf 'Advertencia: modprobe no está disponible; no se pudo cargar uinput.\n' >&2
    fi
  fi

  # El grupo nuevo no entra en el proceso de la sesión actual hasta volver a
  # iniciar sesión. Esta ACL permite que el servicio funcione inmediatamente;
  # el grupo input es la solución permanente después de volver a entrar.
  if [[ -e /dev/uinput ]]; then
    if ! command -v setfacl >/dev/null 2>&1 && [[ -n "$PACKAGE_MANAGER" ]]; then
      if (( DRY_RUN )); then
        printf '+ instalar acl mediante %s\n' "$PACKAGE_MANAGER"
      else
        if ! install_native_package acl; then
          record_failure 'ydotool: no se pudo instalar acl para setfacl'
        fi
      fi
    fi

    if command -v setfacl >/dev/null 2>&1; then
      if (( DRY_RUN )); then
        printf '+ sudo setfacl -m u:%s:rw /dev/uinput\n' "$restore_user"
      else
        if ! as_root setfacl -m "u:${restore_user}:rw" /dev/uinput; then
          record_failure 'ydotool: no se pudo dar acceso a /dev/uinput'
        fi
      fi
    else
      printf 'Advertencia: setfacl no está disponible; el acceso quedará activo después de cerrar sesión y volver a entrar.\n' >&2
      record_failure 'ydotool: falta setfacl'
    fi
  fi

  if ! command -v systemctl >/dev/null 2>&1; then
    return 0
  fi

  if (( DRY_RUN )); then
    printf '+ systemctl --user enable --now ydotool.service\n'
  elif [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" || -S "${XDG_RUNTIME_DIR:-}/bus" ]]; then
    systemctl --user reset-failed ydotool.service 2>/dev/null || true
    if ! systemctl --user enable --now ydotool.service; then
      printf 'Advertencia: no se pudo iniciar ydotool.service; revisá su estado después de volver a entrar.\n' >&2
      record_failure 'ydotool: no se pudo iniciar ydotool.service'
    fi
  else
    printf 'Aviso: no hay un bus de sesión disponible; ydotool.service se habilitará al iniciar sesión.\n'
  fi
}

install_native_packages() {
  local list_file="$1"
  [[ -s "$list_file" ]] || return 0
  [[ -n "$PACKAGE_MANAGER" ]] || {
    printf 'No se encontró un gestor de paquetes compatible; se omite %s.\n' "$(basename -- "$list_file")"
    (( DRY_RUN )) || record_failure "paquetes: no hay gestor compatible para $(basename -- "$list_file")"
    return 0
  }

  read_package_list "$list_file"
  (( ${#PACKAGE_LIST[@]} )) || return 0
  local package=''
  for package in "${PACKAGE_LIST[@]}"; do
    if (( DRY_RUN )); then
      printf '+ instalar %s mediante %s\n' "$package" "$PACKAGE_MANAGER"
    elif ! install_native_package "$package"; then
      printf 'Error: se omitió el paquete %s; se continúa con la restauración.\n' "$package" >&2
      record_failure "$PACKAGE_MANAGER: $package"
    fi
  done
}

install_native_package() {
  local package="$1"
  case "$PACKAGE_MANAGER" in
    pacman) as_root pacman -S --needed --noconfirm "$package" ;;
    apt) as_root apt-get install -y "$package" ;;
    dnf) as_root dnf install -y "$package" ;;
    zypper) as_root zypper --non-interactive install "$package" ;;
    apk) as_root apk add "$package" ;;
    *) return 1 ;;
  esac
}

prepare_pacman_system() {
  [[ "$PACKAGE_MANAGER" == pacman ]] || return 0

  printf 'Sincronizando y actualizando completamente el sistema Arch antes de instalar paquetes.\n'
  if ! as_root pacman -Syu --noconfirm; then
    printf 'Error: no se pudo completar la actualización de Arch; se continúa con advertencias.\n' >&2
    PACMAN_FULL_UPGRADE_OK=0
    record_failure 'pacman: actualización completa'
  fi
}

ensure_aur_helper() {
  local list_file="$1"
  local bootstrap_dir=""

  [[ "$PACKAGE_MANAGER" == pacman ]] || return 0
  [[ -s "$list_file" ]] || return 0
  if command -v paru >/dev/null 2>&1 && paru --version >/dev/null 2>&1; then
    return 0
  fi
  if command -v yay >/dev/null 2>&1 && yay --version >/dev/null 2>&1; then
    return 0
  fi

  printf 'No se encontró paru ni yay; se instalarán las herramientas de compilación y se preparará paru desde AUR.\n'

  if ! as_root pacman -S --needed --noconfirm base-devel git; then
    printf 'Error: no se pudieron instalar base-devel y git; se omitirán los paquetes AUR.\n' >&2
    return 1
  fi

  bootstrap_dir="$(mktemp -d "${TMPDIR:-/tmp}/paru-bootstrap.XXXXXX")"
  if ! git clone https://aur.archlinux.org/paru-bin.git "$bootstrap_dir/paru-bin"; then
    printf 'Error: no se pudo descargar paru-bin; se omitirán los paquetes AUR.\n' >&2
    rm -rf -- "$bootstrap_dir"
    return 1
  fi

  if ! (cd "$bootstrap_dir/paru-bin" && makepkg -si --noconfirm); then
    printf 'Error: no se pudo compilar o instalar paru; se omitirán los paquetes AUR.\n' >&2
    rm -rf -- "$bootstrap_dir"
    return 1
  fi

  rm -rf -- "$bootstrap_dir"
  command -v paru >/dev/null 2>&1 && paru --version >/dev/null 2>&1 ||
    command -v yay >/dev/null 2>&1 && yay --version >/dev/null 2>&1
}

install_foreign_packages() {
  local list_file="$1"
  [[ -s "$list_file" ]] || return 0

  if [[ "$PACKAGE_MANAGER" != pacman ]]; then
    printf 'Los paquetes AUR solo se pueden restaurar en Arch/Manjaro; se omiten.\n' >&2
    return 0
  fi

  read_package_list "$list_file"
  local filtered_package_list=()
  local package=''
  for package in "${PACKAGE_LIST[@]}"; do
    case "$package" in
      paru|paru-bin|yay|yay-debug) ;;
      *) filtered_package_list+=("$package") ;;
    esac
  done
  PACKAGE_LIST=("${filtered_package_list[@]}")
  (( ${#PACKAGE_LIST[@]} )) || return 0

  if (( ! PACMAN_FULL_UPGRADE_OK )); then
    printf 'Se omiten los paquetes AUR porque la actualización completa de Arch falló.\n' >&2
    record_failure 'AUR: actualización completa de Arch pendiente'
    return 0
  fi

  local helper=''
  if ! ensure_aur_helper "$list_file"; then
    record_failure "AUR: no se pudo preparar paru/yay"
    return 0
  fi

  if command -v paru >/dev/null 2>&1 && paru --version >/dev/null 2>&1; then
    helper=paru
  elif command -v yay >/dev/null 2>&1 && yay --version >/dev/null 2>&1; then
    helper=yay
  else
    printf 'No se encontró paru ni yay. Se omiten los paquetes AUR de %s.\n' "$list_file" >&2
    (( DRY_RUN )) || record_failure "AUR: no se encontró paru ni yay para $(basename -- "$list_file")"
    return 0
  fi

  local package=''
  for package in "${PACKAGE_LIST[@]}"; do
    if (( DRY_RUN )); then
      printf '+ %s -S --needed --noconfirm %s\n' "$helper" "$package"
    elif ! "$helper" -S --needed --noconfirm "$package"; then
      printf 'Error: se omitió el paquete AUR %s; se continúa con la restauración.\n' "$package" >&2
      record_failure "AUR: $package"
    fi
  done
}

native_package_list() {
  local candidate=''
  case "$PACKAGE_MANAGER" in
    apt) candidate="$(private_path programs/apt-manual.txt)" ;;
    dnf) candidate="$(private_path programs/dnf-userinstalled.txt)" ;;
    zypper) candidate="$(private_path programs/zypper-installed.txt)" ;;
    apk) candidate="$(private_path programs/apk-installed.txt)" ;;
    *) candidate="$(private_path programs/pacman-explicit-native.txt)" ;;
  esac

  if [[ -s "$candidate" ]]; then
    printf '%s\n' "$candidate"
  else
    # Respaldos anteriores solo contienen el inventario de Arch. Se usa como
    # compatibilidad de último recurso; los paquetes que no existan se omiten.
    printf '%s\n' "$(private_path programs/pacman-explicit-native.txt)"
  fi
}

restore_flatpak_remotes() {
  local remotes_file="$(private_path programs/flatpak-remotes.tsv)"
  [[ -s "$remotes_file" ]] || return 0
  if ! command -v flatpak >/dev/null 2>&1; then
    (( DRY_RUN )) || record_failure 'Flatpak: no está instalado'
    return 0
  fi

  while IFS=$'\t' read -r name url options; do
    [[ -n "${name:-}" && -n "${url:-}" ]] || continue
    if [[ "${options:-}" == *system* ]]; then
      if (( DRY_RUN )); then
        printf '+ flatpak remote-add --system --if-not-exists %s %s\n' "$name" "$url"
      elif ! as_root flatpak remote-add --system --if-not-exists "$name" "$url"; then
        printf 'Error: no se pudo agregar el remoto Flatpak %s; se continúa.\n' "$name" >&2
        record_failure "Flatpak remoto: $name"
      fi
    else
      if (( DRY_RUN )); then
        printf '+ flatpak remote-add --user --if-not-exists %s %s\n' "$name" "$url"
      elif ! flatpak remote-add --user --if-not-exists "$name" "$url"; then
        printf 'Error: no se pudo agregar el remoto Flatpak %s; se continúa.\n' "$name" >&2
        record_failure "Flatpak remoto: $name"
      fi
    fi
  done < "$remotes_file"
}

restore_flatpak_apps() {
  local scope="$1"
  local apps_file="$(private_path programs/flatpak-apps-${scope}.tsv)"
  [[ -s "$apps_file" ]] || return 0
  if ! command -v flatpak >/dev/null 2>&1; then
    (( DRY_RUN )) || record_failure "Flatpak: no está instalado para $scope"
    return 0
  fi

  while IFS=$'\t' read -r app origin; do
    [[ -n "${app:-}" ]] || continue
    origin="${origin:-flathub}"
    if [[ "$scope" == user ]]; then
      if (( DRY_RUN )); then
        printf '+ flatpak install --user -y %s %s\n' "$origin" "$app"
      elif ! flatpak install --user -y "$origin" "$app"; then
        printf 'Error: se omitió la aplicación Flatpak %s; se continúa.\n' "$app" >&2
        record_failure "Flatpak ($scope): $app"
      fi
    else
      if (( DRY_RUN )); then
        printf '+ flatpak install --system -y %s %s\n' "$origin" "$app"
      elif ! as_root flatpak install --system -y "$origin" "$app"; then
        printf 'Error: se omitió la aplicación Flatpak %s; se continúa.\n' "$app" >&2
        record_failure "Flatpak ($scope): $app"
      fi
    fi
  done < "$apps_file"
}

printf 'Restaurando desde %s\n' "$ROOT_DIR"
printf 'Gestor de paquetes detectado: %s\n' "${PACKAGE_MANAGER:-ninguno}"

if (( SKIP_PACKAGES )); then
  printf 'Se omite la instalación de paquetes.\n'
  printf 'Se omite el inventario privado cifrado.\n'
else
  prepare_private_data
  prepare_pacman_system
  install_native_packages "$(native_package_list)"
  install_foreign_packages "$(private_path programs/pacman-explicit-foreign.txt)"
  restore_flatpak_remotes
  restore_flatpak_apps user
  restore_flatpak_apps system
fi

if (( SKIP_PACKAGES )); then
  printf 'Se omite la configuración administrativa de ydotool.\n'
else
  restore_ydotool
fi

copy_tree "$ROOT_DIR/config/gtk-3.0" "$HOME_DIR/.config/gtk-3.0"
portable_file "$ROOT_DIR/config/gtk-3.0/bookmarks" "$HOME_DIR/.config/gtk-3.0/bookmarks"
copy_tree "$ROOT_DIR/config/gtk-4.0" "$HOME_DIR/.config/gtk-4.0"
copy_tree "$ROOT_DIR/config/autostart" "$HOME_DIR/.config/autostart"
copy_tree "$ROOT_DIR/extensions/user" "$HOME_DIR/.local/share/gnome-shell/extensions"
copy_tree "$ROOT_DIR/themes/user-legacy" "$HOME_DIR/.themes"
copy_tree "$ROOT_DIR/themes/user-share" "$HOME_DIR/.local/share/themes"
copy_tree "$ROOT_DIR/icons/user-legacy" "$HOME_DIR/.icons"
copy_tree "$ROOT_DIR/icons/user-share" "$HOME_DIR/.local/share/icons"
copy_tree "$ROOT_DIR/fonts/user-legacy" "$HOME_DIR/.fonts"
copy_tree "$ROOT_DIR/fonts/user-share" "$HOME_DIR/.local/share/fonts"

for file in mimeapps.list user-dirs.dirs user-dirs.locale; do
  copy_file "$ROOT_DIR/config/$file" "$HOME_DIR/.config/$file"
done

if [[ -f "$ROOT_DIR/config/dconf.ini" ]] && command -v dconf >/dev/null 2>&1; then
  if (( DRY_RUN )); then
    printf '+ dconf load / < %s\n' "$ROOT_DIR/config/dconf.ini"
  else
    dconf_file="$(mktemp)"
    trap 'rm -f -- "$dconf_file"' EXIT
    sed "s|__HOME__|$HOME_DIR|g" "$ROOT_DIR/config/dconf.ini" > "$dconf_file"
    dconf load / < "$dconf_file"
    rm -f -- "$dconf_file"
    trap - EXIT
  fi
fi

restore_gsettings_file() {
  local settings_file="$1"
  local schema=''
  local key=''
  local value=''

  [[ -s "$settings_file" ]] || return 0
  command -v gsettings >/dev/null 2>&1 || return 0

  while read -r schema key value; do
    [[ -n "$schema" && -n "$key" && -n "$value" ]] || continue
    if (( DRY_RUN )); then
      printf '+ gsettings set %s %s %s\n' "$schema" "$key" "$value"
    elif ! gsettings set "$schema" "$key" "$value"; then
      printf 'Advertencia: no se pudo restaurar %s %s.\n' "$schema" "$key" >&2
    fi
  done < "$settings_file"
}

# Reaplicar los esquemas evita que una configuración local de destino deje
# atajos o workspaces distintos de los del equipo respaldado.
for settings_file in \
  "$ROOT_DIR/config/gsettings-org-gnome-desktop-wm-keybindings.txt" \
  "$ROOT_DIR/config/gsettings-org-gnome-shell-keybindings.txt" \
  "$ROOT_DIR/config/gsettings-org-gnome-settings-daemon-plugins-media-keys.txt"; do
  restore_gsettings_file "$settings_file"
done

restore_extension_state() {
  command -v dconf >/dev/null 2>&1 || return 0

  local settings_file="$ROOT_DIR/config/gnome-shell-extensions.ini"
  local enabled_file="$ROOT_DIR/extensions/enabled.gvariant"
  local enabled_extensions=''

  if [[ -s "$settings_file" ]]; then
    if (( DRY_RUN )); then
      printf '+ dconf load /org/gnome/shell/extensions/ < %s\n' "$settings_file"
    else
      dconf load /org/gnome/shell/extensions/ < "$settings_file"
    fi
  fi

  if [[ -s "$enabled_file" ]]; then
    enabled_extensions="$(<"$enabled_file")"
    if (( DRY_RUN )); then
      printf '+ dconf write /org/gnome/shell/enabled-extensions %s\n' "$enabled_extensions"
    else
      dconf write /org/gnome/shell/enabled-extensions "$enabled_extensions"
    fi
  fi
}

restore_extension_state

if command -v fc-cache >/dev/null 2>&1; then
  if (( DRY_RUN )); then
    printf '+ fc-cache -f\n'
  else
    fc-cache -f
  fi
fi

if (( DRY_RUN )); then
  printf 'Prueba terminada; no se modificó el equipo.\n'
else
  printf 'Restauración terminada. Cerrá sesión y volvé a entrar para aplicar GNOME Shell y extensiones.\n'
fi

if (( ! DRY_RUN && ${#FAILED_ITEMS[@]} )); then
  printf '\nLa restauración terminó con errores; los elementos siguientes fueron omitidos:\n' >&2
  printf '  - %s\n' "${FAILED_ITEMS[@]}" >&2
  exit 1
fi
