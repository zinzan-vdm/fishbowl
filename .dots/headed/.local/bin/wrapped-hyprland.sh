#!/usr/bin/env bash

cd ~

export _JAVA_AWT_WM_NONREPARENTING=1
export XCURSOR_SIZE=24

# Display software cursors if possible
export WLR_NO_HARDWARE_CURSORS=1

# Use systemd's dbus session
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

exec Hyprland

