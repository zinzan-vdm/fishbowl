#!/usr/bin/env bash

function config() {
  local target=${1}
  local action=${2}

  case "$target" in
    push)
      if [[ "--all" == "$action" ]]; then
        config-push-all
      else
        config-dots-push
        config-nixos-push
      fi

      return 0
    ;;
    edit)
      config-edit
      return 0
    ;;
    *)
      config-$target-$action 2>/dev/null || config-help
      return 0
    ;;
  esac
}

function config-dots-push() {
  echo 'Committing and pushing all dotfile changes in $HOME/.fishbowl/.dots'

  git -C $HOME/.fishbowl add .dots/.
  git -C $HOME/.fishbowl commit -m "dots [$(date --iso-8601=seconds)] [config-dots-push]"
  git -C $HOME/.fishbowl push origin headless
}

function config-dots-edit() {
  cd $HOME/.fishbowl/.dots
  $EDITOR .
  cd -
}

function config-nixos-push() {
  echo 'Committing and pushing all config changes in $HOME/.fishbowl/.nixos'

  git -C $HOME/.fishbowl add .nixos/.
  git -C $HOME/.fishbowl commit -m "nixos [$(date --iso-8601=seconds)] [config-nixos-push]"
  git -C $HOME/.fishbowl push origin headless
}

function config-nixos-edit() {
  cd $HOME/.fishbowl/.nixos
  $EDITOR .
  cd -
}

function config-push-all() {
  echo 'Committing and pushing all config changes in $HOME/.fishbowl'

  git -C $HOME/.fishbowl add .
  git -C $HOME/.fishbowl commit -m "all [$(date --iso-8601=seconds)] [config-push]"
  git -C $HOME/.fishbowl push origin headless
}

function config-edit() {
  cd $HOME/.fishbowl
  $EDITOR .
  cd -
}

function config-help() {
  echo 'usage: config [target] [action]'
  echo
  echo 'Targets:'
  echo '  dots  targets dotfiles in ~/.fishbowl/.dots'
  echo '  nixos  targets nixos config in ~/.fishbowl/.nixos'
  echo
  echo 'Actions:'
  echo '  push  stages target changes, commits, and pushes to remote `headless` branch'
  echo '  edit  opens target directory in your prefered $EDITOR'
  echo '  help  prints this'
  echo
  echo 'Samples:'
  echo '  # print help'
  echo '  config help'
  echo
  echo '  # push only dotfiles'
  echo '  config dots push'
  echo
  echo '  # push only nixos config'
  echo '  config nixos push'
  echo
  echo '  # push all changes in $HOME/.fishbowl'
  echo '  config push --all'
  echo
  echo '  # push both dots and nixos config'
  echo '  config push'
  echo
  echo '  # edit only dots'
  echo '  config dots edit'
  echo
  echo '  # edit only nixos config'
  echo '  config nixos edit'
  echo
  echo '  # edit whole ~/.fishbowl'
  echo '  config edit'
}

