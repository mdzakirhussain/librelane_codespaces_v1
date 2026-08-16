#!/bin/bash
set -e

echo "==============================="
echo "Updating system..."
echo "==============================="
sudo apt update

echo "==============================="
echo "Installing desktop packages..."
echo "==============================="
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    xfce4 \
    xfce4-goodies \
    dbus-x11 \
    xterm \
    thunar \
    mousepad \
    firefox \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify

echo "==============================="
echo "Creating VNC configuration..."
echo "==============================="

mkdir -p ~/.vnc

cat > ~/.vnc/xstartup <<'EOF'
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XDG_SESSION_TYPE=x11
export DESKTOP_SESSION=xfce
export XDG_CURRENT_DESKTOP=XFCE

exec dbus-run-session -- startxfce4
EOF

chmod +x ~/.vnc/xstartup

echo
echo "==============================="
echo "Create your VNC password"
echo "==============================="
vncpasswd

echo
echo "Stopping old VNC session..."
vncserver -kill :1 >/dev/null 2>&1 || true

echo
echo "Starting VNC..."
vncserver :1 -geometry 1600x900 -depth 24

echo
echo "Starting noVNC..."
pkill websockify >/dev/null 2>&1 || true

nohup websockify \
    --web=/usr/share/novnc \
    6080 localhost:5901 \
    >/tmp/novnc.log 2>&1 &

echo
echo "==============================================="
echo "Desktop is ready!"
echo "==============================================="
echo
echo "Forward port 6080 in GitHub Codespaces."
echo
echo "Open:"
echo
echo "https://<your-codespace>-6080.app.github.dev/vnc.html"
echo
echo "Login using your VNC password."