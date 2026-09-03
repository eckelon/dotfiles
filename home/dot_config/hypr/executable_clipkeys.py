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
It needs passwordless `keyd bind` (see run_onchange_after_keyd-sudo-rule.sh).
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


def keyd_pid() -> str:
    return subprocess.run(["systemctl", "show", "keyd", "-p", "MainPID", "--value"],
                          capture_output=True, text=True).stdout.strip()


def keyd(*bindings: str) -> None:
    for binding in bindings:  # one call per binding: keyd applies only the first
        run = subprocess.run(["sudo", "-n", "keyd", "bind", binding],
                             capture_output=True, text=True)
        if "max macros" in run.stdout + run.stderr:
            # keyd appends runtime bindings, it never replaces them, so after a
            # few hundred the table fills up. reload re-reads the config and
            # empties it, then the same binding fits again.
            subprocess.run(["sudo", "-n", "keyd", "reload"], capture_output=True)
            run = subprocess.run(["sudo", "-n", "keyd", "bind", binding],
                                 capture_output=True, text=True)
        if "Success" not in run.stdout:  # a typo'd key name only surfaces here
            print(f"keyd bind failed: {binding} {run.stdout.strip()} "
                  f"{run.stderr.strip()}", file=sys.stderr, flush=True)


def focused_is_terminal() -> bool:
    win = hypr_json(["activewindow", "-j"]) or {}
    return str(win.get("class", "")).lower() in TERMS


def main() -> int:
    path = os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr",
                        os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket2.sock")
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    sock.settimeout(60.0)  # timer: catch a keyd restart, which drops the bindings
    pid = keyd_pid()
    terminal = focused_is_terminal()
    keyd(*(TERM if terminal else GUI))
    while True:
        try:
            data = sock.recv(4096)
        except TimeoutError:
            now = keyd_pid()
            if now != pid:  # a bind now would only duplicate: keyd appends
                pid = now
                keyd(*(TERM if terminal else GUI))
            continue
        if not data:
            return 0
        for event in data.decode(errors="replace").splitlines():
            head, _, payload = event.partition(">>")
            if head == "activewindow":
                now = payload.split(",")[0].lower() in TERMS
                if now != terminal:  # never re-send an unchanged state: keyd
                    keyd(*(TERM if now else GUI))  # appends, it does not replace
                    terminal = now


if __name__ == "__main__":
    raise SystemExit(main())
