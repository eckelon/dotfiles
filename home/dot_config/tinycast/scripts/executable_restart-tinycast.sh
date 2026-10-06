#!/bin/sh
nohup sh -c 'killall Tinycast; sleep 0.5; open -a Tinycast' >/dev/null 2>&1 &
