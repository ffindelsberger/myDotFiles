#!/usr/bin/env bash
set -euo pipefail

prompt=$(wofi --dmenu --prompt "Ask Prime Agent" --width 700 --height 70 \
    --location center --hide-scroll --cache-file /dev/null \
    --define hide_image=true </dev/null) || exit 0

[[ -n ${prompt//[[:space:]]/} ]] || exit 0

scratch=/tmp/prime-agent-query/$(date +%F)
mkdir -p "$scratch"

exec kitty --class opencode-quick --directory "$scratch" \
    prime-agent --provider router9 --model cc/claude-opus-5-5 -- "$prompt"
