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

## Vault Protocol

This repo maintains a compounding `Framework/vault/` of project knowledge. The vault is the
first place you look and the last place you write.

### At Session Start

1. Read `Framework/vault/INDEX.md` to see what's documented.
2. If the task touches a topic with an existing vault page, read it BEFORE reading source code.
3. If the task touches a topic WITHOUT a vault page, note it — you'll write one at the end.

### During the Session

- When you encounter something non-obvious (a gotcha, a decision, a pattern):
  - Check if `Framework/vault/` has a page for it. If yes, do not re-discover it.
  - If no, note it for end-of-session capture.
- Never cite internal knowledge the user can't verify. If it's not in `Framework/vault/`, don't claim it as fact.

### At Session End

When the session produced a decision, solved a non-obvious problem, or established a pattern:

1. Write a vault page. Location rules (match the directories that exist in this repo's `Framework/vault/`):
   - Decisions (why we chose X over Y) → `Framework/vault/decisions/ADR-NNN-<slug>.md` (next sequential number)
   - Postmortems → `Framework/vault/incidents/<YYYY-MM-DD>-<slug>.md`
   - Service/component notes, runbooks, gotchas → `Framework/vault/services/<service>.md`
   - Glossary entries → append to `Framework/vault/glossary.md`
2. Update `Framework/vault/INDEX.md` to link the new page.
3. One page per topic. If a page grows > 300 lines, split it.

### Writing Style

- Plain markdown. No front-matter unless required by another tool.
- Lead with the **bottom line**: the answer in the first 2 lines, details below.
- Use the present tense for current state ("we use PipeWire") and past tense for history ("we tried PulseAudio, it didn't fit").
- Include dates on decisions — these age, and agents need to know how fresh a claim is.
- No prose walls. Headers, lists, tables, code blocks.

### Never

- Put secrets in `Framework/vault/`. It's git-tracked — assume public.
- Put PII in `Framework/vault/`. Same reason.
- Write vault pages that duplicate code comments. The vault is for things code can't express.
- Leave `Framework/vault/INDEX.md` out of date. The index is the API.

### Skills Involved

- `query-wiki` — called first, reads relevant vault pages for the current intent.
- `update-wiki` — called last, writes new or updated pages before session ends.
