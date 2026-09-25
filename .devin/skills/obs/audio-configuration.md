# Audio Configuration & Tuning

Mixer, devices, monitoring, tracks, sync, and platform audio capture. Sources: `kb/audio-mixer-guide`, `kb/application-audio-capture-guide`, `kb/multiple-audio-track-recording-guide`, `kb/twitch-vod-track-guide`, `kb/surround-sound-guide`.

## Audio Mixer anatomy

Each mixer entry: source name, **fader** (dB volume), **volume meter**, **mute** button, **monitor** button, and gear icon → Filters / Advanced Audio Properties.

### Reading the meters

| Zone | What belongs there |
|------|--------------------|
| Red | Nothing sustained — near clipping; speech may touch the low end |
| Yellow | Speech (upper end); gameplay/content (lower end) |
| Green | Background music, alert sounds |

Meter indicators: **peak program bar** (moving, decaying; decay rate in Settings → Audio), **VU black dots** (perceived loudness), **top dot** (20 s peak — clipping check), **bottom dot** (live level). Meter count follows the channel count configured in Settings → Audio.

### Channels

- Mono sources play centered for viewers.
- Stereo: left/right meter pair. One channel lighting only → viewers hear it on one side; fix with **Downmix to Mono** in Advanced Audio Properties.
- Surround (3+): FL, FR, FC, LFE, RL/SL, RR/SR. OBS auto-downmixes to stereo unless a surround layout is configured.

## Gain staging order (set levels in this sequence)

1. **At the device** — mic gain knob, console/app volume, mixer master.
2. **OS mixer** — PipeWire/Pulse app volumes *do* affect what OBS hears; keep capture device input near 0 dBFS to avoid clipping.
3. **OBS fader** — final trim only; Advanced Audio Properties allows >100% (custom % values).
4. Verify by **recording a real session** and listening back — don't trust meters alone.

Mics naturally sit quieter than generated audio; balance by lowering music/game, not by maxing mic.

## Advanced Audio Properties (Edit → Advanced Audio Properties)

Per-source controls:

| Setting | Use |
|---------|-----|
| Volume (%) | Fader beyond 100% if needed |
| Balance / Pan | L-R placement |
| **Sync Offset (ms)** | Delay audio to fix A/V sync — positive = audio later. Use when audio *leads* video; if video leads use Render Delay filter (`filters-video-reference.md`) |
| Monitoring | Monitor Only (mute output) / Monitor and Output — needs a monitoring device set in Settings → Audio |
| Tracks 1–6 checkboxes | Which output tracks carry this source |
| Downmix to Mono | Collapse stereo→mono |
| Mix down to mono w/ surround | For multichannel sources |

## Audio device routing

- Settings → **Audio**: sample rate; up to 2 **Global** desktop devices + 3 mic/aux devices; monitoring device; meter decay; PTT/PTM enable.
- Global Audio Sources are stored in the **Scene Collection** (not the Profile) — they follow collections on import/export.
- Per-source captures (Application Audio Capture, Audio Input/Output Capture sources) can be used *instead of* global devices; if doing so, set the corresponding global device to **Disabled** to avoid doubled audio.

## Application Audio Capture

- **Windows**: native source since OBS 28 — captures one app's audio as its own source. Window-match priority: by type (most apps) or by executable name (Chrome/Spotify — titles change). OBS ≥30.1 also offers **Capture Audio** checkbox inside Window/Game Capture.
- **Linux**: per-app capture via PipeWire/PulseAudio — OBS 30+ ships an *Application Audio Capture (PipeWire)* source on builds with Pulse support; otherwise route apps through a virtual device (PipeWire `pactl load-module module-null-sink`, or a Patchbay like qpwgraph) and capture that as an Audio Output Capture source.
- **Windows fallback**: VB-Cable virtual cable + Windows Volume Mixer per-app routing → Audio Input Capture of `CABLE Output` (KB has step-by-step).
- **macOS**: Desktop audio capture requires macOS 13+ Screen Capture method or third-party tools (`kb/macos-desktop-audio-capture-guide`).

## Multi-track recording

For post-production editing, split sources onto separate tracks:

1. Advanced Audio Properties → check which tracks (1–6) each source writes to.
2. Keep **everything also on track 1** — normal players only play track 1; track 1 = the "listenable" mix.
3. Settings → Output → Recording tab → check the audio tracks to actually record.
4. Container must hold multiple audio tracks (MKV/MP4 fine).

## Twitch VOD track

Send different audio live vs. to the VOD (strip music from VODs):

1. Settings → Stream → connect Twitch account.
2. Settings → Output → **Enable Custom Encoder Settings** → tick **Twitch VOD Track**.
3. Advanced Audio Properties: track 1 = live mix, track 2 = VOD mix (e.g. exclude Music from track 2). Tracks 3–6 still free for recording splits.

## Surround sound

- Settings → Audio → Channels: pick the layout matching the source (4.0/5.1/7.1 — mismatch triggers auto-rematrixing that mixes/drops channels). Restart OBS after changing.
- Advanced output mode unlocks higher audio bitrates (up to 1024 kbps). Rule of thumb: **64 kbps × channel count** ≈ CD quality; 160 kbps stereo default is too low for surround.
- Recording: Standard mode = AAC; Custom FFmpeg unlocks libopus (up to 255 channels with `mapping_family=255`), native aac, uncompressed pcm (e.g. `pcm_s24le`).
- Live surround tested working: Twitch, FB Live 360 (ambisonics, AAC required), YouTube Live (5.1 only, TVs). FB Live downmixes. Servers: wowza, nginx-rtmp (but server-side recording keeps only first 2 channels).

## Linux/PipeWire notes (this host)

- `services.pipewire.enable = true` — OBS sees PulseAudio-compat devices. Desktop audio = monitor of the default sink.
- Devices appearing as "PulseAudio" entries is normal on PipeWire.
- No audio at all → check `pavucontrol`/gnome settings that OBS's capture stream isn't muted and device profile is correct; OBS log (`~/.config/obs-studio/logs/`) shows which devices it opened.
- Wayland sessions: screen capture comes through PipeWire portal (see `capture-sources-reference.md`); audio capture is unaffected.
