declare -a PYENV_GLOBALS=()

PYENV_GLOBALS+=("python", "pip", "python3", "pip3", "pyenv")

for cmd in "${PYENV_GLOBALS[@]}"; do
    eval "$(pyenv init -)"
done
