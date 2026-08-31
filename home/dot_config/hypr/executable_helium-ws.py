#!/usr/bin/env python3
"""Helium must always open alone on its own workspace.

On every new window, if it is a Helium window that landed next to other
windows, move it to the first workspace id that does not exist yet and
switch the view with it (movetoworkspace, not silent). A brand-new
workspace is created on the monitor holding focus, and a freshly mapped
window is focused, so that is the monitor Helium was opened on. Once
Helium is the only window there, the scrolling layout gives it the whole
work area by itself (fullscreen_on_one_column) - no fullscreen flag.

If a launcher ever opens Helium without stealing focus, the fallback
would be to query the workspace's monitor and use workspace,monitor:
selectors instead of relying on focus."""
import json
import os
import socket
import subprocess
import sys
import time

CLASS = "helium"


def hypr_json(command: str):
    try:
        out = subprocess.run(["hyprctl"] + command.split(),
                             capture_output=True, text=True, check=False).stdout
        return json.loads(out) if out else []
    except (OSError, json.JSONDecodeError):
        return []


def hypr(*args: str) -> None:
    subprocess.run(["hyprctl", "--quiet", *args],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def main() -> int:
    sock_path = os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr",
                             os.environ["HYPRLAND_INSTANCE_SIGNATURE"],
                             ".socket2.sock")
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(sock_path)
    pending = ""
    while True:
        data = sock.recv(4096)
        if not data:
            return 0
        pending += data.decode(errors="replace")
        while "\n" in pending:
            event, pending = pending.split("\n", 1)
            try:
                handle(event)
            except Exception as err:  # never die on one bad event
                print(f"helium-ws: {err}", file=sys.stderr)


def handle(event: str) -> None:
    if not event.startswith("openwindow>>"):
        return
    address, workspace, window_class = event.split(">>", 1)[1].split(",")[:3]
    if window_class.strip().lower() != CLASS:
        return
    try:
        workspace_id = int(workspace)
    except ValueError:
        return  # named or special workspace

    clients = hypr_json("clients -j")
    myself = f"0x{address}"
    here = [c for c in clients if c["workspace"]["id"] == workspace_id]
    # the new window may not be listed yet; count it as present
    if len(here) + (0 if any(c["address"] == myself for c in here) else 1) <= 1:
        return  # already alone (e.g. the autostart workspace)

    existing = {w["id"] for w in hypr_json("workspaces -j")}
    target = workspace_id + 1
    while target in existing:
        target += 1
    hypr("dispatch", "movetoworkspace", f"{target},address:{myself}")
    reassert_view(target, myself)


def reassert_view(target: int, address: str) -> None:
    """A chromium-style launcher dies right after spawning the window, and
    Hyprland refocuses on that death, throwing the view back. If the view
    snapped away from the new workspace while still on Helium's monitor,
    take it back; if the user moved to another monitor, leave him alone."""
    time.sleep(0.5)
    live = [c for c in hypr_json("clients -j") if c["address"] == address]
    if not live:
        return
    active = hypr_json("activeworkspace -j")
    if isinstance(active, dict) and active.get("id") != target \
            and active.get("monitorID") == live[0]["monitor"]:
        hypr("dispatch", "workspace", str(target))


if __name__ == "__main__":
    sys.exit(main())
