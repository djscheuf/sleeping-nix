# Agent guidance for this NixOS system

This repository configures a NixOS system. The active host is `Nox` and the configuration entry point is `Framework/configuration.nix`.

## NixOS context

- This is a declarative NixOS installation managed with `nixos-rebuild`.
- System state version is `24.11`; packages are pulled from a mix of `nixos-25.11` (system channel) and a pinned `nixos-unstable` tarball.
- GNOME is the desktop environment (`services.desktopManager.gnome.enable = true`).
- Audio uses PipeWire (`services.pipewire.enable = true`; PulseAudio disabled).
- The user `djs` is in the `wheel` and `networkmanager` groups.

## Relevant skills

Use these Devin skills when working here:

- **nixos** — for system configuration, `nixos-rebuild`, services, and NixOS administration.
- **nix** — for the Nix language, flakes, derivations, the Nix store, and package builds.
- **nix-shell** — for temporary development environments or one-off package access.

## Key files

| File | Purpose |
|------|---------|
| `Framework/configuration.nix` | Main NixOS configuration; imports all other modules |
| `Framework/custom-packages.nix` | Overlay that adds a pinned `nixpkgs-unstable` set as `pkgs.unstable`, plus custom packages |
| `Framework/improving.nix` | User packages, including `unstable.handy`, `windsurf-custom`, `devin-cli-custom`, etc. |
| `Framework/CUSTOM-PACKAGES.md` | How custom packages are integrated and updated |
| `Framework/vault/incidents/` | Notes on past debugging incidents |

## Custom packages under Framework

- `windsurf-custom` — custom VS Code-like editor package from `/home/djs/Documents/nixpkg-windsurf`
- `devin-cli-custom` — custom Devin CLI package from `/home/djs/Documents/devin-cli-nixpkg`
- `teams-for-linux-alt` — secondary Teams instance from `/home/djs/Documents/teams-alt-nixpkg`
- `unstable.handy` — speech-to-text tool from the pinned `nixpkgs-unstable` set

See `Framework/CUSTOM-PACKAGES.md` for update and troubleshooting instructions.

## Rebuild command

After editing NixOS configuration:

```bash
sudo nixos-rebuild switch
```

Use `--show-trace` for debugging evaluation errors.
