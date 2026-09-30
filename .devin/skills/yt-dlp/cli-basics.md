# yt-dlp CLI Basics

Core invocation patterns, general options, network/geo options, verbosity/simulation, workarounds, and preset aliases.

## Invocation

```
yt-dlp [OPTIONS] [--] URL [URL...]
```

- Options can appear before or after URLs; use `--` to separate URLs from options that look like URLs.
- Multiple URLs can be given; playlists and channel URLs are expanded automatically.
- Unqualified terms can be auto-searched with `--default-search PREFIX` (default behavior is `fixup_error`, which repairs broken URLs or errors if it cannot).

## General Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help and exit. |
| `--version` | Print version and exit. |
| `-U, --update` | Update to latest release (works with release binaries). |
| `--update-to [CHANNEL@]TAG` | Switch channels or pin a version. Channels: `stable`, `nightly` (recommended), `master`. Examples: `--update-to nightly`, `--update-to stable@2023.07.06`. |
| `--no-update` | Disable update checks. |
| `-i, --ignore-errors` | Ignore download/post-processing errors; still reports exit success. |
| `--no-abort-on-error` | Continue to next URL on error (default). |
| `--abort-on-error` | Stop on first error. |
| `--list-extractors` | List supported extractors. |
| `--extractor-descriptions` | Show extractor descriptions. |
| `--use-extractors NAMES` / `--ies` | Whitelist/blacklist extractors; regex, `all`, `default`, `end` supported. Prefix with `-` to exclude. |
| `--default-search PREFIX` | Prefix for bare search terms. `auto` guesses; `error` throws; `fixup_error` repairs URLs (default). |
| `--ignore-config` / `--no-config` | Skip loading all config files except those from `--config-locations`. |
| `--config-locations PATH` | Add a config file or directory (`-` for stdin). Can be repeated and nested inside configs. |
| `--plugin-dirs DIR` / `--no-plugin-dirs` | Add/clear plugin search directories. |
| `--js-runtimes RUNTIME[:PATH]` / `--no-js-runtimes` | Enable JS runtimes. Defaults to `deno`; also supports `node`, `quickjs`, `bun`. |
| `--remote-components COMPONENT` / `--no-remote-components` | Allow fetching remote JS components (`ejs:npm`, `ejs:github`). |
| `--flat-playlist` | Do not fully expand playlist entries; faster, less metadata. |
| `--no-flat-playlist` | Fully expand playlists (default). |
| `--live-from-start` | Download livestreams from the beginning (experimental; YouTube, Twitch, TVer, mellow-fan). |
| `--wait-for-video MIN[-MAX]` | Retry waiting for scheduled streams to become available. |
| `--mark-watched` | Mark videos watched even with `--simulate`. |
| `--color [STREAM:]POLICY` | Color output: `always`, `auto` (default), `never`, `no_color`. |
| `--compat-options OPTS` | Revert behavior to match youtube-dl/older versions. See `debugging.md` and the upstream README for compat aliases. |
| `--alias ALIASES OPTIONS` | Define custom option aliases. Aliases can trigger recursively up to 100 times. |
| `-t, --preset-alias PRESET` | Apply a built-in preset: `mp3`, `aac`, `mp4`, `mkv`, `sleep`. |

## Network Options

| Option | Description |
|--------|-------------|
| `--proxy URL` | HTTP/HTTPS/SOCKS proxy. Use empty string for direct connection. Example: `socks5://user:pass@127.0.0.1:1080/`. |
| `--socket-timeout SECONDS` | Connection timeout. |
| `--source-address IP` | Bind to this client IP. |
| `--impersonate CLIENT[:OS]` | Impersonate a browser (e.g. `chrome`, `chrome-110`, `chrome:windows-10`). Pass empty string to impersonate any client. May affect speed/stability. |
| `--list-impersonate-targets` | List available impersonation targets. |
| `-4, --force-ipv4` / `-6, --force-ipv6` | Force IP version. |
| `--enable-file-urls` | Allow `file://` URLs (disabled by default for security). |

## Geo-restriction

