#!/usr/bin/env bash
# Waybar helper for mango WM tags, talking to mango's IPC socket.
set -u

SOCK="${MANGO_INSTANCE_SIGNATURE:-}"
OUTPUT="${WAYBAR_OUTPUT_NAME:-}"

ipc() {
    printf '%s\n' "$1" | socat - "UNIX-CONNECT:${SOCK}" 2>/dev/null
}

focused_output() {
    ipc "get all-monitors" | jq -r '.monitors[] | select(.active==true) | .name' | head -n1
}

case "${1:-}" in
    status)
        idx="$2"
        out="$OUTPUT"
        [ -z "$out" ] && out="$(focused_output)"

        tag="$(ipc "get all-tags" | jq -c --arg out "$out" --argjson idx "$idx" \
            '.all_tags[] | select(.monitor==$out) | .tags[] | select(.index==$idx)')"

        if [ -z "$tag" ]; then
            printf '{"text":"%s","class":"empty"}\n' "$idx"
            exit 0
        fi

        echo "$tag" | jq -c --arg idx "$idx" '
            {
                text: $idx,
                class: (if .is_urgent then "urgent"
                        elif .is_active then "active"
                        elif .client_count > 0 then "occupied"
                        else "empty" end),
                tooltip: ("Tag \($idx) - \(.client_count) client(s)")
            }'
        ;;
    switch)
        idx="$2"
        ipc "dispatch view,${idx},0" >/dev/null
        ;;
    watch)
        # Runs as a persistent daemon (started once from mango's autostart).
        # Every time mango pushes a tag-state update, nudge waybar's custom
        # modules (signal 8) to re-run their "status" query.
        while true; do
            ( printf '%s\n' "watch all-tags"; sleep infinity ) \
                | socat - "UNIX-CONNECT:${SOCK}" \
                | while read -r _; do pkill -RTMIN+8 waybar; done
            sleep 1
        done
        ;;
esac
