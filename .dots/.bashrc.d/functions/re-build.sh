#!/usr/bin/env bash

function re-build() {
  local operation=${1-switch}
  local hostname=${2-default}

  git -C $HOME/.nixos add .

  echo "nixos-rebuild $operation --flake $HOME/.nixos#$hostname"
  sudo nixos-rebuild $operation --flake $HOME/.nixos#$hostname
}

function re-build-upgrade() {
  local operation=${1-switch}
  local hostname=${2-default}

  git -C $HOME/.nixos add .

  echo "nixos-rebuild $operation --flake $HOME/.nixos#$hostname --upgrade"
  sudo nixos-rebuild $operation --flake $HOME/.nixos#$hostname --upgrade
}

