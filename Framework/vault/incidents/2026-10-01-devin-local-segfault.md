# Devin Local agent segfaults on activation (Devin Desktop)

**Status: FIX APPLIED in `nixpkg-windsurf/package.nix` — pending `nixos-rebuild switch`.**

Date opened: 2026-10-01

## Summary

After a `nixos-rebuild` to a newer nixpkgs generation, Devin Desktop can no
longer activate the Devin Local agent. Every attempt — new sessions and the
UI "reconnect" button — spawns the bundled `devin` binary, which dies with
SIGSEGV before completing the ACP handshake. The reconnect button appears
dead because each retry just crashes again identically.

## Root cause (identified)

The `windsurf-custom` package (Devin Desktop, from
`/home/djs/Documents/nixpkg-windsurf`) bundles a `devin` CLI binary at
`lib/devin-desktop/resources/app/extensions/windsurf/devin/bin/devin`. This
is a **static-PIE ELF** (type DYN, no interpreter, self-relocating at
startup via its own DYNAMIC/.rela.dyn).

The newer build runs a newer `auto-patchelf-hook` / patchelf, which
**rewrites even static-pie binaries that contain a DYNAMIC segment**. The
rewritten binary has:

- 11 program headers instead of 10 — a new `LOAD` segment was appended
  (`0xb03a000 → vaddr 0xb042000`, ~4.4 MB appended after the original
  section-header table at file offset 184,781,608).
- `.dynamic`, `.dynstr`, `.dynsym`, `.gnu.hash`, `.note.gnu.build-id`,
  `.rela.dyn` relocated into that appended segment.

The binary's early startup self-relocation then reads a wrong absolute
address and faults. `strace` shows it dies on the **second syscall ever**
(a single `mmap`, then `SIGSEGV`), always reading the same fixed address
`0xaca1b00` (SEGV_MAPERR, error 4 — read of unmapped page), always at
instruction offset `+0x6de8472`.

## Evidence

- `journalctl -k -b`: 16+ identical segfaults since 14:09, all in
  `.../extensions/windsurf/devin/bin/devin`, all at `si_addr=0xaca1b00`,
  `ip=+0x6de8472`. Crash times (14:21, 14:23:38, 14:23:51) line up with
  reconnect-button presses.
- `coredumpctl`: command line is `devin acp`, cgroup
  `app-devin-desktop-*.scope` — spawned by the IDE, not the terminal.
- The bundled binary crashes standalone: `devin --version` → SIGSEGV.
- `~/.local/share/devin/cli/logs/` shows CLI-spawned sessions completing
  `connect_acp: handshake complete` — the standalone `devin-cli-custom`
  package (3000.11.3, `/nix/store/jl2pr15m...-devin-cli-3000.11.3`) is
  **not** affected; only the IDE-bundled copy is corrupted.

## Two store outputs, same tarball — the smoking gun

Two `windsurf-3.10.35` outputs exist in the store, built from the **same**
source tarball (`gkd64c3k...-Devin-linux-x64-3.10.35.tar.gz`) but different
nixpkgs generations:

| Store path | Bundled `devin` | Size | Result |
|------------|-----------------|------|--------|
| `bkhqmwz58...-windsurf-3.10.35` (current profile) | corrupted by patchelf | 189,252,552 | SIGSEGV |
| `jy14py1d...-windsurf-3.10.35` (older build env) | intact | 184,783,336 | `devin 3000.10.35` OK |
| pristine tarball extraction | intact | 184,783,336 | OK |

The derivations differ only in build-input generations (auto-patchelf-hook
`gfcbbkyc…` vs `j0f0a74…`; patchelf-0.18.0 exists in the store, older builds
used 0.15.2 — consistent with patchelf 0.18's full-rewrite behavior
corrupting static-pie binaries).

## Fix applied (2026-10-01)

`nixpkg-windsurf/package.nix` `overrideAttrs` now:

1. `dontAutoPatchelf = true` on Linux — `autoPatchelfPostFixup` runs in
   `postFixupHooks`, i.e. *after* the `postFixup` attr string, so a restore
   placed in `postFixup` gets re-corrupted.
2. `preFixup`: copies the pristine `devin` binary to `$NIX_BUILD_TOP`
   (NOT into `$out` — a backup inside `$out` is itself scanned and rewritten
   by fixupOutput's `shrinkRunpath`, which runs `patchelf` on every ELF).
3. `postFixup`: runs `autoPatchelf -- "$out"` manually (keeps RPATH fixes for
   `.node` modules etc.), then copies the pristine binary back over `devin`.

Verified: rebuilt store output's `devin` is byte-identical to the pristine
tarball extraction and `devin --version` prints `devin 3000.10.48`.

Remaining: `sudo nixos-rebuild switch` to deploy.

## File/component notes

- Package def: `/home/djs/Documents/nixpkg-windsurf/package.nix` —
  `vscode-generic` + `autoPatchelfHook`; now restores the pristine `devin`
  binary after fixup (see "Fix applied" above).
- Devin Desktop user settings (`~/.config/Devin/User/settings.json`):
  `devin.acp.enabledAgents."devin-cli": true`,
  `devin.acp.preferredAgent: "devin-cli"` — correct; not a config problem.
- Log locations: IDE logs `~/.config/Devin/logs/<timestamp>/`; agent/CLI
  logs `~/.local/share/devin/cli/logs/`.
