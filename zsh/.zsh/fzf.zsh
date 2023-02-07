FZF_COMMAND=("fzf")

load_fzf () {
    source $HOME/.fzf.zsh
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
}

eval "${cmd}(){ unset -f ${FZF_COMMAND}; load_fzf; ${cmd} \$@ }"
