#!/bin/sh
# name: Restart Sol
# icon: 🔄
nohup sh -c 'killall sol; sleep 0.5; open -a Sol' >/dev/null 2>&1 &
