# IO & External Integration (`import Quickshell.Io`)

How a shell talks to the outside: processes, files, sockets, and IPC into the running instance.
Module index: https://quickshell.org/docs/v0.3.0/types/Quickshell.Io

## `Process` — run external commands

```qml
Process {
  command: ["date", "+%H:%M"]   // list of strings, each arg separate
  running: true                  // set true to (re)start; false to stop
  workingDirectory: "/tmp"       // default: qs's working dir
  environment: ({ "FOO": "bar" })
  clearEnvironment: false
  stdinEnabled: true             // enable to use write()
  stdout: StdioCollector { onStreamFinished: root.out = this.text }
  stderr: SplitParser { onRead: line => console.warn(line) }
}
```

- `command: [list]` — array form (preferred); also accepts `["sh", "-c", "..."]` for shell syntax.
- `running` toggles execution; `onExited(exitCode, exitStatus)` / `onStarted` signals; `processId`.
- `stdout`/`stderr` take a `DataStreamParser`; `write(data)` sends stdin; `signal(sig)` kills;
  `exec(cmd)`/`startDetached(cmd)` static-ish helpers. For fire-and-forget, prefer
  `Quickshell.execDetached(cmd)` or `DesktopEntry.execute`.
- **Don't create a Process per widget** — hoist one Process + `Timer` to a `Scope` and broadcast
  results through properties (the canonical clock pattern in the intro guide).

## Stream parsers (assign to `stdout`/`stderr`/socket `parser`)

- `StdioCollector` — accumulate everything; `text` on `streamFinished`.
- `SplitParser` — per-line (or per-delimiter) `onRead(line)` callbacks.
- `DataStream`/`DataStreamParser` — base types for incremental reads.

## `FileView` — read/write files

```qml
FileView {
  path: Qt.resolvedUrl("./config.json")
  blockLoading: true             // force sync load before text()/data() use
  watchChanges: true             // emits fileChanged on external edits
  atomicWrites: true             // safe writes via temp+rename
  adapter: JsonAdapter {}        // structured access instead of text()
}
```

- `text()`/`setText()`, `data()`/`setData()`, `writeAdapter()`, `reload()`, `waitForJob()`.
- Signals: `loaded`, `loadFailed`, `saved`, `saveFailed`, `fileChanged`, `adapterUpdated`.
- `preload`, `loaded` (readonly), `blockAllReads`, `blockWrites`, `printErrors`.
- Adapters: `JsonAdapter` (JSON ↔ object graph via `JsonObject`), `FileViewAdapter` base,
  `FileViewError` enum.
- For small/medium files without seeking. **Persisting shell state across restarts**: FileView in
  `Quickshell.stateDir`/`dataDir`, or `PersistentProperties` for auto-persisted properties.

## `Socket` / `SocketServer` — local socket IPC

- `Socket { path, connected }` — connect to a Unix socket; `parser:` for incoming data, `write()`
  out. `connected: false` on a server-created socket closes it.
- `SocketServer { path, active, handler: Socket { ... } }` — `handler` is a Component that must
  create a `Socket` (don't set its `path`/`connected` — the server does). Setting `active: false`
  kills connections and unlinks the socket file. For full-duplex local IPC with other programs.

## `IpcHandler` — expose functions to `qs ipc`

Register named targets callable from the CLI:

```qml
IpcHandler {
  target: "volume"
  function set(v: real): string { ...; return "ok" }
  signal changed(v: real)
}
```

- `qs ipc call <target> <fn> args...` — functions ≤10 args; **arg and return types must be
  declared explicitly** or they aren't registered. Supported: `string`, `int`, `real`, `bool`,
  `color` (accepts names/#RGB/#RRGGBB/#AARRGGBB; returns `#AARRGGBB`), `void`.
- `qs ipc wait` — observe one signal emission. `enabled` toggles registration.
- This is the mechanism for "open/close windows with commands" — bind handler functions to
  `window.visible`/loader `active`.

Sources:
https://quickshell.org/docs/v0.3.0/types/Quickshell.Io/Process
https://quickshell.org/docs/v0.3.0/types/Quickshell.Io/FileView
https://quickshell.org/docs/v0.3.0/types/Quickshell.Io/SocketServer
https://quickshell.org/docs/v0.3.0/types/Quickshell.Io/IpcHandler
