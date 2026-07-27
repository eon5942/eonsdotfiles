#!/usr/bin/env bash
# Streams cava's raw ascii output as waybar bar glyphs, one line per frame.
BARS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

cava -p ~/.config/cava/config | while IFS=';' read -ra levels; do
    out=""
    for lvl in "${levels[@]}"; do
        [ -z "$lvl" ] && continue
        out+="${BARS[$lvl]}"
    done
    echo "$out"
done
