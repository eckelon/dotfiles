# pi-config agent context

Shared, public configuration for the pi coding agent with the API provider.
Everything here is intentional and verified — read before you touch.

## Rules

- **EVERYTHING in English.** All repo content, docs, comments, commit messages — always in English. Do not write any text that is not English in this repo. Never.
- **Never edit `~/.pi/agent/*.json` directly**: edit this repo and apply with `chezmoi apply ~/.pi/agent` (repo wins for tracked keys). The two personal exceptions live only locally and are preserved by sync, never published: `models.json` (your provider catalog) and the `defaultProvider` / `defaultModel` fields in `settings.json`. If the live config changed beyond those, version it back here.
- **`bash ~/software-team/scripts/sync.sh` installs the TEAM files only**: `skills/`, `prompts/`, `agents/`, `rules/` from `$HOME/software-team` into `~/.pi/agent/`. It never touches `settings.json`, `AGENTS.md` or `mcp.json` — those come from this repo via chezmoi. Do not version team files here.
- **Truncation gotcha**: pi defaults `maxTokens` to 16384 when a model doesn't declare it (provider-composer.js) — long answers get cut exactly at 16384 (`stopReason: length`). Every model must declare `maxTokens` in your local `models.json` (e.g. 65536).
- **Provider limits (measured, not guessed)**: `contextWindow` in your local `models.json` should reflect the real limits so auto-compact fires before the provider cuts, not marketing numbers.
- **The provider cuts the first call after a model switch** with a huge session (~194k input, cold cache): `stopReason: length, out=1`. This is provider-side under load, not a config bug. Auto-compact (`compaction.enabled: true`, `reserveTokens: 70000`) rescues the session via `isContextOverflow`.
- **Model routing removed (2026-08-23)**: the `por-tarea` router (`@kylebrodeur/pi-model-router`) and its config were deleted — the user does not use it. Model selection is direct: `defaultModel` (set locally, not in this repo) for interactive, explicit `provider/model` refs in agents. Do not reintroduce a router unless the user asks.
- **Agents (2026-08-15)**: engineer and devops on the default (uncapped score) model, with `-deepseek` variants for hard rounds; architect, QA and ux-ui on the paid model. Pins live in the agent definitions, not here — names intentionally omitted from this public repo.
- **NEVER edit third-party package code** under `~/.pi/agent/npm/node_modules/` (or any extension package). It is reinstalled on updates and every manual edit is lost; if a bug lives there, work around it with config or report it. This is a hard rule (user, 2026-08-07).
- **mcp.json is a template** — replace `${MCP_TOKEN}` with your own; never commit real tokens.
- **Before touching `~/.pi/agent`**: check for parallel agents that might overwrite config (e.g. other AI editors).

## Verification

| What changed | How to verify |
| --- | --- |
| JSON config | `python3 -m json.tool <file>` + `pi --list-models` |
| Sync | `diff <repo>/<file> ~/.pi/agent/<file>` |

## Memory

context-mode manages memory (anchors). Persistent design decisions live in README.md or
this file — agent memory is not versioned.
