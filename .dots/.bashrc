#!/bin/bash
# ~/.bashrc defines settings for users when running subshells.

# If not running interactively, don't apply any configuration.
[[ $- != *i* ]] && return

function include-sources() {
  for FILE in $(find -L "$1" -type f -print); do
    source $FILE
  done
}

export BASHRCD=$HOME/.bashrc.d

include-sources "$BASHRCD"

