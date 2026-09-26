# Noise Reduction & Voice Plugins

Plugins aimed at cleaning up microphone/voice signals: noise removal, echo/AEC, and speech processing.

## Deep Noise Remover

Advanced noise reduction is achieved using "DeepFilterNet" technology. This technology uses AI technology called deep learning to efficiently remove noise from audio signals, enabling higher quality noise suppression than conventional methods. This technology has several control parameters, which are explained below and how to set them.
**Attenuation Limit**

This parameter determines how much noise is attenuated. Higher values result in stronger noise reduction, but too high a value may also remove parts of the audio.

- Recommended setting: 70dB to 80dB is a typical balanced value. This minimizes background noise while preserving speech intelligibility.

**Minimum Processing Threshold**

Signals below the Minimum Processing Threshold are targeted for denoising. Signals louder than this threshold are not subject to noise reduction and are passed through unchanged. This setting is intended to effectively remove small background noise.

- Recommended setting: -15dB to -30dB is good. This should be fine-tuned according to the ambient noise. Currently, Easy Effects does not allow a value smaller than -15dB.

**Maximum ERB Processing Threshold**

The human auditory system has the ability to separate and recognize different frequency components. Equivalent Rectangular Bandwidth (ERB) is a numerical expression and model of this filtering capability. ERB-based processing emphasizes the perceptual importance of speech by focusing on specific frequency bands. This improves the effectiveness of noise reduction and speech enhancement. This threshold sets the maximum level at which perceptually equivalent bandwidth (ERB)-based processing is applied. Signals above this threshold are not subject to noise reduction or speech enhancement processing. This prevents important speech components or loud portions of speech from being unnecessarily processed.

- Recommended setting: Start in the range of 20dB to 30dB and adjust as needed.

**Maximum DF Processing Threshold**

The Maximum DF Processing Threshold sets the maximum level of signal that DeepFilterNet will process. Signals exceeding this threshold are excluded from noise reduction processing. This prevents important or loud portions of speech from being unnecessarily processed.

- Recommended setting: 20 dB as the default value. This effectively suppresses noise while maintaining voice quality.

**Minimum Processing Buffer**

Defines the size of the buffer used to process frames of audio data. A larger buffer can improve noise suppression but may increase latency.

- Recommended setting: Set to a small value (0) if real-time processing is important, or to a number greater than 1 if noise suppression accuracy is a priority.

**Post Filter Beta**

Controls the intensity of the post-processing filter applied after the initial noise suppression. This allows for more subtle refinement of the audio signal.

- Recommended setting: 0.5dB to 2dB is generally recommended, but currently Easy Effects has a maximum value of 0.05dB, which is almost ineffective.

