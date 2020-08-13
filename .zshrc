autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit -i
done
compinit -i -C
ulimit -Sn 4096

fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

setopt auto_cd

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# [ -z "$TMUX"  ] && { tmux -u attach || exec tmux -u new-session && exit;}

# for having italics inside tmux:
# tic -x xterm-256color-italic.terminfo
# tic -x tmux-256color.terminfo
export TERM=xterm-256color-italic
export EDITOR='nvim'
export DISABLE_AUTO_TITLE=true

source $HOME/.zsh/nvm.zsh
source $HOME/.zsh/completions.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/tmux.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

setopt histignorealldups sharehistory

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

export PATH="$HOME/nvim-osx64/bin:$PATH"

export AUTOJUMP_HOME=$HOME/.autojump
source ${AUTOJUMP_HOME}/bin/autojump.zsh
source $HOME/.zsh/zsh-private-config/init.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

PURE_PROMPT_SYMBOL=λ
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black'
