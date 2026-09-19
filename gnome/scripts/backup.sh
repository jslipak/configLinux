#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
HOME_DIR="${HOME:?No se pudo determinar HOME}"

mkdir -p \
  "$ROOT_DIR/config" \
  "$ROOT_DIR/extensions/user" \
  "$ROOT_DIR/themes" \
  "$ROOT_DIR/icons" \
  "$ROOT_DIR/fonts" \
  "$ROOT_DIR/extras/scripts" \
  "$ROOT_DIR/manifest"

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

printf 'Respaldo de GNOME terminado. No se recopilaron paquetes ni se usó cifrado.\n'
