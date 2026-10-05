# Configuring hns

`hns` is configured through environment variables. There is no config file.

## Environment variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `HNS_WHISPER_MODEL` | `base` | Whisper model to load for transcription. |
| `HNS_LANG` | (auto-detect) | Force a transcription language using an ISO 639-1 code. |
| `HNS_CACHE_DIR` | platform default | Override the directory where `last_recording.wav` is saved. Used for `--last` recovery. |

Set them in the current session or add them to your shell config (`~/.bashrc`, `~/.zshrc`, `~/.config/fish/config.fish`).

## Model selection

```bash
export HNS_WHISPER_MODEL="distil-large-v3.5"
hns
```

### Available models

Hosted on Hugging Face by Systran and other contributors.

| Model | Size | Type |
| --- | --- | --- |
| `tiny.en` | ~75 MB | English only |
| `tiny` | ~75 MB | Multilingual |
| `base.en` | ~145 MB | English only |
| `base` | ~145 MB | Multilingual |
| `small.en` | ~484 MB | English only |
| `small` | ~484 MB | Multilingual |
| `medium.en` | ~1.53 GB | English only |
| `medium` | ~1.53 GB | Multilingual |
| `large-v1` | ~3.09 GB | Multilingual |
| `large-v2` | ~3.09 GB | Multilingual |
| `large-v3` | ~3.09 GB | Multilingual |
| `large` | ~3.09 GB | Multilingual |
| `distil-large-v2` | ~1.51 GB | Multilingual |
| `distil-medium.en` | ~789 MB | English only |
| `distil-small.en` | ~332 MB | English only |
| `distil-large-v3` | ~1.51 GB | Multilingual |
| `distil-large-v3.5` | ~1.51 GB | Multilingual |
| `large-v3-turbo` | ~1.62 GB | Multilingual |
| `turbo` | ~1.62 GB | Multilingual |

Invalid model names fall back to `base` with a warning.

### Model recommendations

- **Best overall:** `distil-large-v3.5` — accuracy near `large-v3`, ~1.5 GB RAM, ~6× faster.
- **Maximum accuracy:** `large-v3` — highest accuracy, ~3 GB RAM, slower.
- **Fast & light:** `small` — ~0.6 GB RAM, 3–4× faster than `distil-large-v3.5`.
- **Featherweight:** `tiny` — smallest/fastest, useful when memory is constrained.
- **English-only users:** prefer `.en` variants (e.g., `small.en`) for better accuracy and speed than multilingual equivalents.

## Language selection

Force a language to improve accuracy over Whisper auto-detection.

```bash
export HNS_LANG="en"
hns
```

Use an ISO 639-1 two-letter code. Examples:

| Code | Language | Code | Language | Code | Language |
| --- | --- | --- | --- | --- | --- |
| af | Afrikaans | de | German | fa | Persian |
| ar | Arabic | el | Greek | pl | Polish |
| hy | Armenian | he | Hebrew | pt | Portuguese |
| az | Azerbaijani | hi | Hindi | ro | Romanian |
| be | Belarusian | hu | Hungarian | ru | Russian |
| bs | Bosnian | is | Icelandic | sr | Serbian |
| bg | Bulgarian | id | Indonesian | sk | Slovak |
| ca | Catalan | it | Italian | sl | Slovenian |
| zh | Chinese | ja | Japanese | es | Spanish |
| hr | Croatian | kn | Kannada | sw | Swahili |
| cs | Czech | kk | Kazakh | sv | Swedish |
| da | Danish | ko | Korean | tl | Tagalog |
| nl | Dutch | lv | Latvian | ta | Tamil |
| en | English | lt | Lithuanian | th | Thai |
| et | Estonian | mk | Macedonian | tr | Turkish |
| fi | Finnish | ms | Malay | uk | Ukrainian |
| fr | French | mr | Marathi | ur | Urdu |
| gl | Galician | mi | Maori | vi | Vietnamese |
|  |  | ne | Nepali | cy | Welsh |

A command-line `--language` flag takes precedence over `HNS_LANG`.

[Source: https://hns-cli.dev/docs/configuration/]
