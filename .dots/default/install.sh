#!/usr/bin/env bash

operation=${1}

dots=$HOME/.fishbowl/.dots/default
dependencies=()

function up() {
  echo "Installing dotfiles for profile $profile ($dots/install.sh up)"

  for dep in "${dependencies[@]}"; do
    echo "Installing dependency $dep."
    $dep/install.sh up
  done

  echo 'Installing profile dots.'
  echo "stow -v --no-folding --adopt --dir=$dots --target=\$HOME ."

  stow -v --no-folding --adopt --dir=$dots --target=$HOME .
}

function down() {
  echo "Uninstalling dotfiles for profile $profile ($dots/install.sh down)"

  echo 'Uninstalling profile dots.'
  echo "stow -v --delete --dir=$dots --target=\$HOME ."

  stow -v --delete --dir=$dots --target=$HOME .

  for dep in "${dependencies[@]}"; do
    echo "Uninstalling dependency dotfiles ($dep)."
    $dep/install.sh down
  done
}

case "$operation" in
  up)
    up
    exit 0
    ;;
  down)
    down
    exit 0
    ;;
  *)
    echo "Unknown operation '$operation'."
    exit 1
    ;;
esac
