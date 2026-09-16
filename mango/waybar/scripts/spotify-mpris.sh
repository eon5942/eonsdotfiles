#!/usr/bin/env bash
# Waybar helper for a Spotify-only mpris widget (art/title/prev/playpause/next).
# Mirrors the signal-driven pattern mango-tags.sh uses for tags: a "watch"
# daemon (started once from mango's autostart) caches state to disk and nudges
# waybar (signal 9) whenever it changes; each waybar module just reads the
# cache back out via "status <role>", so no module ever blocks on playerctl.
set -u

CACHE="$HOME/.cache/waybar-spotify"
STATE="$CACHE/state"
ART="$CACHE/art.jpg"
ART_URL_CACHE="$CACHE/art_url"

mkdir -p "$CACHE"

resolve_art_path() {
    local arturl="$1"
    [ -z "$arturl" ] && return
    case "$arturl" in
        file://*)
            printf '%s' "${arturl#file://}"
            ;;
        http://*|https://*)
            if [ ! -f "$ART_URL_CACHE" ] || [ "$(cat "$ART_URL_CACHE" 2>/dev/null)" != "$arturl" ]; then
                curl -sL --max-time 3 -o "$ART.tmp" "$arturl" && mv "$ART.tmp" "$ART"
                printf '%s' "$arturl" > "$ART_URL_CACHE"
            fi
            [ -f "$ART" ] && printf '%s' "$ART"
            ;;
    esac
}

case "${1:-}" in
    status)
        role="$2"
        if [ ! -s "$STATE" ]; then
            case "$role" in
                art) printf '' ;;
                *) printf '{"text":"","tooltip":""}\n' ;;
            esac
            exit 0
        fi
        IFS='|' read -r status artist title arturl < "$STATE"

        case "$role" in
            art)
                resolve_art_path "$arturl"
                ;;
            title)
                jq -cn --arg t "$title" --arg a "$artist" \
                    '{text: ($t + " – " + $a), tooltip: ($t + " – " + $a)}'
                ;;
            playpause)
                icon=""
                [ "$status" = "Paused" ] && icon=""
                cls="playing"
                [ "$status" = "Paused" ] && cls="paused"
                jq -cn --arg i "$icon" --arg c "$cls" '{text: $i, class: $c}'
                ;;
            prev)
                printf '{"text":""}\n'
                ;;
            next)
                printf '{"text":""}\n'
                ;;
        esac
        ;;
    click)
        playerctl -p spotify "${2:-play-pause}" 2>/dev/null
        ;;
    watch)
        # Persistent daemon, started once from mango's autostart.
        while true; do
            playerctl -p spotify metadata \
                --format '{{status}}|{{artist}}|{{title}}|{{mpris:artUrl}}' \
                --follow 2>/dev/null \
            | while IFS= read -r line; do
                printf '%s' "$line" > "$STATE"
                pkill -RTMIN+9 waybar 2>/dev/null
            done
            # playerctl --follow exits once Spotify quits - clear state so
            # the widget hides itself instead of freezing on the last track.
            : > "$STATE"
            pkill -RTMIN+9 waybar 2>/dev/null
            sleep 1
        done
        ;;
esac
