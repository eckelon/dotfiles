# Yet Another Dotfiles Repo

Managed with [chezmoi](https://chezmoi.io).

Want to try them?

1. Install chezmoi (in mac `brew install chezmoi`)
2. `chezmoi init --apply eckelon`

`chezmoi init` clones this repo, asks whether the machine is a work machine,
pulls in the external repos (zsh plugins, Pure, fast-syntax-highlighting,
emacs-solo, and the private configs), and writes everything into `$HOME`.
Re-run `chezmoi apply` after pulling changes, or `chezmoi update` to pull and
apply in one step.

## Homebrew Package Management

The `brew/` directory manages Homebrew packages declaratively:

- **`brew/Brewfile`** — Lists all top-level formulae, casks, and uv tools (dependencies are excluded since they get installed automatically).
- **`brew/restore-brewfile.sh`** — Installs Homebrew if missing, then installs all packages from the Brewfile. Run this on a fresh machine.
- **`brew/update-brewfile.sh`** — Regenerates the Brewfile from currently installed packages, filtering out dependencies to keep only top-level ones.

```sh
# Restore packages on a new machine
./brew/restore-brewfile.sh

# Update the Brewfile after installing/removing packages
./brew/update-brewfile.sh
```

## Superkey

Settings live in two places and are tracked separately:

| What | Where | How it restores |
|---|---|---|
| App config (`.padl`) | `home/Library/Application Support/Superkey/750314.padl` | `chezmoi apply` copies it directly |
| Plist preferences | `home/run_onchange_after_apply-superkey-settings.sh.tmpl` | `chezmoi apply` runs the script → writes `defaults` |
| License (`.spadl`) | **Not tracked** in dotfiles (`*.spadl` is gitignored) | Reactivate on each machine |

If you change Superkey preferences, regenerate the plist script:

```sh
./scripts/capture-superkey-settings.sh
```

### Restore on another machine

```sh
# 1. Install Superkey (if it's not in the Brewfile, restore already installed it)
brew install --cask superkey

# 2. Open Superkey once so it creates its directory, then close it
open -a Superkey && sleep 2 && osascript -e 'quit app "Superkey"'

# 3. Apply dotfiles (copies .padl and runs defaults write via run_onchange)
chezmoi apply

# 4. Force macOS to reload the defaults
killall cfprefsd

# 5. Open Superkey
open -a Superkey
```

> ⚠️ The license (`.spadl`) is not synced. Reactivate it on each machine from the Superkey menu.
> If Superkey was already open when you ran `chezmoi apply`, quit and reopen it so it picks up the new settings.
