# EasyEffects — HyperX Cloud II presets

Three tuned EasyEffects **output** presets exist for the HyperX Cloud II headset: Music, Video Essays (2x playback), Professional Meetings (Teams/Zoom).

Full description, rationale, and per-plugin settings: `Framework/docs/audio/hyperx-cloud-ii-easyeffects-presets.md`.

Preset JSON files: `~/Downloads/EasyEffects/Outputs/{Music,Video_Essays,Professional_Meetings}.json` — copy into `~/.config/easyeffects/output/` to load in-app.

## Key facts worth not re-deriving

- Cloud II has a known U-shaped ("smiley") frequency response with a lumpy bass (humps ~55Hz and ~150-170Hz, not a simple boost) and a resonant dip/THD spike near 4.2kHz. All presets avoid boosting 4.2kHz directly and place presence boosts at 3-3.2kHz instead.
- The "fix weak speakers with dynamics, not EQ" philosophy from `202609271500 - Summary - EasyEffects Notebook Speaker EQ.md` (zweite-fundament vault) does **not** apply here — that's for tiny/weak drivers that can't reproduce boosted frequencies. The Cloud II's 53mm dynamic drivers are full-range, so static parametric EQ is used as the primary corrective layer, with dynamics layered on top.
- Meetings preset is intentionally the shortest chain (4 plugins, no oversampling) — CPU/performance was an explicit requirement, traded against the richer chains used for Music/Video Essays.
- Plugin parameter reference lives in `.devin/skills/easyeffects-plugins/` (dynamics.md, tone-eq.md, noise-reduction.md, spatial-time.md, local-server.md) — consult before re-deriving EasyEffects plugin behavior.

Date: 2026-09-27.
