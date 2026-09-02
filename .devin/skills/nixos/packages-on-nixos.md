# Packages on NixOS

## Declarative package management

On NixOS, the primary way to install software is to declare it in `configuration.nix` and run `nixos-rebuild`.

```nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    jq
  ];
}
```

After editing:

```bash
sudo nixos-rebuild switch
```

These packages become available system-wide in `/run/current-system/sw/bin` and the user `PATH`.

## Services with integrated packages

Many programs are better enabled as a service, which often installs the package automatically and configures it:

```nix
{
  services.openssh.enable = true;
  services.pipewire.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
}
```

Check the [NixOS options search](https://search.nixos.org/options) for the specific module.

## Ad-hoc package management

For one-off commands, use `nix-shell` (or `nix run`) rather than installing globally:

```bash
nix-shell -p jq --run "jq '.key' file.json"
nix run nixpkgs#jq -- '.key' file.json
```

This keeps your `configuration.nix` clean and avoids profile conflicts.

## Avoid `nix-env -i` on NixOS

`nix-env -iA nixpkgs.somepackage` installs into the user profile but does not track the package in `configuration.nix`. It can cause:

- Hidden dependencies that break after GC or upgrades.
- Conflicts between `nix-env` and `nix profile`.
- Difficulty reproducing the system state.

Use `nix-env` only for specific legacy workflows or temporary profiles. Prefer declarative configuration or `nix-shell`/`nix run`.

## Custom packages and overlays

### Add a local package

If you have a custom derivation in `./pkgs/mytool/default.nix`:

```nix
{ pkgs, ... }:

let
  mytool = pkgs.callPackage ./pkgs/mytool {};
in
{
  environment.systemPackages = [ mytool ];
}
```

### Overlays

Overlays modify the Nixpkgs package set before it is used in `configuration.nix`:

```nix
{
  nixpkgs.overlays = [
    (final: prev: {
      mytool = final.callPackage ./pkgs/mytool {};
      neovim = prev.neovim.override { vimAlias = true; };
    })
  ];

  environment.systemPackages = [ pkgs.mytool ];
}
```

Place overlays in `~/.config/nixpkgs/overlays/` for user-only effect, or in `configuration.nix` for system-wide effect.

## Allowing unfree packages

```nix
{
  nixpkgs.config.allowUnfree = true;
}
```

Or allow specific packages only:

```nix
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "nvidia-x11"
  ];
}
```

## Pinning a package version

You can import a different Nixpkgs revision inside your configuration:

```nix
{ pkgs, ... }:

let
  oldpkgs = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "nixos-23.11";
    sha256 = "...";
  }) {};
in
{
  environment.systemPackages = [ oldpkgs.somePackage ];
}
```

For flake-based systems, the cleaner approach is to add a second nixpkgs input and expose it as an overlay (see [Flake-based NixOS](./flakes.md)).

## Best practices

- **Install most packages via `environment.systemPackages` or service modules** so they are tracked declaratively.
- **Use `nix-shell` / `nix run` for one-off tools** instead of cluttering the system profile.
- **Avoid mixing `nix-env` and `nix profile`** on the same system.
- **Use overlays for forks or version overrides**, not for random package installation.
- **Check `programs.<name>.enable`** before adding a package to `environment.systemPackages`; many programs have a dedicated NixOS module.
