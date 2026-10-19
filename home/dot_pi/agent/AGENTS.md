# pi-config agent context

Shared, public configuration for the pi coding agent with the API provider.
Everything here is intentional and verified — read before you touch.

## Rules

- **EVERYTHING in English.** All repo content, docs, comments, commit messages — always in English. Do not write any text that is not English in this repo. Never.
- **Never edit `~/.pi/agent/*.json` directly**: edit this repo and apply with `chezmoi apply ~/.pi/agent` (repo wins). The personal files that stay local and are never versioned: `models.json` (your provider catalog) and `auth.json`. `settings.json` is fully tracked — including `defaultProvider` / `defaultModel` / `theme` (2026-08-28: reality check; they had been in the repo since the first commit). If you changed the live config, version it back here (`chezmoi re-add`).
- **The team repo lives at `~/Development/software-team`** (git@github.com:eckelon/software-team.git). `bash ~/Development/software-team/scripts/sync.sh` installs the TEAM files only — `skills/`, `prompts/`, `agents/`, `rules/` — into `~/.pi/agent/` (repo wins, it prunes files the repo no longer ships, and it substitutes `{{MODEL}}` tokens from `tiers.json`). The `orchestrator.md` `argument-hint` must keep its YAML value quoted — an unquoted `:` inside `<mode: ...>` breaks pi's frontmatter parser. Personal files that stay local and are never versioned in either repo: `models.json` and `auth.json`. sync.sh never touches `settings.json`, `AGENTS.md` or `mcp-adapter.json` — those come from dotfiles via chezmoi. Do not version team files here.
- **MCP config lives in `~/.pi/agent/mcp.json`** (`mcpServers` + adapter `settings`). Personal machine: `pi-mcp-adapter` serves MCP with the built-in disabled via `"extensions": ["-builtin:mcp"]` in `settings.json` — verified 2026-10-19, the live session exposes the adapter's `mcp` gateway tool. Work machine: adapter dropped, built-in serves MCP (2026-11-14). Those two switches always move together; drop the adapter while `-builtin:mcp` stays and every MCP tool disappears.
- **Truncation gotcha**: pi defaults `maxTokens` to 16384 when a model doesn't declare it (provider-composer.js) — long answers get cut exactly at 16384 (`stopReason: length`). Every model must declare `maxTokens` in your local `models.json` (e.g. 65536).
- **Provider limits (measured, not guessed)**: `contextWindow` in your local `models.json` should reflect the real limits so auto-compact fires before the provider cuts, not marketing numbers.
- **The provider cuts the first call after a model switch** with a huge session (~194k input, cold cache): `stopReason: length, out=1`. This is provider-side under load, not a config bug. Auto-compact (`compaction.enabled: true`, `reserveTokens: 70000`) rescues the session via `isContextOverflow`.
- **Model routing removed (2026-08-23)**: the `por-tarea` router (`@kylebrodeur/pi-model-router`) and its config were deleted — the user does not use it. Model selection is direct: `defaultModel` in `settings.json` for interactive, explicit `provider/model` refs in agents. Do not reintroduce a router unless the user asks.
- **Agents (2026-08-15)**: engineer and devops on the default (uncapped score) model, with `-deepseek` variants for hard rounds; architect, QA and ux-ui on the paid model. Pins live in the agent definitions, not here — names intentionally omitted from this public repo.
- **NEVER edit third-party package code** under `~/.pi/agent/npm/node_modules/` (or any extension package). It is reinstalled on updates and every manual edit is lost; if a bug lives there, work around it with config or report it. This is a hard rule (user, 2026-08-07).
- **Before touching `~/.pi/agent`**: check for parallel agents that might overwrite config (e.g. other AI editors).

## Removed packages

- **pi-safe-compact (removed 2026-10-04)**: it makes every subagent child process (`pi --mode json -p --no-session`, as spawned by the subagent extension) exit silently with 0 turns — subagents return "(no output)" and do nothing. Verified by bisecting every installed package; still broken in v0.6.5 with pi 1.0.2. Re-enable only after the package fixes `--no-session` compatibility. Core auto-compaction (`compaction.enabled` in settings.json) is unaffected — that's pi's built-in, not this package.

## Verification

| What changed | How to verify |
| --- | --- |
| JSON config | `python3 -m json.tool <file>` + `pi --list-models` |
| Sync | `diff <repo>/<file> ~/.pi/agent/<file>` |

## Memory

context-mode manages memory (anchors). Persistent design decisions live in README.md or
this file — agent memory is not versioned.
