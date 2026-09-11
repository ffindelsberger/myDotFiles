#!/usr/bin/env bash
set -euo pipefail

prompt=$(wofi --dmenu --prompt "Ask OpenCode" --width 700 --height 100 \
    --location center --hide-scroll --cache-file /dev/null \
    --define hide_image=true </dev/null) || exit 0

[[ -n ${prompt//[[:space:]]/} ]] || exit 0

scratch=$(mktemp -d /tmp/opencode-query.XXXXXXXX)
# Apply the model and effort defaults only to this launcher.
export OPENCODE_CONFIG_CONTENT='{"agent":{"build":{"model":"openai/gpt-5.6-sol","variant":"medium"}}}'
exec kitty --class opencode-quick --directory "$scratch" \
    opencode "$scratch" --agent build --model openai/gpt-5.6-sol --prompt "$prompt"
