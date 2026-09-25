# Streaming Protocols & Layouts

Stream service configuration, protocol options, transcoding, and reference scene layouts. Sources: `kb/transcodes-transcoding`, `kb/srt-protocol-streaming-guide`, `kb/rist-protocol-streaming-guide`, `kb/whip-streaming-guide`, stream layout tutorials 1–3, `kb/video-call-streaming-tutorial`.

## Service configuration

Settings → **Stream**: pick a Service (Show All Services for the full list) or **Custom** for a raw server URL; enter the **Stream Key** (the service's broadcaster secret — get it from the provider's dashboard or "Get Stream Key"). Connected-account login (e.g. Twitch OAuth) unlocks extras like the VOD track.

## Transcoding (platform-side)

Transcoding = the service re-encoding your single feed into multiple quality options for viewers.

- **Twitch**: tiered — Partners guaranteed; Affiliates "as available with priority"; others best-effort.
- **YouTube**: always transcodes all streams (including source feed).
- **Facebook**: varies.
- For smooth "Auto" quality switching on the viewer side, keep a **consistent keyframe interval** (2 s) — don't enable adaptive/scenecut i-frames, and stay within the platform's recommended keyframe interval.

## SRT (Secure Reliable Transport)

UDP-based, FEC/ARQ recovery for lossy links. Any FFmpeg-supported MPEG-TS URL works (srt, udp, tcp, rtp).

**Send (Settings → Stream → Custom)**: `srt://IP:PORT?option=value&...`, no stream key needed.

Key options:
- `latency=<μs>` — recovery window; default 120000 (120 ms); should be ≥ 2.5× RTT. 1 s → `latency=1000000`.
- `mode=caller|listener|rendezvous` — default caller. To stream *to* a local VLC, OBS acts as server: `srt://127.0.0.1:PORT?mode=listener` and point VLC at `srt://127.0.0.1:PORT`.

**Receive**: Media Source → uncheck Local File → Input `srt://IP:PORT` (add `mode=listener` if the encoder calls OBS; add `timeout=5000000` for flaky reconnects) → Input Format `mpegts`. VLC source also works (caller mode only).

## RIST (Reliable Internet Stream Transport)

**Send**: `rist://IP:PORT?cname=OBS&bandwidth=5000` — `cname` is a log label; `bandwidth` = max expected kbps for packet-resend headroom. Recommended: `bandwidth` ≈ total A+V bitrate × 2 (tolerates ~50% loss); `buffer` = 4–7× ping RTT (ms); `session-timeout` also tunable.

**Receive**: Media Source (Main Profile) or VLC (Simple Profile only). Remote sender → `rist://SERVER:PORT?cname=OBS&bandwidth=5000`; sender on the same machine → `rist://@LOCAL_IP:PORT?...` (@ = receiver's own address). Input Format `mpegts`.

## WHIP (WebRTC-HTTP Ingestion)

Sub-second (~100 ms) latency streaming over WebRTC. Service = **WHIP** in Settings → Stream; Server URL + **Bearer Token** (WHIP's stream-key equivalent). Providers: Cloudflare, Twitch, Dolby OptiView, Red5, Tencent, Broadcast Box, Stage TEN.

- Enables AV1/HEVC/Opus streaming, E2E encryption, network roaming (Wi-Fi↔cellular).
- **Linux note**: WHIP missing in Ubuntu 24.04 PPA builds — use Flatpak. Nixpkgs obs-studio builds include WebRTC/WHIP when `libdatachannel` is present.
- **Simulcast (OBS ≥32.1)**: send 1–4 encoded layers so viewers pick quality without server-side transcode. Configured in Settings → Stream. Layer ladders: 2 = 100%+50%; 3 = 100%+66%+33%; 4 = 100%+75%+50%+25% (of global resolution/bitrate).

## Streaming vs Recording in parallel

Advanced output mode gives Streaming and Recording independent encoders/bitrate — e.g. stream NVENC 6000 kbps CBR while recording NVENC CQP 16. "Same as stream" recording preset reuses the stream encoder for free (but disables pause).

## Reference stream layouts (tutorial patterns)

Typical scene set for a game stream collection: **Starting Soon**, **Gameplay**, **BRB**, **Ending**.

**Game screen (Tutorial 1)**
1. Scene "Game": Game Capture / Window / Display source → Edit → Transform → Fit to Screen (Ctrl-F).
2. Webcam: Video Capture Device; Edit Transform → Bounding Box Type *Maximum size only* — 16:9 cam ≈ 480x270 or 640x360; 4:3 ≈ 360x270 or 480x360; park in a corner with margin.
3. Mixer: pull Desktop Audio down below mic level; optional Compressor sidechain ducking (`filters-audio-reference.md`).

**Alerts & chat (Tutorial 2)**: Browser Sources pointing at alert/chat widget URLs (Streamlabs/StreamElements/etc.) layered above the game; keep in a nested scene to reuse across scenes.

**BRB (Tutorial 3)**: dedicated scene — backdrop (Color/Image or looping Media Source), scrolling marquee text via Scroll filter, plus a Music source routed only to stream track.

## OBS content inside video calls

Two approaches:

- **Virtual Camera** — simplest: OBS output appears as a webcam (needs v4l2loopback on Linux). See `capture-sources-reference.md`.
- **Projector + monitor capture** (pre-virtualcam pattern): Fullscreen Projector (Preview/Program) on a second display → share that screen; audio via virtual cable: set OBS Settings → Audio → **Monitoring Device** to the cable input, set the call app's mic to the same device, then in Advanced Audio Properties set wanted sources to **Monitor and Output** (uncheck "Active Sources Only" to configure all). Monitor Only = call-only; Monitor Off = stream-only.
