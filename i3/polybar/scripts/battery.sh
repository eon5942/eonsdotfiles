#!/usr/bin/env sh
# Battery status — prints nothing on machines without a battery.
for b in /sys/class/power_supply/BAT*; do
    [ -e "$b" ] || continue
    cap=$(cat "$b/capacity" 2>/dev/null)
    status=$(cat "$b/status" 2>/dev/null)
    [ -z "$cap" ] && continue
    printf 'BAT %s%%' "$cap"
    break
done
