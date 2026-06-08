autoload bashcompinit
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qNmh-24) ]]; then
  compinit -C
else
  compinit
fi

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
