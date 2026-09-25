# Video (Effect) Filters — Property Reference

All effect filters available on all platforms. Add via right-click on a Source (or Scene) → Filters. Filters stack top-to-bottom per source; eye icon toggles each. Sources: `kb/filters-guide` + individual filter articles.

## Choosing between the keying filters

| Filter | Keys on | Best for |
|--------|---------|----------|
| Chroma Key | A specific color (green/blue/magenta/custom) | Green screens / webcams — includes spill reduction |
| Color Key | A specific color | Graphics, window captures, logos — no spill reduction |
| Luma Key | Lightness (luma) | Keying out white or black backgrounds |

## Crop/Pad

Crops or pads the **base source** — unlike transform cropping, affects every scene instance.

| Property | Description | Default |
|----------|-------------|---------|
| Relative | On = crop/pad by pixel counts; Off = absolute region | On |
| Left/Top/Right/Bottom | Pixels to crop per edge; **negative = pad** | 0 |
| X/Y | (Relative off) top-left point of visible region | 0/0 |
| Width/Height | (Relative off) visible region size | 0/0 |

## Chroma Key

| Property | Description | Default |
|----------|-------------|---------|
| Key Color Type | Color to remove (Green/Blue/Magenta/Custom) | Green |
| Similarity | Color-match threshold — higher removes more aggressively | 400 |
| Smoothness | Edge softness of removed area | 80 |
| Key Color Spill Reduction | Remove color fringing at edges (e.g. green halo in hair) | 100 |
| Opacity | 0.0 transparent – 1.0 opaque | 1.0 |
| Contrast / Brightness / Gamma | Adjust source | 0.0 |

## Color Key

Same as Chroma Key minus **Key Color Spill Reduction**: Key Color Type (Green), Similarity (400), Smoothness (80), Opacity (1.0), Contrast/Brightness/Gamma (0.0).

## Luma Key

| Property | Description | Default |
|----------|-------------|---------|
| Luma Max | Key out pixels brighter than this | 1.0 |
| Luma Max Smooth | Edge softness for bright removal | 0.0 |
| Luma Min | Key out pixels darker than this | 1.0 |
| Luma Min Smooth | Edge softness for dark removal | 0.0 |

(Lower Luma Max → removes white; raise Luma Min → removes black. Widen the Smooth values to soften edges.)

## Color Correction

| Property | Range | Default |
|----------|-------|---------|
| Gamma | -3.0 to 3.0 | 0.0 |
| Contrast | -4.0 to 4.0 | 0.0 |
| Brightness | -1.0 to 1.0 | 0.0 |
| Saturation | -1.0 to 5.0 | 0.0 |
| Hue Shift | -180.0 to 180.0 | 0.0 |
| Opacity | 0.0–1.0 (source transparency) | 1.0 |
| Color Multiply | Tint applied to light colors | #ffffff |
| Color Add | Color added into dark colors | #000000 |

## Apply LUT

Color grading via Look-Up Table (.png or .cube files).

| Property | Description | Default |
|----------|-------------|---------|
| Path | LUT file path | — |
| Amount | Grading strength 0.0 (off) – 1.0 (full) | 1.0 |

## Image Mask/Blend

Mask or blend the source against an image.

| Property | Description | Default |
|----------|-------------|---------|
| Type | Alpha Mask (Color Channel) / Alpha Mask (Alpha Channel) / blend modes (e.g. Additive, Subtract, Lighten…) | Alpha Mask (Color Channel) |
| Path | Mask/blend image | — |
| Color | Color used by mask/blend ops | #ffffff |
| Opacity | Image strength 0.0–1.0 | 1.0 |
| Stretch Image (discard aspect) | Stretch mask to source size | Off |

Color-channel mode: pixels matching the specified color = shown. Alpha-channel mode: image transparency maps to source transparency.

## Scaling/Aspect Ratio

| Property | Description | Default |
|----------|-------------|---------|
| Scale Filtering | Bicubic/Bilinear/Lanczos/Point/Area — overrides right-click Scale Filtering | Bicubic |
| Resolution | Force the source to a resolution or aspect ratio | None |
| Undistort centre from ultrawide | Keep center wide, compress edges (21:9→16:9 face cams etc.) | Off |

## Scroll

Infinite scroll — banners, repeating backgrounds, marquee text.

| Property | Description | Default |
|----------|-------------|---------|
| Horizontal Speed | Neg = left, pos = right | 0.0 |
| Vertical Speed | Neg = down, pos = up | 0.0 |
| Limit Width / Limit Height | Crop inward to a window before scrolling | Off |
| Width / Height | Cropped dimensions when limited | 100 |
| Loop | Repeat after scrolling off; Off = scroll once then gone | On |

## Sharpen

| Property | Description | Default |
|----------|-------------|---------|
| Sharpness | 0.0–1.0 sharpening amount | 0.08 |

Most useful on webcams and soft downscaled captures.

## Render Delay

| Property | Description | Default |
|----------|-------------|---------|
| Delay | Milliseconds to delay the source's video | 0 |

The primary tool for **video leads audio** sync problems (e.g. webcam ahead of mic). For audio-side delay use Advanced Audio Properties → Sync Offset (`audio-configuration.md`). Not available for Window/Display/Game Capture (use V4L2 Buffering or source properties there instead — actually the KB notes Video Delay filter isn't available for those sources).
