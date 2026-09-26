# Dynamics & Gain Plugins

Compressors, gates, limiters, and other plugins that control dynamic range and loudness.

## Auto Gain

Easy Effects Autogain is based on the library libebur128 which implements the EBU R 128 standard for loudness normalization. It changes the audio volume to a perceived loudness target that can be customized by the user.
**Target**

Loudness level.
**Silence**

Silence threshold. While the momentary loudness is below this value the autogain won't make any changes to the current gain being applied to the signal level.
**Maximum History**

Range of time taken into account for the calculation of loudness level and output gain.
**Reference**

The parameter used as reference to evaluate the output gain.

- **Momentary** - Measures the loudness of the past 400 milliseconds.
- **Short-Term** - Measures the loudness of the past 3 seconds.
- **Integrated** - Ideally it indicates how loud the content is on average. It measures the loudness on a long range of time, depending on the value set as Maximum History.
- **Geometric Mean** - Uses the geometric mean of all the above mentioned parameters, or two of them at user choosing.

**Reset History**

Resets the Autogain history related to chosen Reference.
**Monitor Parameters**

Autogain values shown as stats.

- **Relative** - Used to detect silence. Whenever the Momentary term is below a predetermined threshold, modifications to the output gain will be disabled.
- **Loudness** - The difference between its value and the target loudness determines the output gain.
- **Range** - Indicates how large is the dynamic range of the content played.
- **Output Gain** - The input signal is adjusted by this correction gain to bring its loudness to the target value.

### References

