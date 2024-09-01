#!/usr/bin/env bash

function open() {
	local query="$1"
	local cmd

	if [[ -z $query ]]; then
		echo "Usage: open <partial_name>"
		return 1
	fi

	cmd=$(compgen -c | grep -i "$query" | head -n 1)

	if [[ -z "$cmd" ]]; then
		echo "Command matching '$query' could not be found."
		return 1
	fi

	hyprctl dispatch -- exec "$cmd"
}
