#!/usr/bin/env bash
set -euo pipefail

prompt=$(wofi --dmenu --prompt "Ask OpenCode" --width 700 --height 100 \
    --location center --hide-scroll --cache-file /dev/null \
    --define hide_image=true </dev/null) || exit 0

[[ -n ${prompt//[[:space:]]/} ]] || exit 0

scratch=$(mktemp -d /tmp/opencode-query.XXXXXXXX)
exec kitty --class opencode-quick --directory "$scratch" \
    opencode "$scratch" --prompt "$prompt"
