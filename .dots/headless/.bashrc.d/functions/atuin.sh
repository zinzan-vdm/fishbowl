#!/usr/bin/env bash

if command -v atuin &> /dev/null; then
  atuin init bash > /tmp/.atuin-init

  source /tmp/.atuin-init

  source $HOME/.bashrc.resources.d/functions/bash-preexec/bash-preexec.sh
fi

