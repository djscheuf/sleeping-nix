# Spatial & Time-Based Plugins

Plugins that use convolution, delay, or stereo-field manipulation to alter perceived space and timing.

## Convolver

The Convolver creates a simulation of an audio environment using a pre-recorded audio sample of the impulse response of the space being modeled. This feature is based on the "convolution": a process through which the sonic characteristics of one signal are used to alter the character of another.
Easy Effects Convolver offers the opportunity to apply multiple impulse responses by combining them in one file.
**Impulses**

Manage impulse response files. This menu allows to load a specific impulse or add/remove files from the Easy Effects configuration directory.
**Combine**

Select two impulse responses to combine into a single file to be saved under the Easy Effects configuration directory.
**Stereo Width**

Modify the impulse response stereo image width.
**Spectrum**

Visualize the frequency spectrum of the selected channel.

### References

- Wikipedia Reverb Effect (https://en.wikipedia.org/wiki/Reverb_effect)
- Indiana University - Convolution: A Form of Cross-Synthesis (https://cmtext.indiana.edu/synthesis/chapter4_convolution.php)
- Designing Sound - Recording Impulse Responses (https://designingsound.org/2012/12/29/recording-impulse-responses/)

**Configurable properties (plugin ID `convolver`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `kernelName` | String | `""` |
| `irWidth` | Int | `100` |
| `autogain` | Bool | `true` |
| `dry` | Double | `-100` |
| `wet` | Double | `0` |
| `targetSofaAzimuth` | Double | `0` |
| `targetSofaElevation` | Double | `0` |
| `targetSofaRadius` | Double | `1.0` |

Full docs: https://wwmm.github.io/easyeffects/plugins/convolver.html


---

## Crossfeed

Easy Effects uses the Crossfeed by bs2b. This plugin is used to improve headphone listening of stereo audio records. It does so by mixing the left and right channel in a way that simulates a stereo speaker setup while using headphones.
**Cutoff**

Low-Pass filter cutoff frequency.
**Feed**

Amount of signal from a channel that is sent to the other.
**Presets**

- **Default** - Closest to virtual speaker placement (30°, 3 meters).
- **Cmoy** - Close to Chu Moy's Crossfeed (popular).
- **Jmeier** - Close to Jan Meier's CORDA amplifiers (little change).

### References

- Wikipedia Crossfeed (https://en.wikipedia.org/wiki/Crossfeed)
- Bauer Stereophonic-to-Binaural DSP. (http://bs2b.sourceforge.net/)

**Configurable properties (plugin ID `crossfeed`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `fcut` | Int | `700` |
| `feed` | Double | `4.5` |

Full docs: https://wwmm.github.io/easyeffects/plugins/crossfeed.html


---

## Crosstalk Canceller

When audio is played by a stereo speaker audio from both channels arrive to the listener ears. As the superposition
of each channel audio will happen with a delay that depends on the distance between the listener ear and the speakers
undesirable effects can happen. That superposition is called crosstalk in this context and can be attenuated by this
plugin.

**Configurable properties (plugin ID `crosstalk_canceller`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `phantomCenterOnly` | Bool | `false` |
| `delayUs` | Double | `313` |
| `decayDb` | Double | `-2` |

Full docs: https://wwmm.github.io/easyeffects/plugins/crosstalkcanceller.html


---

## Delay

This plugin allows the user to add a short Delay of time to each individual channel of the stereo stream. Easy Effects Delay uses the Delay Compensator Stereo by Linux Studio Plugins set in time mode.
**Left Delay**

Left channel delay in milliseconds.
**Right Delay**

Right channel delay in milliseconds.
**Left Dry Level**

Amount of right unprocessed signal mixed in the output.
**Right Dry Level**

Amount of right unprocessed signal mixed in the output.
**Left Wet Level**

Amount of left processed signal mixed in the output.
**Right Wet Level**

Amount of right processed signal mixed in the output.

### References

- Wikipedia Delay (audio effect) (https://en.wikipedia.org/wiki/Delay_(audio_effect))
- LSP Delay Compensator Stereo (http://lsp-plug.in/?page=manuals&section=comp_delay_x2_stereo)

**Configurable properties (plugin ID `delay`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dryL` | Double | `-80.01` |
| `dryR` | Double | `-80.01` |
| `wetL` | Double | `0` |
| `wetR` | Double | `0` |
| `modeL` | Enum | `2` (Choices: 0: `Samples`, 1: `Distance`, 2: `Time`) |
| `modeR` | Enum | `2` (Choices: 0: `Samples`, 1: `Distance`, 2: `Time`) |
| `timeL` | Double | `0` |
| `timeR` | Double | `0` |
| `invertPhaseL` | Bool | `false` |
| `invertPhaseR` | Bool | `false` |
| `sampleL` | Double | `0` |
| `sampleR` | Double | `0` |
| `metersL` | Double | `0` |
| `metersR` | Double | `0` |
| `centimetersL` | Double | `0` |
| `centimetersR` | Double | `0` |
| `temperatureL` | Double | `20` |
| `temperatureR` | Double | `20` |

Full docs: https://wwmm.github.io/easyeffects/plugins/delay.html


---

## Reverberation

Reverberation is the phenomenon of persistence of sound after the source has been stopped as a result of multiple reflections of the waves over objects within a closed surface. These reflections build up with each other and decay gradually as they are absorbed by the surfaces of objects in the space enclosed.
The Reverberation is different than Echo because the Echo is a reflected sound wave with sufficient magnitude and delay to be detectable as a signal distinct from the source one. To simulate the Reverberation effect, Easy Effects uses the Reverb plugin developed by Calf Studio Gear.
**High Frequency Damping**

Cutoff frequency of the reflections. It causes higher frequencies to decay faster.
**Room Size**

Size of the space where simulated Reverberation occurs inside. It determines the time between reflections.
**Diffusion**

Degree of uniformity. Higher values lead to less uniform Reverberation.
**Pre Delay**

Additional delay. It corresponds to a distance between sound source and the nearest wall.
**Decay Time**

The time it takes for Reverberation to fade out.
**Dry Level**

Amount of unprocessed signal mixed in the output.
**Wet Level**

Amount of processed signal (Reverberation) mixed in the output.
**Bass Cut**

Removes low frequencies from the Reverberation.
**Treble Cut**

Removes high frequencies from the Reverberation.

### References

- Wikipedia Reverberation (https://en.wikipedia.org/wiki/Reverberation)
- Calf Reverb (https://calf-studio-gear.org/doc/Reverb.html)

**Configurable properties (plugin ID `reverb`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `roomSize` | Enum | `2` (Choices: 0: `Small`, 1: `Medium`, 2: `Large`, 3: `Tunnel-like`, 4: `Large/smooth`, 5: `Experimental`) |
| `decayTime` | Double | `1.5` |
| `hfDamp` | Double | `5000` |
| `diffusion` | Double | `0.5` |
| `amount` | Double | `-12` |
| `dry` | Double | `0` |
| `predelay` | Double | `0` |
| `bassCut` | Double | `300` |
| `trebleCut` | Double | `5000` |

Full docs: https://wwmm.github.io/easyeffects/plugins/reverb.html


---
