# Vault Index

Last updated: 2026-09-25

## Decisions

_None yet — ADRs go in `decisions/` as `ADR-NNN-<slug>.md`._

## Services

- [OBS Studio skill](./services/obs-skill.md) — `.devin/skills/obs/` covers scenes/sources/filters/audio/encoders/protocols/troubleshooting/automation; read before OBS work (2026-09-25)
- [EasyEffects HyperX Cloud II presets](./services/easyeffects-hyperx-presets.md) — Music/Video Essays/Meetings output presets, tuned around the headset's known FR quirks; full rationale in `Framework/docs/audio/` (2026-09-27)

## Incidents

- [Handy Push-to-Talk shortcut conflict](./incidents/handy-push-to-talk.md) — Sep 24, 2026 (closed unresolved; Handy removed)
- [Devin Local agent segfaults on activation](./incidents/2026-10-01-devin-local-segfault.md) — Oct 1, 2026 (root cause: patchelf corrupts bundled static-pie `devin` binary in windsurf-custom; fix pending)

## Glossary

- [Project terms](./glossary.md) — hosts, package plumbing, disk/encryption, virtualization
