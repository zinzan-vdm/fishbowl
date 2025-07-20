#/usr/bin/env bash

alias mutter="say"

function say() {
  local arglen=$#

  if [[ $arglen > 1 ]]; then
    spd-say $@
  else
    spd-say -P important -m some -p +50 -r +10 "$1"
  fi
}

