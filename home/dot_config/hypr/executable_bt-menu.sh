#!/bin/sh
# Bluetooth quick menu over fuzzel dmenu. Deps: bluetoothctl + fuzzel.
MENU="fuzzel --dmenu -l 8 -p bt:"

paired() { bluetoothctl devices Paired 2>/dev/null | cut -c8-; }  # "MAC Name..."
is_conn() { bluetoothctl info "$1" 2>/dev/null | grep -q "Connected: yes"; }
powered() { bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; }

entries() {
  paired | while IFS= read -r line; do
    [ -z "$line" ] && continue
    mac=${line%% *}
    name=${line#* }
    if is_conn "$mac"; then echo "[x] $name"; else echo "[ ] $name"; fi
  done
  if powered; then echo "Power off"; else echo "Power on"; fi
  echo "Scan & pair..."
}

pick=$(entries | $MENU)
[ -z "$pick" ] && exit 0

if [ "$pick" = "Power on" ]; then
  sudo -n rfkill unblock bluetooth 2>/dev/null
  bluetoothctl power on >/dev/null 2>&1
elif [ "$pick" = "Power off" ]; then
  bluetoothctl power off >/dev/null 2>&1
elif [ "$pick" = "Scan & pair..." ]; then
  notify-send -t 8000 "bluetooth" "scanning for 10s..."
  bluetoothctl --timeout 10 scan on >/dev/null 2>&1
  target=$(bluetoothctl devices 2>/dev/null | cut -c8- | fuzzel --dmenu -l 10 -p pair:)
  [ -z "$target" ] && exit 0
  mac=${target%% *}
  notify-send -t 8000 "bluetooth" "pairing..."
  bluetoothctl pair "$mac" >/dev/null 2>&1
  bluetoothctl trust "$mac" >/dev/null 2>&1
  if bluetoothctl connect "$mac" >/dev/null 2>&1; then
    notify-send "bluetooth" "connected"
  else
    notify-send -t 8000 "bluetooth" "connect failed"
  fi
else
  name=${pick#* ] }
  mac=$(paired | while IFS= read -r l; do
    m=${l%% *}; n=${l#* }
    [ "$n" = "$name" ] && { echo "$m"; break; }
  done)
  [ -z "$mac" ] && exit 0
  if is_conn "$mac"; then
    bluetoothctl disconnect "$mac" >/dev/null 2>&1
  elif bluetoothctl connect "$mac" >/dev/null 2>&1; then
    notify-send "bluetooth" "$name connected"
  else
    notify-send -t 8000 "bluetooth" "connect failed"
  fi
fi
