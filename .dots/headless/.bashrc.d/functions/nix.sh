#!/usr/bin/env bash

function nixf() {
  local command=""
  local args=()

  if [[ $# -gt 0 ]]; then
    command="$1"
    shift
    while [[ $# -gt 0 ]]; do
      args+=("$1")
      shift
    done
  fi

  case "$command" in
    init)
      local type="${args[0]:-hidden}"
      local dir="./.flake"
      local path="$dir/flake.nix"

      if [[ "$type" == "visible" ]]; then
        dir="./"
        path="$dir/flake.nix"
      fi

      mkdir -p "$dir"
      cp ~/.bashrc.resources.d/functions/flake.sh/flake.nix "$path"

      echo "Created flake at: $path"
      nixf edit
      ;;

    edit)
      local flakepath
      flakepath=$(nixf path)

      if [[ ! -f "$flakepath" ]]; then
        echo "No flake found at: $flakepath"
        return 1
      fi

      ${EDITOR:-vi} "$flakepath"
      ;;

    use)
      local host="default"
      local impure=false

      local i=0
      while [[ $i -lt ${#args[@]} ]]; do
        case "${args[$i]}" in
          --impure|-i)
            impure=true
            ;;
          *)
            host="${args[$i]}"
            ;;
        esac
        ((i++))
      done

      if [[ "$NIXPKGS_ALLOW_INSECURE" == "1" ]]; then
        impure=true
      fi

      local flakepath
      flakepath=$(dirname "$(nixf path)")

      if [[ "$flakepath" == "" ]]; then
        echo "No flake found in current directory tree"
        return 1
      fi

      local flags=""
      if [[ "$impure" == true ]]; then
        flags="$flags --impure"
      fi

      echo "Activating flake: nix develop $flakepath#$host $flags"
      nix develop "$flakepath#$host" $flags
      ;;

    path)
      local subpath=".flake/flake.nix"
      local vispath="flake.nix"

      local current_dir="$PWD"
      local found=""

      while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/$subpath" ]]; then
          found="$current_dir/$subpath"
          break
        fi
        if [[ -f "$current_dir/$vispath" ]]; then
          found="$current_dir/$vispath"
          break
        fi
        current_dir=$(dirname "$current_dir")
      done

      if [[ -z "$found" ]]; then
        if [[ -f "/$subpath" ]]; then
          found="/$subpath"
        elif [[ -f "/$vispath" ]]; then
          found="/$vispath"
        fi
      fi

      if [[ -n "$found" ]]; then
        echo "$found"
        return 0
      else
        return 1
      fi
      ;;

    -h|--help|help)
      echo "Usage: nixf <command> [args]"
      echo "Manage Nix flakes in your project."
      echo ""
      echo "Commands:"
      echo "  init [type]     Create a flake.nix file"
      echo "                  type: 'hidden' (default, in .flake/) or 'visible' (in ./)"
      echo "  use [options] [host]  Activate the nearest flake"
      echo "                  host: default is 'default'"
      echo "                  options:"
      echo "                    -i, --impure  Use --impure flag"
      echo "  edit            Open the nearest flake in \$EDITOR"
      echo "  path            Find and show the path to the nearest flake"
      echo "  help            Show this help message"
      echo ""
      echo "Examples:"
      echo "  nixf init                     # Create hidden flake in .flake/"
      echo "  nixf init visible             # Create visible flake in ./"
      echo "  nixf use                      # Activate default devShell"
      echo "  nixf use dev                  # Activate 'dev' devShell"
      echo "  nixf use --impure             # Activate with --impure flag"
      echo "  nixf use -i dev               # Activate 'dev' devShell with --impure"
      echo "  NIXPKGS_ALLOW_INSECURE=1 nixf use  # Also activates with --impure flag"
      echo "  nixf edit                     # Edit the nearest flake"
      echo "  nixf path                     # Find nearest flake path"
      echo ""
      echo "Options:"
      echo "  -h, --help      Show this help message"
      return 0
      ;;

    "")
      echo "Usage: nixf <command> [args]"
      echo "Manage Nix flakes in your project."
      echo "Try 'nixf help' for more information."
      return 1
      ;;

    *)
      echo "Unknown command: $command"
      echo "Try 'nixf help' for available commands."
      return 1
      ;;
  esac
}

function nixme() {
  local packages=()
  local nix_packages=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        echo "Usage: nixme [channel#]package1 [channel#]package2 ..."
        echo "Opens a temporary nix shell with the specified packages."
        echo ""
        echo "Examples:"
        echo "  nixme nodejs                    # Uses current channel"
        echo "  nixme unstable#nodejs           # Uses unstable channel"
        echo "  nixme 24.05#nodejs python3      # Mixed channels"
        echo "  nixme unstable#nodejs 24.05#python3"
        echo ""
        echo "Options:"
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
    echo "Usage: nixme [channel#]package1 [channel#]package2 ..."
    echo "Opens a temporary nix shell with the specified packages."
    return 1
  fi

  for pkg in "${packages[@]}"; do
    if [[ "$pkg" =~ ^([^#]+)#(.+)$ ]]; then
      local channel="${BASH_REMATCH[1]}"
      local package="${BASH_REMATCH[2]}"

      case "$channel" in
        unstable)
          nix_packages+=("nixpkgs/nixpkgs-unstable#$package")
          ;;
        *)
          nix_packages+=("nixpkgs/nixos-$channel#$package")
          ;;
      esac
    else
      nix_packages+=("nixpkgs#$pkg")
    fi
  done

  tmp_shell=$(mktemp)

  echo "Starting temporary nix shell ($tmp_shell) with: ${packages[*]}"

  echo "source ~/.bash_profile" > "$tmp_shell"

  if [ -z "$NIXME_PACKAGES" ]; then
    echo "export NIXME_PACKAGES=\"${packages[*]}\"" >> "$tmp_shell"
  else
    echo "export NIXME_PACKAGES=\"$NIXME_PACKAGES ${packages[*]}\"" >> "$tmp_shell"
  fi

  echo "ps1 \"nixme[$tmp_shell]: \$NIXME_PACKAGES\"" >> "$tmp_shell"

  # Use the new nix shell command
  nix shell "${nix_packages[@]}" --command bash --rcfile "$tmp_shell" -i

  rm "$tmp_shell"
}
