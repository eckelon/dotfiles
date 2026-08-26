// herdr-sidebar-autohide.ts — keep the herdr-sidebar plugin pane OPEN by
// default (auto_open is ON), but auto-hide it while the terminal is narrow
// (mobile/portrait), and reopen it when the terminal widens again.
//
// herdr exposes NO resize event to plugins (verified: PLUGIN_HOOK_EVENT_KINDS
// has no layout/pane-updated), so the only hook that fires on terminal width
// changes is pi's markdown transformer, which re-runs on width changes and
// provides availableWidth. pi runs inside a herdr pane, so that width tracks
// the terminal.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// --- tuning -------------------------------------------------------------
// HIDE when the terminal is at or below this width (columns).
const NARROW_WIDTH = 64; // mirrors herdr's mobile_width_threshold
// REOPEN only at or above this width. Must be > NARROW_WIDTH + sidebar width
// (24) so the hysteresis can't oscillate: hiding frees the sidebar's columns,
// which alone must never tip the terminal back over the show threshold.
const WIDE_WIDTH = 96;
const AUTO_SHOW_SCRIPT = "/home/eckelon/.config/herdr/scripts/herdr-sidebar-auto.sh";

// state: null until the first render reports a width, then "open" | "hidden"
let state: "open" | "hidden" | null = null;

export default function (pi: ExtensionAPI) {
  pi.registerMarkdownTransformer((markdown, { isStreaming, availableWidth }) => {
    // display hook: must stay sync + cheap; skip streaming re-renders
    if (isStreaming || availableWidth === 0) return markdown;

    let next = state;
    if (availableWidth <= NARROW_WIDTH) next = "hidden";
    else if (availableWidth >= WIDE_WIDTH) next = "open";
    if (next === state) return markdown;
    state = next;

    // fire-and-forget: never block rendering, never throw into the UI
    const mode = state === "hidden" ? "hide" : "show";
    pi.exec("bash", [AUTO_SHOW_SCRIPT, mode]).catch(() => {});
    return markdown;
  });
}