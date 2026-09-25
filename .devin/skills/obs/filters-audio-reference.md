# Audio Filters — Property Reference

All audio filters are available on all platforms. Add via Audio Mixer gear icon (or right-click a source) → Filters. Order matters — they run top-to-bottom. Sources: `kb/filters-guide` + individual filter articles.

## Recommended chain order

`Noise Suppression → Noise Gate/Expander → Compressor → (Gain) → Limiter` — put the **Limiter last** (brick-wall safety) and the **Compressor early** (tames peaks before other processing).

## Gain

| Property | Description | Default |
|----------|-------------|---------|
| Gain | dB boost/cut | 0.00 dB |

Prefer raising gain at the source (mic/interface) first; use this for quiet sources only.

## Noise Gate

Hard on/off gate — silence below threshold. Set Close above the noise floor and Open just below voice level.

| Property | Description | Default |
|----------|-------------|---------|
| Close Threshold | Below this → muted | -32.00 dB |
| Open Threshold | Above this → gate opens | -26.00 dB |
| Attack Time | Open speed | 25 ms |
| Hold Time | Stay open after falling below open threshold | 200 ms |
| Release Time | Close speed | 150 ms |

## Noise Suppression

Subtracts steady background noise (fans, room tone). Not effective for loud environments.

| Property | Description | Default |
|----------|-------------|---------|
| Method | **RNNoise** (better quality, more CPU) / **Speex** (configurable) / **NVIDIA Noise Removal** (needs NVIDIA Broadcast SDK) | RNNoise |
| Suppression Level | Speex only — 0 = off; more negative = stronger suppression, can distort voice | -30 dB |

## Expander

Softer alternative to a noise gate — gain-reduces signal *below* the threshold rather than muting. Typically near the end of the chain (after compressor, before limiter).

| Property | Description | Default |
|----------|-------------|---------|
| Presets | Expander (gentle) / Gate (hard, gate-like) | Expander |
| Ratio | Reduction strength: 2:1 light, ~4:1 balanced, 10:1 ≈ full gate | 2.00:1 |
| Threshold | Above this level, reduction stops — tune until noise gone but voice uncut | -40.00 dB |
| Attack | Open speed (5–10 ms recommended) | 10 ms |
| Release | Close speed (50–120 ms recommended) | 50 ms |
| Output Gain | Makeup gain | 0.00 dB |
| Detection | **RMS** (10 ms average — smoother, recommended) / **Peak** (instant) | RMS |

## Compressor

Tames loud peaks (shouting) by reducing level *above* the threshold; place early in the chain.

| Property | Description | Default |
|----------|-------------|---------|
| Ratio | Compression strength (2:1 weak, 6:1 strong) | 10.00:1 |
| Threshold | Level where compression starts | -18.00 dB |
| Attack | Time to reach full reduction over threshold | 6 ms |
| Release | Time to return to no reduction under threshold | 60 ms |
| Output Gain | Makeup gain to restore average loudness | 0.00 dB |
| Sidechain/Ducking Source | Mic/aux source whose level ducks *this* source | None |

### Ducking recipe (put on Desktop Audio, sidechain = Mic)

Ratio **32:1**, Threshold **-36 dB**, Attack **100 ms**, Release **600 ms**, Output Gain **0 dB** — desktop dips while you speak, returns after. Adjust threshold for ducking depth.

## Limiter

Brick-wall ceiling — always last in the chain; prevents clipping >0 dB.

| Property | Description | Default |
|----------|-------------|---------|
| Threshold | Absolute max output level | -6.00 dB |
| Release | How fast gain reduction recovers after peak passes | 60 ms |

## Invert Polarity

No properties. Corrects phase cancellation (e.g. two mics picking up the same voice thin/hollow — invert one).

## VST 2.x Plugin

Hosts VST **2.x** audio plugins (EQs, de-essers, mastering chains). Not supported: VST 1.x, **VST 3.x**, MIDI input, shell VSTs. Some plugins crash or are CPU-heavy — test before use.

Properties: Plugin selector (from search dirs), Open Plugin Interface (native plugin UI), plus plugin-specific parameters.

Linux search dirs (`.so`/`.o`): `/usr/lib{,64}/{vst,lxvst,linux_vst}/`, `/usr/local/lib{,64}/{vst,lxvst,linux_vst}/`, `~/.vst/`, `~/.lxvst/`. If `VST_PATH` env var is set it **replaces** the default search paths — on NixOS this is the practical way to expose plugins (or use `obs-studio-plugins` wrappers that set it). Windows: `%ProgramFiles%` Steinberg/Common Files VST dirs (`.dll`). macOS: `/Library/Audio/Plug-Ins/VST/` and `~/Library/Audio/Plug-ins/VST/` (`.vst`).

Known-good free plugins: REAPER ReaPlugs VFX suite, Melda Production.
