#!/bin/bash

# Usage: ./set-dpi.sh [laptop|desktop]


#some apps need restarting when dpi settings where changed
restart_applications() {
    # Check if Chrome is running
    if pgrep -x "chrome" > /dev/null; then
        echo "Chrome is running. Restarting..."
        # Kill all Chrome instances
        pkill -x "chrome"
        sleep 2
        # Start Chrome with restore option
        nohup google-chrome-stable --restore-last-session > /dev/null 2>&1 &
    else
        echo "Chrome is not running. No action taken."
    fi
}

set_polybar_font_size_and_restart() {
	local size=$1
	local path_to_polybar_config="$HOME/.config/i3/polybar/config.ini"
	echo "Setting polybar font size to $size in path $path_to_polybar_config"
	sed -i "s/\(font-0 = Inter:size=\)[0-9]\+\(;1\)/\1$size\2/" $path_to_polybar_config
	echo "Restarting Polybar"
	polybar-msg cmd restart
}

case "$1" in
    laptop)
        echo "Setting DPI to 120 for laptop screen..."
        echo "Xft.dpi: 120" | xrdb -merge -
		restart_applications
		set_polybar_font_size_and_restart 14
        ;;
    desktop)
        echo "Setting DPI to 85 for desktop screen..."
        echo "Xft.dpi: 85" | xrdb -merge -
		restart_applications
		set_polybar_font_size_and_restart 9
        ;;
    *)
        echo "Usage: $0 {laptop|desktop}"
        exit 1
        ;;
esac

