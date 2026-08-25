# Managing Dotfiles with chezmoi

This repository manages dotfiles with [chezmoi](https://chezmoi.io). chezmoi
keeps a *source* tree under `home/` and renders it into `$HOME`, writing real
files (not symlinks) — so it works even with apps that rewrite their own config
(Karabiner, Sol, …).

## Requirements

- **Nerd Font** (e.g. JetBrainsMono Nerd Font) — the zsh prompt uses Nerd Font
  icons (``, ``). Without a Nerd Font these will render as boxes.

## Source layout

`.chezmoiroot` points chezmoi at the `home/` subdirectory, so the repo root can
also hold non-deployed files (`brew/`, docs, `zsh_benchmark.sh`).

chezmoi maps source names to target paths via attribute prefixes:

- `dot_zshrc` → `~/.zshrc`
- `dot_config/ghostty/config` → `~/.config/ghostty/config`
- `dot_emacs.d/init.el` → `~/.emacs.d/init.el`
- `Library/Application Support/k9s/...` → `~/Library/Application Support/k9s/...`
- files ending in `.tmpl` are rendered as Go templates (e.g. `dot_config/git/config.tmpl`)

## Per-machine config (work vs personal)

`home/.chezmoi.toml.tmpl` prompts once per machine ("Is this a work machine")
and stores the answer as `is_work` in the local chezmoi config
(`~/.config/chezmoi/chezmoi.toml`, **not** in this repo). Templates branch on
it — e.g. `home/dot_config/git/config.tmpl` only pulls in the private git
identity (`~/.git-private-config/config`) on work machines.

To add a per-machine difference: rename the file to `*.tmpl` and use
`{{ if .is_work }}…{{ else }}…{{ end }}`.

## External repositories

`home/.chezmoiexternal.toml` declares upstream repos that chezmoi clones into
`$HOME` at apply time (these replaced the old git submodules):

- zsh plugins: `zsh-autosuggestions`, `zsh-completions`,
  `zsh-history-substring-search`, `pure`, `fast-syntax-highlighting`
- `emacs-solo`
- private: `zsh-private-config` and `claude-skills` (SSH URLs — the content
  stays in those private repos; only the URL is public here)

They refresh on `chezmoi apply` per their `refreshPeriod` (168h).

## herdr local plugins

`home/dot_config/herdr/local-plugins/` contains local herdr plugins deployed by
chezmoi to `~/.config/herdr/local-plugins/`. The run_onchange script
`run_onchange_after_link-herdr-plugins.sh.tmpl` links them into herdr
automatically on `chezmoi apply`.

| Plugin | Keybinding | What it does |
|---|---|---|
| `lazygit` | `prefix+y` | Toggle lazygit in a right split pane |
| `nvim` | `prefix+.` | Toggle nvim (opens `.` in repo dir) in a right split pane |

Keybindings are in `home/dot_config/herdr/config.toml`.

## Scripts

`home/run_onchange_after_compile-zsh.sh.tmpl` precompiles the zsh files to
`.zwc` bytecode for faster shell startup. It is keyed to the hash of the zsh
sources, so it only reruns when they change.


## Private content

Anything private lives in a separate private repo referenced as an external, or
behind the `is_work` template guard — it never enters this public repo. For true
secrets, chezmoi templates can also pull from a password manager at apply time.

## Common commands

- Bootstrap a new machine: `chezmoi init --apply eckelon`
- Apply pending changes: `chezmoi apply`
- Preview changes: `chezmoi diff`
- Edit a managed file: `chezmoi edit ~/.zshrc`
- Capture a change made directly in `$HOME` (e.g. an app rewrote its config):
  `chezmoi re-add` (or `chezmoi add ~/path` for a new file)
- Pull upstream + apply: `chezmoi update`

## Homebrew Package Management (`brew/`)

The `brew/` directory manages Homebrew packages declaratively using a Brewfile.
It is independent of chezmoi (it is not part of the `home/` source tree). It
contains three files:

- **`brew/Brewfile`**: Declares all top-level Homebrew formulae, casks, and uv tools. Dependencies are intentionally excluded — they are installed automatically when their parent packages are installed.
- **`brew/restore-brewfile.sh`**: Restores all packages from the Brewfile. Installs Homebrew first if not present. Use on a fresh machine: `./brew/restore-brewfile.sh`
- **`brew/update-brewfile.sh`**: Regenerates the Brewfile from the current system state. It runs `brew autoremove` to clean orphaned dependencies, then `brew bundle dump` to capture all packages, and finally filters the output using `brew leaves` to keep only top-level formulae (not dependencies).

### Key Decisions

- The Brewfile only contains **top-level packages**, not dependencies. When a package like `helmfile` is removed and its dependency `helm` should remain, `helm` must be explicitly installed (`brew install helm`) so it becomes a top-level package.
- Packages that were once explicitly installed but are actually libraries (e.g., `gdbm`, `libffi`) should be uninstalled to keep the Brewfile clean. `brew autoremove` alone won't remove them if they're marked as "installed on request".
- The `update-brewfile.sh` script should be run after any `brew install` or `brew uninstall` to keep the Brewfile in sync.
