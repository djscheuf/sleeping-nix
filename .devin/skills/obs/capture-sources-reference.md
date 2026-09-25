# Capture Sources — Property Reference

Per-source-type property tables. Sources: `kb/game-capture-source`, `kb/display-capture-sources`, `kb/window-capture-sources`, `kb/video-capture-sources`, `kb/image-sources`, `kb/media-sources`, `kb/virtual-camera-guide`, `kb/smartphone-camera-guide`.

**Linux note:** On Linux the relevant source names differ from Windows — X11 uses *Screen Capture (XSHM)* and *Window Capture (Xcomposite)*; Wayland uses *Screen/Window Capture (PipeWire)* via xdg-desktop-portal. There is **no Game Capture on Linux** — use Window or PipeWire display capture.

## Game Capture — Windows only

Direct capture of DirectX/OpenGL games; most efficient capture path. Not on Linux/macOS (use macOS Screen Capture, Window Capture, or PipeWire screen capture).

### Modes

| Mode | Behavior |
|------|----------|
| Capture any fullscreen application | Auto-detects the fullscreen game on the primary monitor. Single-monitor users: alt-tabbing stops game rendering → preview goes blank. |
| Capture specific window | Captures the selected window. Not for non-game windows (use Window Capture). |
| Capture foreground window with hotkey | Hotkey (Settings → Hotkeys) grabs the frontmost game — best when switching games mid-session. |

### Properties

| Property | Description | Default |
|----------|-------------|---------|
| SLI/Crossfire Capture Mode (Slow) | Memory capture instead of shared-texture capture; last resort only | Off |
| Allow Transparency | Show transparency instead of opaque black for transparent games/3D apps | Off |
| Limit capture framerate | Don't capture above OBS's output FPS | Off |
| Capture Cursor | Include mouse cursor (in-game rendered cursors always captured) | On |
| Use anti-cheat compatibility hook | Compat hook for anti-cheat games | On |
| Capture third-party overlays | Also capture Steam/etc. overlays if non-conflicting | Off |

## Screen/Display Capture

### Display Capture (Windows; macOS 10.15–12.6 only — deprecated on 13+)

One source per display; reuse the same source across scenes rather than creating duplicates.

| Property | Description | Default |
|----------|-------------|---------|
| Display | Which display to capture | Display 1 |
| Show Cursor | Include mouse cursor | On |
| Crop (macOS) | Crop region; can auto-fit a window but overlapping windows still captured | Off |

### Screen Capture (XSHM) — Linux/X11

| Property | Description | Default |
|----------|-------------|---------|
| Screen | Which display/X screen | — |
| Capture Cursor | Include mouse cursor | On |
| Crop Top/Left/Right/Bottom | Crop region | 0/0/0/0 |

### Screen/Window Capture (PipeWire) — Linux/Wayland

Wayland-only. Selecting the source opens the **desktop-portal dialog** each session to pick the screen/window; capture is delegated to PipeWire + xdg-desktop-portal. Also delivers a "restore token" so the portal prompt can be remembered. Cursor capture depends on the portal backend (GNOME/KDE both support it in recent versions).

### macOS Screen Capture — macOS 13+

Method = Display / Window / Application capture; can include desktop audio. Properties: Method, Display, Application, Window, Show windows with empty names, Show fullscreen/hidden windows, Show cursor.

## Window Capture

### Window Capture (Windows; macOS ≤12.6)

Only the selected window is shown even when occluded.

Windows properties:

| Property | Description | Default |
|----------|-------------|---------|
| Window | Window to capture | — |
| Capture Method | Automatic / BitBlt / Windows 10 — BitBlt is slower but helps some apps | Automatic |
| Window Match Priority | How to re-find the window if lost (match title vs. same type) | Match title, else same type |
| Capture Cursor | Include cursor | On |
| Multi-Adapter Compatibility | Shown for Win7 BitBlt method | Off |
| Client Area | Shown for Win10 method | On |

macOS properties: Window, Show windows with empty names (Off), Show window shadow (Off). On macOS prefer Display Capture — Window Capture is less performant.

### Window Capture (Xcomposite) — Linux/X11

| Property | Description | Default |
|----------|-------------|---------|
| Window | Window to capture | — |
| Crop Top/Left/Right/Bottom | Crop region | 0/0/0/0 |
| Swap red and blue | Fix swapped R/B channels | Off |
| Lock X server when capturing | X server locking | Off |

## Video Capture Devices (webcams, capture cards)

### Video Capture Device — Windows/macOS (DirectShow on Windows)

