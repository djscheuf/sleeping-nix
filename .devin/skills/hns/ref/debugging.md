# Debugging hns

## First-run behavior

- The **first** transcription downloads the configured Whisper model. An internet connection is required.
- If the download is interrupted, delete the partial Hugging Face cache entry or retry with a smaller model first.
- After the model is cached, all transcriptions are fully offline.

## Common errors and fixes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `recording needs an interactive terminal` | stdin is not a TTY, e.g., inside a script or pipeline | Run `hns` interactively, or use `hns --last` to re-transcribe a previous recording. |
| `no audio input device available` | No microphone / sounddevice cannot see an input device | Check microphone permissions and that a recording device is selected in the OS. |
| `failed to initialize audio stream` | `sounddevice` / PortAudio issue | Verify microphone access; reinstall `sounddevice` dependencies. |
| `no audio recorded` | Microphone produced no frames | Check input volume and device selection; ensure the mic is not muted. |
| `transcription failed` | Model loading or inference error | Verify the model name with `hns --list-models`; try a smaller model; ensure enough RAM. |
| `no speech detected in audio` | VAD stripped everything or recording is silent / noisy | Re-record closer to the mic, reduce background noise, or check input levels. |
| `clipboard copy failed` (Linux) | Missing clipboard utility | Install `xclip`, `xsel`, or `wl-clipboard`. The transcription still prints to stdout. |
| `invalid model '<name>', using 'base'` | Unknown model name | Run `hns --list-models` and use an exact valid name. |

## Recovering from crashes

`hns` always saves the most recent recording to `<cache_dir>/last_recording.wav`.

If a run crashes during transcription (e.g., out of memory, model error, or downstream pipeline failure), retry without re-recording:

```bash
hns --last
```

This is especially useful in pipelines:

```bash
# If this fails after recording, you don't have to re-record
hns | llm "summarize this"

# Retry the transcription + pipeline
hns --last | llm "summarize this"
```

## Exit codes

| Exit code | Meaning |
| --- | --- |
| `0` | Success |
| `1` | Runtime or value error (e.g., no audio device, transcription failed, no speech detected) |
| `130` | Cancelled via `Ctrl+C` (`KeyboardInterrupt`) |
| `1` | Any unexpected error |

## Performance and resource notes

- `hns` runs Whisper on the **CPU only** with int8 quantization. There is no GPU support.
- RAM use scales with model size:
  - `tiny` / `base`: ~0.1–0.3 GB
  - `small`: ~0.6 GB
  - `distil-large-v3.5`: ~1.5 GB
  - `large-v3`: ~3 GB
- Transcription speed depends on CPU, model size, and recording length.

## Limitations

- Single-shot recording; press Enter to stop.
- No real-time/streaming transcription — recording must finish before transcription starts.
- No built-in config file; all configuration is via environment variables and CLI flags.
- `--sample-rate` and `--channels` are mentioned in the docs as CLI options but are not exposed in the current CLI; they are hardcoded to 16 kHz mono.
- Models are downloaded from Hugging Face on first use; offline use is possible only after caching.

## Reporting issues

If a problem persists, check the project issues and discussions:

- GitHub Issues: `https://github.com/primaprashant/hns/issues`
- GitHub Discussions: `https://github.com/primaprashant/hns/discussions`

[Source: https://hns-cli.dev/docs/cli-reference/ and https://github.com/primaprashant/hns/blob/main/hns/cli.py]
