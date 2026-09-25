---
name: obs
description: "Use this skill for any task involving OBS Studio (Open Broadcaster Software): scene collections, scenes, sources, filters, transitions, audio mixer tuning, encoders, streaming/recording output configuration, obs-websocket or Lua/Python scripting, and troubleshooting OBS. Triggers include: OBS, obs-studio, scene, scene collection, source, game capture, window capture, display capture, browser source, media source, video capture device, audio mixer, filter, chroma key, color correction, noise suppression, compressor, limiter, transition, stinger, encoder, x264, NVENC, VAAPI, Quick Sync, AMF, bitrate, rate control, stream key, RTMP, SRT, RIST, WHIP, recording format, replay buffer, virtual camera, obs-websocket, dropped frames, encoding overloaded, or any question about configuring or automating a local streaming/recording setup."
---

# OBS Studio Skill

## Overview

OBS Studio is a free, open-source application for video compositing, recording, and live streaming. It captures video/audio from devices, windows, games, files, and the network; composites them into scenes; and encodes the result to files (recording) or to streaming services (RTMP/SRT/RIST/WHIP) or a virtual camera.

Use this skill when you are:

- Configuring or editing OBS scenes, sources, filters, or transitions (via UI, config files, or API).
- Tuning audio: mixer tracks, filters, monitoring, sync offsets, multitrack/VOD routing.
- Choosing or tuning encoders, bitrates, rate control, recording formats.
- Setting up streaming to a service or a local ingest (SRT/RTMP/WHIP).
- Diagnosing black captures, dropped frames, encoding overload, or device conflicts.
- Automating OBS via scene-collection JSON, obs-websocket, or Lua/Python scripts.

## Mental model — the OBS object graph

```
Profile (video/audio/output settings)                Scene Collection
  └── basic.ini, service.json, streamEncoder.json      └── Scenes
                                                         └── Sources (each has settings,
Video output channel:                                        filters chain, transform,
  Scene composited at canvas resolution →                    position/scale/crop/rotation)
  downscale filter → output resolution →                   └── Groups (nested sources)
  per-track audio mixing → Encoders →                    └── current scene / program scene
    Outputs: Stream | Recording | Virtual Cam            └── Transitions (between scenes)

Audio (parallel): per-source tracks → source filters →
  Audio Mixer → monitoring device + output tracks → encoders
```

Key facts to orient on:

- **Profiles** hold output/encoder/video settings; **Scene Collections** hold layouts. They're independent — mix and match. Config root: `~/.config/obs-studio/` (Linux/macOS), `%APPDATA%\obs-studio` (Windows).
- **Everything visible is a source**, including scenes (scenes are sources → nest freely).
- **Sources are typed by platform**: `xcomposite_input`/`xshm_input`/`pipewire` capture on Linux, `game_capture`/`window_capture`/`monitor_capture` on Windows, `screen_capture` on macOS.
- **Audio flows through a global mixer** — every source with audio appears there; filters, monitoring, and track routing are per-source.
- **Encoders and outputs are configured per-Profile** in `basic.ini`, not in scene JSON.

## Quick reference

| Task | Where |
|------|-------|
| Config root (Linux) | `~/.config/obs-studio/` |
| Scene collections | `basic/scenes/*.json` — edit only while OBS is closed |
| Profiles | `basic/profiles/<name>/basic.ini`, `service.json`, `streamEncoder.json` |
| Logs / crash dumps | `logs/` / `crashes/` under config root |
| Headless/minimized recording | `obs --startrecording --minimize-to-tray` |
| Safe mode (no plugins/scripts/websocket) | `obs --safe-mode` |
| obs-websocket endpoint | `ws://localhost:4455` (built-in, OBS 28+) |

## Debugging entry points

