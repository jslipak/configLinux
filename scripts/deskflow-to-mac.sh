#!/usr/bin/env bash

set -euo pipefail

lock_file="${XDG_RUNTIME_DIR:-/tmp}/deskflow-to-mac.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

if ! command -v ydotool >/dev/null 2>&1; then
  printf '%s\n' 'Error: ydotool was not found in PATH.' >&2
  exit 1
fi

for i in {1..10}; do
  ydotool mousemove -x 0 -y -150
  sleep 0.01
done

ydotool mousemove -x 0 -y 200
sleep 0.1

for i in {1..25}; do
  ydotool mousemove -x 150 -y 0
  sleep 0.01
done
