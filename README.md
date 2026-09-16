# eonsdotfiles

Personal configuration files, managed with [`dots`](https://github.com/evanpurkhiser/dots).

`dots` compiles files from this source tree into their real locations under
`install_path` (here, `$HOME/.config`). It copies rather than symlinks, so edits are
made here and then deployed with `dots install` — editing the installed copy
directly has no effect on the source.

This repo tracks **three complete compositor setups**:

| Setup       | Compositor                                              | Group   | Status bar | Launcher | Terminal | Theme                          |
| ----------- | ------------------------------------------------------- | ------- | ---------- | -------- | -------- | ------------------------------ |
| Mango       | [mango](https://github.com/DreamMaoMao/mango) (wlroots) | `mango` | waybar     | fuzzel   | kitty    | Minecraft-ore palette (matugen) |
| Mango (mono)| [mango](https://github.com/DreamMaoMao/mango) (wlroots) | `mono`  | waybar     | wofi     | foot     | Monochrome (black/white)        |
| dwl         | [dwl](https://github.com/djpohly/dwl) (wlroots)         | `dwl`   | yambar     | wofi     | foot     | Monochrome (black/white)        |

All three share the same font (Iosevka Nerd Font Mono), the same 9-tag
Ctrl/Alt key scheme, and the same dual-monitor layout (`HDMI-A-1` primary at
the origin, `eDP-1` to the right). They differ in philosophy: **mango**
(`mango` group) is a full-featured animated compositor with a themed bar and
per-wallpaper color generation; **mango (mono)** (`mono` group) is the *same*
compositor with the dwl monochrome aesthetic and dwl keymap ported onto it;
**dwl** is the stripped-down, compile-time-configured compositor in the spirit
of dwm.

---

## Groups

| Group   | Description                                                                   |
| ------- | ----------------------------------------------------------------------------- |
| `base`  | Shared shell/app config — installed everywhere, always (a `base_groups` entry).|
| `mango` | The old mango rice (mango + waybar + kitty + matugen).                        |
| `dwl`   | The minimal dwl rice (compositor + foot/wofi/mako/yambar).                    |
| `mono`  | The new mango rice: dwl's monochrome look + dwl keymap, ported onto mango.    |

`base` and `dwl` are listed in `base_groups`, so `dots install` always deploys
them. `mango` and `mono` are mutually-exclusive *profiles* — pick one:

```sh
dots config use mango   # old mango rice (matugen/ore waybar)
dots config use mono    # new mango rice (dwl monochrome look)
dots install
```

`dots config use` writes the chosen profile to the lockfile; `dots install`
then compiles `base` + `dwl` + the chosen profile group.

## Profiles

`config.yml` maps each profile name to a list of groups (plus the
`base_groups`, which are always included):

| Profile | Resolves to               | Result                                    |
| ------- | ------------------------- | ----------------------------------------- |
| `mango` | `base` + `dwl` + `mango`  | **old** mango rice (matugen/ore waybar)   |
| `mono`  | `base` + `dwl` + `mono`   | **new** mango rice (dwl monochrome look)  |

The two profiles install `mango/mango/config.conf` and `mono/mango/config.conf`
to the same destination (`~/.config/mango/config.conf`), so switching profiles
is a clean flip between the two rices — no manual cleanup, because `dots
install` removes files that are no longer in the active group set.

## Layout

`install_path` is `${HOME}/.config`, so paths inside a group map straight
into it:

```
base/bashrc                 -> ~/.config/bashrc
mango/mango/config.conf     -> ~/.config/mango/config.conf
mango/waybar/style.css      -> ~/.config/waybar/style.css
dwl/dwl/config.h            -> ~/.config/dwl/config.h
dwl/foot/foot.ini           -> ~/.config/foot/foot.ini
mono/mango/config.conf      -> ~/.config/mango/config.conf   (mono profile)
```

### Non-XDG apps

GTK2 doesn't support `XDG_CONFIG_HOME`, so `base/gtkrc-2.0` installs to
`~/.config/gtkrc-2.0` as usual, and `base/gtkrc-2.0.install` symlinks
`~/.gtkrc-2.0` to it. Install scripts (`<file>.install`) run automatically
whenever the file they're paired with changes; see `dots`' README for the
full mechanism.

GTK3/4 (`~/.config/gtk-{3,4}.0/settings.ini`) and `kdeglobals` are edited
directly and intentionally left untracked — Plasma rewrites them itself
(e.g. from System Settings), so tracking them here would just fight it.

---

## Mango (`mango` group)

Mango is a wlroots-based Wayland compositor written in C++ (a lighter,
Hyprland-adjacent tiling WM with animations, IPC, and many layouts). The
"rice" is a Minecraft inventory-slot aesthetic: every waybar module is a
beveled slot, the tags are hotbar slots 1–9, and the accent palette is named
after ores (`xp-green`, `diamond`, `gold-ore`, `redstone`).

Full upstream docs: <https://github.com/DreamMaoMao/mango/wiki/>.

### Files

| Source                                    | Destination                         | Purpose                                  |
| ----------------------------------------- | ----------------------------------- | ---------------------------------------- |
| `mango/mango/config.conf`                 | `~/.config/mango/config.conf`       | Main compositor config                   |
| `mango/mango/colors.conf`                 | `~/.config/mango/colors.conf`       | Color overrides (generated by matugen)   |
| `mango/matugen/config.toml`               | `~/.config/matugen/config.toml`     | matugen template hooks                    |
| `mango/matugen/templates/*`               | `~/.config/matugen/templates/*`     | Color templates (waybar/kitty/mango/gtk/mako) |
| `mango/waybar/config.jsonc`               | `~/.config/waybar/config.jsonc`     | Bar layout & modules                      |
| `mango/waybar/style.css`                  | `~/.config/waybar/style.css`        | Bar theme (slot/hotbar look)             |
| `mango/waybar/colors.css`                 | `~/.config/waybar/colors.css`       | Ore palette (generated by matugen)       |
| `mango/waybar/scripts/*`                  | `~/.config/waybar/scripts/*`        | Tags / spotify / cava helper scripts     |
| `mango/kitty/kitty.conf`                  | `~/.config/kitty/kitty.conf`        | Terminal config                          |
| `mango/kitty/colors.conf`                 | `~/.config/kitty/colors.conf`       | Terminal colors (generated by matugen)   |

### Theming (matugen)

Colors are not hardcoded: [`matugen`](https://github.com/InioX/matugen)
derives a palette from the current wallpaper and regenerates every target
through the templates in `mango/matugen/templates/`:

- `waybar-colors.template` → `~/.config/waybar/colors.css` — the ore palette
  (`xp-green` = primary, `diamond` = secondary, `gold-ore` = tertiary,
  `redstone` = error), then restarts waybar.
- `mango-colors.template` → `~/.config/mango/colors.conf` — the compositor's
  `rootcolor`/`maximizescreencolor`/`scratchpadcolor`/`urgentcolor`/`globalcolor`,
  then reloads mango via `mmsg dispatch reload_config`.
- `kitty-colors.template` → `~/.config/kitty/colors.conf`.
- `gtk-colors.template` → `~/.config/gtk-4.0/gtk.css` (accent colors).
- `mako-colors.template` → `~/.config/mako/colors` (notifications), then
  `makoctl reload`.

`mango/mango/config.conf` does not define its own colors; it `source`s
`~/.config/mango/colors.conf` (the matugen output), so changing wallpaper and
re-running matugen re-themes the entire WM in one shot.

### Compositor settings (highlights)

- **Effects** — blur/shadows/layer effects disabled; `border_radius=6`;
  focused opacity `1.0`, unfocused `0.8`.
- **Animations** — enabled, `slide` open/close with fade; horizontal tag
  transitions; per-action duration/easing (e.g. `animation_duration_open=400`,
  `animation_curve_open=0.46,1.0,0.29,1`).
- **Layouts available** — `tile`, `scroller`, `grid`, `deck`, `monocle`,
  `center_tile`, `vertical_tile`, `vertical_scroller`. Every tag is pinned to
  `tile` via `tagrule=id:N,layout_name:tile`.
- **Master-stack** — `new_is_master=1`, `default_mfact=0.55`,
  `default_nmaster=1`, `smartgaps=0`.
- **Scroller** — `scroller_default_proportion=0.8`, proportion presets
  `0.5,0.8,1.0`.
- **Dwindle** — `dwindle_smart_split=0`, `dwindle_preserve_split=0`.
- **Overview** — `enable_hotarea=0`, `overviewgappi=5`, `overviewgappo=30`.
- **Gaps** — `gappih=5`, `gappiv=5`, `gappoh=10`, `gappov=10`; `borderpx=4`.
- **Misc** — `sloppyfocus=1`, `warpcursor=1`, `cursor_size=24`,
  `drag_tile_to_tile=1`.

### Input

- **Keyboard** — `repeat_rate=25`, `repeat_delay=600`,
  `xkb_rules_options=caps:escape` (Caps Lock = Escape).
- **Trackpad** — `tap_to_click`, `tap_and_drag`, `drag_lock`,
  `disable_while_typing`; natural scrolling off; 2-finger scroll.
- **Mouse** — natural scrolling off.

### Monitors

```
monitorrule=name:^HDMI-A-1$,x:0,y:0      # LG, primary (origin)
monitorrule=name:^eDP-1$,x:1920,y:0      # laptop panel, to the right
```

### Autostart (from `config.conf`)

```
exec=pkill waybar; waybar
exec=~/.local/bin/awww-init                                   # wallpaper
exec=pkill -f 'spotify-mpris.sh watch'; ~/.config/waybar/scripts/spotify-mpris.sh watch
exec=pkill mako; mako
```

### Keybindings

Modifiers: `SUPER` is the primary mod; `Alt` is used for the launcher,
terminal, and window actions, and `Ctrl` for tag selection — mirroring the
dwm-style scheme.

| Binding                          | Action                                            |
| -------------------------------- | ------------------------------------------------- |
| `Alt+Return`                     | Spawn terminal (`kitty`)                          |
| `Alt+Space`                      | Launcher (`fuzzel`)                               |
| `Super+Shift+s`                  | Screenshot (`screenshot` script)                  |
| `Super+Escape`                   | Suspend (`systemctl suspend`)                     |
| `Super+l`                        | Lock (`swaylock`)                                 |
| `Super+Shift+Escape`             | Power menu (`powermenu`)                          |
| `Super+m`                        | Quit mango                                        |
| `Super+r`                        | Reload config                                     |
| `Alt+q`                          | Kill focused client                               |
| `Super+Tab`                      | Focus next window                                 |
| `Alt+Left/Right/Up/Down`         | Focus window by direction                         |
| `Super+Shift+Left/Right/Up/Down` | Swap window with neighbor                         |
| `Super+g`                        | Toggle global (fullscreen-ish)                    |
| `Alt+Tab`                        | Toggle jump                                       |
| `Alt+\`                          | Toggle floating                                   |
| `Alt+a`                          | Toggle maximize-to-screen                         |
| `Alt+f` / `Alt+Shift+f`          | Toggle fullscreen / fake fullscreen               |
| `Super+i` / `Super+o`            | Minimize / toggle overlay                         |
| `Super+Shift+i`                  | Restore minimized                                 |
| `Alt+z`                          | Toggle scratchpad                                  |
| `Super+n`                        | Switch layout                                      |
| `Super+Left` / `Super+Right`     | View previous / next tag                          |
| `Ctrl+Left` / `Ctrl+Right`       | View previous / next tag with clients             |
| `Ctrl+Super+Left/Right`          | Move client to previous / next tag                |
| `Ctrl+1`–`Ctrl+9`                | View tag 1–9                                      |
| `Alt+1`–`Alt+9`                  | Move client to tag 1–9                            |
| `Alt+Shift+Left/Right`           | Focus previous / next monitor                     |
| `Super+Alt+Left/Right`           | Move client to previous / next monitor            |
| `Alt+Shift+x` / `Alt+Shift+z`    | Increase / decrease gaps                          |
| `Alt+Shift+r`                    | Toggle gaps                                       |
| `Ctrl+Shift+Arrow`               | Move floating window                              |
| `Ctrl+Alt+Arrow`                 | Resize floating window                            |
| `Alt+e` / `Alt+x`                | Set proportion / cycle proportion preset (scroller) |
| `Alt+Super+Ctrl+Arrow`           | Scroller stack move                               |
| `Alt+Shift+Return`               | Dwindle split-direction toggle                    |

Mouse/axis:

| Binding               | Action                                |
| --------------------- | -------------------------------------- |
| `Super+LMB` drag      | Move window                            |
| `MMB`                 | Toggle maximize-to-screen              |
| `Super+RMB` drag      | Resize window                          |
| `Super+Scroll`        | Prev/next tag with clients             |

### Waybar

The bar is themed as an inventory row: modules are beveled "slots", tags are
9 hotbar slots, and accents use the ore palette. Layout:

- **Left** — launcher (`fuzzel`), tags 1–9, clock.
- **Center** — Spotify widget (album art + prev/play-pause/next + title),
  cava visualizer.
- **Right** — tray, pulseaudio, network, CPU, memory, temperature, battery.

**Tag modules** (`custom/tag1`–`tag9`) talk to mango over its IPC socket via
`mango/waybar/scripts/mango-tags.sh`:

- `status <n>` reads tag state and emits JSON with classes `active`,
  `occupied`, `urgent`, or `empty`.
- `switch <n>` dispatches `view,<n>,0`.
- `watch` runs once (from mango autostart) as a persistent daemon; on every
  tag-state push it sends waybar `RTMIN+8` to refresh the tag modules.

**Spotify widget** (`spotify-mpris.sh`) follows the same signal-driven
pattern: a `watch` daemon caches `playerctl` metadata to
`~/.cache/waybar-spotify` and nudges waybar (`RTMIN+9`); the `status <role>`
subcommands read the cache for art/title/prev/playpause/next, so no module
ever blocks on `playerctl --follow`. The `cava-bars.sh` script streams cava's
raw ASCII output as bar glyphs.

---

## Mango (mono) (`mono` group)

The **new rice**: mango with the dwl monochrome aesthetic and the dwl keymap
ported onto it. It keeps mango's feature set (animations, scroller/dwindle
layouts, scratchpad, overview) while looking and behaving like dwl — square
corners, strict black/white, 8px gaps, 2px borders, `grid` (fair) as the
default layout, and foot/wofi/mako as the companion apps.

It keeps **all** of the old rice's waybar features — Spotify widget (art /
prev / play-pause / next / title), cava visualizer, tray, network, audio,
temperature, battery — just restyled monochrome. What it drops for the
lightweight dwl look is only the theming stack: **no matugen, no kitty, no
rofi** (foot/wofi/static colors instead). The bar is a monochrome waybar
(yambar's `dwl` module can't drive mango, which has no dwl status stream, so
the dwl yambar look is reproduced in waybar instead).

### Files

| Source                            | Destination                      | Purpose                              |
| --------------------------------- | -------------------------------- | ------------------------------------ |
| `mono/mango/config.conf`          | `~/.config/mango/config.conf`    | Compositor config (dwl-ported)       |
| `mono/mango/colors.conf`          | `~/.config/mango/colors.conf`    | Static monochrome palette            |
| `mono/waybar/config.jsonc`        | `~/.config/waybar/config.jsonc`  | Bar layout (full module set)         |
| `mono/waybar/style.css`           | `~/.config/waybar/style.css`     | Monochrome bar theme                 |
| `mono/waybar/scripts/mango-tags.sh`| `~/.config/waybar/scripts/mango-tags.sh` | Mango IPC tag helper          |
| `mono/waybar/scripts/spotify-mpris.sh`| `~/.config/waybar/scripts/spotify-mpris.sh` | Spotify MPRIS widget helper |
| `mono/waybar/scripts/cava-bars.sh`| `~/.config/waybar/scripts/cava-bars.sh` | cava ASCII visualizer helper      |

`foot`, `wofi`, and `mako` configs come from the `dwl` group (which is in
`base_groups`), so the `mono` profile reuses them without duplication.

### What was ported from dwl

| dwl (`config.h`)            | mono (`config.conf`)                       |
| --------------------------- | ------------------------------------------ |
| `rootcolor #000000`         | `rootcolor=0x000000FF` (colors.conf)       |
| `bordercolor #333333`       | `bordercolor=0x333333ff`                   |
| `focuscolor #ffffff`        | `focuscolor=0xffffffff`                    |
| `urgentcolor #ffffff`       | `urgentcolor=0xFFFFFFFF` (colors.conf)     |
| `gappx=8`                   | `gappih/gappiv/gappoh/gappov=8`            |
| `borderpx=2`                | `borderpx=2`                               |
| (square, no radius)         | `border_radius=0`                          |
| `smartgaps=1`               | `smartgaps=1`                              |
| `sloppyfocus=1`             | `sloppyfocus=1`                            |
| `layouts[0] = fair`         | `tagrule=...layout_name:grid` (all tags)   |
| terminal `foot`             | `bind=Alt,Return,spawn,foot`               |
| launcher `wofi`             | `bind=Alt,space,spawn,wofi --show drun`    |

### Keybindings

The keymap is the **old mango rice** keymap (identical to the `mango` group),
so muscle memory carries over. The only differences from the old rice are the
spawn targets: `Alt+Return` → `foot` (was `kitty`) and `Alt+Space` → `wofi`
(was `fuzzel`), plus `Super+Shift+s` → `screenshot` (unchanged). Highlights:

| Binding                   | Action                              |
| ------------------------- | ----------------------------------- |
| `Alt+Space` / `Alt+Return`| Launcher (wofi) / terminal (foot)   |
| `Super+Tab`               | Focus next window                   |
| `Alt+Left/Right/Up/Down`  | Focus window by direction           |
| `Super+Shift+Arrow`       | Swap window with neighbor           |
| `Super+Left/Right`        | View prev/next tag                  |
| `Ctrl+Left/Right`         | View prev/next tag (with clients)   |
| `Ctrl+Super+Left/Right`   | Move client to prev/next tag        |
| `Ctrl+1..9` / `Alt+1..9`  | View tag / move client to tag       |
| `Super+g`                 | Toggle global (pin to all tags)     |
| `Super+i` / `Super+o`     | Minimize / toggle overlay           |
| `Super+Shift+I`           | Restore minimized                   |
| `Alt+z` / `Alt+Tab`       | Scratchpad / jump                   |
| `Alt+f` / `Alt+a`         | Fullscreen / maximize               |
| `Alt+\`                   | Toggle floating                     |
| `Super+n`                 | Switch layout                       |
| `Alt+Shift+X/Z/R`         | Inc gaps / toggle gaps              |
| `Alt+Shift+Left/Right`    | Focus prev/next monitor             |
| `Super+Alt+Left/Right`    | Move client to prev/next monitor    |
| `Super+l` / `Super+Shift+Escape` | Lock / power menu             |

Media keys (volume/brightness) are also bound (an addition the old rice
lacked, kept here so hardware keys work).

### Autostart (from `config.conf`)

```
exec=~/.local/bin/monitor-layout
exec=pkill waybar; waybar
exec=pkill -f 'mango-tags.sh watch'; ~/.config/waybar/scripts/mango-tags.sh watch
exec=pkill -f 'spotify-mpris.sh watch'; ~/.config/waybar/scripts/spotify-mpris.sh watch
exec=pkill swaybg; if [ -f ~/.config/dwl/wallpaper ]; then swaybg -i ~/.config/dwl/wallpaper -m fill & fi
exec=pkill mako; mako
```

The wallpaper follows dwl's convention: drop any image at
`~/.config/dwl/wallpaper`.

---

## dwl (`dwl` group)

dwl is a minimal, dwm-for-Wayland compositor (C + wlroots). Everything —
colors, tags, layouts, keybindings, monitor rules, input — is a compile-time
`config.h`, patched here to add gaps. It ships with a purpose-built foot +
wofi + mako + yambar stack in a strict black/white monochrome look.

### Files

| Source                 | Destination                  | Purpose                              |
| ---------------------- | ---------------------------- | ------------------------------------ |
| `dwl/dwl/config.h`     | `~/.config/dwl/config.h`     | dwl compile-time config              |
| `dwl/dwl/gaps.patch`   | `~/.config/dwl/gaps.patch`   | Gaps/smartgaps/togglegaps patch      |
| `dwl/dwl/autostart`    | `~/.config/dwl/autostart`    | Startup script (`dwl -s`)            |
| `dwl/foot/foot.ini`    | `~/.config/foot/foot.ini`    | Terminal config                      |
| `dwl/wofi/config`      | `~/.config/wofi/config`      | Launcher config                      |
| `dwl/wofi/style.css`   | `~/.config/wofi/style.css`   | Launcher theme                       |
| `dwl/mako/config`      | `~/.config/mako/config`      | Notification daemon config           |
| `dwl/yambar/config.yml`| `~/.config/yambar/config.yml`| Status bar config                    |

The NixOS build uses identical copies of `dwl-config.h` and `dwl-gaps.patch`
(living in the `nixos-config` repo) so it can compile the same dwl without
relying on the installed `~/.config` copy — see [NixOS](#nixos) below.

### Building / the gaps patch

dwl reads `config.h` at **compile** time, so `~/.config/dwl/config.h` is the
source of truth you build against, and `gaps.patch` is applied to `dwl.c` to
add:

- a per-monitor `gaps` flag (default on),
- `smartgaps` (no outer gap when there is only one window),
- gap-aware `tile()` (master/stack with `gappx` outer/inner gaps),
- a `togglegaps()` function bound to `Super+g`.

### config.h settings

- **Appearance** — `sloppyfocus=1`, `smartgaps=1`, `gaps=1`, `gappx=8`,
  `borderpx=2`; colors: root `#000000`, border `#333333`, focus/urgent
  `#ffffff`.
- **Tags** — `TAGCOUNT 9`.
- **Layouts** — `[]=` tile, `><>` floating, `[M]` monocle.
- **Monitors** — `HDMI-A-1` primary at `(0,0)`, `eDP-1` at `(1920,0)`;
  both `mfact=0.55`, `nmaster=1`, scale 1, tile layout.
- **Keyboard** — `options="caps:escape"`, `repeat_rate=25`,
  `repeat_delay=600`; `MODKEY = Super` (logo).
- **Trackpad** — tap-to-click, tap-and-drag, drag-lock, disable-while-typing,
  2-finger scroll, adaptive acceleration; natural scrolling off.
- **Commands** — terminal `foot`, launcher `wofi --show drun`, browser
  `librewolf`.

### Keybindings

| Binding                          | Action                                            |
| -------------------------------- | ------------------------------------------------- |
| `Alt+Return`                     | Spawn terminal (`foot`)                           |
| `Alt+Space`                      | Launcher (`wofi --show drun`)                     |
| `Super+b`                        | Browser (`librewolf`)                             |
| `Super+Shift+s`                  | Screenshot region (`slurp \| grim \| wl-copy`)    |
| `Super+Print`                    | Screenshot full screen (`grim \| wl-copy`)        |
| `Super+Escape`                   | Suspend (`systemctl suspend`)                     |
| `Super+l`                        | Lock (`swaylock`)                                 |
| `Super+Shift+Escape`             | Power menu (`powermenu`)                          |
| `Super+m`                        | Quit dwl                                          |
| `Alt+q`                          | Kill focused client                               |
| `Alt+\`                          | Toggle floating                                   |
| `Alt+f`                          | Toggle fullscreen                                 |
| `Super+Tab` / `Super+j`          | Focus next window                                 |
| `Super+Shift+Tab` / `Super+k`    | Focus previous window                             |
| `Super+h` / `Super+l`            | Decrease / increase master factor (`mfact`)       |
| `Super+i` / `Super+d`            | Increase / decrease number of masters             |
| `Super+Shift+Return`             | Zoom (swap focused client into master)            |
| `Super+n`                        | Cycle layout                                      |
| `Super+t` / `Super+f` / `Super+v`| Tile / floating / monocle layout                  |
| `Super+g`                        | Toggle gaps                                       |
| `Ctrl+1`–`Ctrl+9`                | View tag 1–9                                      |
| `Alt+1`–`Alt+9`                  | Move client to tag 1–9                            |
| `Alt+Shift+Left/Right`           | Focus previous / next monitor                     |
| `Super+Alt+Left/Right`           | Move client to previous / next monitor            |
| `Ctrl+Alt+Backspace`             | Quit dwl                                          |
| `Ctrl+Alt+F1`–`F12`              | Switch to VT 1–12                                 |

Mouse:

| Binding               | Action             |
| --------------------- | ------------------ |
| `Super+LMB` drag      | Move window        |
| `MMB`                 | Toggle fullscreen  |
| `Super+RMB` drag      | Resize window      |

### Autostart script

`dwl/dwl/autostart` runs via `dwl -s <script>` (after `WAYLAND_DISPLAY`
exists):

1. Exports `XDG_CURRENT_DESKTOP=dwl` / `XDG_SESSION_DESKTOP=dwl`.
2. Sets the wallpaper with `swaybg` (drop any image at
   `~/.config/dwl/wallpaper`).
3. Starts `yambar` (bar) and `mako` (notifications).
4. `exec cat > ~/.cache/dwltags` — bridges dwl's stdout status stream into a
   file that yambar's `dwl` module reads.

### Companion apps

- **foot** (`foot.ini`) — Iosevka Nerd Font Mono 13, `pad=6x6`, DPI-aware,
  block blinking cursor, clipboard selection; a 16-color grayscale palette;
  copy/paste/search on `Ctrl+Shift+c/v/r`.
- **wofi** (`config` + `style.css`) — `drun` mode, 600×400, anchored, no
  images; black/white beveled theme, Iosevka Nerd Font Mono 13, selected row
  inverts to white-on-black.
- **mako** (`config`) — top-right overlay, `font=Iosevka Nerd Font Mono 11`,
  320×110, 2px border, `default-timeout=6000`; per-urgency overrides
  (low → 3s grey border, critical → no timeout).
- **yambar** (`config.yml`) — 26px top bar, black background/white foreground.
  Left: the `dwl` tag module (9 tags reading `/home/eon/.cache/dwltags`,
  selected tag inverted). Right: CPU, memory, battery (`BAT1`), clock.

---

## NixOS

The NixOS system configuration (flake, `configuration.nix`,
`hardware-configuration.nix`, the `dwl`/`mango` build sources) lives in its
own repo: **[`eon5942/nixos-config`](https://github.com/eon5942/nixos-config)**.

It builds `dwl` (with `dwl-config.h` + the gaps patch) and `mango`, launches
them via `greetd`/`tuigreet`, and installs the companion apps (`foot`, `wofi`,
`yambar`, `rofi`, `waybar`, `kitty`, `cava`, `mako`, `matugen`, …) plus the
Iosevka Nerd Font. Full reproducibility docs are in that repo's README.

The mango setup is the everyday rice (selectable via the `mango` or `mono`
profile); dwl is the minimal, reproducible alternative.

---

## Usage

```sh
dots install --dry-run --verbose   # preview changes
dots install                       # copy source files into place
dots files                         # list all managed files
```

`dots diff` doesn't work with `install_path: ${HOME}` on this machine (it
tries to symlink a `-staged` sibling next to `$HOME`, which isn't writable) —
use `dots install --dry-run --verbose` instead.

## Syncing changes

[`dots-sync`](https://github.com/eon5942/dots-sync) wraps the edit -> install
-> commit -> push loop for this repo into one command
(`dots-sync "commit message"`). See that repo's README for install and usage
details.

## Setup on a new machine

```sh
git clone git@github.com:eon5942/eonsdotfiles.git ~/.local/etc

# pick your rice (old mango = "mango", new dwl-ported mango = "mono")
dots config use mono      # or: dots config use mango
dots install
```

you will have to install on a fresh setup, mango rofi waybar wayland cava lavat fastfetch kitty sddm opencode librewolf btop matugen mako foot wofi yambar swaybg

Requires the `dots` binary built from
[evanpurkhiser/dots](https://github.com/evanpurkhiser/dots) (`main` branch)
and placed on `$PATH`.
