#!/usr/bin/env sh
# Power menu via rofi.
theme="$HOME/.config/rofi/everforest.rasi"
choice=$(printf 'Logout\nSuspend\nReboot\nShutdown' \
    | rofi -dmenu -p 'power' -theme "$theme")

case "$choice" in
    Logout)   i3-msg exit ;;
    Suspend)  systemctl suspend ;;
    Reboot)   systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
