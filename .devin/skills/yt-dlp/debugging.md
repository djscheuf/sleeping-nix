# yt-dlp Debugging

How to diagnose and fix yt-dlp CLI problems. This file pairs with the option references in `cli-basics.md`, `download-and-filesystem.md`, and `formats-and-postprocessing.md`.

## First Steps

1. **Update yt-dlp**: many failures are fixed in newer releases.
   ```bash
   # Release binary users: switch to the recommended nightly channel
   yt-dlp --update-to nightly

   # pip users
   python -m pip install -U --pre "yt-dlp[default]"
   ```
   - Stable releases can lag behind site changes. The project recommends `nightly` for regular users.
   - If a version is older than 90 days, yt-dlp warns; add `--no-update` to suppress.

2. **Read the error message carefully**. yt-dlp usually reports:
   - The extractor used.
   - The operation that failed (download, extraction, post-processing).
   - Whether the failure is for one item or the whole run.

3. **Check dependencies**.
   - Required Python: 3.10+ (CPython), 3.11+ (PyPy).
   - Strongly recommended: `ffmpeg`, `ffprobe`, `yt-dlp-ejs`, and a JS runtime (deno is preferred).
   - yt-dlp warns when a dependency is missing and lists available dependencies at the top of `--verbose` output.

## Verbose Output

Always include verbose output when investigating an issue.

```bash
yt-dlp -v "URL"
```

For maximum detail:

```bash
yt-dlp -vv --print-traffic --write-pages --dump-pages "URL"
```

| Option | Use for |
|--------|---------|
| `-v, --verbose` | Debug-level logs, dependency list, full command line, version. |
| `-vv` | Even more verbose extractor internals. |
| `--print-traffic` | See HTTP request/response headers and bodies. |
| `--write-pages` | Save downloaded intermediary pages to files in the current directory. |
| `--dump-pages` | Print base64-encoded downloaded pages to the log. |
| `--no-warnings` | Hide warnings to reduce noise (only after understanding them). |

## Simulation Before Downloading

Test a command without downloading anything:

```bash
yt-dlp -s "URL"              # Simulate extraction + selection
yt-dlp -F "URL"              # List available formats
yt-dlp -J "URL"              # Dump full info JSON for the URL/playlist
yt-dlp -O filename "URL"     # Print what filename would be used
yt-dlp --print "%(formats_table)s" "URL"
```

Use `--no-simulate` if you want printing/listing options to still download.

## Common Failure Patterns

### "No video formats" / "This video is unavailable"

- Try updating to `nightly` first.
- Pass cookies from a logged-in browser:
  ```bash
  yt-dlp --cookies-from-browser firefox "URL"
  ```
- Use a different player client:
  ```bash
  yt-dlp --extractor-args "youtube:player_client=web,tv" "URL"
  ```
- Check geo-restriction (see below).
- Pass `--ignore-no-formats-error` to continue extracting metadata even when no downloadable formats exist.

### Downloads are very slow or throttled

- Try an external downloader: `--downloader aria2c`.
- Reduce concurrent fragments: `-N 4` or `-N 1`.
- Change protocol preference: `-S proto`.
- Use HTTP chunking: `--http-chunk-size 10M`.
- Add sleeps to avoid rate limits:
  ```bash
  yt-dlp --sleep-requests 0.75 --sleep-interval 10 --max-sleep-interval 20
  ```

### Geo-restricted content

- Use a proxy: `--proxy socks5://user:pass@host:port`.
- Use geo-verification proxy only for checks: `--geo-verification-proxy URL`.
- Try X-Forwarded-For bypass: `--xff COUNTRY_CODE` or `--xff CIDR`.

### Certificate / TLS errors

- Test with `--no-check-certificates` (insecure, only for testing).
- If TLS fingerprinting is suspected, use `--impersonate chrome` or install `curl_cffi` (`pip install "yt-dlp[default,curl-cffi]"`).
- Check system/root certificates; `certifi` is bundled in standalone builds.

