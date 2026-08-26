autoload -Uz add-zsh-hook

_defer_compinit() {
  autoload bashcompinit
  autoload -Uz compinit
  # shellcheck disable=SC1036,SC1072,SC1073  # zsh glob qualifier (#qNmh-24); shellcheck parses this as bash
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

# Deferred completion sources — loaded after first prompt to keep startup snappy.
_defer_fzf() {
  # fzf >= 0.48 emits shell integration via `fzf --zsh`; older fzf (e.g. apt's
  # 0.44 on Ubuntu 24.04) rejects `--zsh` and ships /usr/share/fzf/*.zsh.
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
  fi
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
