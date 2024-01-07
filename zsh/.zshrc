if [ -z "$TMUX" ]; then
    tmux attach -d -t || tmux new-session
fi

TERM=xterm-256color
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
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[5~" page-up

autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Starship prompt theme
eval "$(starship init zsh)"

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'

export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/nvim-macos/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/opt/homebrew/opt/llvm/bin"
export EDITOR='hx'
export VISUAL='vim'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt auto_cd #automatically cd to a directory without `cd`
setopt histignorealldups sharehistory

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'

source <(oc completion zsh)

export PATH="/usr/local/opt/openjdk@17/bin:$PATH"

export PATH="$HOME/.rd/bin:$PATH"
export PATH="$HOME/zig-0.12:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/eckelon/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# bun completions
[ -s "/Users/eckelon/.bun/_bun" ] && source "/Users/eckelon/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[5~" page-up

autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

HISTSIZE=100000000000000
SAVEHIST=100000000000000
HISTFILE=~/.zsh_history

# Starship prompt theme
eval "$(starship init zsh)"

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'

export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/nvim-macos/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$(brew --prefix)/opt/llvm/bin"
export EDITOR='hx'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt auto_cd #automatically cd to a directory without `cd`
setopt histignorealldups sharehistory

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'

source <(oc completion zsh)

export PATH="/usr/local/opt/ruby@2.7/bin:$PATH"
export PATH="/Users/jasamitier/.rd/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/jasamitier/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
