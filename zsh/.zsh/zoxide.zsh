declare -a ZOXIDE_GLOBALS=()

ZOXIDE_GLOBALS+=("zoxide")
ZOXIDE_GLOBALS+=("j")

for cmd in "${ZOXIDE_GLOBALS[@]}"; do
    eval "$(zoxide init zsh --cmd j)"
done
