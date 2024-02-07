#!/bin/sh
# for symlink in zsh brew git helix karabiner kitty tmux vim vscodium starship wezterm nvim editorconfig
for symlink in zsh brew git helix karabiner kitty tmux vim vscodium nvim editorconfig powerlevel10k
do
  stow -v -t "$HOME" "$symlink"
done
