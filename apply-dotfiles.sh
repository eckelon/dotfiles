#!/bin/sh
for symlink in brew git helix karabiner kitty nvim nvm raycast tmux vim vscode zsh
do
  stow -v -t "$HOME" "$symlink"
done
