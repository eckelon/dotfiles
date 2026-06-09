source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/zsh-private-config/init.zsh
autoload -Uz add-zsh-hook
_defer_syntax_hl() {
  source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
  add-zsh-hook -d precmd _defer_syntax_hl
  unfunction _defer_syntax_hl
}
add-zsh-hook precmd _defer_syntax_hl


bindkey '^[[A' history-substring-search-up   # Up arrow
bindkey '^[[B' history-substring-search-down # Down arrow

source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/zoxide.zsh
source $HOME/.zsh/completions.zsh

autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=~/.zsh_history

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt auto_cd #automatically cd to a directory without `cd`
setopt histignorealldups sharehistory

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'

fpath+=("$HOME/.zsh/pure")
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL='%Bλ%b'
prompt pure

source $HOME/.zsh/dtach.zsh

true  # ensure .zshrc exits clean even if optional sources above failed
