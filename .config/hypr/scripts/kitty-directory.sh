#!/usr/bin/env bash
set -euo pipefail

directory=$(
    {
        zoxide query --list
        fd --type directory --absolute-path --exclude .git . "$HOME"
    } | awk '!seen[$0]++' | wofi --dmenu --prompt "Open directory in Kitty" \
        --width 700 --height 500 --location center --matching fuzzy \
        --cache-file /dev/null --define hide_image=true
) || exit 0

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
