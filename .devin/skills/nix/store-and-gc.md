# Nix store, garbage collection, and binary caches

## The Nix store

All Nix packages, derivations, and build outputs live in `/nix/store`. Each entry is immutable and named by a cryptographic hash of its inputs:

```
/nix/store/<hash>-<name>-<version>
```

Examples:

```
/nix/store/abc123...-nix-2.31.6
/nix/store/xyz789...-hello-2.12
```

Because everything is stored by hash, multiple versions of the same package can coexist without conflict, and upgrades are atomic (the old version remains until garbage collection).

## Profiles

A profile is a symlink tree that points to selected store paths and makes them available in the user environment.

| Profile | Path | Managed by |
|-----------|------|------------|
| User profile | `~/.nix-profile` | `nix profile`, `nix-env` |
| System profile (NixOS) | `/nix/var/nix/profiles/system` | `nixos-rebuild` |
| Default channel profile | `~/.nix-defexpr` | `nix-channel` |

Activating a profile means switching a symlink to a new closure of store paths. This is atomic and reversible.

## Garbage collection

Store paths are kept because they are reachable from a profile or a running process. Unused paths can be removed safely.

```bash
nix-collect-garbage                # remove unreachable paths
nix-collect-garbage -d             # also delete old generations
nix-collect-garbage --max-freed 10G # stop after freeing 10 GiB
```

On NixOS, also use:

```bash
sudo nix-collect-garbage -d
```

To free space before a large build, you can remove old system generations first:

```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
sudo nix-collect-garbage -d
```

## Binary caches (substituters)

By default Nix tries to download pre-built store paths from `https://cache.nixos.org/` instead of building from source. A cache is called a **substituter**.

### Configure caches

Globally in `/etc/nix/nix.conf` (or `nix.extraOptions` on NixOS):

```nix
substituters = https://cache.nixos.org https://my-cache.example.org
trusted-public-keys = cache.nixos.org-1:... my-cache:...
```

Per-command:

```bash
nix build . --option substituters https://my-cache.example.org
```

### Disable binary caches

If a cache is unreachable (e.g., behind a firewall), builds may hang waiting for HTTP timeouts. Disable caches temporarily:

```bash
nix build . --option substituters ''
nix build . --option use-binary-caches false        # legacy option, may still work
nixos-rebuild switch --option substituters ''
```

### Check cache availability

A `.narinfo` file at the cache indicates whether a path is available:

```
https://cache.nixos.org/<hash>.narinfo
```

You can also use:

```bash
nix path-info --store https://cache.nixos.org /nix/store/...-hello-2.12
```

## Channels vs flakes

| | Channels | Flakes |
|---|----------|--------|
| Version pinning | `nix-channel --update` updates to latest | `flake.lock` pins exact revisions |
| Reproducibility | Depends on channel state | Fully reproducible when lock is committed |
| Sharing | Hard to share exact state | Easy to share exact state |
| Recommended for | Legacy systems, quick one-offs | Projects, NixOS configs, teams |

On NixOS you can set `nix.settings.experimental-features = [ "nix-command" "flakes" ];` to enable flakes.

## Store repair and verification

If the store becomes corrupt (e.g., after a crash), you can verify and repair:

```bash
nix-store --verify --check-contents --repair
nix-store --repair-path /nix/store/...-hello-2.12
```

On NixOS:

```bash
sudo nixos-rebuild switch --repair
```

This checks every path in the system closure and re-downloads or rebuilds anything whose hash does not match Nix's database.

## Best practices

- **Never manually edit `/nix/store` paths.** They are immutable and hashes will not match.
- **Run GC periodically** on systems with limited disk space, but keep enough generations to roll back.
- **Pin binary caches** you trust in `nix.conf` or the flake's `nixConfig` to avoid surprise substituters.
- **Commit `flake.lock`** so binary cache lookups are predictable across machines.
- **For NixOS**, keep at least one previous generation before running `nix-collect-garbage -d`.
