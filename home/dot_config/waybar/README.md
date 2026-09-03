# Waybar

Floating pill-shaped top bar for Hyprland. Deployed to `~/.config/waybar/`.

## Files

- **`config.jsonc`** — bar geometry and module layout. Three groups:
  - *left*: Hyprland workspaces (click to activate) and focused window title.
  - *center*: clock (`{:%a %d %b  %H:%M}`, click opens `rencal`).
  - *right*: caffeine toggle, system tray, audio, bluetooth, network, battery.
- **`style.css`** — the look: rounded pill, JetBrainsMono Nerd Font, per-module
  paddings and state colors (disconnected network, muted audio, low battery).
- **`theme.css`** — **not versioned**: a runtime symlink into
  `~/.config/hypr/themes/<name>/waybar.css`, swapped by
  `~/.config/hypr/theme.sh` (see `dot_config/hypr/README.md`).

## How the popups work

Clicking audio / network / battery opens a small floating terminal
(`ghostty --title=dotfloat -e alsamixer|netpanel|powertop`). The title
`dotfloat` is what the window rules in `dot_config/hypr/hyprland.conf` match to
float, size and center those windows (Ghostty ignores `--class` on Wayland).

## Caffeine module

`custom/caffeine` polls `~/.config/hypr/caffeinate.sh icon` (JSON output with
an `on`/`off` class). Clicking it toggles and signals waybar with
`pkill -RTMIN+8 waybar` — the `signal: 8` in the config is what makes waybar
re-run the script on that signal. The same toggle is bound to `SUPER+X`.

Launched from `hyprland.conf` (`exec-once = waybar`), restarted by `theme.sh`
when the theme changes.
