# NixOS configuration

Reproducible NixOS system config, managed as a [flake](https://nixos.wiki/wiki/Flakes).
One `git clone` + one rebuild reproduces the whole machine (packages, services,
compositor, users, bootloader, fonts) down to the exact nixpkgs commit it was
built from.

## How it's reproducible

- **`flake.nix`** declares the system as a single output
  (`nixosConfigurations.nixos`) built from `./configuration.nix`.
- **`flake.lock`** pins the `nixpkgs` input to one immutable commit
  (`github:NixOS/nixpkgs/nixos-26.05`, currently
  `21a67dc470149f337cecafbe965d8d252a390518`). Rebuilds are byte-for-byte
  identical until you run `nix flake update`.
- **`configuration.nix`** is the whole system: packages, services, user, fonts,
  bootloader, timezone, the `dwl` compositor, and `doas`/`allowUnfree`.
- **`hardware-configuration.nix`** captures machine-specific bits (btrfs
  subvolumes, disk UUIDs, kernel modules) and is imported by
  `configuration.nix`. Regenerate it on new hardware.
- **`dwl-config.h` + `dwl-gaps.patch`** are local, self-contained sources the
  compositor is compiled from — nothing external or mutable.

## Files

| File                         | Purpose                                                          |
| ---------------------------- | ---------------------------------------------------------------- |
| `../flake.nix`               | Flake entry point; defines `nixosConfigurations.nixos`           |
| `../flake.lock`              | Pins nixpkgs to an exact commit (do not edit by hand)            |
| `configuration.nix`          | The entire system definition                                      |
| `hardware-configuration.nix` | Auto-generated machine config (disks, firmware, kernel modules)  |
| `dwl-config.h`               | dwl compile-time config (patched in at build)                    |
| `dwl-gaps.patch`             | Gaps/smartgaps/togglegaps patch applied to dwl                   |

The flake lives at the **repo root** (`~/.local/etc`), not in this directory;
`configuration.nix` resolves `./hardware-configuration.nix`, `./dwl-config.h`,
and `./dwl-gaps.patch` relative to itself, so everything stays together.

## What's inside the system

- **Compositor** — `dwl` (built from `dwl-config.h` + the gaps patch), launched
  from `greetd` + `tuigreet` (minimal TUI login) via `dwl -s
  ~/.config/dwl/autostart`.
- **X11 fallback** — Window Maker via `startx` (enabled through
  `services.xserver`).
- **Sound** — PipeWire (`alsa` + `pulse` compatibility).
- **User** — `eon`, in `wheel` and `networkmanager`.
- **Auth** — `sudo` disabled; `doas` for the `wheel` group.
- **Fonts** — Iosevka Nerd Font (matches the dotfiles).
- **Misc** — `allowUnfree = true`, latest kernel, systemd-boot, timezone
  `America/Los_Angeles`, `stateVersion = "26.05"`.
- A large `environment.systemPackages` set (neovim, opencode, librewolf, foot,
  wofi, yambar, grim/slurp/wl-clipboard, fastfetch/hyfetch, steam, spotify,
  vesktop, 1password, …).

## Setup on a new machine

```sh
git clone git@github.com:eon5942/eonsdotfiles.git ~/.local/etc

# enable flakes once (only needed if nix.conf doesn't already have it)
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

# (new hardware only) regenerate the machine-specific config, then commit it
# sudo nixos-generate-config --dir ~/.local/etc/nixos
# doas nixos-rebuild switch --flake ~/.local/etc#nixos

sudo nixos-rebuild switch --flake ~/.local/etc#nixos
```

After that first rebuild, flakes are enabled *by the config itself*
(`nix.settings.experimental-features`), so subsequent rebuilds need no
manual `nix.conf` editing.

> On this machine `sudo` is replaced by `doas` — use `doas` instead of `sudo`.

## Daily usage

```sh
cd ~/.local/etc

# rebuild after editing configuration.nix
doas nixos-rebuild switch --flake .#nixos

# check what a rebuild would do without applying it
doas nixos-rebuild dry-build --flake .#nixos

# update nixpkgs to the latest nixos-26.05 commit (re-pins flake.lock)
nix flake update && doas nixos-rebuild switch --flake .#nixos

# garbage-collect old system generations
doas nix-collect-garbage -d
```

`nixos-rebuild --flake ~/.local/etc` (no `#attr`) also works — it defaults to
the hostname `nixos`.

## Gotchas

- **Flakes only see git-tracked files.** If you add/rename a file and the build
  says it can't find it, `git add` it first. `git status` should be clean before
  rebuilding.
- **`hardware-configuration.nix` is machine-specific.** Commit it for *this*
  machine, but regenerate (`nixos-generate-config`) on genuinely different
  hardware — disk UUIDs, filesystems, and firmware differ.
- **Unfree packages** (steam, spotify, 1password, …) need `allowUnfree = true`
  and come from third-party sources, so they're the least reproducible part of
  the build.
- **Secrets are out of scope.** The `eon` user's password is set with `passwd`
  and is not tracked here; use `sops-nix`/`agenix` if you want that declarative
  too.
