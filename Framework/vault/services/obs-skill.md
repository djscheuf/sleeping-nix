# OBS Studio skill

**Bottom line:** a context-engineered Devin skill for OBS Studio lives at
`.devin/skills/obs/` (13 files). Agents working on OBS scenes, audio, encoders,
streaming, or OBS automation should invoke it — do not re-scrape the OBS docs.

Created: 2026-09-25. Source material: `obsproject.com/kb` (end-user KB) plus
selective `docs.obsproject.com` (scripting API shapes). **Gotcha:** the URL
`docs.obsproject.com` is the *developer/plugin C-API* reference — end-user
configuration docs are at `obsproject.com/kb`.

## Layout

```
.devin/skills/obs/
├── SKILL.md                                  # index: object model, quick ref, symptom→file table
├── getting-started.md                        # install, profiles vs scene collections, config layout, launch params
├── scenes-sources-transforms.md              # scenes/sources/groups/transforms, canvas vs output scaling
├── capture-sources-reference.md              # per-source-type property tables
├── transitions.md                            # transition types, stingers, track mattes
├── filters-video-reference.md                # every video filter, property tables
├── filters-audio-reference.md                # every audio filter, property tables
├── audio-configuration.md                    # mixer, tracks, VOD track, monitoring, sync offsets
├── video-output-encoding.md                  # encoder tables (x264/NVENC/VAAPI/QSV/AMF), rate control, formats
├── streaming-protocols.md                    # RTMP/SRT/RIST/WHIP, layouts
├── capture-troubleshooting.md                # black captures, app conflicts, multi-GPU, vcam
├── streaming-performance-troubleshooting.md  # dropped frames vs encoding lag, GPU selection
└── scripting-automation.md                   # JSON edit / obs-websocket / Lua+Python scripts
```

## Facts worth knowing without opening the skill

- **Config root:** `~/.config/obs-studio/` on Linux. Scene collections are
  `basic/scenes/*.json`; profiles are `basic/profiles/<name>/basic.ini`.
  Edit scene JSON **only while OBS is closed** — it overwrites on exit.
- **Automation:** obs-websocket is built into OBS ≥28 at `ws://localhost:4455`;
  password lives in `plugin_config/obs-websocket/`.
- **Nox specifics:** GNOME **Wayland** session → display/window capture goes
  through PipeWire/xdg-desktop-portal (permission dialog per session; a denied
  or stale grant = silent black frame). On X11 it would be Xcomposite/XSHM.
  Virtual camera needs the `v4l2loopback` kernel module in NixOS config.
  GPU is AMD Radeon 780M → hardware encode path is **VAAPI** (or `ffmpeg_vaapi`),
  not NVENC.
- **Same as Handy lesson:** Wayland silently breaks things that "just work" on
  X11 — check PipeWire/portal permissions and `XDG_SESSION_TYPE` before assuming
  an OBS bug. See `incidents/handy-push-to-talk.md` for the same class of issue.

## Maintenance

- Property tables were distilled from KB articles current as of 2026-09; OBS
  releases (roughly quarterly) may add filters/encoders — spot-check against the
  running OBS version when a table seems to be missing an option.
- If the skill grows > ~300 lines/file, split further; keep `SKILL.md`'s
  symptom table in sync when adding troubleshooting pages.
