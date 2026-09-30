# Quickshell Setup, Configuration, and Runtime Options

## Dependencies and install

Quickshell is a Qt6/QML application (binary `qs`). Packaged for most distros:

- **Nix**: nixpkgs `quickshell`, or the repo flake (`git+https://git.outfoxxed.me/outfoxxed/quickshell`
  or `github:quickshell-mirror/quickshell`, add `?ref=<tag>` for a release). **Important**:
  `inputs.nixpkgs.follows = "nixpkgs"` — mismatched Qt deps cause crashes. Package:
  `quickshell.packages.<system>.default`; extra QML modules via `<pkg>.withModules [ ... ]`.
- **Arch**: `pacman -S quickshell` (`quickshell-git` AUR for master; AUR builds can break on Qt
  updates — reinstall if warned).
- **Fedora**: `dnf install quickshell` (Rawhide) or COPR `errornointernet/quickshell`.
- **Debian**: `apt install quickshell` (unstable/testing). **Ubuntu**: PPA `avengemedia/danklinux`.
- **Gentoo**: GURU `gui-apps/quickshell`. **Guix**: `guix install quickshell`. Manual: repo BUILD.md.

Optional Qt packages (names vary): `qtsvg` (SVG icons), `qtimageformats` (WEBP etc.),
`qtmultimedia` (audio/video), `qt5compat` (extra effects e.g. gaussian blur — `MultiEffect`
usually preferable).

Pre-1.0: expect breaking API changes between releases; migration guides are provided.

## Where configs live and how they're launched

- `qs` searches a `quickshell` subfolder of every XDG config path (`~/.config/quickshell`).
  Each named subfolder containing `shell.qml` is a config. If `~/.config/quickshell/shell.qml`
  itself exists, subfolders are ignored.
- `qs -c <name>` / `--config` picks a named config. `qs -p <path>` / `--path` runs any file/dir.
  `QS_CONFIG_PATH` env = `--path`.
- Dotfiles distribution: use a *named* subdir `~/.config/quickshell/<name>` (not the bare dir).
  Packaged configs go under `$XDG_CONFIG_DIRS` (usually `/etc/xdg`).
- **Avoid `import "root:/..."`**: the old root-import feature breaks the LSP and singletons.

## `//@ pragma` comments (Advanced Options)

Pragmas are comment directives `//@ <pragma>` evaluated by Quickshell's preprocessor.

- `//@ pragma Internal` — top of file; hides the file's types outside its module.
- `//@ if <js-expr>` … `//@ endif` — conditional compilation. Functions available:
  `hasVersion(major, minor, features)`, `hasQtVersion(major, minor)`, `env(name)`, `isEnvSet(name)`.
  Use for version-gating code across Quickshell releases.
- **Instance pragmas** — only valid at the top of root `shell.qml`:
  - `Env VAR = VAL` / `DefaultEnv VAR = VAL` — set env vars affecting Quickshell/Qt only (not
    spawned processes).
  - `UseQApplication` — use `QApplication` instead of `QGuiApplication` (needed for QtWidgets styles
    like `qqc2-desktop-style`).
  - `NativeTextRendering` — system text backend (= `Text.renderType: Text.NativeRendering`).
  - `RespectSystemStyle` — don't force Fusion QtQuick Controls style. Set a specific style with
    `//@ pragma Env QT_QUICK_CONTROLS_STYLE = MyStyle`.
  - `DropExpensiveFonts` — exclude woff/woff2 (font loading can stutter). Env: `QS_DROP_EXPENSIVE_FONTS=1`.
  - `IconTheme <theme>` — Qt icon theme. Env: `QS_ICON_THEME`.
  - `AppId <appid>` — override app id (custom icon on floating windows). Env: `QS_APP_ID`.
  - `ShellId <id>` — override the path-derived shell id (affects data dirs and instance dedup).
  - `DataDir|StateDir|CacheDir <dir>` — override per-shell dirs; `$BASE/` expands to the XDG base.

## Environment variables

`QS_DISABLE_FILE_WATCHER` (no hot reload), `QS_CONFIG_PATH`, `QS_NO_XINERAMA_STRUTS` (X11 bar hack),
`QS_CRASHREPORT_URL`, `QS_DISABLE_CRASH_HANDLER` (no crash relaunch), `QS_NO_RELOAD_POPUP`.

## Editor / LSP

- Language server: `qmlls`. Create an empty `.qmlls.ini` next to `shell.qml` — Quickshell replaces
  it with a managed config (gitignore it; machine-specific contents).
- Neovim: `:TSInstall qmljs` + `require("lspconfig").qmlls.setup {}`. Helix: built-in. VSCode:
  official QML extension + `qt-qml.qmlls.useQmlImportPathEnvVar`. Emacs: `qml-ts-mode` + qmlls client.
- Known qmlls limits: breaks on malformed files; **no docs for Quickshell types**; `PanelWindow`
  unresolved.

Sources:
https://quickshell.org/docs/v0.3.0/guide/install-setup
https://quickshell.org/docs/v0.3.0/guide/advanced
https://quickshell.org/docs/v0.3.0/guide/distribution
