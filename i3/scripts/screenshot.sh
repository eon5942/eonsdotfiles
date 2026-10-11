#!/usr/bin/env sh
# Screenshot helper — full | select | window
dir="${SCREENSHOT_DIR:-$HOME/Pictures/screenshots}"
mkdir -p "$dir"
name="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$1" in
    select) maim -s -u "$name" ;;
    window) maim -i "$(xdotool getactivewindow)" -u "$name" ;;
    *)      maim -u "$name" ;;
esac

if command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -t image/png < "$name"
fi

command -v notify-send >/dev/null 2>&1 && notify-send "Screenshot saved" "$name"
