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

Paths inside a group mirror their destination under `install_path` exactly,
including the `.config/` prefix and leading dots:

```
base/.gtkrc-2.0                  -> ~/.gtkrc-2.0
base/.config/fish/config.fish    -> ~/.config/fish/config.fish
base/.config/alacritty/...       -> ~/.config/alacritty/...
```

Currently tracked: fish, alacritty, btop, micro, mango, fwm, matugen,
libinput-gestures, arkrc, and gtkrc-2.0.

## Usage

```sh
dots install --dry-run --verbose   # preview changes
dots install                       # copy source files into place
dots files                         # list all managed files
```

`dots diff` doesn't work with `install_path: ${HOME}` on this machine (it
tries to symlink a `-staged` sibling next to `$HOME`, which isn't writable) —
use `dots install --dry-run --verbose` instead.

## Setup on a new machine

```sh
git clone git@github.com:eon5942/eonsdotfiles.git ~/.local/etc
dots install
```

Requires the `dots` binary built from
[evanpurkhiser/dots](https://github.com/evanpurkhiser/dots) (`main` branch)
and placed on `$PATH`.
