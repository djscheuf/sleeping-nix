# Scenes, Sources & Transforms

How OBS composes output, and how to place/size/crop sources. Sources: `kb/sources-guide`, `kb/aspect-ratio-guide`, `kb/dve-animating-sources-tutorial`, `kb/obs-studio-overview`.

## Core model

- **Scene** = a composited canvas containing an ordered stack of **Sources**. A scene is itself a source and can be nested in other scenes (see DVE below).
- **Source** = anything that produces video and/or audio: capture inputs, images, media, text, browser pages, other scenes, groups.
- **Global namespace**: all scenes and sources share one namespace — a source and a scene cannot have the same name.
- **Z-order**: Sources dock list order = draw order. Higher in the list = drawn on top. Reorder by drag or the up/down arrows (Ctrl-Up/Down/Home/End).
- **Visibility**: eye icon toggles source visibility; hidden sources are not rendered. Same mechanism works on filters.

## Source types (add via Sources dock `+`)

| Source | What it captures/shows | Platform notes |
|--------|------------------------|----------------|
| Audio Input/Output Capture | Mic/desktop audio | Desktop audio via PipeWire/Pulse on Linux |
| Application Audio Capture | Per-app audio (see `audio-configuration.md`) | |
| Browser | Web page (alerts, chat, overlays) | CEF-based |
| Color Source | Solid color block | |
| Display Capture | Entire monitor | Linux: X11 native; Wayland uses PipeWire portal |
| Game Capture | Hardware-accelerated games | **Windows only**; Linux use Window/Display Capture or PipeWire capture |
| Group | Folder of sources sharing a transform | |
| Image / Image Slideshow | Static images or slideshow | |
| Media Source | Audio/video file; playlist if VLC installed | |
| Scene | Another scene (nesting) | |
| Text (FreeType 2 / GDI+) | Styled text, optionally from file | FreeType 2 on Linux |
| Video Capture Device | Webcam, capture card, Blackmagic | V4L2 on Linux |
| Window Capture | Single window | X11 native on Linux; Wayland needs PipeWire portal |
| (macOS) macOS Screen Capture | Display/window/app incl. desktop audio | macOS 13+ only |

Detailed per-source properties → `capture-sources-reference.md`.

## Positioning & sizing

- Selecting a source shows a red **bounding box**; drag to move, drag handles to resize (snaps to edges/other sources — hold Ctrl to disable snapping).
- **Edit Transform** (Ctrl-E, or right-click → Transform) is the precise path: position, size, rotation, alignment, crop values, bounding-box type.
- Preview hotkeys: Ctrl-F fit, Ctrl-S stretch, Ctrl-D center, Ctrl-R reset; arrows nudge.

## Cropping

- Alt + drag a bounding-box edge (edges turn green), or exact pixel values in Edit Transform.
- Crop removes content **before** scaling — cheaper and sharper than scaling down.

## Aspect ratio & scaling strategy

- Target **16:9** (1920x1080 or 1280x720); it's what Twitch/YouTube and most displays expect.
- Non-16:9 content: prefer filling letterbox space with overlays/cameras rather than stretching (Shift-drag warps and looks bad) or pan-and-scan (scale up past canvas edges, losing content).
- **Integer scaling** for pixel-art/retro sources: double/halve dimensions via Edit Transform to keep sharpness.

### Per-source Scale Filtering (right-click source → Scale Filtering)

| Filter | Best for |
|--------|----------|
| Bilinear | General; slight softness |
| Bicubic | Sharper downscale of photos/video |
| Area | Downscaling; good detail retention |
| Point | Pixel-art/retro — preserves hard edges |
| Lanczos | Sharpest general-purpose, slight ringing |

Blurry source → try Bicubic/Lanczos; pixel art → Point or Area.

## Canvas vs output resolution

- **Base (Canvas) Resolution** (Settings → Video): the coordinate space sources are laid out in. Match the monitor/game being captured. Changing it misaligns existing source layouts.
- **Output (Scaled) Resolution**: what the stream/recording encodes (e.g. 1080p canvas → 720p output via the selected downscale filter). Changing it does not affect layout.

## Groups & nested scenes

- **Group**: bundles sources so they can be moved/hidden together; group has its own crop/transform relative to children.
- **Scene-as-source**: add a Scene source to reuse a layout inside multiple scenes; edits to the nested scene propagate everywhere it's used.

## DVE — animating sources with show/hide transitions

Real-time Digital Video Effects (slide-in cams, picture-in-picture reveals) via nested scenes + per-source show/hide transitions:

1. **Crop scene**: create a scene, add a Crop/Pad *filter to the scene itself* (Scenes dock → Filters), uncheck Relative, set target W/H (e.g. 1080x1080).
2. **Position scene** (optional, for animating placement): add the crop scene as a Scene source, position it.
3. In the presentation scene, add the crop (or position) scene as a **Scene source**.
4. Right-click that source → set **Show Transition** and **Hide Transition** — the transition is confined to the source's bounds. Fade and Luma Wipe look best inside a crop.
5. Trigger with the eye icon or a hotkey (same key for show+hide acts as a toggle).

This is how multi-cam slide-ins and reveal animations are built without third-party plugins.
