# yt-dlp Format Selection and Post-processing

Format selection syntax, filtering/sorting, video format options, subtitles, SponsorBlock, authentication, and post-processing.

## Format Selection

Default behavior (no `-f` given) is `bestvideo*+bestaudio/best`. With `--audio-multistreams`, default becomes `bestvideo+bestaudio/best`. Without ffmpeg or when streaming to stdout (`-o -`), default is `best/bestvideo+bestaudio`.

Use `-f FORMAT` or `--format FORMAT` to override.

### Special format selectors

| Selector | Meaning |
|----------|---------|
| `all` | Download every available format separately. |
| `mergeall` | Download and merge all formats (requires `--video-multistreams`, `--audio-multistreams`, or both). |
| `b*` / `best*` | Best format containing video or audio. |
| `b` / `best` | Best combined video+audio format. |
| `bv` / `bestvideo` | Best video-only format. |
| `bv*` / `bestvideo*` | Best format containing video (may have audio). |
| `ba` / `bestaudio` | Best audio-only format. |
| `ba*` / `bestaudio*` | Best format containing audio (may have video). |
| `w*` / `worst*` / `w` / `worst` / `wv` / `wa` | Worst equivalents of the above. |

- Combine with `+` to merge: `-f bv+ba`.
- Use commas for fallback precedence: `-f 22/17/18`.
- Use commas without `+` to download multiple formats: `-f 22,17,18`.
- Use `best<type>.<n>` for the nth best format, e.g. `best.2`, `bv*.3`.

## Filtering Formats

Filter inside brackets after a selector: `-f "best[height=720]"`.

### Numeric fields

`filesize`, `filesize_approx`, `width`, `height`, `aspect_ratio`, `tbr`, `abr`, `vbr`, `asr`, `fps`, `audio_channels`, `stretched_ratio`.

Operators: `<`, `<=`, `>`, `>=`, `=`, `!=`.

### String fields

`url`, `ext`, `acodec`, `vcodec`, `container`, `protocol`, `language`, `dynamic_range`, `format_id`, `format`, `format_note`, `resolution`.

Operators: `=`, `^=` (starts with), `$=` (ends with), `*=` (contains), `~=` (regex).

- Prefix with `!` to negate, e.g. `!*=` (does not contain).
- Append `?` to an operator to include values that are unknown, e.g. `[height<=?720]`.
- Group filters with parentheses: `-f "(mp4,webm)[height<480]"`.

## Sorting Formats

Use `-S` / `--format-sort SORTORDER` to change what "best"/"worst" means. Default order:

```
lang,quality,res,fps,hdr:12,vcodec,channels,acodec,size,br,asr,proto,ext,hasaud,source,id
```

### Available sort fields

| Field | Description |
|-------|-------------|
| `hasvid`, `hasaud` | Prefer formats with video/audio streams. |
| `ie_pref` | Extractor format preference. |
| `lang` | Language preference. |
| `quality` | Quality score. |
| `source` | Source preference. |
| `proto` | Download protocol preference. |
| `vcodec` | Video codec preference (`av01` > `vp9.2` > `vp9` > `h265` > `h264` > ...). |
| `acodec` | Audio codec preference (`flac`/`alac` > `wav`/`aiff` > `opus` > `vorbis` > `aac` > ...). |
| `codec` | Equivalent to `vcodec,acodec`. |
| `vext` | Video extension preference. |
| `aext` | Audio extension preference. |
| `ext` | Equivalent to `vext,aext`. |
| `filesize`, `fs_approx`, `size` | Filesize. |
| `height`, `width`, `res` | Resolution. |
| `fps` | Framerate. |
| `hdr` | Dynamic range (`DV` > `HDR12` > `HDR10+` > `HDR10` > `HLG` > `SDR`). |
| `channels` | Audio channels. |
| `tbr`, `vbr`, `abr`, `br` | Bitrates. |
| `asr` | Audio sample rate. |

