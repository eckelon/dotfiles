#
# User configuration sourced by interactive shells
#

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[ -z "$TMUX"  ] && { tmux -u attach || exec tmux -u new-session && exit;}

# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
export ZSH_HOME=${ZDOTDIR:-${HOME}}/.zsh
export AUTOJUMP_HOME=${ZDOTDIR:-${HOME}}/.autojump

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

export PATH="$HOME/nvim-osx64/bin:$PATH"
export PATH="$HOME/vimr:$PATH"
source ${ZSH_HOME}/aliases.zsh
source ${ZSH_HOME}/case-environments.zsh
source ~/forgit/forgit.plugin.zsh
source ~/zsh-utils/spaceship-prompt/spaceship.zsh

source ${AUTOJUMP_HOME}/bin/autojump.zsh

export GEM_HOME=~/.gem
export GEM_PATH=~/.gem

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export FZF_DEFAULT_COMMAND='rg --files --hidden'
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
alias cat="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias ls="exa"
alias l="exa -lahF"
alias find="fd"
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

if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
