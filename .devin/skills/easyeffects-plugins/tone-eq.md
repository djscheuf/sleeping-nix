# Tone & EQ Plugins

Plugins that shape frequency content, tonal balance, and stereo tone.

## Equalizer

The Equalization in sound recording and reproduction is the process of adjusting the volume of different frequency bands within an audio signal. Easy Effects uses the Parametric Equalizer from Linux Studio Plugins. The user can choose from 1 to 32 bands. Width and center frequency of each band can be customized as needed.

### Global Options

**Bands**

The number of bands.
**Mode**

- **IIR** - Infinite Impulse Response filters, nonlinear minimal phase. In most cases does not add noticeable latency to output signal.
- **FIR** - Finite Impulse Response filters with linear phase, finite approximation of Equalizer's impulse response. Adds noticeable latency to output signal.
- **FFT** - Fast Fourier Transform approximation of the frequency chart, linear phase. Adds noticeable latency to output signal.
**Balance**

Balance between left and right output channels.
**Pitch Left**

The frequency shift for all filters of the left channel, in semitones.
**Pitch Right**

The frequency shift for all filters of the right channel, in semitones.
**Split Channels**

When enabled it is possible to apply different configurations to left and right channels.
**Flat Response**

This function sets each band gain to 0.
**Calculate Frequencies**

This function calculates the center frequency and the width of each band using the current number of bands. Useful when the user wants fewer than 32 bands but has no idea about which frequencies should be chosen.

### Band Options

**Type**

- **Off** - The filter is not working (turned off).
- **Bell** - Bell filter with smooth peak/recess.
- **High Pass** - High Pass filter with rejection of low frequencies.
- **High Shelf** - Shelving filter with adjustment of high frequency range.
- **Low Pass** - Low Pass filter with rejection of high frequencies.
- **Low Shelf** - Shelving filter with adjustment of low frequency range.
- **Notch** - Notch filter with full rejection of selected frequency.
- **Resonance** - Resonance filter with sharp peak/recess.
- **All Pass** - All Pass filter.
**Mode**

