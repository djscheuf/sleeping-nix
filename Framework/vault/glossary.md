# Glossary

Project-specific vocabulary for the sleeping-nix repo / Nox system.

## Hosts & Layout

- **Nox** — hostname of the active Framework Laptop; the only live system this repo configures (`networking.hostName = "Nox"`).
- **Framework** — this repo's directory for the Framework Laptop config. "The Framework config" means `Framework/configuration.nix`, not the laptop brand generally.
- **sleeping-nix** — this repository; backups of working NixOS configurations. `HyperV/` holds a second, dormant host config.
- **Symlinked config** — `/etc/nixos/configuration.nix` is a symlink to `Framework/configuration.nix` in this repo. `hardware-configuration.nix` stays in `/etc/nixos/` and is referenced by absolute path.

## Package Plumbing

- **`pkgs.unstable`** — pinned nixpkgs-unstable tarball imported via overlay in `Framework/custom-packages.nix`. This is NOT the nixos-unstable channel; it's a fixed commit (`builtins.fetchTarball`) bumped manually with `nix-prefetch-url --unpack`.
- **`windsurf-custom`** — custom Windsurf editor package built from `/home/djs/Documents/nixpkg-windsurf`. Used instead of the nixpkgs build to get newer versions faster.
- **`devin-cli-custom`** — custom Devin CLI package built from `/home/djs/Documents/devin-cli-nixpkg`.
- **`teams-for-linux-alt`** — secondary `teams-for-linux` instance (separate profile, second account) built from `/home/djs/Documents/teams-alt-nixpkg`.
- **`improving.nix`** — module holding packages for the user's *work*; "Improving" is the employer's name, not a description of the file. Work packages go here, not in `personal.nix` or `dev.nix`.
- **Channel mix** — the system auto-upgrades on the `nixos-25.11` channel (`system.autoUpgrade.channel`) while `system.stateVersion` remains `"24.11"`. Per NixOS convention, `stateVersion` must NOT be changed when upgrading channels — it records the release the system was first installed with and changing it can break stateful defaults.

## Disk & Encryption

- **luks-swap / luks-data / luks-root** — LUKS device names under `boot.initrd.luks.devices`, unlocked by a single passphrase at boot. `luks-swap` (nvme0n1p3) is live; `luks-data` is defined in `data-partition-initrd.nix`; `luks-root` exists only in `encrypted-root-config.nix.example` (root is still unencrypted).
- **Data partition** — `nvme0n1p2` (684GB LUKS2), the old root filesystem, auto-decrypted in initrd and mounted at `/mnt/data` by `data-partition-initrd.nix`. Its stale `/boot` directory is never used.
- **`dataaccess`** — group (gid 1001) that owns `/mnt/data`; `djs` is a member. Created by `data-partition-initrd.nix`.

## Virtualization

- **Win11 VM** — Windows 11 libvirt/QEMU VM defined by `Framework/Win11 VM.xml`. SecureBoot required CentOS `OVMF.fd` files because nixpkgs `OVMFFull` doesn't ship the complete firmware (see `vm.nix` comments).
