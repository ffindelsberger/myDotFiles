#!/usr/bin/env bash
set -euo pipefail

directory=$(wofi --dmenu --prompt "Open directory in Kitty" --width 700 --height 100 \
    --location center --hide-scroll --cache-file /dev/null \
    --define hide_image=true </dev/null) || exit 0

[[ -n ${directory//[[:space:]]/} ]] || exit 0

case "$directory" in
    '~') directory=$HOME ;;
    '~/'*) directory="$HOME/${directory:2}" ;;
    /*) ;;
    *) directory="$HOME/$directory" ;;
esac

if [[ ! -d "$directory" ]]; then
    notify-send --urgency=normal "Cannot open directory" "Not a directory: $directory"
    exit 1
fi

exec kitty --directory "$directory"
