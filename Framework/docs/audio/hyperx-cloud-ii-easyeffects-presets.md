# HyperX Cloud II — EasyEffects Output Presets

Three EasyEffects **output** presets tuned for the HyperX Cloud II headset (USB or 3.5mm jack), covering music, video-essay/narration viewing at 2x speed, and Teams/Zoom meetings. These are output presets only — they shape what you hear, not your microphone signal.

Preset files: `./docs/audio/outputs/{Music,Video_Essays,Professional_Meetings}.json` (copy into `~/.config/easyeffects/output/` to load them in EasyEffects via Presets → Output).

## Hardware baseline: HyperX Cloud II characteristics

Rated response 15Hz–25,000Hz, 53mm dynamic drivers, closed-back, 60Ω. Independent measurements (Sonarworks, RTINGS/oratory1990-style AutoEQ data) consistently show:

- A **U-shaped ("smiley face") response**: elevated bass shelf, scooped low-mid/mid, treble elevated but uneven.
- An uneven bass shape rather than a simple boost — needs both a shelf and cuts (bass isn't just "too much," it's lumpy: hump around 55-60Hz and again near 150-170Hz).
- A narrow **resonant dip near 4.2kHz correlated with a THD (distortion) spike**. Boosting into this region risks audibly exciting that resonance/distortion, so all three presets deliberately avoid touching ~4.2kHz directly and instead place clarity boosts at 3-3.2kHz (just below it) to get presence without exciting the resonance.

This baseline informs the EQ choices in every preset below — the goal is corrective, not just "make it sound different."

## Design approach: EQ + dynamics, not just static EQ

