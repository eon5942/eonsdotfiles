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

Currently tracked: fish, alacritty, btop, micro, mango, fwm, matugen,
libinput-gestures, arkrc, and gtkrc-2.0.

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

## Syncing changes (`dots-sync`)

`dots-sync` (`~/.local/bin/dots-sync`) wraps the edit -> install -> commit ->
push loop into one command. It's not part of `dots` itself, just a personal
script for this repo.

```sh
dots-sync                  # install, then commit with an auto-generated message and push
dots-sync "add mako config"  # install, then commit with this message and push
```

It runs `dots install` first, so a broken config fails before anything is
pushed, then commits and pushes from `~/.local/etc` (override with
`DOTS_SOURCE_PATH` if the source tree ever moves). If there's nothing to
commit it exits quietly without touching git.

### Where it pushes to

`dots-sync` just runs `git push`, so it pushes wherever this repo's `origin`
remote points — no separate configuration of its own. Check or change that
with:

```sh
git remote -v                                              # see current remote
git remote set-url origin git@github.com:<user>/<repo>.git # point at a different repo/account
```

To publish this repo to a GitHub account for the first time (e.g. after
copying the dotfiles elsewhere without git history):

```sh
gh repo create <repo-name> --source=. --private --remote=origin  # creates the repo on GitHub and adds the remote
git push -u origin main                                          # first push; dots-sync (or plain `git push`) works after this
```

Without the `gh` CLI, create the empty repo on github.com first, then:

```sh
git remote add origin git@github.com:<user>/<repo-name>.git
git push -u origin main
```

SSH pushes require a key added to your GitHub account under
Settings -> SSH and GPG keys; use an `https://` remote URL instead if you'd
rather authenticate with a token.

## Setup on a new machine

```sh
git clone git@github.com:eon5942/eonsdotfiles.git ~/.local/etc
dots install
```

Requires the `dots` binary built from
[evanpurkhiser/dots](https://github.com/evanpurkhiser/dots) (`main` branch)
and placed on `$PATH`.
