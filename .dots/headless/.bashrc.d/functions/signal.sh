#!/usr/bin/env bash

function pause() {
  signal STOP $1
}

function play() {
  signal CONT $1
}

function signal() {
  local sig="$1"
  local target="$2"

  # Check if required arguments are provided
  if [[ -z "$sig" || -z "$target" ]]; then
    echo "Usage: signal SIGNAL TARGET"
    echo "  SIGNAL: Signal to send (e.g., STOP, CONT, TERM, etc.)"
    echo "  TARGET: Process ID or name"
    return 1
  fi

  # Check if target is a number (PID) or a name
  if [[ "$target" =~ ^[0-9]+$ ]]; then
    # Target is a PID
    kill -"$sig" "$target"
  else
    # Target is a process name
    killall -"$sig" "$target"
  fi
}
