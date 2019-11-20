#
# User configuration sourced by interactive shells
#

# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
export ZSH_HOME=${ZDOTDIR:-${HOME}}/.zsh
export AUTOJUMP_HOME=${ZDOTDIR:-${HOME}}/.autojump

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

export PATH="$HOME/nvim-osx64/bin:$PATH"
source ${ZSH_HOME}/aliases.zsh
source ${ZSH_HOME}/case-environments.zsh
source ~/forgit/forgit.plugin.zsh

source ${AUTOJUMP_HOME}/bin/autojump.zsh

export GEM_HOME=~/.gem
export GEM_PATH=~/.gem

#nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

alias vim="nvim -i NONE"
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

