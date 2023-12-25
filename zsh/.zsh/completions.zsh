autoload bashcompinit
autoload -Uz compinit
compinit -i -C

if [ $commands[kubectl] ]; then
  # Placeholder 'kubectl' shell function:
  # Will only be executed on the first call to 'kubectl'
  kubectl() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"
    # Load auto-completion
    source <(kubectl completion zsh)
    # Execute 'kubectl' binary
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

if [ $commands[fzf] ] && [ -f ~/.fzf.zsh ]; then
  fzf() {
    unfunction "$0"
    source <(fzf completion zsh)
    $0 "$@"
  }
fi
