#!/usr/bin/env bash
# Global alt-tab: cycles focus across ALL workspaces by MRU (focusHistoryID is
# global). Hyprland's cyclenext is workspace-scoped, which is useless with one
# window per workspace. Usage: alt-tab.sh next|prev
set -euo pipefail
dir="${1:-next}"
mapfile -t wins < <(hyprctl -j clients | jq -r '[.[] | select(.workspace.id >= 0 and .mapped)] | sort_by(.focusHistoryID) | .[].address')
n=${#wins[@]}
(( n > 0 )) || exit 0
cur=$(hyprctl -j activewindow | jq -r '.address // empty')
i=-1
for k in "${!wins[@]}"; do
	[[ "${wins[$k]}" == "$cur" ]] && { i=$k; break; }
done
if [[ "$dir" == "prev" ]]; then i=$(( (i - 1 + n) % n )); else i=$(( (i + 1) % n )); fi
hyprctl dispatch focuswindow "address:${wins[$i]}" > /dev/null