| Property | Description | Default |
|----------|-------------|---------|
| Device | Device to use | — |
| Deactivate/Active | Power the device on/off | — |
| Configure Video / Configure Crossbar | Open driver/device config utilities | — |
| Deactivate when not showing | Free resources when hidden; small reload delay on re-show | Off |
| Resolution/FPS Type | Device Default or Custom | Device Default |
| Resolution / FPS | Base res + framerate (unsupported values → black) | — |
| Video Format | Preferred format (MJPEG, XRGB, …) if device offers several | Any |
| Color Space / Color Range | Output color space/range | Default |
| Buffering | Enable → fixes stutter; Disable → fixes device delay | Auto-Detect |
| Flip Vertically | Fix upside-down devices | Off |
| Apply rotation data from camera | Honor camera rotation metadata | On |
| Audio Output Mode | Capture only vs. output to desktop audio | Capture only |
| Use custom audio device | Bind a *separate* audio device to this source (e.g. external mic on a webcam) | Off |
| Audio Device | Which device when custom audio enabled | — |

### Video Capture Device (V4L2) — Linux

| Property | Description | Default |
|----------|-------------|---------|
| Device | V4L2 device (`/dev/video*`) | — |
| Input | Device input | — |
| Video Format | Pixel format | YUYV 4:2:2 |
| Resolution | Base resolution | Leave Unchanged |
| Frame Rate | Device framerate | Leave Unchanged |
| Color Range | Output color range | Default |
| Buffering | On → fix stutter; Off → fix delay | On |
| Frames Until Timeout | Timeout threshold | 5 |

### Blackmagic Device — all platforms

Uses Blackmagic's SDK. Properties: **Device**, **Mode** (must match input res + frame rate), **Format** (must match media output), **Use Buffering** (helps low-resource systems / flaky drivers).

### AJA Device — all platforms

KB properties section is a TODO stub; exposes Device/Mode/Format selection similar to Blackmagic.

## Image / Image Slideshow — all platforms

Formats: bmp, tga, png, jpeg, jpg, gif (alpha honored).

**Image** properties: Image File; Unload image when not showing (Off — reload delay on re-show); Apply alpha in linear space (Off).

**Image Slide Show** properties:

| Property | Description | Default |
|----------|-------------|---------|
| Visibility Behaviour | Continue/pause/stop when hidden | Always play |
| Slide Mode | Automatic or hotkey-driven | Automatic |
| Transition | Animation between images | Fade |
| Time Between Slides (ms) | Dwell time per image | 8000 |
| Transition Speed (ms) | Animation length (≥50; capped by dwell) | 700 |
| Loop | Restart at end | On |
| + add files/directories | Shuffle/randomize option available | — |

## Media Source — all platforms

Types: video mp4/ts/mov/flv/mkv/avi/gif/webm; audio mp3/aac/ogg/wav.

| Property | Description | Default |
|----------|-------------|---------|
| Local File | File path | — |
| Loop | Replay on completion | Off |
| Restart playback when source becomes active | Rewind on re-show | On |
| Use hardware decoding when available | GPU decode if decoder exists | Off |
| Show nothing when playback ends | Hide instead of last frame | On |
| Close file when inactive | Unload when hidden (reload delay) | Off |
| Speed | 1%–200% playback speed | 100% |
| YUV Color Range | Partial/Full for the file | Partial |
| Apply alpha in linear space | — | Off |

Media sources expose play/pause/restart/stop/next/previous and seek controls (right-click or hotkeys) — see scripting file for media control procedures.

## VLC Video — all platforms (requires VLC installed)

Playlist-based media via VLC libraries (broader codec support than Media Source). Properties: Loop Playlist (On), Shuffle Playlist (Off), Visibility Behaviour (stop when not visible, restart when visible), plus playlist file/dir list, network URL entries.

## Other built-in sources (brief)

- **Browser** — renders a URL (alerts/chat/overlays) via embedded Chromium; set width/height/FPS/CSS; interact/refresh via right-click.
- **Color Source** — solid color block (width/height/color).
- **Text (FreeType 2 on Linux / GDI+ on Windows)** — text or text-file contents, font, size, color, gradient, outline, alignment, wrapping.
- **Audio Input/Output Capture, Application Audio Capture** — audio sources; see `audio-configuration.md`.

## Virtual Camera (output, not a source)

Shares the OBS output as a webcam to other apps (Zoom/Discord/etc.). On Linux it uses a **v4l2loopback**-style device — needs `v4l2loopback` kernel module (NixOS: `boot.extraModulePackages = [ v4l2loopback ]` + `boot.kernelModules = [ "v4l2loopback" ]`).

Modes (Controls dock → ⚙):
- **Program** — normal OBS output (default).
- **Preview** — Studio Mode preview (viewers see your edits — avoid).
- **Scene** — a fixed scene regardless of current output.
- **Source** — a fixed single source.

Auto-start with `--startvirtualcam`.

## Smartphone as camera (Linux-first ordering)

- **DroidCam** — the only option with Linux support: freemium, iOS/Android, USB+Wi-Fi, dedicated OBS plugin (up to 4K), webcam mode up to 1080p.
- **VDO.Ninja** — platform-agnostic: phone browser → URL → OBS **Browser Source** (no drivers).
- **NDI HX Camera** — phone→NDI on LAN + obs-ndi plugin.
- **Camo / EpocCam / Continuity Camera** — Windows/macOS only (Continuity is iPhone+macOS built-in).
