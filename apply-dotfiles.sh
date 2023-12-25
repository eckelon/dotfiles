#!/bin/sh
for symlink in zsh brew git helix karabiner kitty tmux vim vscode starship
do
  stow -v -t "$HOME" "$symlink"
done
