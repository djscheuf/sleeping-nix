# Output, Encoders & Recording Formats

Settings → Output (Simple vs Advanced modes), encoder selection/property tables, rate control, containers/codecs. Sources: `kb/standard-recording-output-guide`, `kb/recording-encoder-presets-guide`, `kb/advanced-recording-settings-guide`, `kb/audio-video-formats-guide`, `kb/hybrid-mp4`, `kb/advanced-nvenc-options`, `kb/hardware-encoding`.

## Output modes

- **Simple**: one Video Bitrate + Audio Bitrate for streaming; Recording = path + format + quality preset + encoder. Fine for most streaming.
- **Advanced**: independent **Streaming** and **Recording** tabs (separate encoders, rate control, rescaling, per-track audio checkboxes), plus **Replay Buffer** and **Custom FFmpeg** outputs.

## Encoder landscape

| Encoder | Type | Linux availability |
|---------|------|--------------------|
| x264 | Software CPU | Always; best quality-per-bit at a cost |
| NVIDIA NVENC (H.264/HEVC/AV1) | Hardware | Yes — GeForce 750 Ti/900+; prefer 6th-gen NVENC (Turing+, GTX 1650 rev2+) |
| AMD AMF | Hardware | Yes (also via VAAPI where offered) |
| Intel QuickSync (QSV) | Hardware | Yes — Core i 2xxx+; only when it's the render GPU |
| VAAPI | Hardware (Intel/AMD via VA-API) | Linux-native option; quality below NVENC, near-zero perf cost |
| Apple VideoToolbox | Hardware | macOS only (no CBR on Intel Macs → x264 for streaming) |
| SVT-AV1 / libaom-av1 | Software AV1 | Yes; needs a very strong CPU for realtime |

Rule of thumb: use a hardware encoder for streaming (CPU headroom for the game/scene), x264 only when hardware quality is insufficient and CPU is spare. Prefer the encoder on the GPU doing the rendering.

## Rate control modes

| Mode | Behavior | Use for |
|------|----------|---------|
| CBR | Constant bitrate | **Streaming** — services expect it |
| VBR | Variable with target/max | Streaming when service tolerates; better quality at same avg bitrate |
| CQP / CRF / ICQ | Constant quality, variable size | **Recording** — quality target, file size floats |
| VBR+Target Quality (NVENC 31+) | CQP-like with max bitrate cap | High-quality recording with size limit |

## Recording quality presets (Simple mode)

| Preset | Behavior |
|--------|----------|
| Same as stream | Reuse stream encoder — zero extra cost; **can't pause** recordings |
| High Quality | Good quality, medium files |
| Indistinguishable | Higher quality, bigger files, more perf cost |
| Lossless | CPU encoder, ~7 GB/min |

## Baseline encoder settings (Advanced mode equivalents of "High Quality")

**NVENC**: CQP 16–23 (lower = better/bigger) · Keyframe 2 s · Preset P5 · Tuning High Quality · Multipass Two-Pass Quarter-Res · Profile High · Look-ahead Off · Adaptive Quantization On · B-frames 2.

**x264**: CRF 16–23 · Keyframe 2 s · CPU preset veryfast (slower = better quality, more CPU) · Profile High · Tune none.

**AMD AMF**: CQP 16–23 · Keyframe 2 s · Preset Quality · Profile High · Max B-frames 0.

**QuickSync**: ICQ 16–23 · TU4 · Profile High · Keyframe 2 s · Latency normal · B-frames 3.

Other shared options worth knowing: **Rescale Output** (record at different res than canvas), **Custom Encoder Settings** field for `key=value` overrides.

## NVENC advanced options (OBS 31+)

- **Tuning**: High Quality (default) / **Ultra High Quality** — for live-action noise sources, NOT gaming; big throughput hit.
- **Multipass**: Single / Two-Pass Quarter-Res / Two-Pass Full-Res — more analysis = better bitrate allocation.
- **Look-ahead**: Off/On — analyzes future frames (uses extra GPU; CUDA cores).
- **Adaptive Quantization** (renamed "Psycho-Visual Tuning"): improve perceptual quality — on.
- **B-Frames**: count 0–4; **B-Frame as Reference** (HEVC/AV1) improves quality free when using multiple B-frames.
- **Split Encode** (HEVC/AV1, Ada dual-NVENC GPUs 4070 Ti+): splits frame across engines for higher throughput; auto-engages >2160p on fast presets; possible seam at low bitrates.

