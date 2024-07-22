#!/usr/bin/env bash

grey=$(tput setaf 240)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

function ps1() {
  local name=${1-unnamed}

  local host=$(hostname)
  local user=$(whoami)

  export PS1="\n\[$grey\]\$ $user@$host { $name } \[$grey\][\D{%Y-%m-%d} \A]\n\[$red\]\w \[$green\](\!)\n\[$yellow\]  >\[$reset\] "
}

