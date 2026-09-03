# keyd

Keyboard remapping daemon. This layout makes a `us`/`altgr-intl` keyboard feel
macOS-like for Spanish typing: dead-key accents with proper flush behavior,
Command-key positioning, and vim-style navigation.

## Deployment

keyd only reads `/etc/keyd/default.conf`, which chezmoi does not own. Two
run_onchange scripts bridge the gap (see `home/run_onchange_after_keyd-*.sh.tmpl`):

1. **`keyd-layout.sh`** — copies `~/.config/keyd/default.conf` to
   `/etc/keyd/default.conf` and restarts keyd. Re-runs only when the file's
   hash changes.
2. **`keyd-sudo-rule.sh`** — installs a narrow NOPASSWD sudoers rule for
   `keyd bind`, required by `~/.config/hypr/clipkeys.py` (see below).

## What `default.conf` does

- **Dead tilde / acute with flush** (`oneshotm` macros): XKB *discards* an
  unclosed dead-key sequence; macOS *flushes* it (`~` then `/` gives `"~/"`).
  keyd gets flush behavior by typing the character and deleting it when the
  next keystroke is an accent (`'` + `a` → `á`; `~` + `n` → `ñ`, `Shift` → `Ñ`).
  One binding per accent instead of one per key. Known consequence: in apps
  where BackSpace isn't "delete left" (vim normal mode, pagers) a gesture
  sends a stray backspace.
- **Right Alt = Super** — the macOS command key. Nothing is mapped to XKB
  level 3: the accent gestures reach level-3 keysyms via `rightalt` inside
  their own macros, so plain Alt/Ctrl keep working (Alt+Tab, Ctrl+C).
- **Caps Lock overload** — tap = Escape, hold = nav layer (`hjkl` = arrows).
- **`[meta+shift] c`** — passes `SUPER+SHIFT+C` through to Hyprland (clipboard
  history). Composite layers outrank `[meta]`, so it can be static.

## What is deliberately NOT here

**Super+C / Super+V** (copy/paste). A binding in this file outranks anything
keyd is told at runtime, and those chords must change with the focused window
(Ctrl+C is SIGINT in a terminal). `~/.config/hypr/clipkeys.py` installs them
over keyd's socket on every focus change instead. Without that script,
Super+C/V do nothing at all.

## Gotchas

- `[ids] *` is required — without it keyd silently ignores every device.
- Hyprland must use `kb_layout = us`, `kb_variant = altgr-intl` (set in
  `dot_config/hypr/hyprland.conf`); that variant provides the accented keysyms
  the macros reach through Right Alt.
- A keyd restart drops clipkeys.py's runtime bindings; the script re-applies
  them on the next focus change.
