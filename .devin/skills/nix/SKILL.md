---
name: nix
description: "Use this skill for any task involving the Nix package manager, Nix language, Nix flakes, or the Nix ecosystem. Triggers include: nix, nix build, nix run, nix develop, nix-shell, flakes, flake.nix, nixpkgs, derivations, /nix/store, channels, binary caches, or any question about Nix package management and reproducible builds. This skill is also the root index for NixOS and nix-shell work; link out to those skills when the task is specifically about NixOS system configuration or nix-shell development environments."
---

# Nix Skill

## Overview

Nix is a purely functional package manager and build system. It stores every package and build artifact under a cryptographic hash in `/nix/store`, enables atomic upgrades and rollbacks, supports reproducible builds via Nix expressions, and provides a flake-based workflow for pinning dependencies.

Use this skill when you are:

- Building, running, or installing packages with `nix build`, `nix run`, `nix profile`, or `nix-env`.
- Writing or reading `flake.nix`, `default.nix`, or `shell.nix` files.
- Debugging a Nix build, derivation, or evaluation failure.
- Explaining Nix language syntax, store mechanics, garbage collection, or binary caches.
- Deciding whether to use Nix, NixOS, or `nix-shell` for a given task.

## Ecosystem map

| Tool | What it does | When to use it | Skill |
|------|--------------|----------------|-------|
| **Nix** (this skill) | Package manager, language, flakes, builds | Any Nix expression, flake, or package operation | `nix` |
| **NixOS** | Declarative Linux distribution built on Nix | System configuration, services, users, upgrades | [`nixos`](./nixos/SKILL.md) |
| **nix-shell** | Temporary or project-specific development environments | One-off tools, project shells, shebang scripts | [`nix-shell`](./nix-shell/SKILL.md) |

## Core principles

- **Functional**: packages are built from Nix expressions that describe every input and build step.
- **Pure/reproducible**: building the same expression twice should yield the same store path (modulo impurities you explicitly allow).
- **Store-based**: everything lives in `/nix/store/<hash>-<name>`. Multiple versions coexist without conflict.
- **Atomic**: upgrades and rollbacks switch entire profiles, never partially overwrite files.
- **Garbage-collectible**: unused store paths are removed only by `nix-collect-garbage` or similar tools.

## Quick reference

| Task | Command |
|------|---------|
| Build a package or derivation | `nix build <flake or path>` |
| Run a package without installing | `nix run <flake or attr>` |
| Enter a development shell | `nix develop <flake>` |
| Search nixpkgs | `nix search nixpkgs <term>` |
| Install to user profile (flakes) | `nix profile install <flake>` |
| Install to user profile (legacy) | `nix-env -iA nixpkgs.<attr>` |
| List installed packages | `nix profile list` / `nix-env -q` |
| Remove package | `nix profile remove <index or store path>` / `nix-env -e <name>` |
| Update flake lock | `nix flake lock --update-input <input>` |
| Garbage collection | `nix-collect-garbage` / `nix-collect-garbage -d` |
| Repair a corrupt path | `nix-store --verify --check-contents --repair` |
| Show evaluation trace | `nix build ... --show-trace` |

## Which Nix tool should I use?

```
Need a temporary tool or environment?
  → use nix-shell / nix-shell -p <pkg> (see nix-shell skill)

Need a reproducible project environment defined in a flake?
  → use nix develop / devShells (see nix-shell skill)

Need to install a package for your user?
  → use nix profile install or nix-env -iA

Need to build a derivation or package?
  → use nix build

Need to run a command without installing?
  → use nix run

Need to configure a whole NixOS system?
  → use nixos-rebuild (see nixos skill)
```

## Progressive disclosure

Start with the guide that matches your immediate need:

- **[Nix language essentials](./nix-language.md)** — read this first if you need to write or understand `.nix` files.
- **[Flakes](./flakes.md)** — how `flake.nix`, inputs, outputs, and lock files work.
- **[Package management workflows](./package-management.md)** — `nix build`, `nix run`, `nix develop`, `nix profile`, and legacy `nix-env`.
- **[Store, garbage collection, and binary caches](./store-and-gc.md)** — `/nix/store`, profiles, GC, caches, substituters.
- **[Troubleshooting and debugging](./troubleshooting.md)** — `--show-trace`, `NIX_DEBUG`, logs, derivation inspection, repair.

## When to delegate to other skills

- If the user is editing `/etc/nixos/configuration.nix`, running `nixos-rebuild`, or managing system services → switch to the [`nixos`](./nixos/SKILL.md) skill.
- If the user is asking about `nix-shell`, `nix develop`, `shell.nix`, `devShells`, or one-off package environments → switch to the [`nix-shell`](./nix-shell/SKILL.md) skill.

## Remember

Nix is not a conventional package manager. There is no global `/usr/bin`. Packages are referenced by exact store paths and made available through profiles or ephemeral shells. When in doubt, prefer flakes for reproducibility and `nix-shell`/`nix develop` for ad-hoc environments.
