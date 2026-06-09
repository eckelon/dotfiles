# ds         list sessions
# ds <name>  join/create session
# detach with ctrl-\ ; sessions survive terminal close but not reboot
ds() {
  mkdir -p ~/.dtach
  if [[ -z "$1" ]]; then
    for sock in ~/.dtach/*.sock(N); do print -- "${${sock:t}:r}"; done
    return
  fi
  if [[ -n "$DTACH_NAME" ]]; then
    print -u2 "already in session '$DTACH_NAME' — detach with Ctrl-\\ first"
    return 1
  fi
  DTACH_NAME=$1 dtach -A ~/.dtach/$1.sock -z zsh
}

# Restore last cwd per session (survives reboot via the saved file).
if [[ -n "$DTACH_NAME" ]]; then
  _dtach_cwd_file=~/.dtach/$DTACH_NAME.cwd
  if [[ -r $_dtach_cwd_file ]]; then
    _saved=$(<$_dtach_cwd_file)
    [[ -d "$_saved" ]] && cd "$_saved"
    unset _saved
  fi
  _dtach_save_cwd() { print -r -- "$PWD" > ~/.dtach/$DTACH_NAME.cwd }
  add-zsh-hook chpwd _dtach_save_cwd
  unset _dtach_cwd_file
fi

[[ -n "$DTACH_NAME" ]] && RPROMPT='%F{242}[$DTACH_NAME]%f'
