# alias vim="vimr -s"
alias vim="nvim"
alias ivm="vim"
alias weather='curl -4 wttr.in/Zaragoza\?lang=es'
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
alias k="kubectl"
