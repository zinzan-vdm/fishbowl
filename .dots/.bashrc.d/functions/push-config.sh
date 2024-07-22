#!/usr/bin/env bash

function config() {
  local target=${1}
  local action=${2}

  case "$target" in
    "push")
      config-nixos-push
      config-dots-push
    ;;
    "nixos")
      config-nixos "$action"
    ;;
    "dots")
      config-dots "$action"
    ;;
    *)
      config-help
    ;;
  esac
}

function config-nixos() {
  local action=${1}

  case "$action" in
    "push")
      config-nixos-push
    ;;
    "pull")
      config-nixos-pull
    ;;
    "edit")
      config-nixos-edit
    ;;
    *)
      config-help
    ;;
  esac
}

function config-dots() {
  local action=${1}

  case "$action" in
    "push")
      config-dots-push
    ;;
    "pull")
      config-dots-pull
    ;;
    "edit")
      config-dots-edit
    ;;
    *)
      config-help
    ;;
  esac
}

function push-config() {
  push-dotfiles
  push-nixos
}

function push-dotfiles() {
  echo 'Committing and pushing all dotfile changes in $HOME/.dotfiles.'

  git -C $HOME/.dotfiles add .
  git -C $HOME/.dotfiles commit -m "dotfiles [$(date --iso-8601=seconds)] [push-dotfiles]"
  git -C $HOME/.dotfiles push origin nixos/dotfiles
}

function push-nixos() {
  echo 'Committing and pushing all config changes in $HOME/.nixos.'

  sudo git -C $HOME/.nixos add .
  sudo git -C $HOME/.nixos commit -m "config [$(date --iso-8601=seconds)] [push-nixos]"
  sudo git -C $HOME/.nixos push origin nixos/config
}

