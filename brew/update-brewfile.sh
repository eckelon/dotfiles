#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

brew autoremove
brew bundle dump --file="$BREWFILE" --force

# Remove dependency-only formulae, keep only top-level
LEAVES=$(brew leaves)
tmp=$(mktemp)

while IFS= read -r line; do
  case "$line" in
    brew\ *)
      pkg=$(echo "$line" | sed 's/brew "\([^"]*\)".*/\1/')
      if echo "$LEAVES" | grep -qx "$pkg"; then
        echo "$line"
      fi
      ;;
    *)
      echo "$line"
      ;;
  esac
done < "$BREWFILE" > "$tmp"

mv "$tmp" "$BREWFILE"
echo "Brewfile updated at $BREWFILE"
