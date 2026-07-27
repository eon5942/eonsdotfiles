# eonsdotfiles

Personal configuration files, managed with [`dots`](https://github.com/evanpurkhiser/dots).

`dots` compiles files from this source tree into their real locations under
`install_path` (here, `$HOME`). It copies rather than symlinks, so edits are
made here and then deployed with `dots install` — editing the installed copy
directly has no effect on the source.

## Groups

| Group  | Description                                   |
| ------ | ---------------------------------------------- |
| `base` | Installed everywhere; the only group so far.  |

## Layout

`install_path` is `${HOME}/.config`, so paths inside a group map straight
into it:

```
base/fish/config.fish   -> ~/.config/fish/config.fish
base/alacritty/...      -> ~/.config/alacritty/...
```

Currently tracked: fish, btop, micro, mango, matugen, libinput-gestures,
arkrc, gtkrc-2.0, waybar, kitty, mako, and fastfetch.

GTK3/4 (`~/.config/gtk-{3,4}.0/settings.ini`) and `kdeglobals` are edited
directly and intentionally left untracked — Plasma rewrites them itself
(e.g. from System Settings), so tracking them here would just fight it.

### Non-XDG apps

GTK2 doesn't support `XDG_CONFIG_HOME`, so `base/gtkrc-2.0` installs to
`~/.config/gtkrc-2.0` as usual, and `base/gtkrc-2.0.install` symlinks
`~/.gtkrc-2.0` to it. Install scripts (`<file>.install`) run automatically
whenever the file they're paired with changes; see `dots`' README for the
full mechanism.

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
dots install
```

Requires the `dots` binary built from
[evanpurkhiser/dots](https://github.com/evanpurkhiser/dots) (`main` branch)
and placed on `$PATH`.
