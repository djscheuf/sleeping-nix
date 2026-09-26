# Local Server Control Interface

Easy Effects runs a local UNIX socket server for GUI-less control by scripts or other apps. The socket is named `EasyEffectsServer` and lives at `$XDG_RUNTIME_DIR/EasyEffectsServer` (usually `/run/user/1000/EasyEffectsServer`).

Send commands with `socat` or directly via any language's UNIX socket API:

```sh
echo "load_preset:output:MyPresetName" | socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/EasyEffectsServer
```

## General commands

| Command | Arguments | Description |
|---|---|---|
| `show_window` | none | Opens the main window |
| `hide_window` | none | Hides the main window |
| `quit_app` | none | Quits Easy Effects |
| `global_bypass` | `1` (bypass) or `0` (active) | Toggles effects on/off |
| `get_global_bypass` | none | Returns `1` (enabled) or `2` (disabled) |
| `toggle_global_bypass` | none | Toggles global bypass |
| `microphone_monitoring` | `1`/`0` | Sets microphone monitoring |
| `get_microphone_monitoring` | none | Returns `1`/`2` |
| `toggle_microphone_monitoring` | none | Toggles microphone monitoring |
| `audio_sharing` | `1`/`0` | Desktop audio sharing via virtual source |
| `get_audio_sharing` | none | Returns `1`/`2` |
| `toggle_audio_sharing` | none | Toggles audio sharing |
| `load_preset` | `pipeline:preset_name` | Loads a preset (pipeline = `input` or `output`) |
| `get_last_loaded_preset` | `pipeline` | Name of last loaded preset |

## Plugin get/set property

Modify or query individual plugin parameters on the fly. The full property list (names, types, defaults, enum choices) is in each category reference file, sourced from the [Plugin Properties](https://wwmm.github.io/easyeffects/database/plugins_properties.html) page.

Argument positions:

- `pipeline`: `output` or `input`
- `plugin_id`: e.g. `compressor`, `equalizer` (see plugin IDs in reference files)
- `instance_id`: instance number starting at `0`
- `property_name`: e.g. `threshold`, `inputGain`
- enum values are set by their numeric index (see `Choices:` in property tables)

Formats:

```
set_property:pipeline:plugin_id:instance_id:property_name:value
get_property:pipeline:plugin_id:instance_id:property_name
```

For equalizer (left/right channel) properties, insert the channel after the instance id:

```
set_property:pipeline:equalizer:instance_id:(left|right):property_name:value
get_property:pipeline:equalizer:instance_id:(left|right):property_name
```

Examples:

```sh
# Set compressor threshold on the output pipeline to -20dB
echo "set_property:output:compressor:0:threshold:-20" | socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/EasyEffectsServer

# Set compressor mode to Upward (enum index 1)
echo "set_property:output:compressor:0:mode:1" | socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/EasyEffectsServer

# Set left-channel band0 gain on the equalizer
echo "set_property:output:equalizer:0:left:band0Gain:1.5" | socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/EasyEffectsServer

# Read output gain of the equalizer
echo "get_property:output:equalizer:0:outputGain" | socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/EasyEffectsServer
```

Full docs: https://wwmm.github.io/easyeffects/user_interface/local_server.html
