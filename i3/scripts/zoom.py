#!/usr/bin/env python3
"""Swap the focused window into the master position (dwm-style zoom)."""
import i3ipc

i3 = i3ipc.Connection()
focused = i3.get_tree().find_focused()
ws = focused.workspace()

leaves = [l for l in ws.leaves() if l.type == "con" and not l.floating]
if len(leaves) >= 2 and focused.id != leaves[0].id:
    i3.command(f"[con_id={focused.id}] swap container with con_id {leaves[0].id}")
