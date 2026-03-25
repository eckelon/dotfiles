# Yet Another Dotfiles Repo

Want to try them?

1. clone the repo
2. Install stow (in mac `brew install stow`)
2. `git submodule update --recursive --remote`
3. `./apply-dotfiles.sh`

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
