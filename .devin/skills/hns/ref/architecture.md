# hns Architecture

`hns` is implemented as a single module: `hns/cli.py`. The entry point `hns = "hns.cli:main"` is declared in `pyproject.toml`.

## High-level flow

1. **CLI entry** — Click parses arguments and dispatches to one of three paths:
   - `hns` → record + transcribe
   - `hns --last` → transcribe cached audio
   - `hns --list-models` → print valid models and exit
2. **Record** — `AudioRecorder` captures microphone audio via `sounddevice` and writes a mono 16-bit PCM WAV file to the platform cache directory.
3. **Transcribe** — `WhisperTranscriber` loads a `faster-whisper` model locally on the CPU (int8 quantization), applies VAD, and transcribes the WAV.
4. **Output** — `pyperclip` copies the result to the system clipboard; `click.echo` writes the transcription to **stdout**. Progress and errors go to **stderr**.

The stdout/stderr split is what makes `hns` composable: `$(hns)` captures only the transcription text.

## Core components

### AudioRecorder

| Responsibility | Detail |
| --- | --- |
| Capture | `sounddevice.InputStream` at 16 kHz, mono, float32 samples converted to int16 |
| Output | WAV file written to `<cache_dir>/last_recording.wav` |
| Feedback | Background thread prints elapsed recording time to stderr |
| Stop | Blocks on `input()`; press Enter to stop |

Cache directory (`HNS_CACHE_DIR` overrides this):

| Platform | Default path |
| --- | --- |
| macOS | `~/Library/Caches/hns/` |
| Linux | `~/.cache/hns/` |
| Windows | `~/AppData/Local/hns/Cache/` |

### WhisperTranscriber

| Responsibility | Detail |
| --- | --- |
| Model loading | `faster-whisper` `WhisperModel`, `device="cpu"`, `compute_type="int8"` |
| Model name | From `HNS_WHISPER_MODEL` or `--model`; defaults to `base` |
| VAD | `vad_filter=True`, `min_silence_duration_ms=500`, `speech_pad_ms=400`, `threshold=0.5` |
| Decoding | Beam search with `beam_size=5` |
| Language | Optional forcing via `HNS_LANG` or `--language` |
| Progress | Background thread shows elapsed transcription time on stderr |
| Output | Segments joined with spaces into one string |
| Invalid model | Falls back to `base` with a warning |

### Model download and caching

- The first time a model is used, `faster-whisper` downloads it from Hugging Face. This requires an internet connection.
- Before loading, `hns` checks whether the model is already cached by calling `faster_whisper.utils.download_model(..., local_files_only=True)`.
- Weights are stored by `faster-whisper` in the Hugging Face Hub cache (typically `~/.cache/huggingface/` on Linux; governed by `HF_HUB_CACHE` / `XDG_CACHE_HOME`).
- After the first download, transcription is fully offline.

### Output layer

1. `pyperclip.copy()` writes the transcription to the system clipboard.
2. `click.echo()` prints the transcription to stdout.

Clipboard errors are caught, warned on stderr, and do **not** abort the process.

## Threading model

- **Recording timer**: a daemon thread updates elapsed time on stderr while `sounddevice.InputStream` captures audio on its own callback thread.
- **Transcription progress**: transcription runs in a background thread so the main thread can display an elapsed-time counter. Results pass back through `queue.Queue`.

Both threads use `threading.Event` for clean shutdown.

## Dependencies

| Package | Role |
| --- | --- |
| `click` | CLI argument parsing |
| `sounddevice` | Microphone audio capture |
| `numpy` | float32 → int16 sample conversion |
| `faster-whisper` | Local Whisper inference (CTranslate2 backend) |
| `pyperclip` | Cross-platform clipboard access |
| `rich` | Styled stderr output |

[Source: https://hns-cli.dev/docs/architecture/ and https://github.com/primaprashant/hns/blob/main/hns/cli.py]