- Wikipedia EBU R 128 (https://en.wikipedia.org/wiki/EBU_R_128)
- EBU - Loudness Normalisation and Permitted Maximum Level of Audio Signals (https://tech.ebu.ch/publications/r128/)

**Configurable properties (plugin ID `autogain`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `target` | Double | `-23` |
| `reference` | Enum | `3` (Choices: 0: `Momentary`, 1: `Shortterm`, 2: `Integrated`, 3: `Geometric Mean (MSI)`, 4: `Geometric Mean (MS)`, 5: `Geometric Mean (MI)`, 6: `Geometric Mean (SI)`) |
| `maximumHistory` | Int | `15` |
| `silenceThreshold` | Double | `-70` |
| `forceSilence` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/autogain.html


---

## Compressor

A Compressor is used to reduce the dynamic range or, in other words, the difference in level between the quietest and the loudest parts of an audio signal. It achieves this purpose altering the gain when the signal overtakes a predetermined Threshold. Easy Effects uses the Stereo Sidechain Compressor from Linux Studio Plugins.

### Compressor Options

**Attack Time**

The length of time it takes to apply roughly two-thirds of the targeted amount of compression ratio to the uncompressed signal.
**Release Time**

The length of time it takes to restore roughly two-thirds of the reduced gain (in Downward mode) or increased gain (in Upward/Boosting mode) to the compressed signal.
**Attack Threshold**

The target level around which the compression is applied (the range depends by the Knee).
**Release Threshold**

Sets up the Threshold of the Release Time, calculated by summing the Release Threshold to the Attack Threshold.
If the Sidechain level is above that Threshold, the compressor uses the Release Time for the releasing stage. Otherwise the Attack Time is used in place of Release Time.
For example, with -10 dB Attack Threshold and -60 dB Release Threshold, if the Sidechain is above `-10 + (-60) = -70 dB`, the Release Time is used for the gain restoration. If the Sidechain is below -70 dB, the Attack Time is used for the gain restoration.
**Ratio**

The amount of attenuation (in Downward mode) or amplification (in Upward/Boosting mode) that will be applied to the signal.
For example, when the Ratio is 2 in Downward mode and the Sidechain rises above the Threshold by 10 dB, the signal would be ideally reduced by 5 dB (10/2 dB). In practice this behavior mostly depends on how the Compressor is designed and configured.
**Knee**

The range over which the Compressor switches from no compression to almost the full ratio compression (the Threshold usually sits at the center of this transition zone).
**Makeup**

The gain to apply after the compression stage.
**Dry Level**

Amount of unprocessed signal mixed in the output.
**Wet Level**

Amount of processed signal mixed in the output.
**Mode**

- **Downward** - It's aimed to decrease the gain of the signal above the Threshold.
- **Upward** - It's aimed to increase the gain of the signal below the Threshold.
- **Boosting** - It's aimed to increase the gain of the signal below the Threshold by a specific amount.
**Boost Threshold**

The Threshold below which a constant amplification will be applied to the input signal in Upward Mode (it prevents from applying infinite amplification to very quiet signals).
**Boost Amount**

Maximum gain amplification to apply in Boosting Mode.

### Sidechain

**Listen**

Allows to listen the processed Sidechain signal.
**Input Type**

Determines which signal is the Sidechain or, in other words, the signal that controls the compression stage.

- **Feed-forward** - The Sidechain is the Compressor input signal (taken after applying the plugin input gain). More aggressive compression.
- **Feed-back** - The Sidechain is the Compressor output signal (taken before applying the Makeup and the plugin output gain). Vintage-style compression.
- **External** - The Sidechain is an external source took by a specific input device (typically a microphone).

**Input Device**

Select the device for the External Sidechain.
**Mode**

Determines how the Sidechain is evaluated for the compression stage.

- **Peak** - The Compressor reacts according to the peaks.
- **RMS** - The Compressor reacts according to the average loudness measured by the root mean square.
- **Low-Pass** - The Compressor reacts according to the signal processed by a Low-Pass filter.
- **Uniform** - The Compressor reacts according to the loudness measured by the average of the absolute amplitude.

**Source**

Determines which part of the Sidechain is taken into account for the compression stage.

- **Middle** - The sum of left and right channels.
- **Side** - The difference between left and right channels.
- **Left** - Only left channel is used.
- **Right** - Only right channel is used.
- **Min** - The absolute minimum value is taken from stereo input.
- **Max** - The absolute maximum value is taken from stereo input.

**PreAmplification**

Gain applied to the Sidechain signal.
**Reactivity**

The time that defines the number of samples used to process the Sidechain in RMS, Uniform and Low-Pass modes. Higher the value, more smooth the compression.
**Lookahead**

The signal to compress is delayed by this amount of time, so that the compression will be applied earlier than it would be otherwise. The corresponding delay is reproduced on the output signal.

### Sidechain Filters

**High-Pass Filter Mode**

Sets the type of the High-Pass filter applied to Sidechain signal.
**High-Pass Frequency**

Sets the cut-off frequency of the High-Pass filter.
**Low-Pass Filter Mode**

Sets the type of the Low-Pass filter applied to Sidechain signal.
**Low-Pass Frequency**

Sets the cut-off frequency of the Low-Pass filter.

### References

- Wikipedia Dynamic Range Compression (https://en.wikipedia.org/wiki/Dynamic_range_compression)
- LSP Sidechain Compressor Stereo (https://lsp-plug.in/?page=manuals&section=sc_compressor_stereo)
- Black Ghost Audio - The Ultimate Guide to Compression (https://www.blackghostaudio.com/blog/the-ultimate-guide-to-compression)
- Attack Magazine - Demolishing The Myths of Compression (https://www.attackmagazine.com/features/columns/gregory-scott-demolishing-the-myths-of-compression/)

**Configurable properties (plugin ID `compressor`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dry` | Double | `-80.01` |
| `wet` | Double | `0` |
| `mode` | Enum | `0` (Choices: 0: `Downward`, 1: `Upward`, 2: `Boosting`) |
| `attack` | Double | `20` |
| `release` | Double | `100` |
| `releaseThreshold` | Double | `-80.01` |
| `threshold` | Double | `-12` |
| `ratio` | Double | `4` |
| `knee` | Double | `-6` |
| `makeup` | Double | `0` |
| `boostAmount` | Double | `6` |
| `boostThreshold` | Double | `-72` |
| `sidechainListen` | Bool | `false` |
| `sidechainType` | Enum | `0` (Choices: 0: `Feed-forward`, 1: `Feed-back`, 2: `External`, 3: `Link`) |
| `sidechainMode` | Enum | `0` (Choices: 0: `Peak`, 1: `RMS`, 2: `Low-Pass`, 3: `SMA`) |
| `stereoSplit` | Bool | `false` |
| `sidechainSource` | Enum | `0` (Choices: 0: `Middle`, 1: `Side`, 2: `Left`, 3: `Right`, 4: `Min`, 5: `Max`) |
| `stereoSplitSource` | Enum | `0` (Choices: 0: `Left/Right`, 1: `Right/Left`, 2: `Mid/Side`, 3: `Side/Mid`, 4: `Min`, 5: `Max`) |
| `sidechainPreamp` | Double | `0` |
| `sidechainReactivity` | Double | `10` |
| `sidechainLookahead` | Double | `0` |
| `hpfMode` | Enum | `0` (Choices: 0: `Off`, 1: `12 dB/oct`, 2: `24 dB/oct`, 3: `36 dB/oct`) |
| `hpfFrequency` | Double | `10` |
| `lpfMode` | Enum | `0` (Choices: 0: `Off`, 1: `12 dB/oct`, 2: `24 dB/oct`, 3: `36 dB/oct`) |
| `lpfFrequency` | Double | `20000` |
| `sidechainInputDevice` | String | `*calculated*` |
| `inputToSidechain` | Double | `-80.01` |
| `inputToLink` | Double | `-80.01` |
| `sidechainToInput` | Double | `-80.01` |
| `sidechainToLink` | Double | `-80.01` |
| `linkToSidechain` | Double | `-80.01` |
| `linkToInput` | Double | `-80.01` |

Full docs: https://wwmm.github.io/easyeffects/plugins/compressor.html


---

## Expander

An expander is an effect that works inversely to a compressor, further reducing the volume of quiet sounds below a certain level. This allows for natural suppression of background noise and unwanted whispers. For example, it is effective when air conditioning or other environmental sounds intrude into quiet scenes.
This effect is similar to the gate, which is explained in another chapter, in that it blocks quiet sounds. However, while a gate completely cuts sound, an expander gradually reduces sound, resulting in a more natural and smooth decay characteristic. Its main uses are listed below:

- Reduce the prominence of quiet environmental noises (air conditioning, PC fans, clicks, etc.) during periods of silence
- Suppress noise in quiet sections while maintaining the clarity of narration and dialogue
- Emphasize the contours (punch) of sounds to create a more dynamic impression

### Expander Options

The following is an explanation of each parameter when the mode is set to "**Downward**."
**Attack Time**: This determines the time it takes for the expander to begin suppressing the sound after the sound volume drops below the threshold. Shorter values will reduce the volume immediately, quickly suppressing noise and other imperfections. Longer values will cause the processing to begin later, preserving the natural reverberation and nuances of soft sounds.
**Release Time**: This determines the time it takes for the expander to stop suppressing the volume and return to its original volume after the sound exceeds the threshold again and is determined to no longer require processing.
Longer values will cause the sound to return more slowly, making it sound more natural.
Shorter values will return the sound to its original volume quickly, making it sound clearer and tighter, but may sound unnatural in some cases.
**Attack Threshold**: The effect is only applied to sounds quieter than this value.
**Release Threshold**: This can be the same as the Attack Threshold, but setting it about -5dB lower than the Attack Threshold will enable the Hysteresis function, suppressing fluttering around the threshold and achieving more stable processing.
**Ratio**: This is an indicator of how much quieter (= how much) sounds below the threshold will be reduced. Set the value using the following as a guide:

- A setting of 1 passes the signal as is (same as Expander OFF)
- For light noise suppression (natural processing), use 1.5-3
- For clarity of dialogue and smoothing out quiet sections, use 4-8
- For complete noise reduction (gate-like behavior), use 20-100

*Please note that setting the ratio too high can result in a choppy, unnatural sound.
**Knee**: This parameter adjusts how smoothly processing begins near the threshold. The name comes from the fact that the curve on the graph resembles a knee. See below for the relationship between the setting value and the curve.
Knee Value Volume Curve Characteristics Processing Sensation
0dB Abrupt bend (hard knee) The effect is applied suddenly (like an ON/OFF switch)
-6dB Gradual bend Processing begins naturally
-12dB and above Very smooth Processing is barely noticeable
**Makeup**: The gain applied after gating.
**Dry Level**: The amount of unprocessed signal mixed with the output.
**Wet Level**: The amount of processed signal mixed with the output.
For information on how to set up sidechaining and sidechain filtering, see the chapter of Gate.
*When "**Upward**" is selected in the mode setting, the expander will function to boost (increase the volume of) quieter sounds.
This can be used in situations where dialogue or narration is too quiet to be heard, and is also effective when you want to bring out the subtle nuances of a musical performance (such as pianissimo).
Rather than "lowering louder sounds" like a compressor, it is used to increase the average volume by "boosting quieter sounds," or to increase sound pressure while maintaining the punch and three-dimensionality of the original sound.

**Configurable properties (plugin ID `expander`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dry` | Double | `-80.01` |
| `wet` | Double | `0` |
| `mode` | Enum | `1` (Choices: 0: `Downward`, 1: `Upward`) |
| `attack` | Double | `20` |
| `release` | Double | `100` |
| `releaseThreshold` | Double | `-80.01` |
| `threshold` | Double | `-12` |
| `ratio` | Double | `4` |
| `knee` | Double | `-6` |
| `makeup` | Double | `0` |
| `sidechainListen` | Bool | `false` |
| `sidechainType` | Enum | `0` (Choices: 0: `Internal`, 1: `External`, 2: `Link`) |
| `sidechainMode` | Enum | `0` (Choices: 0: `Peak`, 1: `RMS`, 2: `Low-Pass`, 3: `SMA`) |
| `stereoSplit` | Bool | `false` |
| `sidechainSource` | Enum | `0` (Choices: 0: `Middle`, 1: `Side`, 2: `Left`, 3: `Right`, 4: `Min`, 5: `Max`) |
| `stereoSplitSource` | Enum | `0` (Choices: 0: `Left/Right`, 1: `Right/Left`, 2: `Mid/Side`, 3: `Side/Mid`, 4: `Min`, 5: `Max`) |
| `sidechainPreamp` | Double | `0` |
| `sidechainReactivity` | Double | `10` |
| `sidechainLookahead` | Double | `0` |
| `hpfMode` | Enum | `0` (Choices: 0: `Off`, 1: `12 dB/oct`, 2: `24 dB/oct`, 3: `36 dB/oct`) |
| `hpfFrequency` | Double | `10` |
| `lpfMode` | Enum | `0` (Choices: 0: `Off`, 1: `12 dB/oct`, 2: `24 dB/oct`, 3: `36 dB/oct`) |
| `lpfFrequency` | Double | `20000` |
| `sidechainInputDevice` | String | `*calculated*` |
| `inputToSidechain` | Double | `-80.01` |
| `inputToLink` | Double | `-80.01` |
| `sidechainToInput` | Double | `-80.01` |
| `sidechainToLink` | Double | `-80.01` |
| `linkToSidechain` | Double | `-80.01` |
| `linkToInput` | Double | `-80.01` |

Full docs: https://wwmm.github.io/easyeffects/plugins/expander.html


---

## Gate

The Gate attenuates signals that register below a Threshold. This kind of signal processing is used to reduce disturbing noise between useful signals. Easy Effects uses the Stereo Sidechain Gate from Linux Studio Plugins.

### Gate Workflow

The Gate begins to open when the Sidechain level becomes above the Attack Zone Start level.
The Gate fully opens when the Sidechain level becomes above the Attack Threshold level.
The Gate begins to close when the Sidechain level becomes below the Release Zone Start level.
The Gate fully closes when the Sidechain level becomes below the Release Threshold level.

### Gate Options

**Attack Time**

The length of time it takes to restore roughly two-thirds of the gain reduction.
**Release Time**

The length of time it takes to apply roughly two-thirds of the gain reduction.
**Curve Threshold**

The Gate fully opens upon the Sidechain level becoming above Curve Threshold (displayed as Attack Threshold level).
If Hysteresis is not enabled, the Gate begins to close upon the Sidechain level becoming below Curve Threshold (displayed as Release Zone Start level).
**Curve Zone Size**

The Gate begins to open upon the Sidechain level becoming above the Curve Threshold + Curve Zone (displayed as Attack Zone Start level).
If Hysteresis is not enabled, the Gate fully closes upon the Sidechain level becoming below the Curve Threshold + Curve Zone (displayed as Release Threshold level).
**Hysteresis**

When enabled, Curve Threshold and Curve Zone apply only to the opening Gate, and separate parameters can be configured for closing Gate.
**Hysteresis Threshold**

If Hysteresis is enabled, the Gate begins to close upon the Sidechain level becoming below Curve Threshold + Hysteresis Threshold (displayed as Release Zone Start level).
**Hysteresis Zone Size**

If Hysteresis is enabled, the Gate fully closes upon the Sidechain level becoming below the Curve Threshold + Hysteresis Threshold + Hysteresis Zone (displayed as Release Threshold level).
**Dry Level**

Amount of unprocessed signal mixed in the output.
**Wet Level**

Amount of processed signal mixed in the output.
**Reduction**

If the value is negative, it acts as the amount of gain reduction to apply to the input signal when the Gate is fully closed. If the value is positive, the Gate operates in "Reverse Mode": It reduces the amplitude when the signal is above the threshold.
**Makeup**

The gain to apply after the gating stage.

### Sidechain

**Listen**

Allows to listen the processed Sidechain signal.
**Input Type**

Determines which signal is the Sidechain or, in other words, the signal that controls the gating stage.

- **Internal** - The Sidechain is the Gate input signal (taken after applying the plugin input gain).
- **External** - The Sidechain is an external source took by a specific input device (typically a microphone).

**Input Device**

Select the device for the External Sidechain.
**Mode**

Determines how the Sidechain is evaluated for the gating stage.

- **Peak** - The Gate reacts according to the peaks.
- **RMS** - The Gate reacts according to the average loudness measured by the root mean square.
- **Low-Pass Filter** - The Gate reacts according to the signal processed by a recursive 1-pole Low-Pass filter.
- **Simple Moving Average** - The Gate reacts according to the signal processed by the Simple Moving Average filter.

**Source**

Determines which part of the Sidechain is taken into account for the gating stage.

- **Middle** - The sum of left and right channels.
- **Side** - The difference between left and right channels.
- **Left** - Only left channel is used.
- **Right** - Only right channel is used.
- **Min** - The absolute minimum value is taken from stereo input.
- **Max** - The absolute maximum value is taken from stereo input.

**PreAmplification**

Gain applied to the Sidechain signal.
**Reactivity**

The time that defines the number of samples used to process the Sidechain in RMS, Uniform and Low-Pass modes. Higher the value, more smooth the gating.
**Lookahead**

The signal to gate is delayed by this amount of time, so that the gating will be applied earlier than it would be otherwise. The corresponding delay is reproduced on the output signal.

### Sidechain Filters

**High-Pass Filter Mode**

Sets the type of the High-Pass filter applied to Sidechain signal.
**High-Pass Frequency**

Sets the cut-off frequency of the High-Pass filter.
**Low-Pass Filter Mode**

Sets the type of the Low-Pass filter applied to Sidechain signal.
**Low-Pass Frequency**

Sets the cut-off frequency of the Low-Pass filter.

### References

- Wikipedia Dynamic Range Compression (https://en.wikipedia.org/wiki/Dynamic_range_compression)
- LSP Sidechain Gate Stereo (https://lsp-plug.in/?page=manuals&section=sc_gate_stereo)
- Wikipedia Noise Gate (https://en.wikipedia.org/wiki/Noise_gate)

**Configurable properties (plugin ID `gate`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dry` | Double | `-80.01` |
| `wet` | Double | `0` |
| `mode` | Enum | `0` (Choices: 0: `Downward`, 1: `Upward`, 2: `Boosting`) |
| `attack` | Double | `20` |
| `release` | Double | `100` |
| `curveThreshold` | Double | `-24` |
| `curveZone` | Double | `-6` |
| `hysteresis` | Bool | `false` |
| `hysteresisThreshold` | Double | `-12` |
| `hysteresisZone` | Double | `-6` |
| `reduction` | Double | `-24` |
| `makeup` | Double | `0` |
| `sidechainListen` | Bool | `false` |
| `sidechainType` | Enum | `0` (Choices: 0: `Internal`, 1: `External`, 2: `Link`) |
| `sidechainMode` | Enum | `0` (Choices: 0: `Peak`, 1: `RMS`, 2: `Low-Pass`, 3: `SMA`) |
| `stereoSplit` | Bool | `false` |
| `sidechainSource` | Enum | `0` (Choices: 0: `Middle`, 1: `Side`, 2: `Left`, 3: `Right`, 4: `Min`, 5: `Max`) |
| `stereoSplitSource` | Enum | `0` (Choices: 0: `Left/Right`, 1: `Right/Left`, 2: `Mid/Side`, 3: `Side/Mid`, 4: `Min`, 5: `Max`) |
| `sidechainPreamp` | Double | `0` |
| `sidechainReactivity` | Double | `10` |
| `sidechainLookahead` | Double | `0` |
| `hpfMode` | Enum | `0` (Choices: 0: `Off`, 1: `12 dB/oct`, 2: `24 dB/oct`, 3: `36 dB/oct`) |
| `hpfFrequency` | Double | `10` |
| `lpfMode` | Enum | `0` (Choices: 0: `Off`, 1: `12 dB/oct`, 2: `24 dB/oct`, 3: `36 dB/oct`) |
| `lpfFrequency` | Double | `20000` |
| `sidechainInputDevice` | String | `*calculated*` |
| `inputToSidechain` | Double | `-80.01` |
| `inputToLink` | Double | `-80.01` |
| `sidechainToInput` | Double | `-80.01` |
| `sidechainToLink` | Double | `-80.01` |
| `linkToSidechain` | Double | `-80.01` |
| `linkToInput` | Double | `-80.01` |

Full docs: https://wwmm.github.io/easyeffects/plugins/gate.html


---

## Limiter

A Limiter is a special type of downward Compressor (compressor.html) which does not allow the signal to overtake a predetermined Threshold. Ideally it has a very high compression ratio that takes the amplitude below a ceiling which stands as the maximum output level. For this reason it is usually named "brick-wall limiter".
Easy Effects uses the Sidechain Stereo Limiter from Linux Studio Plugins. In most cases it works as a brick-wall limiter, but it offers also an additional feature that acts like a Compressor with extreme settings, so the output signal may exceed the specified Threshold.
**Mode**

Select the operative mode of the peak cutting algorithm which searches the peaks above the Threshold and applies short gain reduction patches to the signal.
These patches can be selected in 3 forms: **Hermite**, **Exponential** and **Linear**. Each one has 4 different variants related to gain reduction of the samples around the peak: **Thin**, **Tail**, **Duck** and **Wide**.
The shape of each form and variant can be referred into the Linux Studio Plugin manual. See References section at the bottom of the present document.
**Oversampling**

When enabled, the sample rate is internally increased in order to improve peak detection and reduce aliasing (that causes distortion).
The modes have 2 main types: **Full**, which increases both the Sidechain and the Input signals, and **Half** which increases only the Sidechain. Each one of them specifies different **multipliers** and, between parentheses, the number of "**lobes** in the kernel".
The oversampled Input signal is downsampled to the original sample rate after processing.
**Dither**

If specified, it enables Dithering for the selected bit depth. The process of Dithering adds a low-level noise to output signal in order to mask "quantization distortion", a form of artifact present in digital audio rendered at lower bit depth.
**SC PreAmp**

The gain applied to the Sidechain before it is processed.
**Lookahead**

The size of the buffer used to detect the peaks in advance. It adds the corresponding latency to the output signal.
**Attack**

The length of time it takes to apply the needed gain reduction to keep the peak below the Threshold.
It affects the length of the gain reduction patch. It cannot be larger than the Lookahead (if specified larger, it's set internally as the max possible value).
**Release**

The length of time it takes to restore the reduced gain around the limited peak.
It affects the length of the gain reduction patch. It cannot be twice larger than the Lookahead (if specified larger, it's set internally as the max possible value).
**Threshold**

The target level above which the Limiter should reduce the peak of the signal. In some modes it represents the maximum output level.
**Threshold Boost**

If enabled it applies an amount of gain to the limited signal equal to the absolute value of the Threshold. This causes the peak limited at the Threshold level to output at 0 dB (it has only effect when the Threshold is set below 0 dB).
**Stereo Link**

The degree of the channel linking. At 0% both channels are limited independently while at 100% the loudest one triggers the same gain reduction on both.
**External Sidechain**

Switch the Sidechain to an external source took by a specific input device (typically a microphone).

### Auto Leveling

The Auto Leveling checkbutton introduces an additional feature named "Automated Level Regulation" (ALR) which acts like a Compressor with infinite ratio for the purpose of applying a smoothed gain reduction rather than a stronger peak cutter like in brick-wall mode. This configuration could get the output level to exceed the Threshold even if the signal is highly compressed.
**Attack**

Manage how the raise of the input signal affects the smoothness of the ALR curve that controls the gain reduction level. Higher the value, more quickly the curve goes to it's maximum.
**Release**

Manage how the fall of the input signal affects the smoothness of the curve that controls the gain reduction level. Higher the value, more quickly the curve goes to it's minimum.
**Knee**

Manage the Threshold of the ALR gain curve and, in fact, adjust the balance between two gain reduction stages. Raising the value delegates more work to the peak-cutting algorithm. Lowering the value delegates more work to the ALR gain reduction algorithm.

### References

- Wikipedia Limiter (https://en.wikipedia.org/wiki/Limiter)
- LSP Sidechain Limiter Stereo (https://lsp-plug.in/?page=manuals&section=sc_limiter_stereo)

**Configurable properties (plugin ID `limiter`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `mode` | Enum | `0` (Choices: 0: `Herm Thin`, 1: `Herm Wide`, 2: `Herm Tail`, 3: `Herm Duck`, 4: `Exp Thin`, 5: `Exp Wide`, 6: `Exp Tail`, 7: `Exp Duck`, 8: `Line Thin`, 9: `Line Wide`, 10: `Line Tail`, 11: `Line Duck`) |
| `oversampling` | Enum | `0` (Choices: 0: `None`, 1: `Half x2/16 bit`, 2: `Half x2/24 bit`, 3: `Half x3/16 bit`, 4: `Half x3/24 bit`, 5: `Half x4/16 bit`, 6: `Half x4/24 bit`, 7: `Half x6/16 bit`, 8: `Half x6/24 bit`, 9: `Half x8/16 bit`, 10: `Half x8/24 bit`, 11: `Full x2/16 bit`, 12: `Full x2/24 bit`, 13: `Full x3/16 bit`, 14: `Full x3/24 bit`, 15: `Full x4/16 bit`, 16: `Full x4/24 bit`, 17: `Full x6/16 bit`, 18: `Full x6/24 bit`, 19: `Full x8/16 bit`, 20: `Full x8/24 bit`, 21: `True Peak/16 bit`, 22: `True Peak/24 bit`) |
| `dithering` | Enum | `0` (Choices: 0: `None`, 1: `7bit`, 2: `8bit`, 3: `11bit`, 4: `12bit`, 5: `15bit`, 6: `16bit`, 7: `23bit`, 8: `24bit`) |
| `sidechainType` | Enum | `0` (Choices: 0: `Internal`, 1: `External`, 2: `Link`) |
| `lookahead` | Double | `5` |
| `attack` | Double | `5` |
| `release` | Double | `5` |
| `threshold` | Double | `0` |
| `gainBoost` | Bool | `true` |
| `sidechainPreamp` | Double | `0` |
| `stereoLink` | Double | `100` |
| `alr` | Bool | `false` |
| `alrAttack` | Double | `5` |
| `alrRelease` | Double | `50` |
| `alrKnee` | Double | `0` |
| `alrKneeSmooth` | Double | `-5` |
| `sidechainInputDevice` | String | `*calculated*` |
| `inputToSidechain` | Double | `-80.01` |
| `inputToLink` | Double | `-80.01` |
| `sidechainToInput` | Double | `-80.01` |
| `sidechainToLink` | Double | `-80.01` |
| `linkToSidechain` | Double | `-80.01` |
| `linkToInput` | Double | `-80.01` |

Full docs: https://wwmm.github.io/easyeffects/plugins/limiter.html


---

## Maximizer

The Maximizer is a special type of Limiter (limiter.html) that does not only prevent the signal to exceed a specified target level, but also adjusts the average Loudness of the audio track.
Easy Effects uses the Maximizer developed by ZamAudio. It acts like an Amplifier that feeds a brick-wall Limiter with a fixed Lookahead of 10 ms adding the corresponding delay to the output signal.
**Threshold**

This parameter represents the ideal amplification level needed by the signal.
It contributes along with the Ceiling to determine the amount of gain to apply to the signal before the limiting stage. The gain is calculated by `(-Threshold) - (-Ceiling)`.
For example, on Threshold -6 dB and Ceiling -2 dB, the signal is amplified by 4 dB and limited to not exceed -2 dB output level.
**Ceiling**

This parameter represents the ideal attenuation level needed by the signal and the maximum allowed output level.
When the Threshold is set to 0 dB, the Ceiling is simply the gain reduction. When the Threshold is lowered, the signal is boosted without overtaking the Ceiling value.
**Release**

Sets the release of the internal brick-wall Limiter. Lower values may introduce small artifacts.

### References

- Sonarworks Blog - What Is A Maximizer? (https://www.sonarworks.com/soundid-reference/blog/learn/what-is-a-maximizer/)

**Configurable properties (plugin ID `maximizer`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `release` | Double | `25` |
| `threshold` | Double | `0` |

Full docs: https://wwmm.github.io/easyeffects/plugins/maximizer.html


---

## Multiband Compressor

Easy Effects uses the Sidechain Multiband Compressor Stereo developed by Linux Studio Plugins. Please refer to the Compressor (compressor.html) documentation to comprehend the basic functionality of the dynamic range compression.

### Global Options

**Band Management**

This Compressor allows to split the input signal up to 8 bands. Each band is not attached to its strict frequency and can be controlled by completely different frequency range that can be obtained by applying Low-Cut and Hi-Cut filters to the Sidechain signal.
The first band is always enabled while the others can be activated if needed. When only the first band is enabled, the functionality is similar to the Singleband Sidechain Compressor. Otherwise the signal is split in more bands and each band is compressed individually. After the compression stage, the bands are mixed together to form the output result.
**Operating Mode**

Determines how the input signal is split to obtain the different bands.

- **Classic** - The original signal is split using crossover filters. After the compression stage, all bands become phase-compensated using All-Pass filters.
- **Modern** - Each band is processed by a pair of dynamic shelving filters. This mode allows a better control over the gain of each band.

**Sidechain Boost**

If enabled, it introduces a special mode for assigning the same weight for higher frequencies opposite to lower frequencies.
When disabled, the frequency band is processed 'as is', but the usual audio signal has 3 dB/octave falloff in the frequency domain and could be compared with the pink noise. So lower frequencies take more effect on the Compressor rather than higher frequencies.
On the other hand the Sidechain Boost mode allows to compensate the -3 dB/octave falloff of the signal spectrum and, even more, makes the signal spectrum growing +3 dB/octave in the almost fully audible frequency range.
**Pink** applies +3 dB/octave while **Brown** applies +6 dB/octave Sidechain Boost. Each of them can use bilinear-transformed (BT) or matched-transformed (MT) shelving filter.
**Sidechain Source**

If the External Sidechain is enabled inside at least one band, this combobox allows to select the input device as source.
**Dry Level**

Amount of unprocessed signal mixed in the output.
**Wet Level**

Amount of processed signal mixed in the output.

### Band Options

**Band Start**

Allows to change the lower end split frequency of the selected band. This value is assigned to the Band End of the previous enabled band. It can be modified for all bands except the first one, which is always enabled and its value is 0 Hz.
**Band End**

Specify the upper end split frequency of the selected band. It cannot be directly modified and assumes the same value of the Band Start of the next enabled band. For the last enabled band it is always 24.000 Hz.
**Compression Mode**

- **Downward** - It's aimed to decrease the gain of the signal above the Threshold.
- **Upward** - It's aimed to increase the gain of the signal below the Threshold.
- **Boosting** - It's aimed to increase the gain of the signal below the Threshold by a specific amount.
**External Sidechain**

The Sidechain is an external source took by a specific input device (typically a microphone).
**Band Bypass**

If enabled, the selected band is not affected by the compression stage.
**Solo**

Turns on the Solo mode to the selected band by applying -36 dB gain to the other non-soloing bands.
**Mute**

Turns on the Mute mode applying -36 dB gain to to the selected band.
**Attack Time**

The length of time it takes to apply roughly two-thirds of the targeted amount of compression ratio to the uncompressed band signal.
**Release Time**

The length of time it takes to restore roughly two-thirds of the reduced gain (in Downward mode) or increased gain (in Upward/Boosting mode) to the compressed band signal.
**Attack Threshold**

The target level around which the compression is applied (the range depends by the Knee).
**Release Threshold**

Sets up the Threshold of the Release Time, calculated by summing the Release Threshold to the Attack Threshold.
If the Sidechain level is above that Threshold, the compressor uses the Release Time for the releasing stage. Otherwise the Attack Time is used in place of Release Time.
For example, with -10 dB Attack Threshold and -60 dB Release Threshold, if the Sidechain is above `-10 + (-60) = -70 dB`, the Release Time is used for the gain restoration. If the Sidechain is below -70 dB, the Attack Time is used for the gain restoration.
**Ratio**

The amount of attenuation (in Downward mode) or amplification (in Upward/Boosting mode) that will be applied to the signal.
For example, when the Ratio is 2 in Downward mode and the Sidechain rises above the Threshold by 10 dB, the signal would be ideally reduced by 5 dB (10/2 dB). In practice this behavior mostly depends on how the Multiband Compressor is designed and configured.
**Knee**

The range over which the Compressor switches from no compression to almost the full ratio compression (the Threshold usually sits at the center of this transition zone).
**Makeup**

The gain to apply after the compression stage.

### Band Sidechain Options

**Mode**

Determines how the Sidechain of the selected band is evaluated for the compression stage.

- **Peak** - The Compressor reacts according to the peaks.
- **RMS** - The Compressor reacts according to the average loudness measured by the root mean square.
- **Low-Pass** - The Compressor reacts according to the signal processed by a Low-Pass filter.
- **Uniform** - The Compressor reacts according to the loudness measured by the average of the absolute amplitude.

**Source**

Determines which part of the Sidechain is taken into account for the compression stage.

- **Middle** - The sum of left and right channels.
- **Side** - The difference between left and right channels.
- **Left** - Only left channel is used.
- **Right** - Only right channel is used.
- **Min** - The absolute minimum value is taken from stereo input.
- **Max** - The absolute maximum value is taken from stereo input.

**Low-Cut Filter**

Enables a custom Low-Cut Filter for the selected band.
**Low-Cut Frequency**

Sets the cut-off frequency of the custom Low-Cut filter. If it is disabled, the default Low-Cut filter assumes internally the Band Start frequency as the cut-off frequency.
**Hight-Cut Filter**

Enables a custom High-Cut Filter for the selected band.
**Hight-Cut Frequency**

Sets the cut-off frequency of the custom High-Cut filter. If it is disabled, the default High-Cut filter assumes internally the Band End frequency as the cut-off frequency.
**PreAmp**

Gain applied to the Sidechain signal of the selected band.
**Reactivity**

The time that defines the number of samples used to process the Sidechain in RMS, Uniform and Low-Pass modes. Higher the value, more smooth the compression.
**Lookahead**

The band signal to compress is delayed by this amount of time, so that the compression will be applied earlier than it would be otherwise.
Each band can have different Lookahead values. To avoid phase distortions in the mixing stage, all the bands are automatically delayed for an individually calculated period of time.
**Boost Amount**

Maximum gain amplification to apply in Boosting Mode.
**Boost Threshold**

The Threshold below which a constant amplification will be applied to the band signal in Upward Mode (it prevents from applying infinite amplification to very quiet signals).

### References

- Wikipedia Dynamic Range Compression (https://en.wikipedia.org/wiki/Dynamic_range_compression)
- LSP Sidechain Multiband Compressor Stereo (https://lsp-plug.in/?page=manuals&section=sc_mb_compressor_stereo)
- Black Ghost Audio - The Ultimate Guide to Compression (https://www.blackghostaudio.com/blog/the-ultimate-guide-to-compression)
- Attack Magazine - Demolishing The Myths of Compression (https://www.attackmagazine.com/features/columns/gregory-scott-demolishing-the-myths-of-compression/)

**Configurable properties (plugin ID `multiband_compressor`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dry` | Double | `-80.01` |
| `wet` | Double | `0` |
| `viewSidechain` | Bool | `false` |
| `externalSidechainEnabled` | Bool | `false` |
| `stereoSplit` | Bool | `false` |
| `compressorMode` | Enum | `1` (Choices: 0: `Classic`, 1: `Modern`, 2: `Linear Phase`) |
| `envelopeBoost` | Enum | `0` (Choices: 0: `None`, 1: `Pink BT`, 2: `Pink MT`, 3: `Brown BT`, 4: `Brown MT`) |
| `inputToSidechain` | Double | `-80.01` |
| `inputToLink` | Double | `-80.01` |
| `sidechainToInput` | Double | `-80.01` |
| `sidechainToLink` | Double | `-80.01` |
| `linkToSidechain` | Double | `-80.01` |
| `linkToInput` | Double | `-80.01` |
| `sidechainInputDevice` | String | `""` |

Each band N (0-7) also exposes `bandN<Suffix>` properties:

| Suffix (`bandN<Suffix>`) | Type | Default |
|---|---|---|
| `AttackThreshold` | Double | `-12` (all bands) |
| `AttackTime` | Double | `20` (all bands) |
| `BoostAmount` | Double | `6` (all bands) |
| `BoostThreshold` | Double | `-72` (all bands) |
| `CompressionMode` | Enum | `0` (Choices: 0: `Downward`, 1: `Upward`, 2: `Boosting`) (all bands) |
| `CompressorEnable` | Bool | `true` (all bands) |
| `Enable` | Bool | varies — N=1: `true`, N=2: `true`, N=3: `true`, N=4: `false`, N=5: `false`, N=6: `false`, N=7: `false` |
| `Knee` | Double | `-6` (all bands) |
| `Makeup` | Double | `0` (all bands) |
| `Mute` | Bool | `false` (all bands) |
| `Ratio` | Double | `1` (all bands) |
| `ReleaseThreshold` | Double | `-80.01` (all bands) |
| `ReleaseTime` | Double | `100` (all bands) |
| `SidechainCustomHighcutFilter` | Bool | `false` (all bands) |
| `SidechainCustomLowcutFilter` | Bool | `false` (all bands) |
| `SidechainHighcutFrequency` | Double | varies — N=0: `500`, N=1: `1000`, N=2: `2000`, N=3: `4000`, N=4: `8000`, N=5: `12000`, N=6: `16000`, N=7: `20000` |
| `SidechainLookahead` | Double | `0` (all bands) |
| `SidechainLowcutFrequency` | Double | varies — N=0: `10`, N=1: `500`, N=2: `1000`, N=3: `2000`, N=4: `4000`, N=5: `8000`, N=6: `12000`, N=7: `16000` |
| `SidechainMode` | Enum | `1` (Choices: 0: `Peak`, 1: `RMS`, 2: `LPF`, 3: `SMA`) (all bands) |
| `SidechainPreamp` | Double | `0` (all bands) |
| `SidechainReactivity` | Double | `10` (all bands) |
| `SidechainSource` | Enum | `0` (Choices: 0: `Middle`, 1: `Side`, 2: `Left`, 3: `Right`, 4: `Min`, 5: `Max`) (all bands) |
| `SidechainType` | Enum | `0` (Choices: 0: `Internal`, 1: `External`, 2: `Link`) (all bands) |
| `Solo` | Bool | `false` (all bands) |
| `SplitFrequency` | Double | varies — N=1: `500`, N=2: `1000`, N=3: `2000`, N=4: `4000`, N=5: `8000`, N=6: `12000`, N=7: `16000` |
| `StereoSplitSource` | Enum | `0` (Choices: 0: `Left/Right`, 1: `Right/Left`, 2: `Mid/Side`, 3: `Side/Mid`, 4: `Min`, 5: `Max`) (all bands) |

Full docs: https://wwmm.github.io/easyeffects/plugins/multibandcompressor.html


---

## Multiband Gate

Easy Effects uses the Multiband Gate Stereo developed by Calf Studio Gear. Please refer to the Gate (gate.html) documentation to comprehend the basic functionality of the gating process.

### Global Options

**Band Management**

This Gate allows to split the input signal up to 8 bands. Each band is not attached to its strict frequency and can be controlled by completely different frequency range that can be obtained by applying Low-Cut and Hi-Cut filters to the Sidechain signal.
The first band is always enabled while the others can be activated if needed. When only the first band is enabled, the functionality is similar to the Singleband Sidechain Gate. Otherwise the signal is split in more bands and each band is processed individually. After the gating stage, the bands are mixed together to form the output result.
**Operating Mode**

Determines how the input signal is split to obtain the different bands.

- **Classic** - The original signal is split using crossover filters. After the gating stage, all bands become phase-compensated using All-Pass filters.
- **Modern** - Each band is processed by a pair of dynamic shelving filters. This mode allows a better control over the gain of each band.

**Sidechain Boost**

If enabled, it introduces a special mode for assigning the same weight for higher frequencies opposite to lower frequencies.
When disabled, the frequency band is processed 'as is', but the usual audio signal has 3 dB/octave falloff in the frequency domain and could be compared with the pink noise. So lower frequencies take more effect on the Gate rather than higher frequencies.
On the other hand the Sidechain Boost mode allows to compensate the -3 dB/octave falloff of the signal spectrum and, even more, makes the signal spectrum growing +3 dB/octave in the almost fully audible frequency range.
**Pink** applies +3 dB/octave while **Brown** applies +6 dB/octave Sidechain Boost. Each of them can use bilinear-transformed (BT) or matched-transformed (MT) shelving filter.
**Sidechain Source**

If the External Sidechain is enabled inside at least one band, this combobox allows to select the input device as source.
**Dry Level**

Amount of unprocessed signal mixed in the output.
**Wet Level**

Amount of processed signal mixed in the output.

### Band Options

**Band Start**

Allows to change the lower end split frequency of the selected band. This value is assigned to the Band End of the previous enabled band. It can be modified for all bands except the first one, which is always enabled and its value is 0 Hz.
**Band End**

Specify the upper end split frequency of the selected band. It cannot be directly modified and assumes the same value of the Band Start of the next enabled band. For the last enabled band it is always 24.000 Hz.
**External Sidechain**

The Sidechain is an external source took by a specific input device (typically a microphone).
**Band Bypass**

If enabled, the selected band is not affected by the gating stage.
**Solo**

Turns on the Solo mode to the selected band by applying -36 dB gain to the other non-soloing bands.
**Mute**

Turns on the Mute mode applying -36 dB gain to to the selected band.
**Attack Time**

The length of time it takes to apply roughly two-thirds of the gain reduction.
**Release Time**

The length of time it takes to restore roughly two-thirds of the gain reduction.
**Curve Threshold**

The Gate fully opens upon the Sidechain level becoming above Curve Threshold.
If Hysteresis is not enabled, the Gate begins to close upon the Sidechain level becoming below Curve Threshold.
**Curve Zone Size**

The Gate begins to open upon the Sidechain level becoming above the Curve Threshold + Curve Zone.
If Hysteresis is not enabled, the Gate fully closes upon the Sidechain level becoming below the Curve Threshold + Curve Zone.
**Hysteresis**

When enabled, Curve Threshold and Curve Zone apply only to the opening Gate, and separate parameters can be configured for closing Gate.
**Hysteresis Threshold**

If Hysteresis is enabled, the Gate begins to close upon the Sidechain level becoming below Curve Threshold + Hysteresis Threshold.
**Hysteresis Zone Size**

If Hysteresis is enabled, the Gate fully closes upon the Sidechain level becoming below the Curve Threshold + Hysteresis Threshold + Hysteresis Zone.
**Reduction**

If the value is negative, it acts as the amount of gain reduction to apply to the input signal when the Gate is fully closed. If the value is positive, the Gate operates in "Reverse Mode": It reduces the amplitude when the signal is above the threshold.
**Makeup**

The gain to apply after the gating stage.

### Band Sidechain Options

**Mode**

Determines how the Sidechain is evaluated for the gating stage.

- **Peak** - The Gate reacts according to the peaks.
- **RMS** - The Gate reacts according to the average loudness measured by the root mean square.
- **Low-Pass Filter** - The Gate reacts according to the signal processed by a recursive 1-pole Low-Pass filter.
- **Simple Moving Average** - The Gate reacts according to the signal processed by the Simple Moving Average filter.

**Source**

Determines which part of the Sidechain is taken into account for the gating stage.

- **Middle** - The sum of left and right channels.
- **Side** - The difference between left and right channels.
- **Left** - Only left channel is used.
- **Right** - Only right channel is used.
- **Min** - The absolute minimum value is taken from stereo input.
- **Max** - The absolute maximum value is taken from stereo input.

**Low-Cut Filter**

Enables a custom Low-Cut Filter for the selected band.
**Low-Cut Frequency**

Sets the cut-off frequency of the custom Low-Cut filter. If it is disabled, the default Low-Cut filter assumes internally the Band Start frequency as the cut-off frequency.
**Hight-Cut Filter**

Enables a custom High-Cut Filter for the selected band.
**Hight-Cut Frequency**

Sets the cut-off frequency of the custom High-Cut filter. If it is disabled, the default High-Cut filter assumes internally the Band End frequency as the cut-off frequency.
**PreAmp**

Gain applied to the Sidechain signal of the selected band.
**Reactivity**

The time that defines the number of samples used to process the Sidechain in RMS, Uniform and Low-Pass modes. Higher the value, more smooth the gating.
**Lookahead**

The band signal to gate is delayed by this amount of time, so that the gating will be applied earlier than it would be otherwise.
Each band can have different Lookahead values. To avoid phase distortions in the mixing stage, all the bands are automatically delayed for an individually calculated period of time.

### References

- LSP Sidechain Multiband Gate Stereo (https://lsp-plug.in/?page=manuals&section=sc_mb_gate_stereo)
- Wikipedia Noise Gate (https://en.wikipedia.org/wiki/Noise_gate)

**Configurable properties (plugin ID `multiband_gate`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `dry` | Double | `-80.01` |
| `wet` | Double | `0` |
| `viewSidechain` | Bool | `false` |
| `externalSidechainEnabled` | Bool | `false` |
| `stereoSplit` | Bool | `false` |
| `gateMode` | Enum | `1` (Choices: 0: `Classic`, 1: `Modern`, 2: `Linear Phase`) |
| `envelopeBoost` | Enum | `0` (Choices: 0: `None`, 1: `Pink BT`, 2: `Pink MT`, 3: `Brown BT`, 4: `Brown MT`) |
| `inputToSidechain` | Double | `-80.01` |
| `inputToLink` | Double | `-80.01` |
| `sidechainToInput` | Double | `-80.01` |
| `sidechainToLink` | Double | `-80.01` |
| `linkToSidechain` | Double | `-80.01` |
| `linkToInput` | Double | `-80.01` |
| `sidechainInputDevice` | String | `""` |

Each band N (0-7) also exposes `bandN<Suffix>` properties:

| Suffix (`bandN<Suffix>`) | Type | Default |
|---|---|---|
| `AttackTime` | Double | `20` (all bands) |
| `CurveThreshold` | Double | `-24` (all bands) |
| `CurveZone` | Double | `-6` (all bands) |
| `Enable` | Bool | varies — N=1: `true`, N=2: `true`, N=3: `true`, N=4: `false`, N=5: `false`, N=6: `false`, N=7: `false` |
| `GateEnable` | Bool | `true` (all bands) |
| `Hysteresis` | Bool | `false` (all bands) |
| `HysteresisThreshold` | Double | `-12` (all bands) |
| `HysteresisZone` | Double | `-6` (all bands) |
| `Makeup` | Double | `0` (all bands) |
| `Mute` | Bool | `false` (all bands) |
| `Reduction` | Double | `-24` (all bands) |
| `ReleaseTime` | Double | `100` (all bands) |
| `SidechainCustomHighcutFilter` | Bool | `false` (all bands) |
| `SidechainCustomLowcutFilter` | Bool | `false` (all bands) |
| `SidechainHighcutFrequency` | Double | varies — N=0: `500`, N=1: `1000`, N=2: `2000`, N=3: `4000`, N=4: `8000`, N=5: `12000`, N=6: `16000`, N=7: `20000` |
| `SidechainLookahead` | Double | `0` (all bands) |
| `SidechainLowcutFrequency` | Double | varies — N=0: `10`, N=1: `500`, N=2: `1000`, N=3: `2000`, N=4: `4000`, N=5: `8000`, N=6: `12000`, N=7: `16000` |
| `SidechainMode` | Enum | `1` (Choices: 0: `Peak`, 1: `RMS`, 2: `LPF`, 3: `SMA`) (all bands) |
| `SidechainPreamp` | Double | `0` (all bands) |
| `SidechainReactivity` | Double | `10` (all bands) |
| `SidechainSource` | Enum | `0` (Choices: 0: `Middle`, 1: `Side`, 2: `Left`, 3: `Right`, 4: `Min`, 5: `Max`) (all bands) |
| `SidechainType` | Enum | `0` (Choices: 0: `Internal`, 1: `External`, 2: `Link`) (all bands) |
| `Solo` | Bool | `false` (all bands) |
| `SplitFrequency` | Double | varies — N=1: `500`, N=2: `1000`, N=3: `2000`, N=4: `4000`, N=5: `8000`, N=6: `12000`, N=7: `16000` |
| `StereoSplitSource` | Enum | `0` (Choices: 0: `Left/Right`, 1: `Right/Left`, 2: `Mid/Side`, 3: `Side/Mid`, 4: `Min`, 5: `Max`) (all bands) |

Full docs: https://wwmm.github.io/easyeffects/plugins/multibandgate.html


---

## Deesser

A Deesser is used to dynamically reduce high frequencies. The standard field of use of this plugin is the reduction of "sssss" and "shhhh" in vocal tracks. Easy Effects uses the Deesser developed by Calf Studio Gear.
**Detection**

Select the detection of the Sidechain signal between Peak (stronger) and RMS (smoother).
**Mode**

Select the operation mode between Wideband and Split. In Split mode not the full range signal will be affected by the gain reduction, but only frequencies above the split frequency will be manipulated in gain.
**F1 Split**

The split frequency. All signals above this frequency will affect the gain reduction (and are affected in Split mode too).
**F1 Gain**

It shifts the volume of the higher band. In Wideband mode it affects the Sidechain. In Split mode it also affects the processed high frequencies.
**F2 Peak**

Center frequency of the bell filter. It allows a more precise selection of the Sidechain signal.
**F2 Level**

Increases or decreases the level of the chosen F2 frequency.
**F2 Peak Q**

Set the quality of the bell filter. Higher values will affect a narrower frequency range. Lower values will affect a wider band.
**Laxity**

The reaction of the Deesser. Higher values won't affect really short peaks.
**Threshold**

The level above which the gain reduction is applied.
**Ratio**

The amount of attenuation applied to the signal.
For example, a Ratio of 2 means that if the level rises 4 dB above the Threshold, it will be only 2 dB above after the reduction.
**Makeup**

The gain to apply after the processing stage. In Split mode only the high band will be made up.

### References

- Wikipedia De-essing (https://en.wikipedia.org/wiki/De-essing)
- Calf Deesser (https://calf-studio-gear.org/doc/Deesser.html)
- LedgerNote - De-esser: The Guide for Sibilant-Free Vocal Recordings (https://ledgernote.com/columns/mixing-mastering/de-esser/)

**Configurable properties (plugin ID `deesser`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `detection` | Enum | `0` (Choices: 0: `RMS`, 1: `Peak`) |
| `mode` | Enum | `0` (Choices: 0: `Wide`, 1: `Split`) |
| `threshold` | Double | `-18` |
| `ratio` | Double | `3` |
| `laxity` | Int | `15` |
| `makeup` | Double | `0` |
| `f1Freq` | Double | `6000` |
| `f2Freq` | Double | `4500` |
| `f1Level` | Double | `0` |
| `f2Level` | Double | `12` |
| `f2Q` | Double | `1` |
| `scListen` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/deesser.html


---
