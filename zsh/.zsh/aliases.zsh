# alias vim="hx"
alias ivm="vim"
alias weather='curl -4 wttr.in/Zaragoza\?lang=es'
alias git-clean-local-branches="git branch -vv | grep -E \"desaparecido|gone\" | awk '{print $1}' | xargs -n1 git branch -d"
alias killNode="ps aux | grep ' node' | awk '{print $2}' | xargs kill"
alias lockscreen='open -a ScreenSaverEngine'
alias grep='grep --color'
alias kdiff3='/Applications/kdiff3.app/Contents/MacOS/kdiff3'
alias mergetool='git mergetool --tool kdiff3'
alias difftool='git difftool --tool kdiff3'
alias diff="diff-so-fancy"
alias rg="rg --hidden"
alias fd="fd --hidden"
# alias cat="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias tmux="tmux -u"
alias k="kubectl"
alias huego=hugo
alias minikubeup="minikube start --driver=virtualbox --memory 4000 --cpus 2 --no-kubernetes"
alias python=$(which python3)
# alias mvn="docker run --rm -it -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven maven:3.8.4-openjdk-17 mvn"
alias pip=$(which pip3)
alias zshspeed='sudo rm -rf /private/var/log/asl/*.asl'
alias hxraw='hx --config $HOME/.config/helix/config_raw.toml'
