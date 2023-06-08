#!/bin/sh
for symlink in zsh brew git helix karabiner kitty nvm raycast tmux vim vscode starship wezterm
do
  stow -v -t "$HOME" "$symlink"
done
