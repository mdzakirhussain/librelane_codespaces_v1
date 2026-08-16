#!/bin/bash

vncserver -kill :1 >/dev/null 2>&1 || true

vncserver :1 -geometry 1600x900 -depth 24

pkill websockify >/dev/null 2>&1 || true

nohup websockify \
--web=/usr/share/novnc \
6080 localhost:5901 >/tmp/novnc.log 2>&1 &

echo
echo "Desktop Started!"
echo "Open:"
echo "https://<your-codespace>-6080.app.github.dev/vnc.html"
