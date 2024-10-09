lazy_load_mcfly() {
    zle -D lazy_load_mcfly      # Remove this widget to prevent recursion
    eval "$(mcfly init zsh)"    # Initialize McFly
    zle reset-prompt            # Reset the prompt to ensure the shell continues running
}

# Bind Ctrl+R to the lazy-loading function
zle -N lazy_load_mcfly
bindkey '^R' lazy_load_mcfly

