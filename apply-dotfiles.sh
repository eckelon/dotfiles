#!/bin/sh
for symlink in zsh brew git helix karabiner kitty tmux vim vscodium starship wezterm nvim editorconfig
do
  stow -v -t "$HOME" "$symlink"
done
