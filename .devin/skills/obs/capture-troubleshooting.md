# Capture & Device Troubleshooting

Black/blank captures, capture-source failures, virtual camera, app conflicts, feedback loops. Sources: `kb/game-capture-troubleshooting`, `kb/known-conflicts`, `kb/virtual-camera-troubleshooting`, `kb/video-feedback-effect-troubleshooting`.

## Universal first steps

1. Check the OBS log (Help → Log Files → View Current Log, or `~/.config/obs-studio/logs/`).
2. Relaunch with `--safe-mode` — rules out third-party plugins/scripts/websockets.
3. Verify the source is the right *type* for the platform (Linux: Xcomposite/XSHM on X11, PipeWire on Wayland — wrong type = silent black frame).
4. On multi-GPU systems, OBS and the captured app must run on the **same GPU**.

## Game Capture issues (Windows; N/A on Linux)

| Symptom / game | Fix |
|----------------|-----|
| CoD, Valorant, Genshin, Honkai: Star Rail, Zenless Zone Zero | Run OBS **as administrator** |
| Counter-Strike 2, Destiny 2, GTA:SA, Roblox, SA-MP | Game Capture can't hook — use windowed/borderless mode + **Window Capture** |
| Fortnite on DX12 | Crashes/frametime bugs — switch game to DX11 |
| League of Legends | Two scenes (launcher = Window Capture, game = Game Capture) + Automatic Scene Switcher |
| Minecraft Java / osu! on laptops | Default to iGPU — force high-perf GPU (Windows Graphics settings), restart both |
| Emulators / old games | Often unhookable — Window Capture |

General: fullscreen games stop rendering when alt-tabbed (blank preview is expected — verify via test recording); kill overlay software (see conflicts below); RTSS ≥7.3.2 needs "Use Microsoft Detours API hooking" for OBS compat.

## Black / empty capture — general decision tree

- **All capture types black** → multi-GPU mismatch (below), or on Wayland the portal permission was denied — re-add the PipeWire source and approve the portal dialog.
- **Window Capture black** → wrong window-match mode; app renders via different GPU; on X11 try "Swap red and blue" off/on for color corruption; Wayland requires PipeWire capture (no Xcomposite).
- **Video capture device black** → Resolution/FPS set to a mode the device doesn't support (set Resolution/FPS Type back to Device Default); device in use by another app.
- **Color looks wrong** → Video Format mismatch (MJPEG vs XRGB/YUYV), or Color Space/Range set manually — reset to Default.

## Multi-GPU / GPU selection

OBS must run on the same GPU as captured content:

- Game/Window Capture → OBS on **High Performance** (discrete) GPU.
- Display Capture → OBS on the GPU driving that display (**Power Saving**/iGPU for laptop internal panels driven by iGPU).
- **Windows**: Settings → System → Display → Graphics → add `obs64.exe` → pick mode. Then restart OBS and the game.
- **Linux**: hybrid graphics (PRIME) — launch OBS with `prime-run` (NVIDIA) or `DRI_PRIME=1` (AMD) as needed to land on the same GPU as the game. On Wayland the compositor decides; capturing a display driven by another GPU typically works via PipeWire but costs extra copies.

## Known application conflicts

Disable/close before using OBS (hook conflicts → crashes or black capture):

- Overlays/FPS counters: MSI Afterburner, RivaTuner, EVGA Precision, FRAPS, Discord/TeamSpeak/Mumble overlays, Medal.tv, Overwolf, Raptr, ASUS GPU Tweak II.
- Other capture software: Action!, DXTory, RivaTuner — never run two hook-based capturers.
- **D3DGear**: installs global DX hooks — must be uninstalled.
- Anti-virus/firewall: whitelist OBS; some products break capture and connectivity until fully disabled.
- Dell/Alienware Backup & Recovery: crashes Browse dialogs (unregister component via the provided .cmd).
- Wacom drawing-tablet drivers (outdated): OBS process hangs at launch — update/remove driver.
- Also flagged: Intel GPA, Sendori, Astrill VPN, Nahimic Audio, Sonic Radar, Personify, Adobe Dynamic Link, Warsaw.

## Video feedback effect (infinite tunnel)

OBS capturing the display it's displayed on. Fixes:

1. **Minimize OBS** while capturing.
2. **Hide OBS from capture** — Windows: Settings → General → "Hide OBS windows from screen capture" (breaks screenshots of OBS); macOS 13+: "Hide OBS from capture" in the Screen Capture source. *(Not available on Linux — use option 1, 3, or 4.)*
3. Capture a window/game instead of the whole display.
4. Move OBS to a second display (or a virtual/dummy display).

## Virtual Camera issues

| Platform | Notes |
|----------|-------|
| Linux | Powered by **v4l2loopback** kernel module — if "Start Virtual Camera" is absent/fails, install it: NixOS → `boot.kernelModules = [ "v4l2loopback" ]; boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];` and grant `dialout`/`video` group access to `/dev/video*`. |
| Windows | If button missing: run `virtualcam-install.bat` (admin) in `data\obs-plugins\win-dshow`; remove with `virtualcam-uninstall.bat`. |
| macOS | OBS ≥30 + macOS 13+ = new camera-extension virtual cam (allow the system extension in Privacy & Security). OBS ≤29.1 vcam incompatible with macOS 14 entirely. |

App can't see the camera → restart the app after starting vcam; Chrome/Edge have best compat.
