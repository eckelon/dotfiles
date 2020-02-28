autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[ -z "$TMUX"  ] && { tmux -u attach || exec tmux -u new-session && exit;}

source $HOME/.zsh/nvm.zsh
source $HOME/.zsh/completions.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt histignorealldups sharehistory

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

export PATH="$HOME/nvim-osx64/bin:$PATH"
export PATH="$HOME/vimr:$PATH"

export AUTOJUMP_HOME=$HOME/.autojump
source ${AUTOJUMP_HOME}/bin/autojump.zsh
source $HOME/.zsh/zsh-private-config/init.zsh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#Java
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

alias vim="vimr -s"
# alias vim="nvim -i NONE"
alias ivm="vim"
alias weather='curl -4 wttr.in/Zaragoza?lang=es'
alias git-clean-local-branches="git branch -vv | grep -E \"desaparecido|gone\" | awk '{print $1}' | xargs -n1 git branch -d"
alias killNode="ps aux | grep ' node' | awk '{print $2}' | xargs kill"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfiles_update='dotfiles push origin master'
alias lockscreen='open -a ScreenSaverEngine'
alias grep='grep --color'
alias kdiff3='/Applications/kdiff3.app/Contents/MacOS/kdiff3'
alias mergetool='git mergetool --tool kdiff3'
alias difftool='git difftool --tool kdiff3'
# alias diff="diff-so-fancy"
# alias cat="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#alias ls="exa"
#alias l="exa -lahF"
#alias find="fd"
alias tmux="tmux -u"

SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
