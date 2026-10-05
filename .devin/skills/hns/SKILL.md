---
description: Reference for installing, configuring, and operating the local hns speech-to-text CLI.
---

# hns Overview

`hns` is a local, offline speech-to-text CLI for developers. It records audio from your microphone, transcribes it using a local Whisper model, and copies the result to your clipboard. It is designed to be piped into other command-line tools: `$(hns)`, `hns | llm ...`, etc.

Because transcription happens on your machine via `faster-whisper` on the CPU, no audio data leaves the device after the initial model download.

## When to use this skill

Reach for this skill when you need to:

- Install, upgrade, or verify `hns` on a machine.
- Choose a Whisper model size or language setting.
- Understand what CLI flags and environment variables are actually available.
- Debug failed recordings, transcription errors, clipboard issues, or model-loading problems.
- Understand where models run, how they are cached, and where the last recording is stored.

## Reference Files

- `ref/installation.md` — install methods, verification, and upgrade commands.
- `ref/configuration.md` — environment variables, model catalog, and language codes.
- `ref/cli-reference.md` — available CLI flags and stdout/stderr behavior.
- `ref/architecture.md` — how `hns` works internally: audio capture, transcription flow, model caching, and cache paths.
- `ref/debugging.md` — common errors, recovery with `--last`, exit codes, limitations, and performance notes.

[Source: https://hns-cli.dev/]