### NVENC custom `option=value` pairs (Advanced encoder field, space-separated)

| Option | Meaning |
|--------|---------|
| `keyint=N` | Keyframe interval in frames (`1` = intra-only) |
| `frameIntervalP=N` | GOP pattern: 0=I, 1=IPP, 2=IBP, 3=IBBP |
| `gopLength=N` | GOP size (4294967295 = infinite; prefer `keyint`) |
| `constQP=N` or `<I>:<P>:<B>` | Fixed QP per frame type |
| `minQP`/`maxQP`(+`enableMinQP=1`/`enableMaxQP=1`) | QP bounds for rate control |
| `initialRCQP`(+`enableInitialRCQP=1`) | Initial QP hint |
| `averageBitRate` / `maxBitRate` | bps targets (max = VBR cap) |
| `vbvBufferSize` / `vbvInitialDelay` | VBV buffer/initial delay in bits (0 = default) |
| `targetQuality` | CQ-style target quality for VBR+TQ mode |

## Recording containers & codecs

**Recommendation**: MKV (default, crash-safe) or **Hybrid MP4/MOV** (crash-safe + editor-friendly). Never record direct to plain MP4 — unfinished files are unrecoverable.

| Container | Crash-safe | Editor support | Notes |
|-----------|-----------|----------------|-------|
| MKV | Yes | Poor — remux for editing | Holds every codec OBS supports |
| Hybrid MP4 (OBS ≥30.2, Win/Linux default) | Yes | Excellent | Fragmented write + soft-remux finalise |
| Hybrid MOV (OBS ≥32, macOS default) | Yes | Excellent | ProRes/ALAC/PCM support |
| Fragmented MP4/MOV | Yes | Good | Lossless audio may need remux |
| MP4/MOV | **No** | Excellent | Remux target only |
| FLV | Yes | Poor | RTMP container, 1 audio track, H.264/AAC only |
| MPEG-TS / HLS | Yes | TS good, HLS poor | Streaming-oriented |

Audio-in-container: AAC works everywhere; Opus/FLAC in MP4+MKV; ALAC in MP4/MOV; PCM in MP4/MOV/MKV (Hybrid MP4 PCM support is spotty — use Hybrid MOV). Video: H.264 = universal; HEVC = better compression, not in FLV; AV1 = best efficiency (needs recent GPU or huge CPU), weak editor support; ProRes = Mac professional path.

### Hybrid MP4/MOV extras

- **Chapter markers**: hotkey "Add chapter marker", websocket `CreateRecordChapter`, or `obs_frontend_recording_add_chapter()` — named markers for editing (lost on crash; written at finalise).
- **Muxer options** (space-separated `key=value` in Custom Muxer Options): `use_negative_cts=1` (default; B-frame timestamp handling), `write_encoder_info=1` (embed encoder JSON per track), `use_metadata_tags=1`, `skip_soft_remux=1` (debug only).

## Remuxing

File → **Remux Recordings** converts MKV→MP4 (or others) losslessly (stream copy, no re-encode). Settings → Advanced → **Automatically remux to mp4** does it on record-stop. Same path for making MKVs edit-friendly.

## Recording file settings

- **Recording Path** + **Generate File Name without Space** (Settings → Output).
- Filename tokens in Settings → Advanced → Filename Formatting (e.g. `%CCYY-%MM-%DD_%hh-%mm-%ss`); replay buffer prefix/suffix fields live there too.
- **Audio track selection** for recordings lives in Advanced → Recording tab — pair with track routing in `audio-configuration.md`.

## Replay Buffer

Settings → Output → Replay Buffer: enable + set **Max Replay Time** (seconds of RAM/VRAM kept). Save via button or hotkey (must bind hotkey in Settings → Hotkeys → Save Replay). `--startreplaybuffer` auto-starts.
