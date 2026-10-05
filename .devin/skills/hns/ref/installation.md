# Installing hns

`hns` is a Python CLI. Prefer an isolated install with `uv` or `pipx`; `pip --user` works but is more prone to dependency conflicts.

## Prerequisites

- System Python **3.10+** is recommended.
- A working microphone and an internet connection for the **first** model download.

## Run without installing

If you already have `uv`:

```bash
uvx hns
```

`uvx` uses a temporary virtual environment and always fetches the latest version. Pin a version with `uvx hns@1.0.1`.

## Install

### uv (recommended)

```bash
uv tool install hns
```

Install uv if needed:

```bash
# macOS / Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### pipx

```bash
pipx install hns
```

Install pipx if needed:

```bash
# macOS (Homebrew)
brew install pipx
pipx ensurepath

# Linux / Windows
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```

### pip in a virtual environment

```bash
python -m venv ~/.venvs/hns
source ~/.venvs/hns/bin/activate   # Windows: ~/.venvs/hns/Scripts/activate
pip install hns
```

Activate the environment before each use.

### pip --user (least isolated)

```bash
pip install --user hns
```

Ensure `~/.local/bin` (or your platform equivalent) is in `PATH`.

## Verify the install

```bash
hns --version
hns --list-models
```

The first transcription downloads the configured Whisper model, so it needs internet. After that, transcription is fully offline.

## Upgrade

| Install method | Command |
| --- | --- |
| uv | `uv tool upgrade hns` |
| pipx | `pipx upgrade hns` |
| pip (user) | `pip install --upgrade --user hns` |
| uvx | No upgrade needed; always latest unless pinned |

Find how it was installed:

```bash
uv tool list | grep hns
pipx list | grep hns
pip show hns
```

[Source: https://hns-cli.dev/docs/installation/]
