#!/bin/bash
# Captures the current Tinycast preferences into:
#   home/dot_config/tinycast/settings.plist
#
# Window/menu-bar state, inherited system defaults and snippetsEnabled are
# dropped: the first two are churn, the last is consent to keystroke listening
# and Tinycast keeps it out of its own backups for that reason.
#
# Usage: ./scripts/capture-tinycast-settings.sh

set -euo pipefail

domain="com.tinycast.app"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
settings="$repo_root/home/dot_config/tinycast/settings.plist"

tmp="$(mktemp -t tinycast-settings).plist"
trap 'rm -f "$tmp"' EXIT

defaults export "$domain" - > "$tmp"

while IFS= read -r key; do
  [ -n "$key" ] || continue
  /usr/libexec/PlistBuddy -c "Delete :\"$key\"" "$tmp" >/dev/null
  echo "⊘ Dropped $key"
done < <(plutil -convert json -o - "$tmp" |
  jq -r 'keys[] | select(startswith("NS") or startswith("Apple") or . == "snippetsEnabled")')

plutil -convert xml1 "$tmp"
mv "$tmp" "$settings"
echo "✓ Captured $settings"
