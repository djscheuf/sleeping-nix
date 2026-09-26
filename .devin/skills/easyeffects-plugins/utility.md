# Spectrum & Utility Plugins

Metering/analysis plugins with no audible processing.

## Spectrum

**Enabled**

Show or hide the Spectrum.
**Shape**

Choose the style of the animation.
**Points**

Number of points/bars on the x axis.
**Height**

Changes the height of the Spectrum.
**Line Width**

The width of a single bar.
**Fill**

Draw filled bars.
**Show Bars Border**

Draw bars with borders.
**Rounded Corners**

Draw bars with rounded corners.
**Color**

Choose the color of the Spectrum components.
**Minimum Frequency Range**

Lower end frequency of the Spectrum.
**Maximum Frequency Range**

Upper end frequency of the Spectrum.
Settings Menu (../user_interface/settingsmenu.html)

**Configurable properties (plugin ID `spectrum`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `state` | Bool | `true` |
| `dynamicYScale` | Bool | `true` |
| `logarithmicHorizontalAxis` | Bool | `true` |
| `spectrumShape` | Enum | `0` (Choices: 0: `Bars`, 1: `Lines`, 2: `Dots`, 3: `Area`) |
| `nPoints` | Int | `100` |
| `height` | Int | `140` |
| `minimumFrequency` | Int | `20` |
| `maximumFrequency` | Int | `20000` |
| `avsyncDelay` | Int | `0` |
| `spectrumFpsCap` | Int | `60` |

Full docs: https://wwmm.github.io/easyeffects/plugins/spectrum.html


---

## Level Meter

Internal per-app/per-device level meter used for UI VU displays (e.g. the saturation warning indicator). Not documented as a standalone user-facing plugin page.


**Configurable properties (plugin ID `level_meter`, via D-Bus/local server):**

| Property | Type | Default |
|---|---|---|
| `bypass` | Bool | `false` |

Full docs: https://wwmm.github.io/easyeffects/database/plugins_properties.html
