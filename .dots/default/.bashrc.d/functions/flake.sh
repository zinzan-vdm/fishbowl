#!/usr/bin/env bash

function flake() {
  local comm=${1}; shift

  case "$comm" in
    *)
      flake-$comm "$@" 2>&1

      if [[ "$?" == 127 ]]; then
        flake-help
      fi

      return 0
    ;;
  esac
}

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
  local host=${1-default}

  local flakepath=$(dirname $(flake-path))

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
  if [[ ! -f $(flake-path) ]]; then
    echo 'No flake found.'
    return 1;
  fi

  $EDITOR $(flake-path)
}

function flake-help() {
  echo 'usage: flake <command> [args]'
  echo
  echo 'Commands:'
  echo '  init   creates a .flake/flake.nix file in the current directory with a basic flake boilerplate'
  echo '  use    activates nearest flake (resolves using flake-path)'
  echo '  edit   opens the nearest flake in your prefered $EDITOR (resolves using flake-path)'
  echo '  path   resolves the path to the nearest flake checking ./.flake/flake.nix and then traversing upwards from there'
  echo
  echo 'Samples:'
  echo '  # create a new flake'
  echo '  flake init'
  echo
  echo '  # activate flake'
  echo '  flake use'
  echo
  echo '  # activate insecure flake'
  echo '  NIXPKGS_ALLOW_INSECURE=1 flake use'
  echo
  echo '  # edit flake'
  echo '  flake edit'
}
