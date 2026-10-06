#!/bin/sh
open -na Ghostty --args -e sh -c "chezmoi diff | less -R"
