#!/bin/bash

dependencies_linux=("feh:for setting background images in i3"
                    "maim:used as a screenshot tool for 'Print'"
                    "polybar:bar for i3")

dependencies_common=("rg: (ripgrep) used in nevom telescope plugin"
                     "unzip:used to install the c (clangd) lsp")

missing_dependencies=()

# Check if the OS is Linux
if [ "$(uname)" == "Linux" ]; then
    for dependency_info in "${dependencies_linux[@]}"; do
        dependency=$(echo "$dependency_info" | cut -d':' -f1)
        explanation=$(echo "$dependency_info" | cut -d':' -f2)

        if ! command -v "$dependency" &> /dev/null; then
            missing_dependencies+=("$dependency ($explanation)")
        fi
    done
elif [ "$(uname)" == "Darwin" ]; then
    # macOS-specific dependencies
    for dependency_info in "${dependencies_common[@]}"; do
        dependency=$(echo "$dependency_info" | cut -d':' -f1)
        explanation=$(echo "$dependency_info" | cut -d':' -f2)

        if ! command -v "$dependency" &> /dev/null; then
            missing_dependencies+=("$dependency ($explanation)")
        fi
    done
else
    echo "The script is running on an unsupported system."
fi

if [ ${#missing_dependencies[@]} -eq 0 ]; then
    echo "All dependencies are installed."
else
    echo "The following dependencies are missing:"
    for dep in "${missing_dependencies[@]}"; do
        echo " - $dep"
    done
fi
