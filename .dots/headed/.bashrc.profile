#!/bin/bash
# ~/.bashrc.profile defines a dots-profile specific rc to be executed before any other rcs.

# run hyprland only on first TTY & if no display manager already running
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
	exec ~/.local/bin/wrapped-hyprland.sh
fi

