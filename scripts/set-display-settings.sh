#!/bin/bash

# Get the current hostname using uname -n
HOSTNAME=$(uname -n)

# Target hostname to match
ASUS_LAPTOP="mobile-vegapunk"

# Check if the hostname matches
if [[ "$HOSTNAME" == "$ASUS_LAPTOP" ]]; then
  # Run the xrandr command. This command is for hybrid mode
  xrandr --output eDP-1 --mode 2880x1800 --rate 120
fi
