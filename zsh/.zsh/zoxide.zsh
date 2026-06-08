j() {
    unset -f j zoxide
    eval "$(zoxide init zsh --cmd j)"
    j "$@"
}
zoxide() {
    unset -f j zoxide
    eval "$(zoxide init zsh --cmd j)"
    zoxide "$@"
}
