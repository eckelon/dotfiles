export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/nvim-macos/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Library/Python/3.11/bin/"
export PATH="$PATH:$HOME/.lmstudio/bin"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export DYLD_LIBRARY_PATH="/usr/local/lib:$DYLD_LIBRARY_PATH"

export EDITOR="nvim"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

typeset -gU path
