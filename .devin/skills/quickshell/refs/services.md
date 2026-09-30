# System Services (`import Quickshell.Services.*`)

Built-in integrations that replace shelling out to dbus/CLI tools. Most top-level types are
singletons exposing reactive `ObjectModel` lists — bind UI to them and they update live.
Module index: https://quickshell.org/docs/v0.3.0/types/

## Notifications — `Quickshell.Services.Notifications`

Implement a notification daemon (Desktop Notifications Spec):

- `NotificationServer` — *you* run the server; receives `notification(Notification)` signals and
  exposes `trackedNotifications`. Capability flags default mostly off; enable what you render:
  `bodySupported` (true), `bodyImagesSupported`, `bodyMarkupSupported`, `bodyHyperlinksSupported`,
  `actionsSupported`, `actionIconsSupported`, `imageSupported`, `persistenceSupported`,
  `inlineReplySupported`, `extraHints`, `keepOnReload`.
- `Notification` — the received object; `NotificationAction` (invoke action buttons),
  `NotificationUrgency`, `NotificationCloseReason` enums.
- **Coexistence note**: only one notification server can own the dbus name — if another daemon
  (dunst, mako, DE builtin) runs, yours won't receive. This is how Quickshell replaces, rather than
  augments, a system's notification stack.

## Media — `Quickshell.Services.Mpris`

- `Mpris.players : ObjectModel<MprisPlayer>` (readonly) — all connected MPRIS players, reactive.
- `MprisPlayer` — per-player metadata/controls; `MprisPlaybackState`, `MprisLoopState` enums.
  Bind `players` into a `Repeater`/`Variants` for a media widget; no polling needed.

## Audio — `Quickshell.Services.Pipewire`

- `Pipewire` — access to the Pipewire graph. `PwNode` (devices/streams; `PwNodeAudio` adds
  volume/mute/channel props via `PwAudioChannel`), `PwLink`/`PwLinkGroup`/`PwLinkState` (routing).
- Trackers: `PwObjectTracker` (keep refs to a set of nodes), `PwNodeLinkTracker`,
  `PwNodePeakMonitor` (live volume meters). `PwNodeType` enum.
- Typical volume slider: find default sink node → bind `PwNodeAudio.volume`, write back on change.

## Tray — `Quickshell.Services.SystemTray` + `Quickshell.DBusMenu`

- `SystemTray` — hosts StatusNotifierItems; `SystemTrayItem` per icon (icon, id, `menu` handle,
  activate/secondaryActivate methods). `Status`, `Category` enums.
- `DBusMenuHandle`/`DBusMenuItem` — render an item's context menu (feed into `QsMenuOpener`/`QsMenuAnchor`).
- Same coexistence caveat as notifications: the tray host protocol expects one host; Quickshell
  takes that role instead of a DE tray.

## Power — `Quickshell.Services.UPower`

- `UPower` — devices (battery etc.) via `UPowerDevice` (`UPowerDeviceState`, `UPowerDeviceType`
  enums, `PerformanceDegradationReason`); `PowerProfiles`/`PowerProfile` for power-profiles-daemon.
- `Quickshell.Services.Greetd` — `Greetd` + `GreetdState` for building a greeter/login screen.
- `Quickshell.Services.Pam` — `PamContext`, `PamResult`, `PamError` for authenticating in lock
  screens/greeters (pair with `WlSessionLock`).
- `Quickshell.Services.Polkit` — `PolkitAgent` + `AuthFlow` to act as the polkit authentication
  agent (privilege-escalation prompts). One agent per session — same singleton-service caveat.

## Hardware connectivity

- `Quickshell.Networking` — `Networking`/`Network` (NetworkManager); `NetworkDevice` →
  `WifiDevice`/`WiredDevice`, `WifiNetwork`, `NMSettings`. Enums: `ConnectionState`,
  `ConnectionFailReason`, `DeviceType`, `NetworkConnectivity`, `NetworkBackendType`,
  `WifiDeviceMode`, `WifiSecurityType`.
- `Quickshell.Bluetooth` — `Bluetooth` → `BluetoothAdapter` (`BluetoothAdapterState`) →
  `BluetoothDevice` (`BluetoothDeviceState`).

## Desktop entries & menus

- `DesktopEntries` (core module) — search/launch .desktop apps; `DesktopEntry.execute`,
  `DesktopAction`. See core-types.md.

Per-type property details (signatures, signals): follow each type's page under
https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.<Module>/<Type>

Sources:
https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Notifications/NotificationServer
https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Mpris/Mpris
https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Pipewire
https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.SystemTray
https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.UPower
