autoload -Uz add-zsh-hook

_defer_compinit() {
  autoload bashcompinit
  autoload -Uz compinit
  if [[ -n ~/.zcompdump(#qNmh-24) ]]; then
    compinit -C -u
  else
    compinit
  fi
  add-zsh-hook -d precmd _defer_compinit
  unfunction _defer_compinit
}
add-zsh-hook precmd _defer_compinit

if [ $commands[kubectl] ]; then
  kubectl() {
    unfunction "$0"
    source <(kubectl completion zsh)
    $0 "$@"
  }
fi

if [ $commands[git] ]; then
  git() {
    unfunction "$0"
    source <(git completion zsh)
    $0 "$@"
  }
fi

# Deferred completion sources — loaded after first prompt to keep startup snappy.
_defer_fzf() {
  source <(fzf --zsh)
  add-zsh-hook -d precmd _defer_fzf
  unfunction _defer_fzf
}
add-zsh-hook precmd _defer_fzf

_defer_bun() {
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  add-zsh-hook -d precmd _defer_bun
  unfunction _defer_bun
}
add-zsh-hook precmd _defer_bun
