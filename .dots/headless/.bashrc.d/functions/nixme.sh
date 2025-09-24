#!/usr/bin/env bash

function nixme() {
  local channel=""
  local packages=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -c|--channel)
        if [[ -z "$2" || "$2" == -* ]]; then
          echo "Error: Channel option requires a value."
          return 1
        fi
        channel="$2"
        shift 2
        ;;
      -h|--help)
        echo "Usage: nixme [-c|--channel CHANNEL] package1 package2 ..."
        echo "Opens a temporary nix-shell with the specified packages."
        echo ""
        echo "Options:"
        echo "  -c, --channel CHANNEL   Specify the Nix channel to use (e.g., unstable, 24.5)"
        echo "  -h, --help              Show this help message"
        return 0
        ;;
      *)
        packages+=("$1")
        shift
        ;;
    esac
  done

  if [ ${#packages[@]} -eq 0 ]; then
    echo "Usage: nixme [-c|--channel CHANNEL] package1 package2 ..."
    echo "Opens a temporary nix-shell with the specified packages."
    return 1
  fi

  echo "Starting temporary nix-shell with: ${packages[*]}"
  if [[ -n "$channel" ]]; then
    echo "Using channel: $channel"
  fi

  tmp_shell=$(mktemp)

  echo "source ~/.bash_profile" > $tmp_shell

  if [ -z "$NIXME_PACKAGES" ]; then
    echo "export NIXME_PACKAGES=\"${packages[*]}\"" >> "$tmp_shell"
  else
    echo "export NIXME_PACKAGES=\"$NIXME_PACKAGES ${packages[*]}\"" >> "$tmp_shell"
  fi

  echo "ps1 \"nixme[$tmp_shell]: \$NIXME_PACKAGES\"" >> "$tmp_shell"

  if [[ -n "$channel" ]]; then
    nix-shell "https://github.com/NixOS/nixpkgs/archive/nixos-$channel.tar.gz" -p "${packages[@]}" --command "bash --rcfile $tmp_shell -i"
  else
    nix-shell -p "${packages[@]}" --command "bash --rcfile $tmp_shell -i"
  fi

  rm "$tmp_shell"
}