### Fragmented downloads fail mid-way

- Enable retries:
  ```bash
  yt-dlp -R infinite --fragment-retries infinite --retry-sleep fragment:exp=1:20 "URL"
  ```
- Resume partial files: `--continue` (default).
- Keep fragments for inspection: `--keep-fragments`.
- Skip missing fragments: `--skip-unavailable-fragments` (default).
- For HLS live streams, use `--hls-use-mpegts`.

### ffmpeg / post-processing errors

- Verify ffmpeg/ffprobe are installed and on PATH, or specify `--ffmpeg-location PATH`.
- Pass `--no-check-formats` if format probing fails but the file plays.
- Check postprocessor args with `--ppa` when customizing ffmpeg behavior.

## Dumping Structured Data

The most reliable way to inspect what yt-dlp sees:

```bash
yt-dlp -J --flat-playlist "URL" > playlist.json
yt-dlp -j "URL" > videos.jsonl
yt-dlp -F "URL" > formats.txt
```

Use `-j` for one JSON object per video, `-J` for one object per URL (playlists included).

## Progress and Logs

- `--newline` forces progress bars to print on separate lines (useful when capturing logs).
- `--no-progress` hides the progress bar.
- `--progress-template` lets you customize progress output for machine parsing.
- `--console-title` updates the terminal title.

## Isolating Configuration

To rule out user config files:

```bash
yt-dlp --ignore-config -v "URL"
```

To load only a specific config:

```bash
yt-dlp --config-locations /path/to/yt-dlp.conf "URL"
```

## Bisecting Playlist / Batch Issues

- Limit to one item: `-I 1`.
- Limit total downloads: `--max-downloads 1`.
- Process a single URL first before running a large batch.
- Use `--break-on-existing` with `--download-archive` to stop at the first already-seen item.

## Useful Debug Recipes

```bash
# Minimal reproducible run with no config
yt-dlp --ignore-config -v "URL"

# See available formats + extractor debug info
yt-dlp -v -F "URL"

# Dump page source for inspection
yt-dlp -v --write-pages "URL"

# Test format selection without downloading
yt-dlp -s -f "bv*+ba/b" -S res:720 "URL"

# Capture full traffic (noisy)
yt-dlp -vv --print-traffic "URL"

# Verify cookie loading
yt-dlp -v --cookies-from-browser firefox --list-formats "URL"
```

## Update Channels

- `stable` (default): monthly; can be stale when sites change.
- `nightly` (recommended): published nightly if code changed.
- `master`: per-commit canary; latest fixes but possible regressions.

Switch or pin:

```bash
yt-dlp --update-to nightly
yt-dlp --update-to stable@2023.07.06
yt-dlp --update-to 2023.10.07
```

> Warning: `--update-to owner/repo@tag` can update from arbitrary repositories without verification.

## Reporting Issues

Before opening an issue:

1. Update to the latest nightly/master.
2. Search existing issues.
3. Provide a **minimal** command and a public URL that reproduces the problem.
4. Include the **full verbose output** (`-v`) as text, not screenshots.
5. Include the version (`yt-dlp --version`).

## Compatibility Switches

If a command that worked with youtube-dl behaves differently, use `--compat-options`:

| Use case | Option |
|----------|--------|
| youtube-dl-style filename | `--compat-options filename` |
| youtube-dl-style format sorting | `--compat-options format-sort` |
| youtube-dl-style format selector | `--compat-options format-spec` |
| Abort on error by default | `--compat-options abort-on-error` |
| Enable multi-streams | `--compat-options multistreams` |
| Old list-formats output | `--compat-options list-formats` |
| Embed metadata like youtube-dl | `--compat-options embed-metadata` |
| Restore mtime-by-default | `--compat-options mtime-by-default` |

Year aliases exist: `--compat-options 2023`, `--compat-options 2024`, etc. Each pins behavior to the end of that calendar year.

[Source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md and yt-dlp Wiki/FAQ]
