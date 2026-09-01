#!/usr/bin/env python3
"""Super+C / Super+V: copy and paste, in the terminal too.

keyd owns those chords - it is the only layer that can lift Super before
emitting Ctrl, which a Hyprland bind cannot - but keyd does not know which
window is focused. Hyprland does, so this tells keyd, over its socket, which
pair to send: Ctrl+C/V for normal apps, Ctrl+Shift+C/V for terminals, where
plain Ctrl+C is SIGINT (and Ctrl+Shift+C/V is Ghostty's own copy/paste).

The bindings cannot live in /etc/keyd/default.conf: a binding in that file
outranks anything installed at runtime, so the file leaves c and v alone and
whatever runs this script owns them. Without it Super+C/V does nothing at all.
It needs `sudo -n keyd bind`; on a machine where sudo asks for a password, add
a NOPASSWD rule for that one command. keyd restarts drop the bindings - switch
a window once and they come back.
"""
import json
import os
import socket
import subprocess
import sys

TERMS = {"com.mitchellh.ghostty"}
GUI = ("meta.c=macro(leftcontrol+c)", "meta.v=macro(leftcontrol+v)")
TERM = ("meta.c=macro(leftcontrol+leftshift+c)", "meta.v=macro(leftcontrol+leftshift+v)")


def hypr_json(args: list[str]):
    out = subprocess.run(["hyprctl", *args], capture_output=True, text=True).stdout
    try:
        return json.loads(out) if out else None
    except json.JSONDecodeError:
        return None


def keyd(bindings: tuple[str, str]) -> None:
    for binding in bindings:  # one per call: keyd applies only the first argument
        run = subprocess.run(["sudo", "-n", "keyd", "bind", binding],
                             capture_output=True, text=True)
        if "Success" not in run.stdout:  # catches a typo'd key name, which keyd
            print(f"keyd bind failed: {binding} {run.stdout.strip()} {run.stderr.strip()}",
                  file=sys.stderr, flush=True)  # only reports when the key is used


def focused_is_terminal() -> bool:
    win = hypr_json(["activewindow", "-j"]) or {}
    return str(win.get("class", "")).lower() in TERMS


def main() -> int:
    path = os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr",
                        os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket2.sock")
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    sock.settimeout(60.0)  # re-apply on a timer: a keyd restart drops the bindings
    terminal = focused_is_terminal()
    keyd(TERM if terminal else GUI)
    while True:
        try:
            data = sock.recv(4096)
        except TimeoutError:
            keyd(TERM if terminal else GUI)
            continue
        if not data:
            return 0
        for event in data.decode(errors="replace").splitlines():
            head, _, payload = event.partition(">>")
            if head == "activewindow":
                now = payload.split(",")[0].lower() in TERMS
                if now != terminal:
                    keyd(TERM if now else GUI)
                    terminal = now


if __name__ == "__main__":
    raise SystemExit(main())
