# Enable autocompletion

# autoload -Uz compinit # for dump in ~/.zcompdump(N.mh+24); do #   compinit -i # done # compinit -i -C

source $HOME/.zsh/nvm.zsh
source $HOME/.zsh/zoxide.zsh
source $HOME/.zsh/completions.zsh
source $HOME/.zsh/aliases.zsh

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/zsh-private-config/init.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [ -f ~/.fzf.zsh ]; then
  source $HOME/.fzf.zsh
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[5~" page-up

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Theme settings
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure
PURE_PROMPT_SYMBOL=λ
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'

export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/nvim-macos/bin"
export PATH="$PATH:$HOME/.local/bin"

export EDITOR='hx'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt auto_cd #automatically cd to a directory without `cd`
setopt histignorealldups sharehistory

source <(oc completion zsh)