**Configurable properties (plugin ID `deepfilternet`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `attenuationLimit` | Double | `100` |
| `minProcessingThreshold` | Double | `-10` |
| `maxErbProcessingThreshold` | Double | `30` |
| `maxDfProcessingThreshold` | Double | `20` |
| `minProcessingBuffer` | Int | `0` |
| `postFilterBeta` | Double | `0.02` |

Full docs: https://wwmm.github.io/easyeffects/plugins/deepfilternet.html


---

## Noise Reduction

The Noise Reduction is a process aimed to attenuate the disturbing noise from a signal.
Easy Effects Noise Reduction is made on the RNNoise library which is based based on recurrent neural network, a class of artificial neural networks where connections between nodes form a directed graph along a temporal sequence. This allows it to exhibit temporal dynamic behavior.
Standard RNNoise Model is used and custom models can be imported to perform different types of noise reduction.

### References

- Wikipedia Noise Reduction (https://en.wikipedia.org/wiki/Noise_reduction)
- Wikipedia Recurrent Neural Network (https://en.wikipedia.org/wiki/Recurrent_neural_network)
- Jean-Marc Valin - RNNoise: Learning Noise Suppression (https://jmvalin.ca/demo/rnnoise/)

**Configurable properties (plugin ID `rnnoise`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `modelName` | String | `""` |
| `useStandardModel` | Bool | `true` |
| `enableVad` | Bool | `false` |
| `vadThres` | Double | `50` |
| `wet` | Double | `0.0` |
| `release` | Double | `20.0` |

Full docs: https://wwmm.github.io/easyeffects/plugins/rnnoise.html


---

## Echo Canceller

The Echo is a reflected sound wave with sufficient magnitude and delay to be detectable as a signal distinct from the source one. An Echo Canceller is used to improve voice quality by preventing Echo from being created or removing it after it has been added to the source signal. Easy Effects uses the Echo Canceller from SpeexDSP library.
**Frame Size**

The amount of time in milliseconds to process at once. It is recommended to use a frame size in the order of 20 ms.
**Filter Length**

The amount of time of the Echo cancelling filter to use (also known as tail length). The recommended tail length is approximately the third of the room reverberation time. For example, in a small room, reverberation time is in the order of 300 ms, so a tail length of 100 ms is a good choice.

### References

- Wikipedia Echo Suppression and Cancellation (https://en.wikipedia.org/wiki/Echo_suppression_and_cancellation)
- Speex Acoustic Echo Canceller (https://www.speex.org/docs/manual/speex-manual/node4.html#SECTION00450000000000000000)

**Configurable properties (plugin ID `echo_canceller`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `enableEchoCanceller` | Bool | `true` |
| `echoCancellerMobileMode` | Bool | `false` |
| `echoCancellerEnforceHighPass` | Bool | `true` |
| `enableNoiseSuppression` | Bool | `true` |
| `noiseSuppressionLevel` | Enum | `1` (Choices: 0: `Low`, 1: `Moderate`, 2: `High`, 3: `VeryHigh`) |
| `enableHighPassFilter` | Bool | `true` |
| `highPassFilterFullBand` | Bool | `true` |
| `enableAGC` | Bool | `true` |

Full docs: https://wwmm.github.io/easyeffects/plugins/echocanceller.html


---

## Voice Suppressor

Very simple plugin that removes voice from audio. It calculates the correlation of the lefft and right channels in
the frequency domain. Frequencies whose correlation and phase difference are beyond the configured thresholds are attenuated.  
**Start**  
Frequencies below this value are not attenuated.  
**End**  
Frequencies above this value value are not attenuated.  
**Correlation**  
Frequencies are attenuated only if the correlation between left and right channel is at least equal to this value.  
**Phase Difference**  
Frequencies are not attenuated when the magnitude of phase difference between left and right channel is above this value.  
**Minimum Kurtosis**  
Frequencies with local kurtosis below this value are attenuated.  
**Maximum Instantaneous Frequency**  
This is related to the frequency of rotation of the complex vector that represents the correlation between the left and right channel at a given frequency.
In other words this measures how fast the phase difference between the left and right channels changes at a given frequency bin in the Fourier transform.
More attenuation is applied to the channels samples that have rotation frequency below this parameter value.  
**Inverted Mode**

Instead of suppressing voice the plugin will try to suppress the background and keep the voice.

**Configurable properties (plugin ID `voice_suppressor`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `freqStart` | Double | `20` |
| `freqEnd` | Double | `22000` |
| `correlation` | Double | `95` |
| `phaseDifference` | Double | `20` |
| `minKurtosis` | Double | `1` |
| `maxInstFreq` | Double | `1` |
| `invertedMode` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/voicesuppressor.html


---

## Speech Processor

This plugin allows EasyEffects to use the Speex preprocessor to attenuate disturbing background noises from a signal.
Compared to Noise Reduction which uses RNNoise to suppress noises, Speech Processor has the benefit of using less computational resources, at the cost of sacrificing noise suppression quality.
For more information on noise suppression in general, refer to the manual page on Noise Reduction.

### References

- The Speex Project (https://www.speex.org/)

**Configurable properties (plugin ID `speex`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |
| `inputGain` | Double | `0` |
| `outputGain` | Double | `0` |
| `enableDenoise` | Bool | `true` |
| `noiseSuppression` | Int | `-70` |
| `enableAgc` | Bool | `false` |
| `enableVad` | Bool | `false` |
| `vadProbabilityStart` | Int | `95` |
| `vadProbabilityContinue` | Int | `90` |
| `enableDereverb` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/plugins/speex.html


---
