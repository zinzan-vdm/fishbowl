#!/usr/bin/env bash

function flake-path() {
  local subpath=./.flake/flake.nix
  local vispath=./flake.nix

  if [[ -f $subpath ]]; then
    echo $subpath
    return 0
  fi

  echo $vispath
  return 0
}

function flake-use() {
  local flakepath=$(dirname $(flake-path))
  local host=${1-default}

  local flags=''
  if [[ "$NIXPKGS_ALLOW_INSECURE" == "1" ]]; then
    flags="$flags --impure"
  fi

  echo "nix develop $flakepath#$host $flags"
  nix develop $flakepath#$host $flags
}

function flake-init() {
  local typ=${1-hidden}
  local dir=./.flake
  local path=$dir/flake.nix

  if [[ "$typ" == "visible" ]]; then
    dir=./
    path=$dir/flake.nix
  fi

  mkdir -p $dir
  cp ~/.bashrc.resources.d/functions/flake.sh/flake.nix $path

  flake-edit
}

function flake-edit() {
  $EDITOR $(flake-path)
}
