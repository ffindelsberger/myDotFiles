#!/bin/bash

dependencies_linux=("feh: used in Desktop Env for setting background images in i3"
                    "maim: used in Desktop Env as a screenshot tool for 'Print'"
                    "polybar: used in Desktop Env, bar for i3")

dependencies_common=("rg: (ripgrep) used in nevom telescope plugin"
                     "unzip: used neovim to install the c (clangd) lsp"
                     "wget: used in neovim by mason.nvim (core utils)")

# Function to check a dependency
check_dependency() {
    local dependency="$1"
    local explanation="$2"

    if command -v "$dependency" &> /dev/null; then
        echo "Dependency '$dependency' ($explanation) is installed."
    else
        echo "Dependency '$dependency' ($explanation) is not installed."
    fi
}

# Check if the OS is Linux
if [ "$(uname)" == "Linux" ]; then
    for dependency_info in "${dependencies_linux[@]}"; do
        dependency=$(echo "$dependency_info" | cut -d':' -f1)
        explanation=$(echo "$dependency_info" | cut -d':' -f2)
        check_dependency "$dependency" "$explanation"
    done

    for dependency_info in "${dependencies_common[@]}"; do
        dependency=$(echo "$dependency_info" | cut -d':' -f1)
        explanation=$(echo "$dependency_info" | cut -d':' -f2)

        check_dependency "$dependency" "$explanation"
    done
elif [ "$(uname)" == "Darwin" ]; then
    for dependency_info in "${dependencies_common[@]}"; do
        dependency=$(echo "$dependency_info" | cut -d':' -f1)
        explanation=$(echo "$dependency_info" | cut -d':' -f2)

        check_dependency "$dependency" "$explanation"
    done
else
    echo "The script is running on an unsupported system."
fi
