#!/bin/sh
for symlink in zsh git karabiner nvim editorconfig starship ghostty k9s claude-skills emacs sol; do
  stow -v -t "$HOME" "$symlink"
done
