# yt-dlp Download and Filesystem Options

Video selection, download behavior, filesystem options, thumbnails, and internet shortcuts.

## Video Selection

Control which videos from a playlist or channel are processed.

| Option | Description |
|--------|-------------|
| `-I, --playlist-items ITEM_SPEC` | Comma-separated indices/ranges. Syntax: `[START]:[STOP][:STEP]`. Negative indices count from end; negative step reverses order. Example: `-I 1:3,7,-5::2`. |
| `--min-filesize SIZE` / `--max-filesize SIZE` | Skip videos outside size range (e.g. `50k`, `44.6M`). |
| `--date DATE` | Only videos uploaded on this date. Formats: `YYYYMMDD` or `[now|today|yesterday][-N[day|week|month|year]]`. |
| `--datebefore DATE` / `--dateafter DATE` | Date filters. |
| `--match-filters FILTER` | Generic filter on any output-template field. Operators and syntax match format filtering. Repeat for OR conditions. Use `--match-filters -` to interactively prompt. |
| `--break-match-filters FILTER` | Stop the whole run when a video is rejected. |
| `--no-playlist` / `--yes-playlist` | Choose whether a video-with-playlist URL downloads only the video or the playlist. |
| `--age-limit YEARS` | Skip videos above age limit. |
| `--download-archive FILE` | Skip videos whose IDs are already in this file; record newly downloaded IDs. |
| `--max-downloads NUMBER` | Stop after N files. |
| `--break-on-existing` | Stop when encountering an already-archived ID. |
| `--break-per-input` | Reset `--max-downloads`, `--break-on-existing`, `--break-match-filters`, and `autonumber` per input URL. |
| `--skip-playlist-after-errors N` | Skip remaining playlist after N consecutive errors. |

See `formats-and-postprocessing.md` for `--format`/`-f` selection and `output-templates-and-metadata.md` for fields usable in `--match-filters`.

## Download Options

| Option | Description |
|--------|-------------|
| `-N, --concurrent-fragments N` | Parallel fragment downloads for DASH/HLS/ISM (default 1). |
| `-r, --limit-rate RATE` | Max bytes/sec (e.g. `50K`, `4.2M`). |
| `--throttled-rate RATE` | Minimum rate below which throttling is assumed and data is re-extracted. |
| `-R, --retries RETRIES` | Retries for HTTP downloads (default 10, or `infinite`). |
| `--file-access-retries RETRIES` | Retries on file-access errors (default 3). |
| `--fragment-retries RETRIES` | Retries per fragment (default 10). |
| `--retry-sleep [TYPE:]EXPR` | Sleep between retries. Types: `http`, `fragment`, `file_access`, `extractor`. Expr: number, `linear=START[:END[:STEP=1]]`, `exp=START[:END[:BASE=2]]`. |
| `--skip-unavailable-fragments` | Skip missing fragments (default). |
| `--abort-on-unavailable-fragments` | Abort if any fragment is unavailable. |
| `--keep-fragments` | Keep fragment files after download. |
| `--buffer-size SIZE` | Download buffer size (default 1024). |
| `--resize-buffer` / `--no-resize-buffer` | Auto-resize buffer (default) or not. |
| `--http-chunk-size SIZE` | Chunk-based HTTP download size; can help bypass server-side throttling (experimental). |
| `--playlist-random` | Download in random order. |
| `--lazy-playlist` | Process playlist entries as they are received; incompatible with `--playlist-random` and `--playlist-reverse`. |
| `--hls-use-mpegts` | Use `mpegts` container for HLS; allows playback during download (default for live). |
| `--download-sections REGEX` | Download only chapters matching regex. Prefix with `*` for time range. Needs ffmpeg. Repeatable. |
| `--downloader [PROTO:]NAME` | External downloader per protocol. Supported: `native`, `aria2c`, `axel`, `curl`, `ffmpeg`, `httpie`, `wget`. Repeatable. |
| `--downloader-args NAME:ARGS` | Pass args to an external downloader. For ffmpeg, supports input/output position syntax like `--postprocessor-args`. |

## Filesystem Options

| Option | Description |
|--------|-------------|
| `-a, --batch-file FILE` | Read URLs from file (`-` for stdin). Lines starting with `#`, `;`, or `]` are comments. |
| `-P, --paths [TYPES:]PATH` | Base paths for output. Types include `home` (default), `temp`, plus all `--output` types. Intermediary files go to `temp` and are moved to `home` after download. |
| `-o, --output [TYPES:]TEMPLATE` | Output filename template. See `output-templates-and-metadata.md`. |
| `--output-na-placeholder TEXT` | Placeholder for missing fields (default `NA`). |
| `--restrict-filenames` | ASCII-only filenames; no `&` or spaces. |
| `--windows-filenames` | Force Windows-compatible filenames. |
| `--trim-filenames LENGTH` | Cap filename length (excluding extension). |
| `-w, --no-overwrites` | Never overwrite existing files. |
| `--force-overwrites` | Overwrite video and metadata; implies `--no-continue`. |
| `--no-force-overwrites` | Default: overwrite sidecar files but not the video. |
| `-c, --continue` | Resume partial downloads (default). |
| `--no-continue` | Restart partial files. |
| `--part` | Use `.part` files while downloading (default). |
| `--no-part` | Write directly to destination. |
| `--mtime` | Set file mtime from `Last-Modified` header. |
| `--write-description` | Write `.description` file. |
| `--write-info-json` | Write `.info.json` (may contain personal information). |
| `--write-playlist-metafiles` / `--no-write-playlist-metafiles` | Write playlist-level metadata files (default: yes). |
| `--clean-info-json` | Remove internal metadata from infojson (default). |
| `--write-comments` | Retrieve comments into infojson. |
| `--load-info-json FILE` | Use previously saved infojson. |
| `--cookies FILE` | Read/write Netscape-format cookies. |
| `--cookies-from-browser BROWSER[+KEYRING][:PROFILE][::CONTAINER]` | Load cookies from a browser. Supported: `brave`, `chrome`, `chromium`, `edge`, `firefox`, `opera`, `safari`, `vivaldi`, `whale`. Keyrings: `basictext`, `gnomekeyring`, `kwallet`, `kwallet5`, `kwallet6`. |
| `--cache-dir DIR` / `--no-cache-dir` / `--rm-cache-dir` | Control permanent cache directory (default `${XDG_CACHE_HOME}/yt-dlp`). |

## Thumbnail Options

| Option | Description |
|--------|-------------|
| `--write-thumbnail` | Write thumbnail image. |
| `--write-all-thumbnails` | Write all available thumbnail formats. |
| `--list-thumbnails` | List thumbnails (simulate unless `--no-simulate`). |

## Internet Shortcut Options

| Option | Description |
|--------|-------------|
| `--write-link` | Platform-appropriate shortcut (`.url`, `.webloc`, `.desktop`). |
| `--write-url-link` | Windows `.url` shortcut. |
| `--write-webloc-link` | macOS `.webloc` shortcut. |
| `--write-desktop-link` | Linux `.desktop` shortcut. |

[Source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md#usage-and-options]
