#!/usr/bin/env bash
set -uo pipefail

herdr_bin="${HERDR_BIN_PATH:-herdr}"
plugin_id="${HERDR_PLUGIN_ID:-lazygit}"

target_cwd() {
  local cwd=""
  cwd="$(printf '%s' "${HERDR_PLUGIN_CONTEXT_JSON:-}" | python3 -c "
import json, sys, os
raw = sys.stdin.read()
if raw:
    d = json.loads(raw)
    print(d.get('focused_pane_cwd') or d.get('workspace_cwd') or '')
" 2>/dev/null)" || cwd=""
  [ -d "$cwd" ] || cwd="$HOME"
  printf '%s' "$cwd"
}

open_pane() {
  exec "$herdr_bin" plugin pane open \
    --plugin "$plugin_id" --entrypoint lazygit \
    --placement split --direction right --focus \
    --cwd "$(target_cwd)"
}

panes="$("$herdr_bin" pane list 2>/dev/null)" || open_pane
[ -n "$panes" ] || open_pane

decision="$(printf '%s' "$panes" | python3 -c "
import json, sys, re
data = json.load(sys.stdin)
panes = data.get('result', {}).get('panes', [])
focused = next((p for p in panes if p.get('focused')), None)
if not focused:
    print('OPEN')
else:
    lg = next((p for p in panes if p.get('label') == 'lazygit' and p.get('tab_id') == focused['tab_id']), None)
    if not lg or not re.match(r'^[A-Za-z0-9_:.][A-Za-z0-9_:.-]*$', lg.get('pane_id', '')):
        print('OPEN')
    elif lg['pane_id'] == focused['pane_id']:
        print(f'CLOSE {lg[\"pane_id\"]}')
    else:
        print(f'CLOSE {lg[\"pane_id\"]}')
" 2>/dev/null)" || decision="OPEN"

case "$decision" in
  "CLOSE "*)
    pid="${decision#CLOSE }"
    exec "$herdr_bin" pane close "$pid"
    ;;
  *)
    open_pane
    ;;
esac
