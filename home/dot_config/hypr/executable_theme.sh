#!/usr/bin/env bash
# Theme + wallpaper switcher (PoC). Themes live in ~/.config/hypr/themes/<name>/
# (theme.conf = hyprland colors, waybar.css = waybar palette); wallpapers are any
# images in ~/Pictures/wallpapers. Switching = symlink swap + reload, state kept
# in runtime files (not chezmoi-managed): theme.conf, waybar/theme.css,
# hyprpaper.conf, .theme, .wallpaper.
#
#   theme.sh list          list themes
#   theme.sh set <name>    apply theme (hyprland borders + waybar)
#   theme.sh next          cycle themes
#   theme.sh wall <file>   set wallpaper on all monitors
#   theme.sh walln         cycle ~/Pictures/wallpapers
#   theme.sh boot          exec-once: restore theme, start hyprpaper
set -euo pipefail

HYP="$HOME/.config/hypr"
THEMES="$HYP/themes"
WAYBAR_CSS="$HOME/.config/waybar/theme.css"
WALL_DIR="$HOME/Pictures/wallpapers"

notify() { command -v notify-send >/dev/null 2>&1 && notify-send -t 2000 "$1" "${2:-}" & }

monitors() { hyprctl monitors | sed -n 's/^Monitor \([^ ]*\).*/\1/p'; }

themes() { find "$THEMES" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort; }

start_hyprpaper() {
  pgrep -x hyprpaper >/dev/null && return 0
  setsid hyprpaper >/dev/null 2>&1 &
  for _ in $(seq 20); do
    hyprctl hyprpaper listactive >/dev/null 2>&1 && return 0
    sleep 0.5
  done
  echo "hyprpaper did not come up" >&2
}

set_wallpaper() { # $1 = image path
  local img="$1" m
  [ -f "$img" ] || {
    echo "no such image: $img" >&2
    exit 1
  }
  start_hyprpaper
  # hyprpaper 0.8+ config format (blocks); daemon reads this at boot
  {
    echo "splash = false"
    for m in $(monitors); do
      printf '\nwallpaper {\n    monitor = %s\n    path = %s\n}\n' "$m" "$img"
    done
  } >"$HYP/hyprpaper.conf"
  # runtime switch (hyprpaper 0.8+ ipc: only 'wallpaper' and 'listactive' requests)
  for m in $(monitors); do hyprctl hyprpaper wallpaper "$m,$img" >/dev/null; done
  echo "$img" >"$HYP/.wallpaper"
}

set_theme() { # $1 = theme name
  local t="$1" dir="$THEMES/$1"
  [ -d "$dir" ] || {
    echo "unknown theme: $1" >&2
    echo "available:" >&2
    themes >&2
    exit 1
  }
  ln -sfn "$dir/theme.conf" "$HYP/theme.conf"
  ln -sfn "$dir/waybar.css" "$WAYBAR_CSS"
  echo "$t" >"$HYP/.theme"
  hyprctl reload >/dev/null 2>&1 || true
  pkill -x waybar 2>/dev/null || true
  setsid waybar >/dev/null 2>&1 &
  if [ -f "$HYP/.wallpaper" ]; then set_wallpaper "$(cat "$HYP/.wallpaper")"; fi
  notify "Theme: $t"
}

next_theme() {
  local all cur i
  mapfile -t all < <(themes)
  cur=$(cat "$HYP/.theme" 2>/dev/null || true)
  for i in "${!all[@]}"; do
    if [ "${all[i]}" = "$cur" ]; then
      set_theme "${all[((i + 1) % ${#all[@]})]}"
      return
    fi
  done
  set_theme "${all[0]}"
}

next_wall() {
  local all cur i img
  mapfile -t all < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) | sort)
  if [ ${#all[@]} -eq 0 ]; then
    echo "no images in $WALL_DIR" >&2
    exit 1
  fi
  cur=$(cat "$HYP/.wallpaper" 2>/dev/null || true)
  img="${all[0]}"
  for i in "${!all[@]}"; do
    if [ "${all[i]}" = "$cur" ]; then
      img="${all[((i + 1) % ${#all[@]})]}"
      break
    fi
  done
  set_wallpaper "$img"
  notify "Wallpaper: $(basename "$img")"
}

boot() {
  local t
  t=$(cat "$HYP/.theme" 2>/dev/null || true)
  if [ -z "$t" ] || [ ! -d "$THEMES/$t" ]; then t=$(themes | head -1); fi
  [ -n "$t" ] || exit 0
  ln -sfn "$THEMES/$t/theme.conf" "$HYP/theme.conf"
  ln -sfn "$THEMES/$t/waybar.css" "$WAYBAR_CSS"
  echo "$t" >"$HYP/.theme"
  # fresh install: hyprland.conf sourced theme.conf before it existed -> reload
  hyprctl reload >/dev/null 2>&1 || true
  if [ -f "$HYP/hyprpaper.conf" ]; then start_hyprpaper; fi
}

case "${1:-}" in
list) themes ;;
set) set_theme "${2:?theme name required}" ;;
next) next_theme ;;
wall)
  set_wallpaper "${2:?image path required}"
  notify "Wallpaper: $(basename "$2")"
  ;;
walln) next_wall ;;
boot) boot ;;
*)
  echo "usage: theme.sh list|set <name>|next|wall <file>|walln|boot" >&2
  exit 1
  ;;
esac
