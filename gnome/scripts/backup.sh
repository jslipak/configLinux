#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
HOME_DIR="${HOME:?No se pudo determinar HOME}"
PRIVATE_DIR="$ROOT_DIR/private"
PACKAGE_MANAGER=''

detect_package_manager() {
  if command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER=pacman
  elif command -v apt-mark >/dev/null 2>&1; then
    PACKAGE_MANAGER=apt
  elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER=dnf
  elif command -v zypper >/dev/null 2>&1; then
    PACKAGE_MANAGER=zypper
  elif command -v apk >/dev/null 2>&1; then
    PACKAGE_MANAGER=apk
  fi
}

detect_package_manager

as_root() {
  if [[ "$EUID" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

ensure_age() {
  command -v age >/dev/null 2>&1 && return 0
  printf 'age no está instalado; se instalará para cifrar el respaldo privado.\n'
  case "$PACKAGE_MANAGER" in
    pacman) as_root pacman -S --needed --noconfirm age ;;
    apt) as_root apt-get update && as_root apt-get install -y age ;;
    dnf) as_root dnf install -y age ;;
    zypper) as_root zypper --non-interactive install age ;;
    apk) as_root apk add age ;;
    *) return 1 ;;
  esac
  command -v age >/dev/null 2>&1
}

filter_restore_excluded_packages() {
  local package=''
  local excludes_file="$ROOT_DIR/programs/restore-exclude.txt"

  while IFS= read -r package; do
    [[ -n "$package" ]] || continue
    if [[ -s "$excludes_file" ]] && grep -Fxiq -- "$package" "$excludes_file"; then
      continue
    fi
    printf '%s\n' "$package"
  done
}

mkdir -p \
  "$ROOT_DIR/config" \
  "$ROOT_DIR/extensions/user" \
  "$ROOT_DIR/themes" \
  "$ROOT_DIR/icons" \
  "$ROOT_DIR/fonts" \
  "$ROOT_DIR/programs" \
  "$ROOT_DIR/extras/scripts" \
  "$ROOT_DIR/manifest" \
  "$PRIVATE_DIR"

copy_tree() {
  local source="$1"
  local destination="$2"
  if [[ -d "$source" ]]; then
    mkdir -p "$destination"
    cp -a -- "$source"/. "$destination"/
  fi
}

copy_file() {
  local source="$1"
  local destination="$2"
  if [[ -f "$source" ]]; then
    mkdir -p "$(dirname -- "$destination")"
    cp -a -- "$source" "$destination"
  fi
}

portable_copy() {
  local source="$1"
  local destination="$2"
  [[ -f "$source" ]] || return 0
  mkdir -p "$(dirname -- "$destination")"
  sed "s|$HOME_DIR|__HOME__|g" "$source" > "$destination"
}

printf 'Generando respaldo de GNOME en %s\n' "$ROOT_DIR"

{
  printf 'generated_at=%s\n' "$(date --iso-8601=seconds)"
  printf 'user=portable\n'
  printf 'home=__HOME__\n\n'
  cat /etc/os-release 2>/dev/null || true
  printf '\n'
  uname -srmo 2>/dev/null || true
  printf '\n'
  gnome-shell --version 2>/dev/null || true
  printf '\nlocale\n'
  locale 2>/dev/null || true
} > "$ROOT_DIR/manifest/system.txt"

if command -v dconf >/dev/null 2>&1; then
  dconf dump / | sed "s|$HOME_DIR|__HOME__|g" > "$ROOT_DIR/config/dconf.ini" 2>/dev/null
  dconf dump /org/gnome/ | sed "s|$HOME_DIR|__HOME__|g" > "$ROOT_DIR/config/dconf-gnome.ini" 2>/dev/null
  dconf dump /org/gnome/shell/extensions/ > "$ROOT_DIR/config/gnome-shell-extensions.ini" 2>/dev/null
  dconf read /org/gnome/shell/enabled-extensions > "$ROOT_DIR/extensions/enabled.gvariant" 2>/dev/null || true
else
  : > "$ROOT_DIR/config/dconf.ini"
  printf 'dconf no está disponible en este equipo.\n' > "$ROOT_DIR/config/README.txt"
fi

if command -v gsettings >/dev/null 2>&1; then
  for schema in \
    org.gnome.desktop.interface \
    org.gnome.desktop.background \
    org.gnome.desktop.wm.keybindings \
    org.gnome.settings-daemon.plugins.media-keys \
    org.gnome.shell.keybindings; do
    safe_name="${schema//./-}"
    gsettings list-recursively "$schema" > "$ROOT_DIR/config/gsettings-${safe_name}.txt" 2>/dev/null || true
  done
fi

extension_dir="$HOME_DIR/.local/share/gnome-shell/extensions"
if [[ -d "$extension_dir" ]]; then
  find "$extension_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | LC_ALL=C sort > "$ROOT_DIR/extensions/all.txt"
  find "$extension_dir" -mindepth 2 -maxdepth 2 -name metadata.json -print0 2>/dev/null |
    while IFS= read -r -d '' metadata; do
      printf '\n===== %s =====\n' "${metadata#"$extension_dir"/}"
      sed -n '1,160p' "$metadata"
    done > "$ROOT_DIR/extensions/metadata.txt"
  copy_tree "$extension_dir" "$ROOT_DIR/extensions/user"
else
  : > "$ROOT_DIR/extensions/all.txt"
fi

if [[ -d /usr/share/gnome-shell/extensions ]]; then
  find /usr/share/gnome-shell/extensions -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
    LC_ALL=C sort > "$ROOT_DIR/extensions/system.txt"
fi

