# if [ -z "$TMUX" ]; then
#     tmux attach -d -t || tmux new-session
# fi

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/nvim-macos/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Library/Python/3.11/bin/"
export EDITOR='nvim'

if [ -z "$TMUX" ]; then
    attached_session=$(tmux list-sessions | grep attached)
    if [ -z "$attached_session" ]; then
        tmux attach -d -t || tmux new-session
    else
        tmux new-session
    fi
fi

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/zsh-private-config/init.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/zoxide.zsh
source $HOME/.zsh/gcloud.zsh
source $HOME/.zsh/completions.zsh


bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[H" beginning-of-line
bindkey "^A" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[5~" page-up

autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=~/.zsh_history

PROMPT='%F{#8caaee}%~%f%F{#8caaee}❭ '

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'


alias vim='nvim'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt auto_cd #automatically cd to a directory without `cd`
setopt histignorealldups sharehistory

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'

# source <(oc completion zsh)

export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export PATH="$HOME/.rd/bin:$PATH"
export PATH="$HOME/zig-0.12:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/eckelon/.bun/_bun" ] && source "/Users/eckelon/.bun/_bun"
