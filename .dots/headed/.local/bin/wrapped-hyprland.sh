#!/usr/bin/env bash

cd ~

# Recommended variables - see https://wiki.hyprland.org/Getting-Started/Quick-start/#wrapping-the-launcher-recommended
export _JAVA_AWT_WM_NONREPARENTING=1
export XCURSOR_SIZE=24

# Display software cursors if possible
export WLR_NO_HARDWARE_CURSORS=1

exec Hyprland

