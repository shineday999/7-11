#!/usr/bin/env bash
set -euo pipefail

# Background runner: 每小時執行一次 send_kaohsiung_weather.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEND_SCRIPT="$SCRIPT_DIR/send_kaohsiung_weather.sh"

if [ ! -x "$SEND_SCRIPT" ]; then
  echo "Error: $SEND_SCRIPT not found or not executable" >&2
  exit 1
fi

while true; do
  "$SEND_SCRIPT" || true
  sleep 3600
done
