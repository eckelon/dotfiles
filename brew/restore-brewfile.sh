#!/bin/sh
set -e

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
brew bundle --file="$SCRIPT_DIR/Brewfile"