- Prefix a field with `+` to reverse (ascending).
- Suffix `:VALUE` to prefer nearest or limit to a value, e.g. `res:720`, `filesize~1G`.
- `hasvid` and `ie_pref` normally have highest priority; use `--format-sort-force` to let user order dominate.
- Use `--format-sort-reset` to discard previous `-S` arguments.

## Useful Format Examples

```bash
# Best video+audio, or merge best video-only + audio-only
yt-dlp -f "bv*+ba/b"

# Best no larger than 720p
yt-dlp -S "res:720"

# Smallest file
yt-dlp -S "+size,+br"

# Best mp4, else best available
yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"

# Best via direct HTTP/HTTPS
yt-dlp -f "(bv*+ba/b)[protocol^=http][protocol!*=dash] / (bv*+ba/b)"

# Best H.264/h.265 only
yt-dlp -f "(bv*[vcodec~='^((he|a)vc|h26[45])']+ba) / (bv*+ba/b)"
```

## Video Format Options

| Option | Description |
|--------|-------------|
| `-f, --format FORMAT` | Format selector. |
| `-S, --format-sort SORTORDER` | Sort order. |
| `--format-sort-reset` | Reset sort order. |
| `--format-sort-force` / `--no-format-sort-force` | Let user sort override extractor defaults (default: no). |
| `--video-multistreams` / `--no-video-multistreams` | Allow multiple video streams (default: no). |
| `--audio-multistreams` / `--no-audio-multistreams` | Allow multiple audio streams (default: no). |
| `--prefer-free-formats` / `--no-prefer-free-formats` | Prefer free containers. |
| `--check-formats` / `--check-all-formats` / `--no-check-formats` | Verify formats are actually downloadable before selecting. |
| `-F, --list-formats` | List available formats (simulate unless `--no-simulate`). |
| `--merge-output-format FORMAT` | Container used when merging (e.g. `mp4/mkv`). Supported: `avi`, `flv`, `mkv`, `mov`, `mp4`, `webm`. |

## Subtitle Options

| Option | Description |
|--------|-------------|
| `--write-subs` | Write subtitle file. |
| `--write-auto-subs` | Write auto-generated subtitles. |
| `--list-subs` | List available subtitles. |
| `--sub-format FORMAT` | Preferred format(s), e.g. `srt` or `ass/srt/best`. |
| `--sub-langs LANGS` | Comma-separated language codes or regex, e.g. `en.*,ja`. Use `all` or prefix with `-` to exclude. |

## Authentication Options

| Option | Description |
|--------|-------------|
| `-u, --username USERNAME` | Account ID. |
| `-p, --password PASSWORD` | Account password. |
| `-2, --twofactor TWOFACTOR` | 2FA code. |
| `-n, --netrc` | Use `.netrc`. See `configuration.md`. |
| `--netrc-location PATH` | Custom `.netrc` location (default `~/.netrc`). |
| `--netrc-cmd NETRC_CMD` | Command to fetch credentials in netrc format. |
| `--video-password PASSWORD` | Video-specific password. |
| `--ap-mso MSO` / `--ap-username` / `--ap-password` | Adobe Pass TV-provider credentials. |
| `--ap-list-mso` | List supported TV providers. |
| `--client-certificate CERTFILE` / `--client-certificate-key KEYFILE` / `--client-certificate-password PASSWORD` | Client certificate auth. |

## Post-processing Options

