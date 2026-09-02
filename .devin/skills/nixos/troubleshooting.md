# Troubleshooting NixOS

## General debugging flags

Add these to `nixos-rebuild` or `nix build`:

```bash
--show-trace              # full expression trace on error
-v -vv -vvv               # increasing verbosity
-L                        # print build logs
--option log-lines 100    # show more log lines per derivation
```

Example:

```bash
sudo nixos-rebuild switch --show-trace -L
```

## Boot recovery

If a new configuration fails to boot:

1. Reboot.
2. In the bootloader, open **NixOS - All configurations**.
3. Select a previous generation that worked.
4. Once booted, make it the default:

   ```bash
   sudo /run/current-system/bin/switch-to-configuration boot
   ```

Or roll back in a running system:

```bash
sudo nixos-rebuild switch --rollback
```

## Store corruption and repair

After a crash, store paths may be corrupt. Verify and repair:

```bash
sudo nix-store --verify --check-contents --repair
sudo nixos-rebuild switch --repair
```

`--repair` compares each path's hash to Nix's database and re-downloads or rebuilds mismatched paths from binary caches.

## Network and binary cache issues

If a binary cache is unreachable, Nix may hang waiting for HTTP timeouts. Temporarily disable caches:

```bash
sudo nixos-rebuild switch --option substituters ''
```

Use an alternative cache:

```bash
sudo nixos-rebuild switch --option substituters 'https://cache.nixos.org https://my-cache.example.org'
```

Configure caches persistently in `configuration.nix`:

```nix
{
  nix.settings.substituters = [ "https://cache.nixos.org" "https://my-cache.example.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:..." "my-cache:..." ];
}
```

## Reading service logs

```bash
journalctl -u <service>
journalctl -u <service> -f
journalctl -xb
```

For a failed NixOS build, read the derivation log:

```bash
sudo nix log /nix/store/...-nixos-system-...
```

## Build a VM to test changes

For risky configuration changes, build a VM first:

```bash
sudo nixos-rebuild build-vm
./result/bin/run-*-vm
```

This starts a QEMU VM running your new configuration without touching the host system.

## Common errors

### `The option '<name>' does not exist`

You referenced an option that is not declared. Check the exact option name with `nixos-option` or the web search.

### `The option value '<name>' is not of type <type>`

The value you assigned has the wrong type. Check the option documentation for expected type (boolean, string, list, attribute set, etc.).

### `infinite recursion`

Usually caused by a module reading `config` before it is available, or a circular import. Use `--show-trace` to find the loop.

### `attribute 'foo' missing`

You are trying to access a package or option that does not exist in the current `pkgs` or `config`. Check spelling and whether the relevant module is imported.

### `builder failed`

A derivation failed to build. Use `nix log /nix/store/...-name` to see why. Common causes:

- Missing `buildInputs` or `nativeBuildInputs`.
- Tests failing in `checkPhase`.
- Sandbox preventing network access during the build.

## Checking the configuration

Evaluate the configuration without building:

```bash
nixos-rebuild build
```

Inspect the resulting system closure:

```bash
nix derivation show /nix/store/...-nixos-system-...
nix path-info -Sh /nix/store/...-nixos-system-...   # closure size
```

For flake-based systems:

```bash
nix eval .#nixosConfigurations.myhost.config.system.build.toplevel --json
nix flake check
```

## Agentic troubleshooting checklist

When a NixOS command fails while you are automating a task:

1. **Re-run with `--show-trace`** to locate the failing expression.
2. **Check the option name** with `nixos-option` or search.nixos.org/options.
3. **Read the build log** with `nix log` or `-L`.
4. **Try `build` or `test` first** before `switch` for risky changes.
5. **If the system is broken**, boot a previous generation or use `--rollback`.
6. **Verify store integrity** with `nix-store --verify --check-contents` after crashes.
7. **Check network/cache timeouts** with `--option substituters ''` if builds hang.
