#!/bin/sh
for symlink in zsh brew git helix karabiner kitty nvim nvm raycast tmux vim vscode starship
do
  stow -v -t "$HOME" "$symlink"
done
