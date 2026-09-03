# nwg-dock-hyprland

macOS-style dock pinned to the left edge of the screen, showing pinned and
running apps (<https://github.com/nwg-piotr/nwg-dock-hyprland>).

## What lives here

Only **`style.css`** — Catppuccin Mocha theming to match the waybar pill:
translucent rounded window, underline on the focused client's button, hover
highlight.

All behavior is configured through CLI flags, in `dot_config/hypr/hyprland.conf`:

```sh
exec-once = nwg-dock-hyprland -d -p left -i 40 -c walker -ml 6 -mt 10 -mb 10
```

- `-d` — auto-hide: appears when the mouse hits the hotspot, closes on leave or click.
- `-p left` — left edge; `-i 40` — 40px icons.
- `-c walker` — the launcher button runs walker.
- `-ml/-mt/-mb` — margins (px).

## Pinned apps

The pinned-apps list lives in `~/.cache/nwg-dock-pinned` — runtime state,
deliberately not versioned. Manage it by right-clicking apps in the dock.
