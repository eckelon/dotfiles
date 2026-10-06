#!/bin/bash
# Applies Tinycast preferences and restarts the app if running.
# settings.plist is captured by scripts/capture-tinycast-settings.sh.

set -eu

defaults import com.tinycast.app "$HOME/.config/tinycast/settings.plist"

if pgrep -qx Tinycast; then
  killall Tinycast
  sleep 1
  open -a Tinycast
fi