| Symptom | Read first |
|---------|-----------|
| Black / empty game or window capture | [capture-troubleshooting](./capture-troubleshooting.md) |
| Infinite "hall of mirrors" in preview | capture-troubleshooting → Video feedback effect |
| Virtual camera missing / app can't see it | capture-troubleshooting → Virtual Camera |
| OBS crashes on launch or during capture | capture-troubleshooting → Known application conflicts |
| Dropped frames, disconnects, buffering | [streaming-performance-troubleshooting](./streaming-performance-troubleshooting.md) → Connection |
| "Encoding overloaded", render lag | streaming-performance-troubleshooting → Performance |
| Audio out of sync / drift | [audio-configuration](./audio-configuration.md) → Sync offsets |
| Mic too quiet/too loud, clipping | audio-configuration → Gain staging + filters-audio-reference |
| Wrong audio on a recording track | audio-configuration → Tracks/mixer |
| Stream refused / "invalid stream key" | [streaming-protocols](./streaming-protocols.md) |
| Recording file won't open / corrupt | [video-output-encoding](./video-output-encoding.md) → Formats |
| Capture lagging only on one game | capture-troubleshooting → per-game table |

## Progressive disclosure

Start with the guide that matches your immediate need:

- **[Getting started](./getting-started.md)** — install (Linux-first, incl. Nix/nixpkgs), profiles vs. scene collections, config layout, launch parameters, portable mode, shortcuts, first-run workflow.
- **[Scenes, sources & transforms](./scenes-sources-transforms.md)** — scene/source management, groups, transforms (crop, bounding box, alignment), aspect-ratio & canvas/output scaling, DVE-style positioning.
- **[Capture sources reference](./capture-sources-reference.md)** — per-source-type property tables: game/window/display/video capture, image, media, browser, text, color, virtual camera, smartphone.
- **[Transitions](./transitions.md)** — transition types and settings, duration/hotkeys, stingers, track mattes.
- **[Video filters reference](./filters-video-reference.md)** — property tables for every video filter: crop/pad, chroma/luma/color key, color correction, LUT, mask/blend, scaling, scroll, sharpen, render delay, upscale/blend.
- **[Audio filters reference](./filters-audio-reference.md)** — property tables for every audio filter: gain, noise gate, noise suppression (Speex/RNNoise/NVIDIA), expander, compressor, limiter, sidechain, VST, invert polarity.
- **[Audio configuration](./audio-configuration.md)** — mixer, global audio devices, per-app capture, multitrack recording, VOD track, surround, monitoring, sync offsets, PipeWire notes.
- **[Video output & encoding](./video-output-encoding.md)** — Simple vs. Advanced output, encoder property tables (x264, NVENC, VAAPI, QSV, AMF), rate-control modes, scaling filters, recording formats, replay buffer.
- **[Streaming protocols & layouts](./streaming-protocols.md)** — transcoding vs. local ingest, RTMP/SRT/RIST/WHIP setup, stream layouts (game/alerts/BRB), video-call streaming.
- **[Capture troubleshooting](./capture-troubleshooting.md)** — black captures, per-game quirks, app conflicts, multi-GPU, virtual camera, feedback loops.
- **[Streaming & performance troubleshooting](./streaming-performance-troubleshooting.md)** — dropped frames vs. encoding lag, connection checklist, GPU-selection guide, scene-complexity diet.
- **[Scripting & automation](./scripting-automation.md)** — three paths: scene-collection JSON editing, obs-websocket live control, in-process Lua/Python scripts with lifecycle exports.

## Which path should I use?

```
Need to change what viewers see (layout, overlays, text)?
  → scenes-sources-transforms + capture-sources-reference (+ filters references)

Need to change quality, bitrate, encoder, or file format?
  → video-output-encoding

Need to fix audio levels, noise, sync, or track routing?
  → audio-configuration + filters-audio-reference

Need to go live to a service or another OBS instance?
  → streaming-protocols

Something is broken?
  → debugging entry points table above → the right troubleshooting file

Need to automate / drive OBS without the GUI?
  → scripting-automation (JSON offline, websocket live, scripts in-process)
```

## Remember

- Scene collections are plain JSON — an agent can generate or edit them, but only while OBS is not running (it overwrites on exit).
- obs-websocket is the supported way to manipulate a *running* instance; the password lives in `plugin_config/obs-websocket/`.
- On Linux/Wayland, capture is PipeWire-portal based and permissions are per-dialog; on X11, Xcomposite/XSHM. Many "capture is black" issues are Wayland permission or multi-GPU mismatches — check the troubleshooting files before assuming a bug.
- Most performance issues are GPU headroom: OBS composites on the GPU *and* (for hardware encoders) encodes there. Cap game framerate first.
