# Pitch Plugins

Plugins that shift or correct the pitch of a signal.

## Pitch

Pitch shifting is a sound recording technique in which the original Pitch of a sound is raised or lowered. Easy Effects uses the pitch shifter from SoundTouch.
**Mode**

Controls the method used for pitch shifting.

- **High Speed** - Uses a method with a CPU cost that is relatively moderate and predictable.
- **High Quality** - Uses the highest quality method for pitch shifting. This CPU cost is approximately proportional to the required frequency shift.
- **High Consistency** - Uses the method that gives greatest consistency when used to create small variations in pitch around the 1.0-ratio level. Unlike the previous two options, this avoids discontinuities when moving across the 1.0 pitch scale. It also consumes more CPU than the others in the case where the pitch scale is exactly 1.0.

**Formant**

Controls the handling of formant shape (spectral envelope) when pitch-shifting.

- **Shifted** - Applies no special formant processing. The spectral envelope will be pitch shifted as normal.
- **Preserved** - Preserves the spectral envelope of the unshifted signal. This permits shifting the note frequency without so substantially affecting the perceived pitch profile of the voice or instrument.

**Transients**

Controls the component frequency phase-reset mechanism that may be used at transient points to provide clarity and realism to percussion and other significant transient sounds.

- **Crisp** - Resets component phases at the peak of each transient (the start of a significant note or percussive event). This usually results in a clear-sounding output, but it is not always consistent, and may cause interruptions in stable sounds present at the same time as transient events.
- **Mixed** - Resets component phases at the peak of each transient, outside a frequency range typical of musical fundamental frequencies. The results may be more regular for mixed stable and percussive notes than Crisp option, but with a "phasier" sound. The balance may sound very good for certain types of music and fairly bad for others.
- **Smooth** - Does not reset component phases at any point. The results will be smoother and more regular but may be less clear than the other transient options.

**Detector**

Controls the type of transient detector used.

- **Compound** - Uses a general purpose transient detector which is likely to be good for most situations.
- **Percussive** - Detects percussive transients.
- **Soft** - Uses an onset detector with less of a bias toward percussive transients. This may give better results with certain material (e.g. relatively monophonic piano music).

**Phase**

Controls the adjustment of component frequency phases from one analysis window to the next during non-transient segments.

- **Laminar** - Adjusts phases when stretching in such a way as to try to retain the continuity of phase relationships between adjacent frequency bins whose phases are behaving in similar ways. This should give good results in most situations.
- **Independent** - Adjusts the phase in each frequency bin independently from its neighbours. This usually results in a slightly softer, phasier sound.

**Cents**

Number of cents the Pitch will be increased or decreased.
**Semitones**

Number of semitones the Pitch will be increased or decreased.
**Octaves**

Number of octaves the Pitch will be increased or decreased.

### References

- Wikipedia Pitch Shift (https://en.wikipedia.org/wiki/Pitch_shift)
- SoundTouch Audio Time Stretcher Library - Attractive Features (https://www.surina.net/soundtouch/)

**Configurable properties (plugin ID `pitch`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dry` | Double | `-100` |
| `wet` | Double | `0` |
| `cents` | Double | `0.0` |
| `semitones` | Double | `0.0` |
| `octaves` | Double | `0.0` |
| `quickSeek` | Bool | `false` |
| `antiAlias` | Bool | `false` |
| `sequenceLength` | Int | `40` |
| `seekWindow` | Int | `15` |
| `overlapLength` | Int | `8` |
| `tempoDifference` | Double | `0` |
| `rateDifference` | Double | `0` |

Full docs: https://wwmm.github.io/easyeffects/plugins/pitch.html


---

## Autotune

Autotune is a pitch correction effect that automatically adjusts the pitch of an audio signal to the nearest target note. It can be used to subtly correct vocal intonation or to create the characteristic "auto-tune effect" heard in modern music. Easy Effects uses the fat1 plugin from x42 LV2 Plugins.

### Tuning Options

**Mode**

Controls how pitch correction is applied.

- **Auto** - Automatically detects the pitch and corrects it to the nearest enabled note in the scale.
- **Manual** - Targets a fixed pitch set by the Offset parameter.

**Tuning**

The reference frequency for the A4 note, in Hz. The standard tuning is 440 Hz. Adjust this if you are working with non-standard tuning (range: 400–480 Hz).
**Correction**

Controls the strength of pitch correction. At 1.0, the pitch is fully corrected to the target note. Lower values allow more of the natural pitch variation through, producing a subtler effect.
**Bias**

Controls the preference toward the current note versus the nearest target note. At 0.5 (center), no bias is applied. Higher values make the correction stick to the current note longer before switching. Lower values make it switch to the nearest target more readily.
**Filter**

Controls the smoothness of the pitch detection. Lower values result in faster, more responsive detection but may introduce artifacts. Higher values produce smoother, more stable detection but with slower response.
**Offset**

Shifts the target pitch by the specified number of semitones (range: -2.0 to 2.0). In Manual mode, this sets the fixed target pitch offset.
**Fast Correction**

When enabled, applies pitch correction with minimal latency. This produces a more immediate, aggressive correction effect but may introduce more artifacts.

### Scale Selection

The Scale section allows you to select which notes the pitch correction will target.
**Root**

The root note of the scale (C, D, E, F, G, A, or B).
**Accidental**

Applies a sharp or flat modifier to the root note.
**Scale**

Selects either Major or Minor scale pattern. Choosing a scale automatically enables the correct notes for that key.
**Note Toggles**

Individual toggles for each of the 12 chromatic notes (C through B). Selecting a scale sets these automatically, but you can also configure them manually for custom scales or chromatic correction (all notes enabled).

### Pitch Error Meter

Displays the current pitch deviation from the target note. A value of 0 means the pitch is exactly on target. Negative values indicate the pitch is flat, positive values indicate it is sharp.

### References

- x42 fat1 Auto Tune (https://x42-plugins.com/x42/x42-autotune)
- Wikipedia Auto-Tune (https://en.wikipedia.org/wiki/Auto-Tune)

**Configurable properties (plugin ID `autotune`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `mode` | Enum | `0` (Choices: 0: `Auto`, 1: `Manual`) |
| `channelFilter` | Int | `0` |
| `tuning` | Double | `440.0` |
| `bias` | Double | `0.5` |
| `filter` | Double | `0.1` |
| `correction` | Double | `1.0` |
| `offset` | Double | `0.0` |
| `bendRange` | Double | `2.0` |
| `fastMode` | Bool | `false` |
| `noteC` | Bool | `true` |
| `noteCSharp` | Bool | `true` |
| `noteD` | Bool | `true` |
| `noteDSharp` | Bool | `true` |
| `noteE` | Bool | `true` |
| `noteF` | Bool | `true` |
| `noteFSharp` | Bool | `true` |
| `noteG` | Bool | `true` |
| `noteGSharp` | Bool | `true` |
| `noteA` | Bool | `true` |
| `noteASharp` | Bool | `true` |
| `noteB` | Bool | `true` |

Full docs: https://wwmm.github.io/easyeffects/plugins/autotune.html


---
