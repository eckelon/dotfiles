// Pi status overrides — OWN extension, no third-party code is edited.
//
// Interaction timer: STARTS when the user presses Enter (before_agent_start,
// fired after the prompt is submitted) and STOPS when the agent is FULLY done
// (agent_settled, fired after all continuations/retries finish). It is
// deliberately NOT tied to turn_start/turn_end or agent_end: those fire per
// model call inside one request, so they would reset the count "each time the
// agent thinks". We want: Enter -> counts continuously -> ends when the agent
// returns with everything done.
//
// Keys we own:
//   "0uptime"    -> real wall clock + interaction elapsed (while working).
//                    Key starts with a digit: pi sorts extension statuses
//                    alphabetically and truncates to terminal width, so "0"
//                    sorts FIRST and always survives even on a narrow terminal
//                    (the later keys are the ones that get cut).
//   "ponytail"   -> compact badge "🐴 FULL" (replaces ponytail's own text via
//                    the same key; our reassert/timer wins the race).
//   "pi-lens-lsp"-> replaces pi-lens's own status via the same key:
//                    LSP servers alive (from ~/.pi-lens/instances.json — the
//                    pi-lens instance registry; same process so process.pid
//                    matches) -> just "LSP Active"; else nothing at all
//                    (clears pi-lens's "LSP Inactive" + server list).
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let interactionStart: number | null = null;
  // Kept after the interaction finishes so the final time stays visible
  // (frozen) instead of disappearing; reset on the next Enter.
  let frozenElapsed: number | null = null;
  let timer: ReturnType<typeof setInterval> | undefined;
  let setStatus: ((key: string, text: string | undefined) => void) | undefined;
  let theme: any;

  const now = (): string => {
    const d = new Date();
    const p = (n: number) => String(n).padStart(2, "0");
    return `${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
  };

  const ponytailMode = (): string => {
    try {
      const env = process.env.PONYTAIL_DEFAULT_MODE;
      if (env && /^(full|lite|ultra)$/i.test(env)) return env.toLowerCase();
      const fs = require("node:fs") as typeof import("node:fs");
      const os = require("node:os") as typeof import("node:os");
      const path = require("node:path") as typeof import("node:path");
      const base =
        process.env.XDG_CONFIG_HOME || path.join(os.homedir(), ".claude");
      for (const p of [
        path.join(base, "ponytail", "config.json"),
        path.join(os.homedir(), ".claude", "ponytail", "config.json"),
      ]) {
        try {
          const cfg = JSON.parse(fs.readFileSync(p, "utf8"));
          if (cfg.defaultMode && /^(full|lite|ultra)$/.test(cfg.defaultMode))
            return cfg.defaultMode;
        } catch {
          /* try next */
        }
      }
    } catch {
      /* no config */
    }
    return "full";
  };

  const dim = (s: string): string => (theme?.fg ? theme.fg("dim", s) : s);

  // Live LSP liveness, read from pi-lens's instance registry. True when THIS
  // pi process has live LSP-server children; clear otherwise so pi-lens's own
  // "LSP Inactive" and comma-separated server list never render.
  const lspStatus = (): string | undefined => {
    try {
      const fs = require("node:fs") as typeof import("node:fs");
      const os = require("node:os") as typeof import("node:os");
      const path = require("node:path") as typeof import("node:path");
      const reg = JSON.parse(
        fs.readFileSync(
          path.join(os.homedir(), ".pi-lens", "instances.json"),
          "utf8",
        ),
      );
      const me = (reg?.instances ?? []).find(
        (i: { pid?: number }) => i.pid === process.pid,
      );
      const alive =
        Boolean(me) &&
        Array.isArray(me.lspChildren) &&
        me.lspChildren.length > 0;
      if (alive) {
        return theme?.fg ? theme.fg("success", "LSP Active") : "LSP Active";
      }
      return undefined;
    } catch {
      return undefined;
    }
  };

  const apply = () => {
    if (!setStatus) return;
    try {
      // Key "0uptime" (digit first) sorts FIRST in the footer status line, so it
      // is never truncated, even on narrow terminals.
      const parts = now();
      const base =
        interactionStart === null
          ? frozenElapsed
          : Date.now() - interactionStart;
      setStatus(
        "0uptime",
        dim(base === null ? parts : `⏱${fmtShort(base)} ${parts}`),
      );
    } catch {
      /* ignore */
    }
    try {
      // Same key as ponytail's own status -> our compact text replaces it.
      setStatus("ponytail", `🐴 ${ponytailMode().toUpperCase()}`);
    } catch {
      /* ignore */
    }
    try {
      // Same key as pi-lens's own status -> we own the render (reassert wins).
      setStatus("pi-lens-lsp", lspStatus());
    } catch {
      /* ignore */
    }
  };

  // Compact elapsed: 0-59s -> "42s"; minutes -> "5m12s"; hours -> "1h05m".
  const fmtShort = (ms: number): string => {
    const s = Math.floor(ms / 1000);
    const h = Math.floor(s / 3600);
    const m = Math.floor((s % 3600) / 60);
    const ss = s % 60;
    if (h > 0) return `${h}h${String(m).padStart(2, "0")}m`;
    if (m > 0) return `${m}m${String(ss).padStart(2, "0")}s`;
    return `${ss}s`;
  };

  const reassert = () => setTimeout(apply, 0);

  const hook = (event: string, mid?: () => void) => {
    pi.on(event as any, async (_ev: any, ctx: any) => {
      if (!setStatus && ctx?.ui?.setStatus) {
        setStatus = ctx.ui.setStatus.bind(ctx.ui);
        theme = ctx.ui.theme;
      }
      mid?.();
      apply();
      reassert();
    });
  };

  hook("session_start", () => {
    if (!timer) {
      timer = setInterval(apply, 250);
    }
  });

  // ── Interaction timer ───────────────────────────────────────────────────
  // START: first of (before_agent_start | turn_start) that fires after Enter;
  // guarded so later per-model-call turn_start events do NOT reset it.
  // STOP: agent_settled — after ALL continuations/retries finish.
  // START: first of (before_agent_start | turn_start) that fires after Enter;
  // guarded so later per-model-call turn_start events do NOT reset it.
  // STOP+freeze: agent_settled -> keep showing the final elapsed (frozen);
  // reset frozen on the next Enter.
  const startInteraction = () => {
    if (interactionStart === null) {
      frozenElapsed = null;
      interactionStart = Date.now();
    }
  };
  hook("before_agent_start", startInteraction);
  hook("turn_start", startInteraction);
  hook("agent_settled", () => {
    if (interactionStart !== null) {
      frozenElapsed = Date.now() - interactionStart;
    }
    interactionStart = null;
  });
  // ────────────────────────────────────────────────────────────────────────

  pi.on("session_shutdown", () => {
    if (timer) clearInterval(timer);
    timer = undefined;
  });
}
