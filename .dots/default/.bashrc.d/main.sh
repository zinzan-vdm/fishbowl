#!/usr/bin/env bash

function include-sources() {
  for FILE in $(fd -HL -t file -e sh . "$1"); do
    source $FILE
  done
}

include-sources ~/.bashrc.d/functions
include-sources ~/.bashrc.d/appearance

source ~/.bashrc.d/env.sh
source ~/.bashrc.d/term.sh

