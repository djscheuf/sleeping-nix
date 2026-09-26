---
description: Use this skill for any task involving Easy Effects (PipeWire audio effects app for Linux): choosing or understanding its audio effect plugins, configuring plugin parameters (GUI options or D-Bus/local-server properties), scripting plugin control, or troubleshooting an effects chain. Triggers include easyeffects, Easy Effects, PipeWire audio effects, compressor/gate/limiter/equalizer/reverb plugins, EBU R128 autogain, rnnoise/deepfilternet noise reduction, convolver impulse responses, and the EasyEffectsServer socket commands (set_property/get_property).
---

# Easy Effects Plugins Overview

Easy Effects applies audio effects to applications managed by PipeWire. Effects can be applied to **output** (apps' playback audio) or **input** (microphone audio sent to recording apps). Each "plugin" in a pipeline is a configurable effect unit; almost every plugin also exposes `bypass`, `inputGain`, and `outputGain` properties.

All plugin parameters are scriptable via a local UNIX socket (`EasyEffectsServer`) using `set_property` / `get_property` commands — see `local-server.md`. The property tables in each reference file come from the official [Plugin Properties](https://wwmm.github.io/easyeffects/database/plugins_properties.html) database page; enum defaults list their numeric `Choices:` for use with `set_property`.

## Reference Files

- `local-server.md` — consult when scripting/controlling Easy Effects: socket commands, `set_property`/`get_property` format, presets, global bypass
- `dynamics.md` — consult for compressors/gates/limiters and loudness normalization: Auto Gain, Compressor, Expander, Gate, Limiter, Maximizer, Multiband Compressor, Multiband Gate, Deesser
- `tone-eq.md` — consult for equalization and tonal shaping: Equalizer, Mid-Side Equalizer, Loudness, Bass Loudness, Bass Enhancer, Exciter, Crystalizer, Stereo Tools, Filter, Crusher
- `noise-reduction.md` — consult for mic cleanup/voice processing: Deep Noise Remover, Noise Reduction (rnnoise), Echo Canceller, Voice Suppressor, Speech Processor (speex)
- `spatial-time.md` — consult for space/depth/timing effects: Convolver, Crossfeed, Crosstalk Canceller, Delay, Reverberation
- `pitch.md` — consult for pitch shifting/correction: Pitch, Autotune
- `utility.md` — consult for metering/analysis: Spectrum, Level Meter

## Notes

- Multiband plugins repeat the same property set per band as `bandN<Suffix>` (N = 0–7); tables in `dynamics.md` list the suffixes and per-band defaults rather than all 200+ rows.
- Equalizer properties are per-channel (`left`/`right`) in the local-server command format — see `local-server.md`.
- Guides and user-interface docs (presets, effects order, blocklist, test signals, PipeWire settings) live at https://wwmm.github.io/easyeffects/ — not covered here; consult that site if a task needs them.

[Source: https://wwmm.github.io/easyeffects/]
