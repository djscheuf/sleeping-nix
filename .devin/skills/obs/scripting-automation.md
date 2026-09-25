# Scripting & Remote Automation

Three automation paths, in order of practical usefulness for an agent: **config-file editing** (offline, simplest), **obs-websocket** (live control, language-agnostic), **in-process scripts** (Lua/Python inside OBS). Sources: `kb/developer-guide`, `kb/scripting-guide`, `kb/remote-control-guide`, `docs.obsproject.com/scripting`.

## Path 1 — Edit scene-collection JSON directly

`~/.config/obs-studio/basic/scenes/<Collection>.json` holds scenes, sources (with settings dicts), filters, transitions, transforms, and global audio sources. Profile output settings live in `~/.config/obs-studio/basic/profiles/<Profile>/basic.ini` + `service.json`.

Rules:
- Edit while OBS is **closed** (or switch collections to force reload) — OBS overwrites the file on exit/scene changes.
- JSON structure: `sources` array (each with `id` like `xcomposite_input`, `settings`, `filters`, `scale_filter`, `sync`, `volume`…), `scene_items` transforms inside `groups`/scene sources, `transitions`, `current_scene`, `current_program_scene`.
- Absolute file paths (images/media/LUTs/scripts) are embedded — rewrite them when moving collections between machines.

## Path 2 — obs-websocket (live control)

Built into OBS **28+** (no plugin install needed; obs-websocket package only for older versions).

- Tools → **obs-websocket Settings**: enable server, set password (auto-generated on first load — keep auth on).
- Default endpoint `ws://localhost:4455`.
- CLI overrides: `--websocket_port <p>`, `--websocket_password <p>`, `--websocket_debug`, `--websocketipv4only`.
- Config stored in `~/.config/obs-studio/plugin_config/obs-websocket/` (password can be read there for agent use).

What it can do (request categories): scene/source create-remove-enumerate, scene-item transforms/visibility, filter lists + settings, transition set/trigger, input settings get/set, volume/mute/monitor/track routing, stream/record/virtualcam/replay start-stop-status, `CreateRecordChapter` (Hybrid MP4 chapters), media control, projector control.

Client libraries: `obsws-python`, `obs-websocket-js`/`obs_ws` (JS), `simpleobsws`, plus Stream Deck–style clients (Companion, Streamer.bot, OBS-web). Protocol spec: `obs-websocket/docs/generated/protocol.md` on GitHub.

Typical agent loop: read password from plugin_config → connect → `GetInputList`/`GetSceneItemList` to map names→IDs → `SetInputSettings`/`SetSceneItemTransform`/`SetInputVolume`/`SetSourceFilterSettings` → verify with `GetInputSettings`.

## Path 3 — In-process Lua/Python scripts

Tools → **Scripts**: `+` adds a script, `🗘` reloads, `Defaults` resets property values. Python needs a system interpreter (3.6–3.12) + *Python Install Path* in the Scripts → Python Settings tab. Lua is embedded (LuaJIT), zero deps, and the only one that can register **custom sources** (`source_info`).

### Script lifecycle exports (define what you need)

| Function | Called |
|----------|--------|
| `script_description()` | At load — returns the description shown in the Scripts window |
| `script_defaults(settings)` | At load — set default values into settings data |
| `script_load(settings)` | One-time init (hook signals here) |
| `script_update(settings)` | On load AND whenever property values change |
| `script_properties()` | Build the editable properties UI in the Scripts window |
| `script_save(settings)` | When settings are saved |
| `script_unload()` | Cleanup on removal/reload/quit |
| `script_tick(seconds)` | Per-frame callback |
| `timer_add(fn, ms)` / `timer_remove(fn)` | Script timers |
| `script_path()` | Directory containing the current script |

### API shape

The `obs` module mirrors the C API (SWIG-generated wrappers): `obs_source_create(id, name, settings)`, `obs_scene_create`, `obs_scene_add`, `obs_sceneitem_set_pos/set_scale/set_visible`, `obs_source_filter_create`, `obs_get_source_by_name`, `obs_source_update`, `signal_handler_connect`, `obs_hotkey_register_frontend`, `obs_data_*` for settings, `obs_frontend_*` for UI/stream control. Reference: docs.obsproject.com (Source/Scene/Frontend API pages — C signatures; names/args carry over).

Caveats: some C functions (pointer/out-param shapes) aren't scriptable; no official type stubs; example scripts ship in `data/obs-plugins/frontend-tools/scripts` and at `obsproject.com/wiki` (Source Shake, Halftone tutorials).

## Which to use when

| Goal | Path |
|------|------|
| Generate/duplicate a scene collection offline | JSON edit |
| Tune a live setup (volume, transform, filter settings, switch scenes) | obs-websocket |
| Reactive behavior inside OBS (hotkey-animated sources, custom source type, shaders) | Lua/Python script |
| New input/output/filter *types* or heavy perf work | C++ plugin (out of scope here) |