- **RLC** - Very smooth filters based on similar cascades of RLC contours. Bilinear Z-transform (BT) or Matched Z-transform (MT) is used for pole/zero mapping.
- **BWC** - Butterworth-Chebyshev-type-1 based filters. Does not affect Resonance and Notch filters. Bilinear Z-transform (BT) or Matched Z-transform (MT) is used for pole/zero mapping.
- **LRX** - Linkwitz-Riley based filters. Does not affect Resonance and Notch filters. Bilinear Z-transform (BT) or Matched Z-transform (MT) is used for pole/zero mapping.
- **APO** - Digital biquad filters derived from canonic analog biquad prototypes digitalized through Bilinear transform. These are textbook filters (https://shepazu.github.io/Audio-EQ-Cookbook/audio-eq-cookbook.html) which are implemented as in the Equalizer APO (https://equalizerapo.com/) software. Direct design (DR) is used to serve the digital filter coefficients directly in the digital domain, without performing transforms.
**Slope**

The slope of the filter characteristics.
**Solo**

Makes the selected band the only one active.
**Mute**

Mutes the selected band.
**Frequency**

Center frequency of the selected band.
**Width**

Bandwidth calculated as `width = frequency / quality`.
**Quality**

The quality factor of the filter used.

### References

- Wikipedia Equalization (audio) (https://en.wikipedia.org/wiki/Equalization_(audio))
- LSP Parametric Equalizer x32 LeftRight (http://lsp-plug.in/?page=manuals&section=para_equalizer_x32_lr)
- Wikipedia Q Factor (https://en.wikipedia.org/wiki/Q_factor)
- How to EQ - Q Factor and Bandwidth in EQ: What They Mean (https://howtoeq.wordpress.com/2010/10/07/q-factor-and-bandwidth-in-eq-what-it-all-means/)

**Configurable properties (plugin ID `equalizer`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `numBands` | Int | `32` |
| `mode` | Enum | `0` (Choices: 0: `IIR`, 1: `FIR`, 2: `FFT`, 3: `SPM`) |
| `splitChannels` | Bool | `false` |
| `balance` | Double | `0` |
| `pitchLeft` | Double | `0` |
| `pitchRight` | Double | `0` |
| `viewLeftChannel` | Bool | `true` |
| `decramp` | Enum | `0` (Choices: 0: `Off`, 1: `x2`, 2: `x3`, 3: `x4`, 4: `x6`, 5: `x8`) |

Full docs: https://wwmm.github.io/easyeffects/plugins/equalizer.html


---

## Mid-Side Equalizer

The Mid-Side Equalizer processes the Mid (sum) and Side (difference) parts of a stereo signal independently. It's useful, for example, to fix the overall tone of a recording through the Mid channel while keeping the stereo ambience untouched on the Side channel. Easy Effects uses the Parametric Equalizer x32 MidSide from Linux Studio Plugins. You can run anywhere from 1 to 32 bands per channel, and tweak the width and center frequency of each band.

### Global Options

**Bands**

Number of bands.
**Mode**

- **IIR** - Infinite Impulse Response filters, nonlinear minimal phase. Usually doesn't add noticeable latency to the output.
- **FIR** - Finite Impulse Response filters with linear phase, a finite approximation of the equalizer's impulse response. Adds noticeable latency to the output.
- **FFT** - Fast Fourier Transform approximation of the frequency chart, linear phase. Adds noticeable latency to the output.
**Balance**

Balance between the left and right output channels.
**Pitch Mid**

Frequency shift for all mid channel filters, in semitones.
**Pitch Side**

Frequency shift for all side channel filters, in semitones.
**Link Mid/Side**

When enabled, you can apply different configurations to the mid and side channels.
**Flat Response**

Resets all band gains to 0.
**Calculate Frequencies**

Figures out the center frequency and width for each band based on the current band count. Handy if you want fewer than 32 bands but aren't sure which frequencies to pick.

### Band Options

**Type**

- **Off** - Filter is disabled.
- **Bell** - Bell filter with smooth peak/recess.
- **High Pass** - High Pass filter that removes low frequencies.
- **High Shelf** - Shelving filter that adjusts the high frequency range.
- **Low Pass** - Low Pass filter that removes high frequencies.
- **Low Shelf** - Shelving filter that adjusts the low frequency range.
- **Notch** - Notch filter that fully rejects the selected frequency.
- **Resonance** - Resonance filter with sharp peak/recess.
- **All Pass** - All Pass filter.
**Mode**

- **RLC** - Very smooth filters built from cascaded RLC contours. Uses Bilinear Z-transform (BT) or Matched Z-transform (MT) for pole/zero mapping.
- **BWC** - Butterworth-Chebyshev-type-1 based filters. Doesn't affect Resonance and Notch filters. Uses Bilinear Z-transform (BT) or Matched Z-transform (MT) for pole/zero mapping.
- **LRX** - Linkwitz-Riley based filters. Doesn't affect Resonance and Notch filters. Uses Bilinear Z-transform (BT) or Matched Z-transform (MT) for pole/zero mapping.
- **APO** - Digital biquad filters derived from canonical analog biquad prototypes digitalized through Bilinear transform. These are textbook filters (https://shepazu.github.io/Audio-EQ-Cookbook/audio-eq-cookbook.html) implemented the same way as in Equalizer APO (https://equalizerapo.com/). Direct design (DR) generates the digital filter coefficients directly in the digital domain, without any transforms.
**Slope**

Slope of the filter curve.
**Solo**

Makes the selected band the only active one.
**Mute**

Mutes the selected band.
**Frequency**

Center frequency of the band.
**Width**

Bandwidth, calculated as `width = frequency / quality`.
**Quality**

Quality factor of the filter.

### References

- Wikipedia Equalization (audio) (https://en.wikipedia.org/wiki/Equalization_(audio))
- LSP Parametric Equalizer x32 MidSide (http://lsp-plug.in/?page=manuals&section=para_equalizer_x32_ms)
- Wikipedia Q Factor (https://en.wikipedia.org/wiki/Q_factor)
- How to EQ - Q Factor and Bandwidth in EQ: What They Mean (https://howtoeq.wordpress.com/2010/10/07/q-factor-and-bandwidth-in-eq-what-it-all-means/)

**Configurable properties (plugin ID `midside_equalizer`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `numBands` | Int | `32` |
| `mode` | Enum | `0` (Choices: 0: `IIR`, 1: `FIR`, 2: `FFT`, 3: `SPM`) |
| `splitChannels` | Bool | `false` |
| `balance` | Double | `0` |
| `pitchMid` | Double | `0` |
| `pitchSide` | Double | `0` |
| `viewMidChannel` | Bool | `true` |
| `decramp` | Enum | `0` (Choices: 0: `Off`, 1: `x2`, 2: `x3`, 3: `x4`, 4: `x6`, 5: `x8`) |

Full docs: https://wwmm.github.io/easyeffects/plugins/midside_equalizer.html


---

## Loudness

Easy Effects uses the Loudness Compensator from Linux Studio Plugins which applies the "equal-loudness contour" corrections to the input signal.
An equal-loudness contour is a measure of sound pressure level (SPL), over the frequency spectrum, for which a listener perceives a constant loudness when presented with pure steady tones. The unit of measurement for loudness levels is the phon and is arrived at by reference to equal-loudness contours.
Usage of equal-loudness contours solves many mixing problems that every sound engineer meets while working on the track. The main problem is that human ear perceives different frequencies for different volume settings in a different way. In other words, applying changes to the mix on the low volume settings may cause unexpected sounding of the mix at the maximum loudness.
The Loudness Compensator performs frequency response computations and applies the computed frequency response to the input signal depending on the output volume settings. Additionally it can provide ear protection by applying hard-clipping to the output signal if it exceeds the allowed configurable level.
**Standard**

Allows to select different equal-loudness contour standards.

- **Flat** - Applies flat frequency response to the whole spectrum. It's similar to just a gain knob but useful to perform a comparison to other modes.
- **ISO 226:2003** - Recent equal-loudness contour standard published in 2003.
- **Fletcher-Munson** - The first equal-loudness contour implementation by Harvey Fletcher and Wilden A. Munson published in 1933.
- **Robinson-Dadson** - More accurate equal-loudness contour implementation by D.W. Robinson and R.S. Dadson published in 1956. It became the basis for the ISO 226:2003 standard.

**FFT Size**

Allows to select size of the Fast Fourier Transform frame used for the processing. The larger FFT frame is, the more precise the curve is approximated and the more latency is introduced.
**Output Volume**

The output volume of the signal with applied equal loudness contour. It controls the loudness of the 1 kHz pure sine wave.
**Clipping**

Allows to enable and the hard clipping of the output signal.
**Clipping Range**

Allows to set the gap level for the hard clipping of the output signal.

### References

- Wikipedia Equal-Loudness Contour (https://en.wikipedia.org/wiki/Equal-loudness_contour)
- LSP Loudness Compensator Stereo (https://lsp-plug.in/?page=manuals&section=loud_comp_stereo)
- Lindos Electronics - Equal-Loudness Contours (http://www.lindos.co.uk/cgi-bin/FlexiData.cgi?SOURCE=Articles&VIEW=full&id=17)

**Configurable properties (plugin ID `loudness`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `mode` | Enum | `0` (Choices: 0: `FFT`, 1: `IIR`) |
| `fft` | Enum | `4` (Choices: 0: `256`, 1: `512`, 2: `1024`, 3: `2048`, 4: `4096`, 5: `8192`, 6: `16384`) |
| `std` | Enum | `4` (Choices: 0: `Flat`, 1: `ISO226-2003`, 2: `Fletcher-Munson`, 3: `Robinson-Dadson`, 4: `ISO226-2023`) |
| `volume` | Double | `0` |
| `clipping` | Bool | `false` |
| `clippingRange` | Double | `6` |
| `iirApproximation` | Enum | `2` (Choices: 0: `Fastest`, 1: `Low`, 2: `Normal`, 3: `High`, 4: `Best`) |

Full docs: https://wwmm.github.io/easyeffects/plugins/loudness.html


---

## Bass Loudness

The ear is less sensitive to low frequencies when listening at low volume. This plugin developed by MDA allows the bass level to be adjusted measuring the "equal-loudness contour".
**Loudness**

Source level relative to listening level (based on a 100 dB SPL maximum level).
**Output**

Change output level.
**Link**

Automatically adjusts Output to maintain a consistent tonal balance at all levels.

### References

- Wikipedia Equal-Loudness Contour (https://en.wikipedia.org/wiki/Equal-loudness_contour)
- MDA Loudness (http://mda.smartelectronix.com/vst/help/loudness.htm)

**Configurable properties (plugin ID `bass_loudness`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `loudness` | Double | `-3.1` |
| `output` | Double | `-6` |
| `link` | Double | `-9.1` |

Full docs: https://wwmm.github.io/easyeffects/plugins/bassloudness.html


---

## Bass Enhancer

A Bass Enhancer is used to produce very low sound that is not present in the original signal. This is done by creating harmonic distortions of the signal which are restricted in range and added to the original signal. It raises the lower end of an audio signal without simply raising the lower frequencies like an Equalizer (equalizer.html) would do to create a more "fat" or "boomy" sound.
**Amount**

Amount of harmonics added to the original signal.
**Harmonics**

Amount of newly created harmonics.
**Scope**

The frequency above which harmonics are produced.
**Floor (button)**

Constrain the enhancement on the lower end.
**Floor (value)**

The frequency below which no harmonics are produced.
**Blend Harmonics**

The "colour" (or octave) of the harmonics.
**Listen**

Mute the original signal and listen to the harmonics exclusively.

### References

- Calf Bass Enhancer (https://calf-studio-gear.org/doc/Bass%20Enhancer.html)
- Wikipedia Missing Fundamental (https://en.wikipedia.org/wiki/Missing_fundamental)

**Configurable properties (plugin ID `bass_enhancer`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `amount` | Double | `0` |
| `harmonics` | Double | `8.5` |
| `scope` | Double | `100` |
| `floor` | Double | `20` |
| `blend` | Double | `0` |
| `floorActive` | Bool | `false` |
| `listen` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/bassenhancer.html


---

## Exciter

An Exciter is used to produce high sound that is not present in the original signal. This is done by creating harmonic distortions of the signal which are restricted in range and added to the original signal. It raises the upper end of an audio signal without simply raising the higher frequencies like an Equalizer (equalizer.html) would do to create a more "crisp" or "brilliant" sound.
**Amount**

Amount of harmonics added to the original signal.
**Harmonics**

Amount of newly created harmonics.
**Scope**

The frequency above which harmonics are produced.
**Ceiling (button)**

Constrain the excitement on the upper end.
**Ceiling (value)**

The frequency above which no harmonics are produced.
**Blend Harmonics**

The "colour" (or octave) of the harmonics.
**Listen**

Mute the original signal and listen to the harmonics exclusively.

### References

- Calf Exciter (https://calf-studio-gear.org/doc/Exciter.html)
- Wikipedia Exciter (effect) (https://en.wikipedia.org/wiki/Exciter_(effect))

**Configurable properties (plugin ID `exciter`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `amount` | Double | `0` |
| `harmonics` | Double | `8.5` |
| `scope` | Double | `7500` |
| `ceil` | Double | `16000` |
| `blend` | Double | `0` |
| `ceilActive` | Bool | `false` |
| `listen` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/exciter.html


---

## Crystalizer

The Crystalizer plugin can be used to add a little of dynamic range to songs that were overly compressed. The signal is split in multiple bands to which different intensities can be applied in order to alter the overall dynamic range.
**Intensities**
The higher the value the higher is the difference in magnitude between the loudest and the quietest sounds of the selected band. Different intensities can be set for each frequency band.
**Bypass**
When active the audio signal passing through the selected band is not modified.
**Mute**
Mutes the selected band.
**Adaptive Intensity**
When enabled the intensity value set by the band slider is continuously scaled as audio is processed. The scaling may
increase or decrease the intensity based on the geometric mean of the signal crest factor, kurtosis and spectral flux.
When using static intensity values it may happen that the crystalizer enhances high frequency audio too much. What leads
to audible artifacts. The adaptive scaling removes this is most of the cases.
**Oversampling**
Resamples the signal to double its sampling rate value and back to the original value after the plugins effects are applied.
It improves the effects quality but it also increases CPU usage.
**Oversampling Quality**
Controls the resampling quality. Higher values require more CPU power.
**Fixed Quantum**
Forces the plugin to use a fixed audio buffer size to process audio. This helps to avoid noises when the sound server switches latency on the fly.
But it has the downside of introducing unneeded latency in some cases. And increased CPU usage in cases where higher latency could be used.
**Transition Band**
Controls the width of the transition band of the bandpass filters used to split the signal in several bands. Higher values will use less CPU. But will result in more overlap between the bands.

### References

- Wikipedia Dynamic Range (https://en.wikipedia.org/wiki/Dynamic_range)
- Crest factor (https://en.wikipedia.org/wiki/Crest_factor)
- Kurtosis (https://en.wikipedia.org/wiki/Kurtosis)
- Spectral flux (https://en.wikipedia.org/wiki/Spectral_flux)

**Configurable properties (plugin ID `crystalizer`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `adaptiveIntensity` | Bool | `true` |
| `oversampling` | Bool | `true` |
| `oversamplingQuality` | Double | `5` |
| `useFixedQuantum` | Bool | `false` |
| `transitionBand` | Double | `120` |
| `intensityBand0` | Double | `0` |
| `intensityBand1` | Double | `0` |
| `intensityBand2` | Double | `-2` |
| `intensityBand3` | Double | `0` |
| `intensityBand4` | Double | `0` |
| `intensityBand5` | Double | `0` |
| `intensityBand6` | Double | `0` |
| `intensityBand7` | Double | `0` |
| `intensityBand8` | Double | `0` |
| `intensityBand9` | Double | `0` |
| `intensityBand10` | Double | `0` |
| `intensityBand11` | Double | `0` |
| `intensityBand12` | Double | `0` |
| `muteBand0` | Bool | `false` |
| `muteBand1` | Bool | `false` |
| `muteBand2` | Bool | `false` |
| `muteBand3` | Bool | `false` |
| `muteBand4` | Bool | `false` |
| `muteBand5` | Bool | `false` |
| `muteBand6` | Bool | `false` |
| `muteBand7` | Bool | `false` |
| `muteBand8` | Bool | `false` |
| `muteBand9` | Bool | `false` |
| `muteBand10` | Bool | `false` |
| `muteBand11` | Bool | `false` |
| `muteBand12` | Bool | `false` |
| `bypassBand0` | Bool | `false` |
| `bypassBand1` | Bool | `false` |
| `bypassBand2` | Bool | `false` |
| `bypassBand3` | Bool | `false` |
| `bypassBand4` | Bool | `false` |
| `bypassBand5` | Bool | `false` |
| `bypassBand6` | Bool | `false` |
| `bypassBand7` | Bool | `false` |
| `bypassBand8` | Bool | `false` |
| `bypassBand9` | Bool | `false` |
| `bypassBand10` | Bool | `false` |
| `bypassBand11` | Bool | `false` |
| `bypassBand12` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/crystalizer.html


---

## Stereo Tools

Easy Effects uses the Stereo Tools developed by Calf Studio Gear which provides some handy utilities to manage Stereo streams handling Left and Right channels in conjunction with Mid and Side signals.
Mid/Side is a recording technique which registers Mid and Side signals rather then plain Left and Right channels. Its basic setup makes use of one cardioid microphone (Mid) and one bidirectional (figure-eight) microphone (Sides). In mastering stage Mid and Side can be used to shape the balance of the Stereo image having more control over the mix to get a wider, deeper, and more focused track.
Having a Stereo stream, Mid is obtained summing both channels `(L+R)` while Side is the result of the difference between Left and Right `(L-R)`. Mid and Side signals can be decoded back to Left `(M+S)/2` and Right `(M-S)/2`.

### Input

**Balance**

Sets the balance between both channels.
**Softclip (button)**

Makes a kind of analog distortion instead of harsh digital 0 dB clipping.
**Softclip (value)**

Level of Softclip.

### Stereo Matrix

**Mode**

Allows to choose between different channel configurations such as normal Stereo Mode, Mid-Side or Mono simulation.
**Mute L/R**

Mutes the Left/Right channel.
**Invert Phase L/R**

Changes the Phase of the Left/Right channel.
**Side Level**

The level of the Side signal.
**Side Balance**

The balance of the Side signal.
**Middle Level**

The level of the Middle signal.
**Middle Panorama**

The position in the Panorama of the Middle signal.

### Output

**Balance**

Sets the balance between both channels.
**Delay L/R**

Delays the Left or the Right channel. Negative values delay the Left channel and positive values the Right channel.
**Stereo Base**

Sets the Stereo Base of the content seamless between Mono and inverted channels.
**Stereo Phase**

Set the Stereo Phase of the content.

### References

- Wikipedia Stereophonic Sound (https://en.wikipedia.org/wiki/Stereophonic_sound)
- Calf Stereo Tools (https://calf-studio-gear.org/doc/Stereo%20Tools.html)
- Unlock Your Sound - Stereo, Mono, Mid, Side, Panning, and Imaging Explained (https://unlockyoursound.com/stereo/)

**Configurable properties (plugin ID `stereo_tools`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `balanceIn` | Double | `0` |
| `balanceOut` | Double | `0` |
| `softclip` | Bool | `false` |
| `mutel` | Bool | `false` |
| `muter` | Bool | `false` |
| `phasel` | Bool | `false` |
| `phaser` | Bool | `false` |
| `mode` | Enum | `0` (Choices: 0: `LR &gt; LR (Stereo Default)`, 1: `LR &gt; MS (Stereo to Mid-Side)`, 2: `MS &gt; LR (Mid-Side to Stereo)`, 3: `LR &gt; LL (Mono Left Channel)`, 4: `LR &gt; RR (Mono Right Channel)`, 5: `LR &gt; L+R (Mono Sum L+R)`, 6: `LR &gt; RL (Stereo Flip Channels)`) |
| `slev` | Double | `0` |
| `sbal` | Double | `0` |
| `mlev` | Double | `0` |
| `mpan` | Double | `0` |
| `stereoBase` | Double | `0` |
| `delay` | Double | `0` |
| `scLevel` | Double | `1` |
| `stereoPhase` | Double | `0` |
| `dry` | Double | `-100` |
| `wet` | Double | `0` |

Full docs: https://wwmm.github.io/easyeffects/plugins/stereotools.html


---

## Filter

A Filter is used to amplify (boost), pass or attenuate (cut) defined parts of a frequency spectrum. Easy Effects uses the Filter from Linux Studio Plugins.
**Type**

- **Low-pass** - Low-pass filter with rejection of high frequencies.

- **High-pass** - High-pass filter with rejection of low frequencies.

- **Low-shelf** - Shelving filter with adjustment of low frequencies.

- **High-shelf** - Shelving filter with adjustment of high frequency range.

- **Bell** - Bell filter with smooth peak/recess.

- **Bandpass** - Bandpass filter.

- **Notch** - Notch filter with full rejection of selected frequency.

- **Resonance** - Resonance filter with sharp peak/recess.

- **Ladder-pass** - The filter that makes some ladder-passing in the spectrum domain.

- **Ladder-rej** - The filter that makes some ladder-rejection in the spectrum domain.

- **Allpass** - All-pass filter which only affects the phase of the audio signal at the specified frequency.  
**Filter Mode**

- **RLC** - Very smooth filters based on similar cascades of RLC contours.

- **BWC** - Butterworth-Chebyshev-type-1 based filters. Does not affect Resonance and Notch filters.

- **LRX** - Linkwitz-Riley based filters. Does not affect Resonance and Notch filters.

- **APO** - Digital biquad filters derived from canonic analog biquad prototypes digitalized through Bilinear transform. These are textbook filters which are implemented as in the EqualizerAPO software.

- **BT** - Bilinear Z-transform is used for pole/zero mapping.

- **MT** - Matched Z-transform is used for pole/zero mapping.

- **DR** - Direct design is used to serve the digital filter coefficients directly in the digital domain, without performing transforms.  
**Equalizer Mode**

- **IIR** - Infinite Impulse Response filters, nonlinear minimal phase. In most cases does not add noticeable latency to output signal.

- **FIR** - Finite Impulse Response filters with linear phase, finite approximation of equalizer's impulse response. Adds noticeable latency to output signal.

- **FFT** - Fast Fourier Transform approximation of the frequency chart, linear phase. Adds noticeable latency to output signal.

- **SPM** - Spectral Processor Mode of equalizer, equalizer transforms the magnitude of signal spectrum instead of applying impulse response to the signal.
**Slope**

The slope of the filter characteristics.  
**Frequency**

The cutoff/resonance frequency of the filter or the middle frequency of the band.  
**Width**

The width of the bandpass/ladder filters in octaves.  
**Gain**

The gain of the filter. It is disabled for lo-pass/hi-pass/notch filters.  
**Quality**

The quality factor of the filter.  
**Balance**

The balance between left and right output channels.  

### References

- Wikipedia Audio Filter (https://en.wikipedia.org/wiki/Audio_filter)
- Linux Studio Plugins Filter (https://lsp-plug.in/?page=manuals&section=filter_stereo)

**Configurable properties (plugin ID `filter`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `type` | Enum | `0` (Choices: 0: `Low-pass`, 1: `High-pass`, 2: `Low-shelf`, 3: `High-shelf`, 4: `Bell`, 5: `Band-pass`, 6: `Notch`, 7: `Resonance`, 8: `Ladder-pass`, 9: `Ladder-rejection`, 10: `All-pass`) |
| `equalMode` | Enum | `0` (Choices: 0: `IIR`, 1: `FIR`, 2: `FFT`, 3: `SPM`) |
| `mode` | Enum | `0` (Choices: 0: `RLC (BT)`, 1: `RLC (MT)`, 2: `BWC (BT)`, 3: `BWC (MT)`, 4: `LRX (BT)`, 5: `LRX (MT)`, 6: `APO (DR)`) |
| `slope` | Enum | `0` (Choices: 0: `x1`, 1: `x2`, 2: `x3`, 3: `x4`, 4: `x6`, 5: `x8`, 6: `x12`, 7: `x16`) |
| `frequency` | Double | `2000` |
| `width` | Double | `4.0` |
| `quality` | Double | `0.0` |
| `gain` | Double | `0` |
| `balance` | Double | `0` |
| `decramp` | Enum | `0` (Choices: 0: `Off`, 1: `x2`, 2: `x3`, 3: `x4`, 4: `x6`, 5: `x8`) |

Full docs: https://wwmm.github.io/easyeffects/plugins/filter.html


---

## Crusher

A bitcrusher reduces the resolution or bandwidth of digital audio data. Audio reduced in bit depth sounds more harsh and "digital". 
In the bitcrusher from Calf Studio Gear used in EasyEffects reduction can be done in a linear or logarithmic way.
According to the plugin authors the logarithmic way results in a much smoother sound in low volume signals. 
**Mode**

- **Linear** - Linear distance between bits.
- **Logarithmic** - Logarithmic distances between bits. The result is a much more "natural" sounding crusher which doesn't gate low signals. 
**Bit reduction**

Controls the processed audio bit depth. 
**DC offset**

This offset causes different crushing of the lower and the upper half of the signal. 
**Anti-aliasing**

Controls the softness of the crushing sounds. 
**Mix**

Controls the mix of original and processed audio. When at 0% the output signal is equal to the original. When at 100% only the processed signal is in the output signal. 
**Reduction**

Controls the reduction of the sample rate (downsampling).  
**Low frequency oscillator active**

Enable the low frequency oscillator. The oscillator will make the sample rate reduction change between a range determined by the range control.
**Low frequency oscillator range**

Controls the amount of modulation applied to the sample rate reduction. 
**Low frequency oscillator rate**

Controls the frequency of the oscillator. 

### References

- Wikipedia Bit Crusher (https://en.wikipedia.org/wiki/Bitcrusher)
- Calf Crusher (https://calf-studio-gear.org)
- Calf Crusher Documentation (https://calf-studio-gear.org/doc/Crusher.html)

**Configurable properties (plugin ID `crusher`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `mode` | Enum | `0` (Choices: 0: `Linear`, 1: `Logarithmic`) |
| `bitReduction` | Double | `4.0` |
| `morph` | Double | `0.5` |
| `dc` | Double | `0` |
| `antiAliasing` | Double | `0.5` |
| `sampleReduction` | Int | `1` |
| `lfoActive` | Bool | `false` |
| `lfoRange` | Int | `20` |
| `lfoRate` | Double | `0.3` |

Full docs: https://wwmm.github.io/easyeffects/plugins/crusher.html


---
