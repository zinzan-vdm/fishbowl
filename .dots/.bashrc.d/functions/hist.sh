#!/usr/bin/env bash

# prefixing with space to remove entry from history
alias hist=' _hist'

function _hist() {
  local query="$@"

  local history_line=$(history | fzf "--query=$query")

  local id=$(echo "$history_line" | cut -d' ' -f3-4 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  local command=$(echo "$history_line" | cut -d' ' -f5- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  echo "  > [$id] $command"
  
  history -s "$command"

  $command
}