| Option | Description |
|--------|-------------|
| `-x, --extract-audio` | Convert to audio-only (needs ffmpeg/ffprobe). |
| `--audio-format FORMAT` | Target audio format: `best` (default), `aac`, `alac`, `flac`, `m4a`, `mp3`, `opus`, `vorbis`, `wav`. |
| `--audio-quality QUALITY` | VBR 0-10 (default 5) or bitrate like `128K`. |
| `--remux-video FORMAT` | Remux into another container if needed. Supported containers similar to `--merge-output-format`; can use rules like `aac>m4a/mov>mp4/mkv`. |
| `--recode-video FORMAT` | Re-encode video. Syntax same as `--remux-video`. |
| `--postprocessor-args NAME:ARGS` / `--ppa` | Pass args to postprocessors/executables. Prefixes like `Merger+ffmpeg_i1:` for input/output position. Repeatable. |
| `-k, --keep-video` | Keep intermediate file after post-processing. |
| `--post-overwrites` / `--no-post-overwrites` | Overwrite post-processed files (default: yes). |
| `--embed-subs` | Embed downloaded subtitles in mp4/webm/mkv. |
| `--embed-thumbnail` | Embed thumbnail as cover art. |
| `--embed-metadata` / `--add-metadata` | Embed metadata; also embeds chapters/infojson unless disabled. |
| `--embed-chapters` / `--add-chapters` | Embed chapter markers. |
| `--embed-info-json` | Attach infojson to mkv/mka files. |
| `--parse-metadata [WHEN:]FROM:TO` | Parse/rewrite metadata. See `output-templates-and-metadata.md`. |
| `--replace-in-metadata [WHEN:]FIELDS REGEX REPLACE` | Regex replace in metadata fields. |
| `--xattrs` | Write metadata to xattrs. |
| `--concat-playlist POLICY` | Concatenate playlist videos: `never`, `always`, `multi_video` (default). |
| `--fixup POLICY` | Auto-correct file faults: `never`, `warn`, `detect_or_warn` (default), `force`. |
| `--ffmpeg-location PATH` | Path to ffmpeg binary or directory. |
| `--exec [WHEN:]CMD` | Run a shell command at a post-processing stage. Allowed output-template conversions are `i`, `d`, `f`, `q`. Default stage: `after_move`. |
| `--no-exec` | Clear previous `--exec` definitions. |
| `--convert-subs FORMAT` | Convert subtitles (`ass`, `lrc`, `srt`, `vtt`). |
| `--convert-thumbnails FORMAT` | Convert thumbnails (`jpg`, `png`, `webp`). |
| `--split-chapters` | Split output by internal chapters. Use `chapter:` prefix in `--output`/`--paths`. |
| `--remove-chapters REGEX` | Remove chapters matching regex. |
| `--force-keyframes-at-cuts` | Re-encode around chapter cuts for cleaner output. |
| `--use-postprocessor NAME[:ARGS]` | Enable a plugin postprocessor. `when` argument controls stage. |

## SponsorBlock Options

Use the [SponsorBlock API](https://sponsor.ajay.app) on YouTube.

| Option | Description |
|--------|-------------|
| `--sponsorblock-mark CATS` | Create chapter markers for categories. |
| `--sponsorblock-remove CATS` | Remove segments from video. |
| `--sponsorblock-chapter-title TEMPLATE` | Title template for marked chapters. |
| `--no-sponsorblock` | Disable SponsorBlock. |
| `--sponsorblock-api URL` | API endpoint (default `https://sponsor.ajay.app`). |

Available categories: `sponsor`, `intro`, `outro`, `selfpromo`, `preview`, `filler`, `interaction`, `music_offtopic`, `hook`, `poi_highlight`, `chapter`, `all`, `default`.

## Extractor Options

| Option | Description |
|--------|-------------|
| `--extractor-retries RETRIES` | Retries for extractor errors (default 3, or `infinite`). |
| `--allow-dynamic-mpd` / `--ignore-dynamic-mpd` | Process dynamic DASH manifests (default: allow). |
| `--hls-split-discontinuity` | Split HLS playlists at discontinuities (e.g. ad breaks). |
| `--extractor-args IE_KEY:ARGS` | Pass site-specific arguments. See `configuration.md` for common extractors. |

[Source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md#format-selection]
