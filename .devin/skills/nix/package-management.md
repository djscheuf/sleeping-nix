# Nix package management workflows

Nix has two CLI generations: the **new experimental-style CLI** (`nix build`, `nix run`, `nix profile`, `nix develop`) and the **legacy CLI** (`nix-env`, `nix-store`, `nix-build`, `nix-shell`). Flakes are primarily designed around the new CLI, but the legacy tools still work and are sometimes needed.

## New CLI (recommended with flakes)

### `nix build`

Build a derivation and place the result in `./result`.

```bash
nix build nixpkgs#hello
nix build .#myPackage
nix build .#myPackage --rebuild   # rebuild even if cached
```

The `./result` symlink points to the store path. You can run it directly:

```bash
./result/bin/hello
```

### `nix run`

Build and run a program without installing it.

```bash
nix run nixpkgs#jq -- '.key' file.json
nix run .#myApp -- --help
```

Everything after `--` is passed to the program.

### `nix develop`

Enter a development shell defined by a flake's `devShells` output.

```bash
nix develop .#default
nix develop .#backend
```

This is the modern replacement for `nix-shell` in flake-based projects.

### `nix profile`

Install packages into a persistent user profile.

```bash
nix profile install nixpkgs#jq
nix profile install .#myTool
nix profile list
nix profile remove nixpkgs#jq
nix profile upgrade nixpkgs#jq
nix profile upgrade --all
```

### `nix search`

Search for packages in a flake (usually nixpkgs).

```bash
nix search nixpkgs python3Packages.openpyxl
nix search nixpkgs nodejs
```

## Legacy CLI

### `nix-env`

Install, query, upgrade, and remove packages imperatively.

```bash
nix-env -iA nixpkgs.jq           # install
nix-env -uA nixpkgs.jq           # upgrade
nix-env -e jq                    # remove by name
nix-env -q                       # list installed
nix-env -qaP '.*openpyxl.*'      # search available packages
nix-env --rollback               # rollback to previous profile
nix-env --list-generations       # show generations
nix-env --delete-generations 3   # delete generation 3
```

### `nix-build`

Legacy build command. With flakes, prefer `nix build`.

```bash
nix-build '<nixpkgs>' -A hello
nix-build ./default.nix
```

### `nix-shell`

See the [`nix-shell` skill](../nix-shell/SKILL.md). Briefly:

```bash
nix-shell -p jq curl              # temporary shell with packages
nix-shell '<nixpkgs>' -A hello    # build dependencies of a derivation
nix-shell                         # use shell.nix / default.nix in current dir
```

## Profiles

A profile is a collection of symlinks that make packages available in your user environment (e.g., `~/.nix-profile/bin`).

- `nix profile` (new) manages `~/.nix-profile` via the new CLI.
- `nix-env` (legacy) manages the same profile but uses a different metadata format.
- **Do not mix `nix profile` and `nix-env` on the same profile.** They store state differently and will conflict.

List generations:

```bash
nix-env --list-generations
nix profile history
```

Rollback:

```bash
nix-env --rollback
nix profile rollback
```

## Channels (legacy)

Before flakes, channels were the way to get a named version of nixpkgs.

```bash
nix-channel --list
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --update
```

In `nix` expressions, `<nixpkgs>` resolves to the channel named `nixpkgs`.

For new projects, **prefer flakes** over channels. Channels are still used by default on some NixOS installations, but flake-based NixOS is increasingly common.

## Choosing a workflow

| Situation | Recommended tool |
|-----------|------------------|
| Temporary command or script | `nix-shell -p` / `nix run` |
| Project development environment | `nix develop` / `shell.nix` |
| Install for daily use | `nix profile install` |
| Legacy system without flakes | `nix-env -iA` |
| Build a derivation | `nix build` / `nix-build` |
| Reproducible shared project | Flakes + `nix develop` / `nix build` |

## Best practices

- **Prefer `nix profile` over `nix-env`** if you are using the new CLI.
- **Do not mix `nix profile` and `nix-env` on the same profile.** Pick one.
- **Use flakes for projects** so dependencies are pinned in `flake.lock`.
- **For NixOS system packages**, declare them in `configuration.nix` or `home.nix`, not via `nix-env`/`nix profile`.
- **Check `./result` after `nix build`** to verify what was produced.
