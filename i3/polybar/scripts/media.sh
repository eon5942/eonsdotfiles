#!/usr/bin/env sh
# Now-playing via playerctl. Empty output when nothing is playing.
command -v playerctl >/dev/null 2>&1 || exit 0

status=$(playerctl status 2>/dev/null) || exit 0
case "$status" in
    Playing) ;;
    Paused)  ;;
    *)       exit 0 ;;
esac

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
[ -z "$title" ] && exit 0

printf '%s%s' "${artist:+$artist - }" "$title"
