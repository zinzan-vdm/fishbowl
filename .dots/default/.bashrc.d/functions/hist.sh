#!/usr/bin/env bash

# prefixing with space to remove entry from history
alias hist=' _hist'

function _hist() {
  local query="$@"

  local history_line=$(history | sort -n -r | fzf --no-sort "--query=$query")

  local id=$(echo "$history_line" | sed -E 's/^[[:space:]]*([[:digit:]]+)[[:space:]]+(.+)[[:space:]]*$/\1/')

  fc -s $id
}

