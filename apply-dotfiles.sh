#!/bin/sh
for symlink in zsh git karabiner nvim editorconfig starship ghostty k9s claude-skills emacs sol; do
  stow -v -t "$HOME" "$symlink"
done

# Pre-compile zsh sources to .zwc bytecode for faster shell startup.
# These files are gitignored and regenerated on every apply.
zsh -c '
  files=(
    ~/.zshrc
    ~/.zshenv
    ~/.zsh/aliases.zsh
    ~/.zsh/completions.zsh
    ~/.zsh/zoxide.zsh
    ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
    ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    ~/.zsh/pure/pure.zsh
  )
  for f in "${files[@]}"; do
    [ -f "$f" ] && zcompile "$f"
  done
  # Ensure .zcompdump exists, then compile it
  autoload -Uz compinit && compinit -u
  [ -f ~/.zcompdump ] && zcompile ~/.zcompdump
'
