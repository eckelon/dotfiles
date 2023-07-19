GCLOUD_GLOBALS=("gcloud")

load_gcloud () {
    if [ -f '/Users/jasamitier/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jasamitier/google-cloud-sdk/path.zsh.inc'; fi
    if [ -f '/Users/jasamitier/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jasamitier/google-cloud-sdk/completion.zsh.inc'; fi
}

for cmd in "${GCLOUD_GLOBALS[@]}"; do
    eval "${cmd}(){ unset -f ${GCLOUD_GLOBALS}; load_gcloud; ${cmd} \$@ }"
done
