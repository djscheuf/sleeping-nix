# hns — local speech-to-text CLI

`hns` is the system's speech-to-text tool, installed via `pkgs.hns` in
`Framework/stt.nix` alongside `xclip` for clipboard integration. It records
from the mic, transcribes locally with Whisper (faster-whisper/ctranslate2),
prints the text to stdout, and copies it to the clipboard. 100% offline after
the first model download.

Docs: <https://hns-cli.dev/> · Source: <https://github.com/primaprashant/hns>

## Context

- Added 2026-10-04 as the successor to [[handy-push-to-talk|Handy]], which was
  removed after its global push-to-talk shortcut proved unfixable on GNOME
  Wayland. hns avoids that entire class of problems: it's a plain CLI invoked
  on demand, so no global hotkey daemon is needed — bind it to a
  compositor-level keybinding or shell alias if push-to-talk is wanted.
- Unlike upstream's recommended `uv tool install hns`, we use the nixpkgs
  package (`pkgs.hns`).

## Usage

```bash
hns                          # record, Enter to stop, transcription → stdout + clipboard
hns --last                   # re-transcribe ~/.cache/hns/last_recording.wav (crash recovery)
hns --language ja            # force language (ISO 639-1); overrides HNS_LANG
hns --list-models            # list available Whisper models
```

Recording defaults: 16 kHz mono (`--sample-rate`, `--channels` — don't change,
Whisper expects this).

## Configuration (env vars)

| Var | Purpose | Default |
|-----|---------|---------|
| `HNS_WHISPER_MODEL` | Whisper model | `base` |
| `HNS_LANG` | Force language (ISO 639-1) | auto-detect |

Model picks: `distil-large-v3.5` (best overall, ~1.5 GB), `large-v3` (max
accuracy, ~3 GB), `small` (fast, ~0.6 GB). Prefer `.en` variants for
English-only. Set `HNS_LANG=en` even for English — improves accuracy.

## Gotchas

- First run downloads the model from Hugging Face — needs network once.
- Clipboard needs `xclip` under X11/XWayland; on Wayland it may need
  `wl-clipboard` instead if clipboard copy misbehaves (untested here).
- Integration patterns (pipe to `claude`, `ollama`, `llm`, append to journal):
  see <https://hns-cli.dev/docs/use-cases/>.
