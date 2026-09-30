# yt-dlp Configuration

Configuration file locations, environment variables, `.netrc` authentication, and extractor arguments.

## Configuration File Locations

yt-dlp reads options from config files in this order (later files can override earlier ones):

1. **Main Configuration** — file/directory given to `--config-locations`.
2. **Portable Configuration** — recommended for portable installs:
   - Binary directory: `yt-dlp.conf`
   - Source tree parent directory: `yt-dlp.conf`
3. **Home Configuration**:
   - `yt-dlp.conf` in the `-P` home path (or current directory if `-P` omitted).
4. **User Configuration**:
   - `${XDG_CONFIG_HOME}/yt-dlp.conf`
   - `${XDG_CONFIG_HOME}/yt-dlp/config` (recommended on Linux/macOS)
   - `${XDG_CONFIG_HOME}/yt-dlp/config.txt`
   - `${APPDATA}/yt-dlp.conf`
   - `${APPDATA}/yt-dlp/config` (recommended on Windows)
   - `${APPDATA}/yt-dlp/config.txt`
   - `~/yt-dlp.conf`
   - `~/yt-dlp.conf.txt`
   - `~/.yt-dlp/config`
   - `~/.yt-dlp/config.txt`
5. **System Configuration**:
   - `/etc/yt-dlp.conf`
   - `/etc/yt-dlp/config`
   - `/etc/yt-dlp/config.txt`

If `--ignore-config` (`--no-config`) is found in a config file, no further config files are loaded. If found in the system config, the user config is not loaded (backward compatibility).

## Configuration File Format

- Each line contains one CLI option exactly as on the command line.
- **No whitespace** after `-` or `--`. Use `-o` or `--proxy`, not `- o` or `-- proxy`.
- Quote values as needed, as if in a UNIX shell.
- Lines starting with `#` are comments.

Example `yt-dlp.conf`:

```
# Always extract audio
-x

# Copy the mtime
--mtime

# Use this proxy
--proxy 127.0.0.1:3128

# Save all videos under ~/YouTube
-o ~/YouTube/%(title)s.%(ext)s
```

## Configuration File Encoding

- Files are decoded from UTF BOM if present; otherwise from the system locale.
- To force a different encoding, put `# coding: ENCODING` as the very first line with no preceding characters (not even spaces or BOM).

## Environment Variables

- Path-like options accept UNIX-style variables on Windows as well as Windows-style.
- Defaults:
  - `${XDG_CONFIG_HOME}` defaults to `~/.config`
  - `${XDG_CACHE_HOME}` defaults to `~/.cache`
- On Windows:
  - `~` resolves to `${HOME}` if set, otherwise `${USERPROFILE}`, otherwise `${HOMEDRIVE}${HOMEPATH}`.
  - `${USERPROFILE}` is typically `C:\Users\<user>`.
  - `${APPDATA}` is `${USERPROFILE}\AppData\Roaming`.

## netrc Authentication

Use a `.netrc` file to avoid passing credentials on the command line.

1. Create and lock down the file:

```bash
touch ${HOME}/.netrc
chmod a-rwx,u+rw ${HOME}/.netrc
```

2. Add entries per extractor (extractor name in lowercase):

```netrc
machine youtube login myaccount@gmail.com password my_youtube_password
machine twitch login my_twitch_account_name password my_twitch_password
```

3. Enable with `--netrc` or place it in the config file.

### Encrypted netrc

Use `--netrc-cmd` to provide credentials from a command that outputs netrc-format text and exits 0. `{}` is replaced by the extractor name.

```bash
yt-dlp --netrc-cmd 'gpg --decrypt ~/.authinfo.gpg' "URL"
```

## Extractor Arguments

Pass site-specific options with `--extractor-args IE_KEY:ARGS`. `ARGS` is a semicolon-separated list of `ARG=VAL1,VAL2`. In the CLI, `-` and `_` are interchangeable in `ARG` names.

### Common / notable extractors

#### `youtube`

| Argument | Description |
|----------|-------------|
| `lang=CODE` | Prefer translated metadata of this language. |
| `skip=hls,dash,translated_subs` | Skip extraction of manifests/subtitles. |
| `player_client=CLIENTS` | Default: `visionos,web`. Available: `web`, `web_safari`, `web_embedded`, `web_music`, `web_creator`, `mweb`, `ios`, `visionos`, `android`, `android_vr`, `tv`, `tv_downgraded`, `tv_simply`. Use `default` or `all`; prefix with `-` to exclude. |
| `player_skip=CONFIGS,WEBPAGE,JS,INITIAL_DATA` | Skip network requests for configs/webpage/JS player/initial data. |
| `webpage_skip=...` | Skip embedded webpage data extraction. |
| `player_params=...` | Override YouTube player parameters. |
| `player_js_variant=...` | JavaScript variant for n/sig deciphering. |
| `player_js_version=...` | Pin JS version for deciphering. |
| `comment_sort=top|new` | Comment sort mode. |
| `max_comments=...` | Limit comments gathered. |
| `formats=dashy,duplicate,incomplete,missing_pot` | Adjust returned format types. |
| `po_token=CLIENT.CONTEXT+TOKEN,...` | Proof of Origin tokens. |
| `fetch_pot=always|never|auto` | PO token fetching policy (default `auto`). |
| `use_ad_playback_context=true|false` | Skip preroll ads for `mweb`/`web_music` (do not use with premium cookies). |

#### `youtube-ejs`

- `jitless=true|false` — run JS runtimes in JIT-less mode (supports `deno`, `node`, `bun`).

#### `generic`

- `fragment_query`, `variant_query`, `key_query` — pass query parameters to fragments/variants/HLS key URIs.
- `hls_key=URI|KEY[,IV]` — override HLS AES-128 key/IV in hex.
- `is_live=true|false` — force live status.
- `impersonate=TARGETS` — impersonation targets for initial webpage.

#### `twitter`

- `api=graphql|legacy|syndication` — API used for tweet extraction (no effect if logged in).

#### `twitch`

- `client_id=ID` — custom GraphQL client ID.

#### `tiktok`

- `api_hostname`, `app_name`, `app_version`, `manifest_app_version`, `aid`, `app_info`, `device_id` — mobile API parameters.

#### `vimeo`

- `client=android|web` — client to extract from.
- `original_format_policy=always|never|auto` — original format extraction policy.

> Many more extractor-specific arguments exist. See the upstream README for the full list.

[Source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md#configuration]
