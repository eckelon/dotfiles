# hyprshell

Window switcher overlay for Hyprland (<https://github.com/H-M-H/hyprshell>):
hold `SUPER+Tab` to see open windows across all workspaces (MRU order) and
switch between them. Started by `hyprland.conf` (`exec-once = hyprshell run`).

## Config

**`config.ron`** is minimal on purpose — only what differs from hyprshell's
defaults:

```ron
version: 4,                       // config schema version, must match the binary
windows: ( switch: ( modifier: "super" ) )   // switcher bound to Super
```

Everything else (styling, shortcuts inside the overlay) uses hyprshell's
built-in defaults; add keys here only when overriding something.
