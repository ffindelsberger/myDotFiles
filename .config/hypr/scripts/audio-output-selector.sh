#!/usr/bin/env bash
# Pick the default audio output from a wofi menu.

set -euo pipefail

sinks=$(pactl -f json list sinks | jq -r '.[] | "\(.properties."node.nick" // .description)\t\(.name)"')

choice=$(
    cut -f1 <<<"$sinks" | wofi --dmenu --prompt "Audio output" \
        --style "$HOME/.config/wofi/audio-selector.css" \
        --width 320 --lines "$(wc -l <<<"$sinks")" \
        --location top_right --xoffset -20 --yoffset 5 \
        --cache-file /dev/null --define hide_image=true --define hide_search=true
) || exit 0

sink=$(awk -F'\t' -v choice="$choice" '$1 == choice { print $2; exit }' <<<"$sinks")
[[ -n $sink ]] || exit 0

pactl set-default-sink "$sink"
