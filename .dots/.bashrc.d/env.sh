export EDITOR=nvim

export HISTCONTROL=ignorespace

export PATH="$PATH:$HOME/.local/bin"

shopt -s histappend
shopt -s histverify
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

