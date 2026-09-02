# Troubleshooting Nix builds and evaluation

## General debugging flags

Add these flags to most Nix commands for more detail:

```bash
--show-trace          # Print full Nix expression trace on error
--verbose -v          # Increase verbosity (repeat: -vv, -vvv)
--debug               # Maximum debug output
--option log-lines 100 # Show more build log lines
```

Example:

```bash
nix build .#myPackage --show-trace -L
```

`-L` (or `--print-build-logs`) streams build logs to the terminal during `nix build`.

## Reading build logs

For a failed derivation, find the log path:

```bash
nix log /nix/store/...-myPackage
nix log .#myPackage
nix-store --read-log /nix/store/...-myPackage
```

On NixOS, logs are also available via `journalctl` for systemd services.

## Inspecting derivations

Show the evaluated derivation as JSON:

```bash
nix derivation show /nix/store/...-myPackage
nix derivation show .#myPackage
```

Instantiate a `.nix` file to see its store path:

```bash
nix-instantiate ./default.nix
nix-instantiate ./default.nix -A myAttr
```

## Common errors

### `attribute '<name>' missing`

The Nix expression referenced an attribute that does not exist. Use `--show-trace` to find the file and line.

### `cannot coerce a set to a string`

You passed an attribute set where a string was expected. Use `builtins.toString` or interpolate a string value.

### `build of ... failed`

Check the build log with `nix log`. Common causes:

- Missing `buildInputs` or `nativeBuildInputs`.
- Hardcoded `/usr/bin` or `/bin` paths in build scripts.
- Network access blocked during the build (Nix builds are sandboxed by default).
- Tests failing in `checkPhase`; you can skip them with `doCheck = false;` for diagnosis.

### `infinite recursion`

Usually caused by a self-referential option or module, or by evaluating `config` before it is defined. Use `--show-trace` and look for circular module references.

### `path ... is not valid`

The store path is missing or was garbage-collected. Rebuild it or repair the store.

### Network / cache timeouts

If Nix hangs trying to reach a cache, disable it temporarily:

```bash
nix build . --option substituters ''
nixos-rebuild switch --option substituters ''
```

## Repairing the store

If a path is corrupt or missing:

```bash
nix-store --verify --check-contents --repair
nix-store --repair-path /nix/store/...-package
```

For a NixOS system closure:

```bash
sudo nixos-rebuild switch --repair
```

## Adding tracing to Nix expressions

Use `builtins.trace` to print values during evaluation:

```nix
let x = builtins.trace "evaluating x" (someFunction y); in
x
```

For repeated traces, `lib.debug.traceSeq` or `lib.debug.traceVal` from `nixpkgs` can be helpful.

## NIX_DEBUG

Set `NIX_DEBUG` in a derivation or shell to see environment details:

```nix
stdenv.mkDerivation {
  # ...
  NIX_DEBUG = 1;  # 1 is moderate; 7 is extremely verbose
}
```

In `nix-shell`:

```bash
nix-shell -p hello --run 'echo $NIX_DEBUG'
```

## Debugging flake evaluation

```bash
nix flake check --show-trace
nix flake metadata .                    # show inputs
nix flake lock --update-input nixpkgs   # refresh one input
nix eval .#packages.x86_64-linux.default --json
nix eval --json '.#nixosConfigurations.myhost.config.system.build.toplevel'
```

## Agentic CLI checklist

When a Nix command fails while you are automating a task:

1. **Re-run with `--show-trace`** to locate the expression error.
2. **Read the log** with `nix log <path>` or `-L`.
3. **Check missing inputs** — did you forget a `buildInput` or `nativeBuildInput`?
4. **Check for impurities** — is the build script trying to download or write outside the store?
5. **Check substituters** — is a cache unreachable? Try `--option substituters ''`.
6. **Check store integrity** — run `nix-store --verify --check-contents` if crashes occurred.
7. **Roll back** if you are on NixOS and the new configuration is broken.
