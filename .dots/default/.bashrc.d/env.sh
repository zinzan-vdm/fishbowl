export EDITOR=nvim

export HISTCONTROL=ignorespace
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend
shopt -s histverify

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export PATH="$PATH:$HOME/.local/bin"

