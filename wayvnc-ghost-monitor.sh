#!/bin/bash

VIRTUAL_MONITOR="HEADLESS-2"
REAL_MONITOR="DP-2"

echo "[wayvnc] Starting script at $(date) with PID $$" >> /tmp/wayvnc_run.log

cleanup() {
  echo -e "\n[wayvnc] Cleaning up..."
  pkill -f "wayvnc 0.0.0.0 5902 $VIRTUAL_MONITOR"
  echo "[wayvnc] Done."
}

trap 'cleanup; exit 0' SIGINT SIGTERM

if ! hyprctl monitors | grep -q "$VIRTUAL_MONITOR"; then
  echo "[wayvnc] Creating $VIRTUAL_MONITOR dynamically..."
  hyprctl output create headless
  sleep 0.5
fi

echo "[wayvnc] Starting WayVNC on $VIRTUAL_MONITOR..."
wayvnc 0.0.0.0 5902 "$VIRTUAL_MONITOR" > /tmp/wayvnc.log 2>&1 &
WAYVNC_PID=$!

wait $WAYVNC_PID

