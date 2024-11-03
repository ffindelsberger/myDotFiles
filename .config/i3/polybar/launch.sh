#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
#polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Wait until the processes have ben shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Start polybar
#polybar -c ~/data/git/myDotFiles/.config/polybar/other_config.ini
polybar -c ~/data/git/myDotFiles/.config/i3/polybar/config.ini

# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar --config=~/.config/polybar/config.ini example 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
