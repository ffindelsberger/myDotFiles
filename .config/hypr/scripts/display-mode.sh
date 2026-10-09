#!/usr/bin/env bash
# Switch display configuration between 4K, gaming (1080p), and WQHD profiles.
# Usage: display-mode.sh [default|gaming|wqhd]

set -euo pipefail

mode="${1:-}"

case "$mode" in
    default)
        hyprctl eval 'hl.monitor({ output = "DP-2", mode = "3840x2160@119.88", position = "-2880x0", scale = 1.333333 })'
        hyprctl eval 'hl.monitor({ output = "DP-1", mode = "3840x2160@60", position = "0x0", scale = 1.333333, transform = 3 })'
        ;;
    gaming)
        hyprctl eval 'hl.monitor({ output = "DP-2", mode = "1920x1080@119.93", position = "-1920x0", scale = 1 })'
        hyprctl eval 'hl.monitor({ output = "DP-1", mode = "1920x1080@60", position = "0x0", scale = 1, transform = 3 })'
        ;;
    wqhd)
        hyprctl eval 'hl.monitor({ output = "DP-2", mode = "2560x1440@120", position = "-2560x0", scale = 1 })'
        hyprctl eval 'hl.monitor({ output = "DP-1", mode = "2560x1440@60", position = "0x0", scale = 1, transform = 3 })'
        ;;
    *)
        echo "Usage: $(basename "$0") [default|gaming|wqhd]" >&2
        exit 1
        ;;
esac
