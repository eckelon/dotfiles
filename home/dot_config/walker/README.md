# Walker

App launcher and clipboard history (<https://github.com/abenz1267/walker>), with
[elephant](https://github.com/abenz1267/elephant) as its data backend.

## Config

**`config.toml`** only carries overrides — unset keys fall back to the system
default `/etc/xdg/walker/config.toml`. The only override here is the theme:

```toml
theme = "catppuccin"
```

## Theme

**`themes/catppuccin/style.css`** — Catppuccin Mocha window with rounded
borders, matching the waybar pill.

## How it runs

Started from `hyprland.conf` as a warm service so it pops instantly:

```sh
exec-once = systemctl --user start elephant.service   # data backend, first
exec-once = walker --gapplication-service             # keep an instance warm
```

Keybindings (in `dot_config/hypr/hyprland.conf`):

- `SUPER+R` or `SUPER` (released alone) — open the launcher.
- `SUPER+SHIFT+C` — open clipboard history (`walker -m clipboard`).

Clipboard mode: `:` prefix searches history, `ctrl+d` deletes an entry,
`ctrl+shift+d` clears it.
