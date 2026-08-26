# Lazy-loading zoxide used to redefine `j` after `unset -f j`; that call-site
# had already been parsed as a function call, so the first `j` died with
# `command not found: j`. Eager eval defines the alias once at startup (a few
# ms) and is immune to that zsh alias-parse-time trap.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
fi