The house reference for headphone/speaker correction in this [artice](https://wwmm.github.io/easyeffects/guides/guide_1.html) argues that **weak/tiny drivers** (e.g. laptop speakers) are best fixed with dynamic processors (Bass Enhancer, Multiband Compressor) rather than a static EQ, because those drivers physically can't reproduce boosted frequencies louder.

The Cloud II's 53mm dynamic drivers don't have that limitation — they're full-range headphone drivers, not a laptop speaker. So static parametric EQ is a legitimate and appropriate tool here; it's used as the primary corrective layer in all three presets, with dynamics (Compressor, Limiter, Bass Enhancer, Exciter) added on top for headroom control and harmonic richness, not as a replacement for EQ.

## Preset 1 — Music

**Goal:** sound richness, full body, preserve dynamic range (quiet stays quiet, loud stays bold but isn't deafening).

Chain: `Filter → Equalizer → Bass Enhancer → Exciter → Crystalizer → Crossfeed → Stereo Tools → Limiter`

| Stage | Setting | Why |
|---|---|---|
| Filter (HPF) | 30Hz, x2 slope | Removes sub-rumble/DC below audible range without touching real sub-bass (driver goes to 15Hz) |
| Equalizer | -1.5dB @ 55Hz, -1.5dB @ 150Hz | Tames the Cloud II's known lumpy bass hump/mud |
| Equalizer | +1.5dB @ 600Hz, +2.0dB @ 3000Hz | Fills the mid scoop for body and richness; 3kHz sits just below the 4.2kHz resonance to avoid exciting it |
| Equalizer | +1.5dB @ 9000Hz | Adds air/sparkle |
| Bass Enhancer | amount 4.0, scope 90Hz | Adds harmonic low-end richness rather than raw EQ gain — less distortion risk than just boosting bass further |
| Exciter | amount 3.5, scope 6500Hz | Adds high-frequency harmonic sparkle |
| Crystalizer | intensity +1 on upper-mid bands only | Restores a little micro-dynamic "snap" without touching bass (which is already generous on this headset) |
| Crossfeed | fcut 700Hz, feed 4.5 (default) | Reduces hard-panned L/R fatigue, more natural headphone soundstage |
| Stereo Tools | stereo-base 0.15 | Subtle width increase |
| Limiter | threshold -1dB, **ALR off**, Herm Thin, Half x4 oversampling | Pure brick-wall safety ceiling — catches peaks so playback isn't deafening, but doesn't average/compress loudness, which is what preserves "quiet stays quiet, loud stays bold" |

No Compressor in this chain — intentional, since a leveling compressor would work against the stated goal of preserving dynamic range.

## Preset 2 — Video Essays (2x playback)

**Goal:** rich sound with crisp vocal tones; vocal clarity must survive 2x-speed pitch-preserving playback, which tends to blur consonants and can introduce sibilance artifacts.

Chain: `Filter → Equalizer → Compressor → Deesser → Exciter → Crossfeed → Limiter`

| Stage | Setting | Why |
|---|---|---|
| Filter (HPF) | 40Hz, x2 slope | Cleans low rumble; speech-centric content doesn't need sub-bass extension |
| Equalizer | -1.0dB @ 90Hz, -1.5dB @ 250Hz | Reduces boom/mud that masks dialogue — 250Hz is a classic "muddy voice" frequency |
| Equalizer | +1.0dB @ 1000Hz | Adds vocal body/warmth (richness) |
| Equalizer | **+3.0dB @ 3200Hz** | Primary intelligibility/consonant-clarity boost — the band that degrades most under 2x pitch-preserving playback; placed just below the 4.2kHz resonance |
| Equalizer | +1.5dB @ 6000Hz, +1.0dB @ 10000Hz | Consonant crispness and air, kept modest to avoid harshness from 2x-speed artifacts |
| Compressor | Downward, threshold -20dB, ratio 2.5, attack 15ms, release 150ms, makeup +2dB | Levels narration against louder music/SFX swings common in video essays |
| Deesser | threshold -26dB, ratio 3, Wide mode | Controls sibilance, including artifacts introduced by pitch-preserving time-stretch algorithms |
| Exciter | amount 3.0, scope 7000Hz | Adds crispness supporting consonant definition |
| Crossfeed | default | Comfort over long viewing sessions |
| Limiter | threshold -1dB, Half x2 oversampling (lighter than Music preset) | Safety ceiling; slightly cheaper oversampling since this preset runs alongside video decode |

## Preset 3 — Professional Meetings (Teams/Zoom)

**Goal:** stay lightweight on CPU; improve vocal clarity across multiple speakers of varying loudness; keep voices sounding like themselves, just "a little clearer."

Chain: `Filter → Equalizer (3 bands) → Compressor → Limiter` — deliberately the shortest chain of the three.

| Stage | Setting | Why |
|---|---|---|
| Filter (HPF) | 70Hz, x2 slope | Removes hum/rumble while preserving male vocal fundamentals (~85-180Hz) |
| Equalizer | -1.5dB @ 200Hz | Reduces the congestion/mud that builds up when multiple speakers' room tone and voices overlap in a call |
| Equalizer | +2.5dB @ 3000Hz | The clarity/intelligibility band — makes voices "a little clearer" without changing their character; most call codecs (Opus) already roll off well above this |
| Equalizer | +1.0dB @ 8000Hz | Mild, natural air — kept small since it's easy to sound harsh here on compressed call audio |
| Compressor | Downward, threshold -22dB, ratio 2.0, attack 20ms, release 150ms, makeup +1.5dB | Its real job is leveling *between speakers* of different loudness, not tonal shaping — addresses "multiple speakers" directly |
| Limiter | threshold -1dB, **oversampling None** | Lowest-CPU safety ceiling; performance was prioritized over the marginal quality gain from oversampling |

Only 4 plugins vs. 7-8 in the other two presets — this is the explicit performance/CPU tradeoff requested for meeting use.

## Known open question

Deesser is documented as usable on both the `input` and `output` EasyEffects pipelines, but this hasn't been confirmed against the specific EasyEffects version installed on this system. If the Video Essays preset fails to load Deesser correctly, remove `"deesser#0"` from that preset's `plugins_order` array — the rest of the chain is unaffected.

## Source material

- HyperX Cloud II FR measurements: Sonarworks headphone review, RTINGS/oratory1990 AutoEQ-style analysis (via Morrow Shore review), SoundGuys review — all researched 2026-09-27.
- Plugin behavior/parameters: `.devin/skills/easyeffects-plugins/` (`dynamics.md`, `tone-eq.md`, `noise-reduction.md`, `spatial-time.md`, `local-server.md`).
- Speaker/dynamics-vs-EQ philosophy: EasyEffects [guide](https://wwmm.github.io/easyeffects/guides/guide_1.html) on dynamics vs EQ, used as contrast/reference rather than directly applied (that guide targets weak speakers, not full-range headphone drivers).
