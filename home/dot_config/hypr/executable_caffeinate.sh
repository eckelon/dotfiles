#!/bin/sh
# macOS-style caffeinate: keep the laptop awake for remote access.
# Blocks idle timers, suspend and lid switch while active.
# Works over SSH (no Wayland session env needed):
#   caffeinate.sh on|off|toggle|status
PIDFILE=/tmp/caffeinate.pid

case "${1:-toggle}" in
on)
  [ "$($0 status)" = on ] && exit 0
  # kill (not STOP) hypridle: frozen stale timers would fire on resume
  pkill hypridle
  nohup systemd-inhibit --what=sleep:idle:handle-lid-switch sleep infinity \
    >/dev/null 2>&1 &
  echo $! >"$PIDFILE"
  ;;
off)
  [ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null
  rm -f "$PIDFILE"
  # fresh hypridle instance = fresh idle timers
  export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  export HYPRLAND_INSTANCE_SIGNATURE="${HYPRLAND_INSTANCE_SIGNATURE:-$(ls -t "$XDG_RUNTIME_DIR/hypr" | head -1)}"
  hyprctl dispatch exec hypridle >/dev/null 2>&1 || echo "warn: could not restart hypridle (no session?)"
  ;;
status)
  if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    echo on
  else
    echo off
  fi
  ;;
toggle)
  [ "$($0 status)" = on ] && "$0" off || "$0" on
  "$0" status
  ;;
*)
  echo "usage: $0 on|off|toggle|status" >&2
  exit 2
  ;;
esac