copy_tree "$HOME_DIR/.themes" "$ROOT_DIR/themes/user-legacy"
copy_tree "$HOME_DIR/.local/share/themes" "$ROOT_DIR/themes/user-share"
copy_tree "$HOME_DIR/.icons" "$ROOT_DIR/icons/user-legacy"
copy_tree "$HOME_DIR/.local/share/icons" "$ROOT_DIR/icons/user-share"
copy_tree "$HOME_DIR/.fonts" "$ROOT_DIR/fonts/user-legacy"
copy_tree "$HOME_DIR/.local/share/fonts" "$ROOT_DIR/fonts/user-share"

for directory in gtk-3.0 gtk-4.0 autostart; do
  copy_tree "$HOME_DIR/.config/$directory" "$ROOT_DIR/config/$directory"
done

portable_copy "$HOME_DIR/.config/gtk-3.0/bookmarks" "$ROOT_DIR/config/gtk-3.0/bookmarks"

for file in mimeapps.list user-dirs.dirs user-dirs.locale; do
  copy_file "$HOME_DIR/.config/$file" "$ROOT_DIR/config/$file"
done

if command -v pacman >/dev/null 2>&1; then
  pacman -Qqe | LC_ALL=C sort | filter_restore_excluded_packages > "$ROOT_DIR/programs/pacman-explicit.txt"
  pacman -Qqen | LC_ALL=C sort | filter_restore_excluded_packages > "$ROOT_DIR/programs/pacman-explicit-native.txt"
  pacman -Qqem | LC_ALL=C sort | filter_restore_excluded_packages > "$ROOT_DIR/programs/pacman-explicit-foreign.txt"
  pacman -Qq | LC_ALL=C sort > "$ROOT_DIR/programs/pacman-all-names.txt"
  pacman -Q | LC_ALL=C sort > "$ROOT_DIR/programs/pacman-installed-versions.txt"
fi

case "$PACKAGE_MANAGER" in
  apt)
    apt-mark showmanual 2>/dev/null | LC_ALL=C sort | filter_restore_excluded_packages > "$ROOT_DIR/programs/apt-manual.txt" || :
    ;;
  dnf)
    if command -v dnf5 >/dev/null 2>&1; then
      dnf5 repoquery --userinstalled --qf '%{name}' 2>/dev/null | LC_ALL=C sort > "$ROOT_DIR/programs/dnf-userinstalled.txt" || :
    elif command -v dnf >/dev/null 2>&1; then
      dnf repoquery --userinstalled --qf '%{name}' 2>/dev/null | LC_ALL=C sort > "$ROOT_DIR/programs/dnf-userinstalled.txt" || :
    fi
    ;;
  zypper)
    zypper search --installed-only --type package 2>/dev/null |
      awk -F'|' 'NR > 2 && $2 ~ /[^ -]/ {gsub(/[ *+]/, "", $2); print $2}' |
      LC_ALL=C sort -u > "$ROOT_DIR/programs/zypper-installed.txt" || :
    ;;
  apk)
    apk info 2>/dev/null | LC_ALL=C sort > "$ROOT_DIR/programs/apk-installed.txt" || :
    ;;
esac

for helper in yay paru; do
  if command -v "$helper" >/dev/null 2>&1; then
    "$helper" --version > "$ROOT_DIR/programs/${helper}-version.txt" 2>&1 || true
  fi
done

if command -v flatpak >/dev/null 2>&1; then
  flatpak remotes --columns=name,url,options > "$ROOT_DIR/programs/flatpak-remotes.tsv" 2>/dev/null || true
  flatpak list --user --app --columns=application,origin > "$ROOT_DIR/programs/flatpak-apps-user.tsv" 2>/dev/null || true
  flatpak list --system --app --columns=application,origin > "$ROOT_DIR/programs/flatpak-apps-system.tsv" 2>/dev/null || true
  flatpak list --user --columns=application,version,origin > "$ROOT_DIR/programs/flatpak-installed-user.tsv" 2>/dev/null || true
  flatpak list --system --columns=application,version,origin > "$ROOT_DIR/programs/flatpak-installed-system.tsv" 2>/dev/null || true
fi

if command -v snap >/dev/null 2>&1; then
  snap list > "$ROOT_DIR/programs/snap-list.txt" 2>/dev/null || true
fi

if command -v npm >/dev/null 2>&1; then
  npm list --global --depth=0 > "$ROOT_DIR/programs/npm-global.txt" 2>&1 || true
  sed -i "s|$HOME_DIR|__HOME__|g" "$ROOT_DIR/programs/npm-global.txt"
fi

if command -v pipx >/dev/null 2>&1; then
  pipx list > "$ROOT_DIR/programs/pipx.txt" 2>&1 || true
fi

if command -v cargo >/dev/null 2>&1; then
  cargo install --list > "$ROOT_DIR/programs/cargo-installed.txt" 2>&1 || true
fi

if ! ensure_age; then
  printf 'Error: age es necesario para cifrar la información privada; no se completó el respaldo.\n' >&2
  exit 1
fi

private_archive="$PRIVATE_DIR/system-and-programs.tar.age"
private_tar="$(mktemp)"
trap 'rm -f -- "$private_tar"' EXIT
tar -cf "$private_tar" \
  --exclude='programs/restore-exclude.txt' \
  -C "$ROOT_DIR" manifest/system.txt programs
age -p -o "$private_archive" "$private_tar"
rm -f -- "$private_tar"
trap - EXIT

# El archivo cifrado es la única copia versionable de estos datos.
rm -f -- "$ROOT_DIR/manifest/system.txt"
find "$ROOT_DIR/programs" -maxdepth 1 -type f ! -name restore-exclude.txt -delete

printf 'Respaldo terminado. Revisá %s/README.md para restaurarlo.\n' "$ROOT_DIR"
