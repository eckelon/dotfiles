# Enable autocompletion

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit -i
done
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

if [ $commands[tmuxinator] ]; then
_tmuxinator() {
  local commands projects
  commands=(${(f)"$(tmuxinator commands zsh)"})
  projects=(${(f)"$(tmuxinator completions start)"})

  if (( CURRENT == 2 )); then
    _alternative \
      'commands:: _describe -t commands "tmuxinator subcommands" commands' \
      'projects:: _describe -t projects "tmuxinator projects" projects'
  elif (( CURRENT == 3)); then
    case $words[2] in
      copy|cp|c|debug|delete|rm|open|o|start|s|edit|e)
        _arguments '*:projects:($projects)'
      ;;
    esac
  fi

  return
}

fi
