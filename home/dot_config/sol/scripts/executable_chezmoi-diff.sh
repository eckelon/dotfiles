#!/bin/sh
# name: Chezmoi Diff
# icon: 👀
open -na Ghostty --args -e sh -c "chezmoi diff | less -R"
