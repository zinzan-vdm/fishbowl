#!/usr/bin/env bash

# host-dir - Start an FileBrowser server for a directory
# Usage: host-dir [root=.] [address=0.0.0.0] [port=8080] [user=] [pass=]

set -e

ROOT_DIR=${1:-.}
ADDRESS=${2:-0.0.0.0}
PORT=${3:-8080}
USER=$4
PASS=$5

if [[ "$ROOT_DIR" = "-h" ]] || [[ "$ROOT_DIR" = "--help" ]]; then
	echo "Usage: host-dir [root=.] [address=0.0.0.0] [port=8080] [user=] [pass=]"
	exit 0
fi

if [[ ! "$ROOT_DIR" = /* ]]; then
	ROOT_DIR="$(pwd)/$ROOT_DIR"
fi

if [ ! -d "$ROOT_DIR" ]; then
	echo "Error: Directory '$ROOT_DIR' does not exist."
	exit 1
fi

INSTANCE_ID="$(uuidgen)"

CMD="filebrowser --database /tmp/host-dir/$INSTANCE_ID.db --address $ADDRESS --port $PORT --root \"$ROOT_DIR\""

if [ -z "$USER" ]; then
	CMD="$CMD --noauth"
	AUTH_STATUS="Disabled (anonymous access)"
else
	CMD="$CMD --username $USER"
	AUTH_STATUS="Enabled"
	if [ -n "$PASS" ]; then
		CMD="$CMD --password \"\$(filebrowser hash "$PASS")\""
		PASS_STATUS="[set]"
	else
		PASS_STATUS="[none]"
	fi
fi

echo "╔═══════════════════════════════════════════════════"
echo "║ FileBrowser Server"
echo "║ ─────────────────────────────────────────────────"
echo "║ Sharing directory: $ROOT_DIR"
echo "║ Server URL: http://$ADDRESS:$PORT"
echo "║ Authentication: $AUTH_STATUS"
if [ -n "$USER" ]; then
	echo "║ Username: $USER"
	echo "║ Password: $PASS_STATUS"
fi
echo "║"
echo "║ Command: $CMD"
echo "║"
echo "║ Press Ctrl+C to stop the server"
echo "╚═══════════════════════════════════════════════════"

nix-shell -p filebrowser --run "$CMD"
