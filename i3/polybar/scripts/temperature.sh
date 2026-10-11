#!/usr/bin/env sh
# Temperature — highest thermal zone. Prints nothing if no sensors exist.
t=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -rn | head -1)
[ -n "$t" ] && printf 'tmp %s°C' "$((t / 1000))"
