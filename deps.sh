#!/bin/bash

dependencies=("ripgrep:used in nevom telescope plugin"
              "maim:used as a screenshot tool for 'Print'"
              "feh:for setting background images in i3"
              "polybar:bar for i3"
              "unzip:used to install the c (clangd) lsp")

missing_dependencies=()

# Check if the OS is a Linux distribution
if [ "$(uname)" == "Linux" ]; then
    # Linux-specific dependencies
    for dependency_info in "${dependencies[@]}"; do
        dependency=$(echo "$dependency_info" | cut -d':' -f1)
        explanation=$(echo "$dependency_info" | cut -d':' -f2)

        if ! command -v "$dependency" &> /dev/null; then
            missing_dependencies+=("$dependency ($explanation)")
        fi
    done
else
    echo "The script is running on a non-Linux system (macOS)."
fi

if [ ${#missing_dependencies[@]} -eq 0 ]; then
    echo "All dependencies are installed."
else
    echo "The following dependencies are missing:"
    for dep in "${missing_dependencies[@]}"; do
        echo " - $dep"
    done
fi
