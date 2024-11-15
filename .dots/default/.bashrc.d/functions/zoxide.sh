#!/usr/bin/env bash

if command -v zoxide &> /dev/null; then
  zoxide init --no-cmd bash > /tmp/.zoxide-init
  source /tmp/.zoxide-init
fi

\builtin unalias cd &>/dev/null || \builtin true
function cd() {
  if [[ -d "$@" ]]; then
    __zoxide_z "$@"
    return $?
  fi

  if [[ "$@" != '.' && "$@" != '..' && "$@" != '-' ]]; then
    local fdstart="$(fd --max-results 1 --max-depth 1 --type d --no-ignore --hidden "^$@")"

    if [[ -n "$fdstart" ]]; then
      __zoxide_z "$fdstart"
      return $?
    fi

    local fdend="$(fd --max-results 1 --max-depth 1 --type d --no-ignore --hidden "$@$")"

    if [[ -n "$fdend" ]]; then
      __zoxide_z "$fdend"
      return $?
    fi
  fi

  __zoxide_z "$@" &>/dev/null
  local ecode=$?

  if [[ "$ecode" != '0' ]]; then
    echo "no directory found matching query $@"
    return $ecode
  fi

  return 0
}

\builtin unalias cdi &>/dev/null || \builtin true
function cdi() {
  __zoxide_zi "$@"
  return $?
}
