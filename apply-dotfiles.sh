#!/bin/sh
for symlink in zsh brew git helix karabiner kitty raycast tmux vim vscode starship wezterm
do
  stow -v -t "$HOME" "$symlink"
done
