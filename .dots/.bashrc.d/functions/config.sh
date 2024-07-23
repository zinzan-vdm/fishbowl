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

function config-dots-up() {
  echo 'Installing dotfiles using stow.'
  echo 'stow -v --no-folding --dir=$HOME/.fishbowl/.dots --target=$HOME .'

  stow -v --no-folding --dir=$HOME/.fishbowl/.dots --target=$HOME .
}

function config-dots-down() {
  echo 'Uninstalling dotfiles using stow.'
  echo 'stow -v --delete --dir=$HOME/.fishbowl/.dots --target=$HOME .'

  stow -v --delete --dir=$HOME/.fishbowl/.dots --target=$HOME .
}

function config-dots-source() {
  source ~/.bashrc
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

function config-nixos-up() {
  git -C $HOME/.fishbowl add .nixos/.

  echo "nixos-rebuild switch --flake $HOME/.nixos#default"
  sudo nixos-rebuild switch --flake $HOME/.nixos\#default
}

function config-nixos-upgrade() {
  git -C $HOME/.fishbowl add .nixos/.

  echo "nixos-rebuild switch --flake $HOME/.nixos#default --upgrade"
  sudo nixos-rebuild switch --flake $HOME/.nixos#default --upgrade
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
  echo 'usage: config [target] <action> [opts]'
  echo
  echo 'Targets:'
  echo '  dots         targets dotfiles in ~/.fishbowl/.dots'
  echo '  nixos        targets nixos config in ~/.fishbowl/.nixos'
  echo
  echo 'Targetless Actions:'
  echo '  edit         opens ~/.fishbowl directory in your prefered $EDITOR'
  echo '  push         alias for "config dots push && config nixos push"'
  echo '    --all      stages all changes in ~/.fishbowl, commits, and pushes to remote `headless` branch'
  echo '  help         prints this'
  echo
  echo 'Target Specific Actions:'
  echo '  dots'
  echo '    up         installs the dotfiles from ~/.fishbowl/.dots into $HOME using gnustow'
  echo '    down       uninstalls the dotfiles from $HOME using gnustow'
  echo '    source     re-sources the $HOME/.bashrc file'
  echo '    push       stages dots changes, commits, and pushes to remote `headless` branch'
  echo '    edit       opens dots directory in your prefered $EDITOR'
  echo '  nixos'
  echo '    up         rebuilds the nixos system using nixos-rebuild with the flake defined in ~/.fishbowl/.nixos'
  echo '    upgrade    rebuilds and upgrades the nixos system with --upgrade'
  echo '    push       stages dots changes, commits, and pushes to remote `headless` branch'
  echo '    edit       opens dots directory in your prefered $EDITOR'
  echo
  echo 'Common Samples:'
  echo '  # install dots'
  echo '  config dots up'
  echo
  echo '  # source dots'
  echo '  config dots source'
  echo
  echo '  # push dots changes to the repo'
  echo '  config dots push'
  echo
  echo '  # rebuild nixos from conf'
  echo '  config nixos up'
  echo
  echo '  # push nixos changes to the repo'
  echo '  config nixos push'
  echo
  echo '  # push both dots and nixos config'
  echo '  config push'
  echo
  echo '  # edit dots'
  echo '  config dots edit'
  echo
  echo '  # edit nixos conf'
  echo '  config nixos edit'
}

