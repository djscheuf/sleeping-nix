# hns CLI Reference

## Usage

```bash
hns [OPTIONS]
```

Transcription is printed to **stdout**; status, progress, and warnings go to **stderr**.
This separation makes `hns` safe to pipe and capture: `$(hns)` only receives the transcribed text.

## Core options

| Option | Description |
| --- | --- |
| `--model`, `-m` | Whisper model to use. Defaults to `HNS_WHISPER_MODEL` env var or `base`. Must be one of the valid model names. |
| `--language <CODE>` | Force transcription language (e.g., `en`, `es`, `ja`). Overrides `HNS_LANG` for this run. |
| `--last` | Transcribe the cached `last_recording.wav` instead of making a new recording. |
| `--no-copy` | Do not copy the transcription to the clipboard. |
| `--quiet`, `-q` | Suppress status/progress output. Warnings and errors still print. |
| `--list-models` | List all supported Whisper models and exit. |
| `--version` | Show version and exit. |
| `--help` | Show help and exit. |

## Important notes

- `--language` takes precedence over `HNS_LANG`.
- `--model` takes precedence over `HNS_WHISPER_MODEL`.
- `--last` is useful when a prior run crashed or a downstream command failed: it re-transcribes the already-saved audio.

## Recording defaults

Audio is recorded with these fixed defaults:

- **Sample rate:** 16000 Hz
- **Channels:** 1 (mono)
- **Format:** 16-bit PCM WAV

The published docs mention `--sample-rate` and `--channels` options, but these are not exposed in the current CLI; the values above are hardcoded.

[Source: https://hns-cli.dev/docs/cli-reference/ and https://github.com/primaprashant/hns/blob/main/hns/cli.py]
