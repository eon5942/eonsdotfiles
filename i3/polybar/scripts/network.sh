#!/usr/bin/env sh
# Active network status via NetworkManager.
command -v nmcli >/dev/null 2>&1 || { printf 'NET 📶 off'; exit 0; }

state=$(nmcli -t -f STATE general 2>/dev/null)
[ "$state" = "connected" ] || { printf 'NET 📶 off'; exit 0; }

line=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$3=="connected"{print; exit}')
type=$(printf '%s' "$line" | cut -d: -f2)

if [ "$type" = "wifi" ]; then
    info=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2" "$3"%"; exit}')
    printf 'NET 📶 %s' "${info:-wifi}"
else
    printf 'NET 📶 eth'
fi
