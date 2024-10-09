#!/bin/sh
for symlink in zsh brew git helix karabiner kitty tmux vim vscodium nvim editorconfig starship
do
  stow -v -t "$HOME" "$symlink"
done
