# NixOS rebuild, upgrade, and rollback

## `nixos-rebuild` commands

`nixos-rebuild` is the central tool for applying NixOS configuration changes.

| Subcommand | What it does |
|------------|--------------|
| `switch` | Build, activate, and set as default boot entry |
| `test` | Build and activate in the running system, but **do not** update the boot default |
| `build` | Build the configuration but do not activate it |
| `boot` | Build and set as boot default, but do not activate now |
| `build-vm` | Build a VM that runs the configuration (useful for testing) |
| `edit` | Open the configuration file in `$EDITOR` |
| `switch --upgrade` | Update channels and apply |
| `switch --flake .#host` | Apply a flake-based configuration |
| `switch --rollback` | Switch to the previous generation |
| `switch --repair` | Re-verify and repair all paths in the closure |

Examples:

```bash
sudo nixos-rebuild switch
sudo nixos-rebuild switch --flake .#myhost
sudo nixos-rebuild test --flake .#myhost
sudo nixos-rebuild build-vm
```

## Applying a new configuration

After editing `configuration.nix` (or `flake.nix`):

```bash
sudo nixos-rebuild switch
```

This will:

1. Evaluate the configuration.
2. Build or download all required store paths.
3. Activate the new system (start/stop services, update `/etc`, etc.).
4. Add the new configuration to the bootloader menu as the default.

## Testing changes safely

Use `test` for risky changes. If something breaks, a reboot returns you to the previous generation:

```bash
sudo nixos-rebuild test
```

Use `build` to verify the configuration builds without activating:

```bash
sudo nixos-rebuild build
```

For complex changes, build a VM:

```bash
sudo nixos-rebuild build-vm
./result/bin/run-*-vm
```

## Upgrading NixOS

### Channel-based upgrade

```bash
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade
```

### Flake-based upgrade

```bash
nix flake update
sudo nixos-rebuild switch --flake .#myhost
```

Update only `nixpkgs`:

```bash
nix flake lock --update-input nixpkgs
sudo nixos-rebuild switch --flake .#myhost
```

## Rollback

### Rollback in a running system

```bash
sudo nixos-rebuild switch --rollback
```

This is equivalent to:

```bash
sudo /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch
```

where `N` is the previous generation number.

### Rollback at boot

If the new configuration does not boot:

1. Reboot.
2. In the bootloader, select **NixOS - All configurations**.
3. Choose a previous generation.
4. Once booted, make it the default:

   ```bash
   sudo /run/current-system/bin/switch-to-configuration boot
   ```

### List generations

```bash
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
ls -l /nix/var/nix/profiles/system-*-link
```

### Delete old generations

```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations 3 4 5
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10  # keep last 10
sudo nix-collect-garbage -d
```

## Repair and verification

If store paths are corrupt or missing:

```bash
sudo nixos-rebuild switch --repair
```

This checks every path in the system closure and rebuilds or re-downloads anything whose hash differs from Nix's database.

For a broader store scan:

```bash
sudo nix-store --verify --check-contents --repair
```

## Best practices

- **Use `test` or `build` for risky changes** before `switch`.
- **Keep several generations** before garbage collection so you can roll back.
- **Commit your config before `switch`** so you can revert the source file too.
- **Run `nixos-rebuild switch --upgrade` regularly** on channel-based systems.
- **On flake systems**, update `flake.lock` intentionally and review the diff.
- **Check `nixos-rebuild build` output** for warnings about deprecated options.
