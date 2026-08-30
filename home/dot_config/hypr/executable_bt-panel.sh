#!/usr/bin/env bash
# bt-panel — floating bluetooth manager, official tools only (bluetoothctl).
# Redraws on keypress only (no timer). Arrows+Enter select, <n> toggles, s) scan, p) power, q/Esc) quit.
set -u
declare -A MAP
STATUS=""
SEL=1
MAX=0

powered() { bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; }
paired() { bluetoothctl devices Paired 2>/dev/null | cut -c8-; }
is_conn() { bluetoothctl info "$1" 2>/dev/null | grep -q "Connected: yes"; }
newdevs() { bluetoothctl devices 2>/dev/null | cut -c8- | while IFS= read -r l; do
  [ -z "$l" ] && continue
  m=${l%% *}
  paired | grep -q "^$m" || echo "$l"
done; }
controller() { bluetoothctl show 2>/dev/null | grep -m1 ^Controller | sed 's/^Controller \(.*\) (public).*/\1/'; }
devname() { {
  paired
  newdevs
} | while IFS= read -r l; do
  [ "${l%% *}" = "$1" ] && {
    echo "${l#* }"
    break
  }
done; }

toggle_connect() {
  local mac="$1" name="$2"
  STATUS="connecting $name..."
  if is_conn "$mac"; then
    bluetoothctl disconnect "$mac" >/dev/null 2>&1 && STATUS="$name disconnected"
  elif bluetoothctl connect "$mac" >/dev/null 2>&1; then
    STATUS="$name connected"
  else
    STATUS="connect failed: $name"
  fi
}

pair_new() {
  local mac="$1" name="$2"
  STATUS="pairing $name..."
  bluetoothctl pair "$mac" >/dev/null 2>&1
  bluetoothctl trust "$mac" >/dev/null 2>&1
  if bluetoothctl connect "$mac" >/dev/null 2>&1; then
    STATUS="$name paired + connected"
  else
    STATUS="paired $name (connect failed - retry with its number)"
  fi
}

run_action() { # mac kind
  local mac="$1" kind="$2" name
  name=$(devname "$mac")
  if [ "$kind" = "old" ]; then toggle_connect "$mac" "$name"; else pair_new "$mac" "$name"; fi
}

row() { # idx text — reverse-video when selected
  if [ "$1" = "$SEL" ]; then
    printf '  \e[7m %s \e[0m\n' "$2"
  else
    printf '   %s\n' "$2"
  fi
}

draw() {
  clear
  local pw="off"
  powered && pw="on"
  local ctl
  ctl=$(controller)
  echo "── BLUETOOTH ── controller: ${ctl:---} ── power: $pw ──"
  echo
  MAP=()
  MAX=0
  local i=1
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    local mac=${line%% *} name=${line#* } st=""
    is_conn "$mac" && st="connected"
    MAP[$i]="$mac old"
    row "$i" "$i) [$([ -n "$st" ] && echo x || echo ' ')] $name $st"
    i=$((i + 1))
  done < <(paired)
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    local mac=${line%% *} name=${line#* }
    MAP[$i]="$mac new"
    row "$i" "$i) [ ] $name (discovered)"
    i=$((i + 1))
  done < <(newdevs)
  MAX=$((i - 1))
  [ "$SEL" -gt "$MAX" ] && SEL=$MAX
  echo
  echo "  arrows+Enter select · <n> toggle · s) scan (10s) · p) power · r) refresh · q) quit"
  [ -n "$STATUS" ] && echo "  » $STATUS"
}

while true; do
  draw
  key=""
  read -rsn1 key
  if [ "$key" = "q" ]; then
    clear
    exit 0
  fi
  if [ "$key" = $'\e' ]; then
    if read -rsn1 -t 0.05 k2; then
      if [ "$k2" = "[" ]; then
        if read -rsn1 -t 0.05 k3; then
          case "$k3" in
          A) [ "$SEL" -gt 1 ] && SEL=$((SEL - 1)) ;;
          B) [ "$SEL" -lt "$MAX" ] && SEL=$((SEL + 1)) ;;
          esac
        fi
      fi
      continue
    fi
    clear
    exit 0 # lone Esc quits
  fi
  if [ "$key" = "s" ]; then
    STATUS="scanning (10s), screen frozen..."
    draw
    bluetoothctl --timeout 10 scan on >/dev/null 2>&1
    STATUS="scan done"
  elif [ "$key" = "p" ]; then
    if powered; then
      bluetoothctl power off >/dev/null 2>&1
      STATUS="power off"
    else
      sudo -n rfkill unblock bluetooth 2>/dev/null
      bluetoothctl power on >/dev/null 2>&1
      STATUS="power on"
    fi
  elif [ "$key" = "r" ]; then
    :
  elif [ -z "$key" ] && [ -n "${MAP[$SEL]:-}" ]; then
    SEL_mark="${MAP[$SEL]% *}"
    run_action "$SEL_mark" "${MAP[$SEL]#* }"
  elif [[ "$key" =~ ^[0-9]$ && -n "${MAP[$key]:-}" ]]; then
    SEL=$key
    run_action "${MAP[$key]% *}" "${MAP[$key]#* }"
  fi
done
