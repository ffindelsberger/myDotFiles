#!/usr/bin/env bash
set -euo pipefail

prompt=$(wofi --dmenu --prompt "Ask OpenCode" --width 700 --height 70 \
    --location center --hide-scroll --cache-file /dev/null \
    --define hide_image=true </dev/null) || exit 0

[[ -n ${prompt//[[:space:]]/} ]] || exit 0

scratch=$(mktemp -d /tmp/opencode-query.XXXXXXXX)
# Apply the model and effort defaults only to this launcher.
cat >"$scratch/opencode.json" <<'EOF'
{
    "model": "openai/gpt-5.6-sol",
    "default_agent": "build",
    "agents": {
        "build": {
            "model": "openai/gpt-5.6-sol#medium"
        }
    }
}
EOF

exec kitty --class opencode-quick --directory "$scratch" \
    opencode "$scratch" --prompt "$prompt"
