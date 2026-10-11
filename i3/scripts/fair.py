#!/usr/bin/env python3
"""Fair (grid) layout for i3 — dwl 'fair' / mango 'grid'.

Each new window splits the currently largest window along its longer axis, so
all windows converge on equal area. Workspaces in tabbed/stacking layout are
left untouched.
"""
import i3ipc

i3 = i3ipc.Connection()


def on_new(i3, e):
    con = e.container
    if con.type != "con":
        return
    ws = con.workspace()
    if ws is None or ws.layout not in ("splith", "splitv"):
        return

    others = [
        l for l in ws.leaves()
        if l.type == "con" and not l.floating and l.id != con.id
    ]
    if not others:
        return  # first window -> fullscreen

    largest = max(others, key=lambda l: l.rect.width * l.rect.height)
    r = largest.rect

    # split the longer axis so both halves stay closer to square
    # (i3: "horizontal" = side by side, "vertical" = top/bottom)
    direction = "horizontal" if r.width >= r.height else "vertical"

    mark = f"_fair_{ws.name}"
    i3.command(f"[con_id={largest.id}] mark --add {mark}")
    i3.command(f"[con_id={largest.id}] split {direction}")
    i3.command(f"[con_id={con.id}] move container to mark {mark}")
    i3.command(f"[con_id={largest.id}] unmark {mark}")
    i3.command(f"[con_id={con.id}] focus")


i3.on("window::new", on_new)
i3.main()
