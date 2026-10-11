#!/usr/bin/env sh
# Launch polybar on every connected monitor.
# Called by i3 (exec_always) and by the install script.

# Terminate any running instances
killall -q polybar
while pgrep -u "$(id -u)" -x polybar >/dev/null; do sleep 0.2; done

launch() {
    MONITOR="$1" polybar --reload everforest 2>/tmp/polybar.log &
}

if command -v xrandr >/dev/null 2>&1; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        launch "$m"
    done
else
    launch ""
fi