| Option | Description |
|--------|-------------|
| `--geo-verification-proxy URL` | Proxy used only for IP/geo verification checks. Actual download still uses `--proxy`. |
| `--xff VALUE` | Fake `X-Forwarded-For` header. Values: `default`, `never`, CIDR block, or two-letter country code. |

## Verbosity and Simulation Options

Use these heavily when debugging (see `debugging.md`).

| Option | Description |
|--------|-------------|
| `-q, --quiet` | Quiet mode. With `--verbose`, logs to stderr. |
| `--no-warnings` | Suppress warnings. |
| `-s, --simulate` | Do not download or write files. |
| `--no-simulate` | Download even when printing/listing. |
| `--ignore-no-formats-error` | Extract metadata even when no downloadable formats exist. |
| `--skip-download` | Skip the video but write sidecar files. |
| `-O, --print [WHEN:]TEMPLATE` | Print an output-template field. Implies `--quiet` and `--simulate` unless later `WHEN` or `--no-simulate`. |
| `--print-to-file [WHEN:]TEMPLATE FILE` | Append printed output to a file. |
| `-j, --dump-json` | Print JSON info for each video (quiet + simulate). |
| `-J, --dump-single-json` | Dump a single JSON line per URL/playlist. |
| `--force-write-archive` | Write archive entries even during simulation. |
| `--newline` | Print progress bar as new lines. |
| `--no-progress` / `--progress` | Hide/show progress bar. |
| `--console-title` | Show progress in terminal title. |
| `--progress-template [TYPES:]TEMPLATE` | Customize progress output. Fields under `info` and `progress` keys. |
| `--progress-delta SECONDS` | Minimum seconds between progress updates (default 0). |
| `-v, --verbose` | Print debug info. Repeat for more verbosity (`-vv`). |
| `--dump-pages` | Print base64-encoded downloaded pages (very verbose). |
| `--write-pages` | Write intermediary downloaded pages to files. |
| `--print-traffic` | Display sent/received HTTP traffic. |

## Workarounds

| Option | Description |
|--------|-------------|
| `--encoding ENCODING` | Force encoding (experimental). |
| `--legacy-server-connect` | Allow HTTPS to servers without RFC 5746 secure renegotiation. |
| `--no-check-certificates` | Disable HTTPS certificate validation. |
| `--prefer-insecure` | Use HTTP instead of HTTPS for video info. |
| `--add-headers FIELD:VALUE` | Add custom HTTP headers. Repeatable. |
| `--bidi-workaround` | Work around terminals lacking bidirectional text support. |
| `--sleep-requests SECONDS` | Sleep between data-extraction requests. |
| `--sleep-interval SECONDS` / `--max-sleep-interval SECONDS` | Sleep before downloads (min/max). |
| `--sleep-subtitles SECONDS` | Sleep before subtitle downloads. |

## Preset Aliases

Built-in aliases for common tasks (defined in General Options):

| Preset | Equivalent options |
|--------|--------------------|
| `-t mp3` | `-f 'ba[acodec^=mp3]/ba/b' -x --audio-format mp3` |
| `-t aac` | `-f 'ba[acodec^=aac]/ba[acodec^=mp4a.40.]/ba/b' -x --audio-format aac` |
| `-t mp4` | `--merge-output-format mp4 --remux-video mp4 -S vcodec:h264,lang,quality,res,fps,hdr:12,acodec:aac` |
| `-t mkv` | `--merge-output-format mkv --remux-video mkv` |
| `-t sleep` | `--sleep-subtitles 5 --sleep-requests 0.75 --sleep-interval 10 --max-sleep-interval 20` |

## Common Simple Commands

```bash
# Basic download
yt-dlp "URL"

# Search and download top result
yt-dlp "ytsearch:python tutorial"

# Update to the recommended nightly channel
yt-dlp --update-to nightly

# List available formats without downloading
yt-dlp -F "URL"

# Download with a specific format code
yt-dlp -f 22 "URL"

# Show what would be downloaded
yt-dlp -s "URL"

# Verbose dry run
yt-dlp -v -s "URL"
```

[Source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md#usage-and-options]
