#!/usr/bin/env sh
# Power menu via rofi.
theme="$HOME/.config/rofi/everforest.rasi"
choice=$(printf 'Lock\nLogout\nSuspend\nReboot\nShutdown' \
    | rofi -dmenu -p 'power' -theme "$theme")

case "$choice" in
    Lock)     i3lock -i "$HOME/.config/i3/wallpaper" -c 000000 ;;
    Logout)   i3-msg exit ;;
    Suspend)  systemctl suspend ;;
    Reboot)   systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
