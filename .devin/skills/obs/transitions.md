# Scene Transitions

How scenes swap in the Program output. Sources: `kb/obs-studio-overview`, `kb/track-matte-stinger-transitions`, `kb/dve-animating-sources-tutorial`.

## Transition types

Set the default transition + duration in the **Scene Transitions** dock (`+` to add others; duration in ms). Built-ins:

| Transition | Behavior |
|------------|----------|
| Cut | Instant switch (default 0 ms) |
| Fade | Crossfade between scenes |
| Swipe | Scene wipes across in a direction |
| Slide | Scenes slide past each other |
| Fade to Color | Fade through a chosen color |
| Luma Wipe | Wipe driven by a luminance mask image |
| Stinger | Video overlay plays over a cut (below) |

- **Quick Transitions** (Studio Mode): extra transitions bound to buttons/hotkeys for one-shot use without changing the default.
- Transitions apply to **scene switches** only; per-source show/hide animations are separate (see DVE below).

## Stinger transitions

A video (with alpha, e.g. WebM/MOV) that plays fullscreen over a scene cut. The cut happens at a **cut point**; the overlay covers the swap.

Modes (select in the stinger's properties):

| Mode | How the cut is timed |
|------|----------------------|
| Milliseconds cut point | Cut at N ms into the video |
| Frame number cut point | Cut at frame N |
| Track Matte (OBS ≥27) | No cut point — an animated mask video drives the transition |

### Track Matte stingers

A second "mask video" controls where the old vs new scene shows at each moment:

- **Black pixels** → show the *current* (from) scene.
- **White pixels** → show the *next* (to) scene.
- **Grays** → crossfade blend between them (e.g. a soft-edged circle reveal).

Layouts — matte must be bundled **in the same video file** (separate files disabled: no lock-step decode):

- **Side-by-side**: stinger left, matte right. 1920x1080 content → 3840x1080 file.
- **Stacked**: stinger top, matte bottom → 1920x2160 file.

Combine two videos with ffmpeg:

```bash
ffmpeg -i left.mp4 -i right.mp4 -filter_complex hstack output.mp4   # side-by-side
ffmpeg -i top.mp4 -i bottom.mp4 -filter_complex vstack output.mp4   # stacked
```

Free sample track-matte stingers: `cdn-fastly.obsproject.com/downloads/TrackMatteStingers.zip`.

Other stinger properties: video file, audio monitoring/fade options, scene-switch timing relative to the cut point (transition point type above).

## Per-source show/hide transitions (DVE)

Sources inside a scene can animate in/out independently: right-click a source (typically a nested Scene source) → **Show Transition** / **Hide Transition**. The animation is clipped to the source's bounds, so Fade and Luma Wipe read best. Trigger via the eye icon or hotkeys. Full recipe in `scenes-sources-transforms.md` → "DVE".

## In scene-collection JSON

Transitions and their duration are stored in the scene collection file (`basic/scenes/<name>.json` under `~/.config/obs-studio/`), so they can be scripted/edited while OBS is closed — see `scripting-automation.md` and `getting-started.md` → config layout.
