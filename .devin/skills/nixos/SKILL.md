---
name: nixos
description: "Use this skill for any task involving NixOS system configuration, installation, maintenance, or operation. Triggers include: NixOS, configuration.nix, nixos-rebuild, nixos-generate-config, nixos-install, systemd services on NixOS, NixOS upgrades, rollbacks, NixOS flakes, or any question about running and managing a NixOS machine. Link out to the nix skill for Nix language and flake mechanics, and to the nix-shell skill for ad-hoc development environments."
---

# NixOS Skill

## Overview

NixOS is a Linux distribution built on the Nix package manager. The entire system is configured declaratively through `configuration.nix` (and optionally `flake.nix`). After you edit the configuration, you run `nixos-rebuild switch` to build the new system, activate it, and make it the default boot entry.

Use this skill when you are:

- Editing `/etc/nixos/configuration.nix` or a flake-based NixOS configuration.
- Running `nixos-rebuild`, `nixos-generate-config`, `nixos-install`, or `nixos-enter`.
- Managing system services, users, networking, filesystems, or boot on NixOS.
- Upgrading NixOS, rolling back a configuration, or recovering from a broken system.
- Creating or modifying NixOS modules.

## Core NixOS model

- **Declarative**: the system state is described in `configuration.nix`, not installed imperatively.
- **Atomic**: `nixos-rebuild switch` builds a new generation; the old one remains available at boot.
- **Reproducible**: with flakes, inputs are pinned in `flake.lock`.
- **Rollback-friendly**: every successful `nixos-rebuild switch` creates a boot entry and a system profile generation.

## Quick reference

| Task | Command |
|------|---------|
| Apply configuration | `sudo nixos-rebuild switch` |
| Build without activating | `sudo nixos-rebuild build` |
| Test in memory without touching boot | `sudo nixos-rebuild test` |
| Build and set as boot default | `sudo nixos-rebuild boot` |
| Upgrade channels | `sudo nixos-rebuild switch --upgrade` |
| Upgrade flake | `sudo nixos-rebuild switch --flake .#hostname` |
| Roll back to previous generation | `sudo nixos-rebuild switch --rollback` |
| Roll back to specific generation | `sudo /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch` |
| List generations | `sudo nix-env -p /nix/var/nix/profiles/system --list-generations` |
| Garbage collection | `sudo nix-collect-garbage -d` |
| Repair store | `sudo nixos-rebuild switch --repair` |
| Generate hardware config | `sudo nixos-generate-config --root /mnt` |
| Install NixOS | `sudo nixos-install --flake .#hostname` |
| Build a VM for testing | `sudo nixos-rebuild build-vm` |

## Progressive disclosure

Start with the guide that matches your task:

- **[configuration.nix syntax and structure](./configuration.nix.md)** — the basics of writing a NixOS configuration.
- **[Flake-based NixOS](./flakes.md)** — how to manage NixOS with a `flake.nix`.
- **[Rebuild, upgrade, and rollback](./rebuild-upgrade.md)** — `nixos-rebuild` commands and recovery.
- **[Services and administration](./services-admin.md)** — systemd, `systemctl`, users, logging.
- **[Packages on NixOS](./packages-on-nixos.md)** — declarative packages, services, ad-hoc tools, overlays.
- **[Troubleshooting](./troubleshooting.md)** — boot recovery, store repair, `--show-trace`, cache issues.

## When to delegate to other skills

- If you need to understand Nix expression syntax, flakes, or the Nix store → switch to the [`nix`](../nix/SKILL.md) skill.
- If you need a temporary development environment or `nix-shell` usage → switch to the [`nix-shell`](../nix-shell/SKILL.md) skill.

## Remember

On NixOS, most system-level changes happen through `configuration.nix` (or `flake.nix`) followed by `nixos-rebuild`. Avoid installing packages globally with `nix-env -iA` on a NixOS system unless you have a specific reason; it bypasses the declarative configuration and complicates maintenance.
