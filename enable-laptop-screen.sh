#!/bin/bash

# --- CONFIGURATION ---
# !! IMPORTANT !!
# Use the same monitor name as in your lid-close.sh script
LAPTOP_MONITOR="eDP-1"

# Set your preferred monitor settings.
# Format: "name,resolution,position,scale"
# "preferred" uses the monitor's native resolution.
# "auto" positions it automatically.
# "1" is the scale.
# Adjust this to match your normal setup in hyprland.conf
LAPTOP_MONITOR_SETTINGS="preferred,auto,1"
# ---------------------

echo "Enabling $LAPTOP_MONITOR."
hyprctl keyword monitor "$LAPTOP_MONITOR,$LAPTOP_MONITOR_SETTINGS"
