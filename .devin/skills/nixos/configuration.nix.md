# NixOS configuration.nix

## Structure

A NixOS configuration file is a Nix function that returns an attribute set of option definitions:

```nix
{ config, pkgs, lib, ... }:

{
  # option definitions
  networking.hostName = "myhost";
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [ git vim ];
}
```

The arguments are automatically provided by NixOS:

| Argument | Meaning |
|----------|---------|
| `config` | The evaluated configuration value (useful for reading other options) |
| `pkgs` | The Nixpkgs package set (including overlays) |
| `lib` | The Nixpkgs library helper functions |
| `options` | The raw option declarations (advanced use) |
| `...` | Accepts any additional arguments (required when using `imports` or `specialArgs`) |

## Imports and modularity

Split your configuration into multiple files with `imports`:

```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ./services.nix
  ];

  networking.hostName = "myhost";
}
```

Each imported file must be a function returning an attribute set. NixOS merges all imported modules into a single configuration.

## Option names and nesting

Option names use dot notation. The dot is shorthand for nested attribute sets:

```nix
{ services.httpd.enable = true; }
# is equivalent to
{ services = { httpd = { enable = true; }; }; }
```

You can use quoted attribute names for keys that are not valid identifiers:

```nix
{ boot.kernel.sysctl."net.ipv4.tcp_keepalive_time" = 60; }
```

## Common value types

| Type | Example |
|------|---------|
| String | `networking.hostName = "myhost";` |
| Boolean | `services.openssh.enable = true;` |
| Integer | `boot.loader.timeout = 5;` |
| List | `environment.systemPackages = [ pkgs.git pkgs.vim ];` |
| Attribute set | `users.users.alice = { isNormalUser = true; };` |
| Multi-line string | `networking.extraHosts = '' 127.0.0.2 other-localhost '';` |
| Null | `services.xserver.displayManager.gdm.enable = null;` |

## Reading options from `config`

Use `config` to read the value of another option:

```nix
{ config, pkgs, ... }:

{
  services.nginx.enable = true;
  networking.firewall.allowedTCPPorts =
    if config.services.nginx.enable then [ 80 443 ] else [ ];
}
```

## Conditionals and abstractions

Use `let`/`in` for local bindings and `lib.mkIf` for conditional option definitions:

```nix
{ config, pkgs, lib, ... }:

let
  cfg = config.my.enableWeb;
in
{
  options.my.enableWeb = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable web server";
  };

  config = lib.mkIf cfg {
    services.nginx.enable = true;
  };
}
```

This is the basis of writing custom NixOS modules.

## Finding options

NixOS has thousands of options. Discover them with:

- **Web**: https://search.nixos.org/options
- **CLI**: `nixos-option services.nginx.enable`
- **Local**: `nixos-help` or `man configuration.nix`

## Common option categories

| Category | Example options |
|----------|-----------------|
| Boot | `boot.loader.systemd-boot.enable`, `boot.kernelPackages`, `boot.kernelParams` |
| Networking | `networking.hostName`, `networking.useDHCP`, `networking.firewall` |
| Users | `users.users.<name>`, `users.groups.<name>` |
| Packages | `environment.systemPackages`, `programs.<name>.enable` |
| Services | `services.<name>.enable`, `services.<name>.settings` |
| Filesystems | `fileSystems.<mount>`, `swapDevices` |
| Nix settings | `nix.settings.experimental-features`, `nixpkgs.config.allowUnfree` |

## Best practices

- **Keep `configuration.nix` under version control** (e.g., `/etc/nixos` as a git repo or a flake repo).
- **Use `imports` to split large configs** by concern (networking, services, users, hardware).
- **Use `nixos-option` or the web search** before inventing an option name.
- **Set `nix.settings.experimental-features = [ "nix-command" "flakes" ];`** if you want flakes.
- **Avoid hardcoded paths**; use Nix store paths or config options instead.
