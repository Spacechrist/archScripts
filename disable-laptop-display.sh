#!/bin/bash

# --- CONFIGURATION ---
# !! IMPORTANT !!
# Find your laptop's monitor name by running `hyprctl monitors` in your terminal.
# It's usually eDP-1, eDP-2, or LVDS-1.
LAPTOP_MONITOR="eDP-1"
# ---------------------

# Exit if jq is not installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install it (e.g., sudo pacman -S jq)" >&2
    exit 1
fi

# Get all monitor info in JSON
MONITORS_JSON=$(hyprctl monitors -j)

# Find the first external monitor that is NOT the laptop monitor
EXTERNAL_MONITOR_NAME=$(echo "$MONITORS_JSON" | jq -r --arg LAPTOP_MONITOR "$LAPTOP_MONITOR" \
    '.[] | select(.name != $LAPTOP_MONITOR) | .name' | head -n 1)

# If no external monitor is found, exit the script
if [ -z "$EXTERNAL_MONITOR_NAME" ]; then
    echo "No external monitor found. Exiting."
    exit 0
fi

# Find the active workspace ID on the laptop monitor
LAPTOP_WORKSPACE_ID=$(echo "$MONITORS_JSON" | jq -r --arg LAPTOP_MONITOR "$LAPTOP_MONITOR" \
    '.[] | select(.name == $LAPTOP_MONITOR) | .activeWorkspace.id')

# If no active workspace is found (monitor already off?), exit
if [ -z "$LAPTOP_WORKSPACE_ID" ] || [ "$LAPTOP_WORKSPACE_ID" == "null" ]; then
    echo "Could not find active workspace on $LAPTOP_MONITOR. It might be off."
    exit 0
fi

echo "Moving workspace $LAPTOP_WORKSPACE_ID to $EXTERNAL_MONITOR_NAME..."

# Dispatch the command to move the workspace
hyprctl dispatch moveworkspacetomonitor "$LAPTOP_WORKSPACE_ID" "$EXTERNAL_MONITOR_NAME"

# Wait a tiny moment for the move to process (optional, but can help)
sleep 0.1

# Disable the laptop monitor
echo "Disabling $LAPTOP_MONITOR."
hyprctl keyword monitor "$LAPTOP_MONITOR,disable"
