# Streaming & Performance Troubleshooting

Dropped frames / disconnects (network) vs. "encoding overloaded" / render lag (local). Distinguish first: **dropped frames = network**, **rendering/encoding lag = machine**. Sources: `kb/stream-connection-troubleshooting`, `kb/encoding-performance-troubleshooting`, `kb/gpu-selection-guide`.

## Diagnose which problem you have

| Symptom | Domain | Go to |
|---------|--------|-------|
| "Dropped frames", viewer buffering, disconnects | Network path to ingest | Connection section |
| "Encoding overloaded", skipped frames due to rendering lag, laggy preview | Local GPU/CPU | Performance section |
| Stuttering in OBS stats but stream fine | Preview/render lag | Performance section |

View Stats (docks → Stats) separates: rendering lag (GPU), skipped frames (encoder), dropped frames (network).

## Dropped frames / disconnections — connection checklist

In OBS:

1. **Try a different ingest server** (Settings → Stream → Server). Twitch + Windows: TwitchTest picks the best Quality score; test with Enhanced Broadcasting off or capped Max Streaming Bandwidth.
2. **Lower video bitrate** — target ~75% of stable upload speed, within service limits.
3. **Try a different service** — isolates provider-side issues.
4. **Network optimizations + TCP pacing** (Settings → Advanced → Network; Windows only) — also adds diagnostics to the log.
5. **Bind to IP → Default**.
6. **IP Family → IPv4 Only** (test; revert to IPv4+IPv6 if no change).
7. **Dynamic Bitrate (Beta)** — lowers bitrate under congestion instead of dropping frames; a mitigation, not a fix.

Outside OBS:

- **Security software** — whitelist OBS; test with it disabled.
- **VPNs** — test disabled.
- **OEM network software** — Lenovo Vantage "Network Boost", Killer NIC suite, etc. deprioritize OBS; disable features or uninstall.
- **Hardware** — prefer wired Ethernet over Wi-Fi; bypass/reboot the router; check cables; rule out powerline adapters.
- **ISP** — persistent instability after the above → contact ISP with TwitchTest/speedtest evidence.

## "Encoding overloaded" / render lag — performance checklist

OBS needs GPU headroom to composite scenes *and* (for hw encode) to feed the encoder. Order of attack:

1. **Windows: run OBS as administrator** — lets Windows reserve GPU capacity. (No Linux equivalent; renice/OOM niceness is marginal — reduce load instead.)
2. **Kill other GPU hogs** — background games, browsers with hardware accel, second OBS instances.
3. **Cap the game's framerate** — vsync or FPS cap at refresh rate; uncapped fps starves OBS. If still short, cap to match OBS output FPS.
4. **Lower in-game graphics** — frees GPU for OBS.
5. **Game Capture: disable Multi-Adapter Compatibility** (Windows) — only needed for SLI/CrossFire/multi-GPU laptops.
6. **Windows Game Mode/Game DVR** — disable Game DVR always; disable Game Mode on Windows 10 <1809.
7. **Reduce output demands** — lower Output (Scaled) Resolution; drop 60→30 fps; lower canvas resolution only as last resort (breaks layouts — do it in a fresh Scene Collection).
8. **Switch encoder** — x264 → NVENC/VAAPI/QSV offloads encode to the GPU; or pick a faster x264 preset.

### Scene complexity diet (render lag with modest hardware)

- Sources cost resources **even when hidden** (needed for smooth switching) — split heavy setups into separate Scene Collections.
- Don't run 4K webcam/media sources for a 720p output — set device resolution lower or use lower-res media.
- Prefer several small Browser/Media sources over fullscreen ones with empty space.
- Disable filters when testing; apply them to the smallest possible source (per-source, not whole scenes).
- Browser sources are the most expensive source type — consolidate, lower their FPS/width/height, replace static ones with Images.

## GPU selection quick reference

| Goal | GPU for OBS |
|------|-------------|
| Game/Window Capture | Same dGPU as the game (High Performance) |
| Display Capture | GPU driving that display (often iGPU = Power Saving) |

Windows: Graphics Settings → add `obs64.exe` → set mode, restart both. Linux/PRIME: `prime-run obs` or `DRI_PRIME=1`. Detail + caveats in `capture-troubleshooting.md`.

## Reading the OBS log

`~/.config/obs-studio/logs/` — look for: `Output 'adv_stream': Total frames encoded` vs dropped/skipped counters, `detected X% network lag`, `Encoding overloaded`, device-open failures at startup. Stats dock gives the same counters live.
