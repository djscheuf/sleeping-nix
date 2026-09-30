# yt-dlp Output Templates and Metadata

Output filename templates, available metadata fields, and metadata modification.

## Output Template Syntax

Use `-o TEMPLATE` for filenames and `-P [TYPES:]PATH` for base paths.

- `%(NAME)s` references a field.
- The default output template is `%(title)s [%(id)s].%(ext)s`.
- Use `%%` for a literal `%`.
- Output to stdout with `-o -`.

### Field formatting

| Feature | Syntax | Example |
|---------|--------|---------|
| Object traversal | `%(field.subkey)s` | `%(subtitles.en.-1.ext)s` |
| Slicing | `%(id.3:7)s` | `%(formats.:.format_id)s` |
| Dictionary subset | `%(formats.:.{format_id,height})#j` | |
| Arithmetic | `%(playlist_index+10)03d` | `%(n_entries+1-playlist_index)d` |
| strftime | `%(upload_date>%Y-%m-%d)s` | `%(duration>%H-%M-%S)s` |
| Alternates | `%(field1,field2|default)s` | `%(release_date>%Y,upload_date>%Y|Unknown)s` |
| Replacement | `%(field&replacement|default)s` | `%(title&TITLE={:>20}|NO TITLE)s` |
| Default value | `%(field|default)s` | `%(uploader|Unknown)s` |

### Additional conversion types

yt-dlp adds these format conversion letters beyond standard Python printf:

- `B` — bytes with decimal suffix.
- `j` — JSON (`#j` pretty-prints, `+j` uses Unicode).
- `h` — HTML escape.
- `l` — comma-separated list (`#l` newline-separated).
- `q` — terminal-quoted string (`#q` splits a list into arguments).
- `D` — decimal suffixes (e.g. `10M`); `#D` uses 1024 factor.
- `S` — sanitize as filename; `#S` restricted.
- `U` — Unicode normalization (`#U` for NFD, `+U` for NFKC/NFKD).

### Per-file-type templates

Prefix the template with the file type and a colon:

```bash
-o "subtitle:%(title)s.%(ext)s" -o "thumbnail:%(title)s/%(title)s.%(ext)s"
```

Supported types: `subtitle`, `thumbnail`, `description`, `annotation` (deprecated), `infojson`, `link`, `pl_thumbnail`, `pl_description`, `pl_infojson`, `chapter`, `pl_video`.

### Output template examples

```bash
# Literal name preserving correct extension
yt-dlp --print filename -o "test video.%(ext)s" ptd1NN40vMw

# Playlist in separate directory indexed by order
yt-dlp -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "PLAYLIST_URL"

# Group by upload year
yt-dlp -o "%(upload_date>%Y)s/%(title)s.%(ext)s" "PLAYLIST_URL"

# Subtitles in a sibling directory
yt-dlp -P "C:/MyVideos" -o "%(uploader)s/%(title)s.%(ext)s" \
       -o "subtitle:%(uploader)s/subs/%(title)s.%(ext)s" ID --write-subs

# Stream to stdout
yt-dlp -o - ID
```

## Common Output Template Fields

### Video

- `id`, `title`, `fulltitle`, `alt_title`, `description`, `ext`
- `display_id`, `uploader`, `uploader_id`, `uploader_url`
- `license`, `creators`, `creator`
- `timestamp`, `upload_date`, `release_timestamp`, `release_date`, `release_year`
- `modified_timestamp`, `modified_date`
- `channel`, `channel_id`, `channel_url`, `channel_follower_count`, `channel_is_verified`
- `location`, `duration`, `duration_string`
- `view_count`, `concurrent_view_count`, `like_count`, `dislike_count`, `repost_count`, `average_rating`, `comment_count`, `save_count`
- `age_limit`, `live_status`, `is_live`, `was_live`
- `playable_in_embed`, `availability`, `media_type`
- `start_time`, `end_time`
- `extractor`, `extractor_key`, `epoch`

### Playlist / queue

- `autonumber`, `video_autonumber`
- `n_entries`, `playlist_id`, `playlist_title`, `playlist`, `playlist_count`, `playlist_index`
- `playlist_autonumber`, `playlist_uploader`, `playlist_uploader_id`
- `playlist_channel`, `playlist_channel_id`, `playlist_webpage_url`

### URLs and categories

- `webpage_url`, `webpage_url_basename`, `webpage_url_domain`, `original_url`
- `categories`, `tags`, `cast`

### Chapter / section

- `chapter`, `chapter_number`, `chapter_id`
- `section_title`, `section_number`, `section_start`, `section_end`

### Episode / music

- `series`, `series_id`, `season`, `season_number`, `season_id`
- `episode`, `episode_number`, `episode_id`
- `track`, `track_number`, `track_id`
- `artists`, `artist`, `genres`, `genre`, `composers`, `composer`
- `album`, `album_type`, `album_artists`, `album_artist`, `disc_number`

### Print-only / post-download

- `urls` — requested format URLs.
- `filename` — intended filename (actual may differ after post-processing).
- `formats_table`, `thumbnails_table`, `subtitles_table`, `automatic_captions_table`.
- `filepath` — final path after download (`post_process`/`after_move`).

## Modifying Metadata

Use `--parse-metadata [WHEN:]FROM:TO` and `--replace-in-metadata [WHEN:]FIELDS REGEX REPLACE`.

- `FROM` can be a field name or an output-template expression.
- `TO` can be a field name, regex with named capture groups, or output-template.
- Options preserve relative order, so replacements can operate on parsed fields and vice versa.
- New fields can be used in `--output`, `--print`, and metadata embedding.

### Special metadata prefixes

- `meta_<field>` — set the embedded metadata field value.
- `meta<n>_<field>` — set metadata for the nth stream (e.g. `meta1_language`).
- `additional_urls` — download an extra URL from extracted metadata.

### Default embedded metadata mapping

| Embedded field | Source |
|----------------|--------|
| `title` | `track` or `title` |
| `date` | `upload_date` |
| `description`, `synopsis` | `description` |
| `purl`, `comment` | `webpage_url` |
| `track` | `track_number` |
| `artist` | `artist`, `artists`, `creator`, `creators`, `uploader`, `uploader_id` |
| `composer` | `composer`, `composers` |
| `genre` | `genre`, `genres`, `categories`, `tags` |
| `album` | `album` or `series` |
| `album_artist` | `album_artist` or `album_artists` |
| `disc` | `disc_number` |
| `show` | `series` |
| `season_number` | `season_number` |
| `episode_id` | `episode` or `episode_id` |
| `episode_sort` | `episode_number` |
| `language` of each stream | format `language` |

### Metadata modification examples

```bash
# Interpret title as "Artist - Title"
yt-dlp --parse-metadata "title:%(artist)s - %(title)s"

# Extract artist from description with regex
yt-dlp --parse-metadata "description:Artist - (?P<artist>.+)"

# Copy episode field to title
yt-dlp --parse-metadata "episode:title"

# Set title to custom series format
yt-dlp --parse-metadata "%(series)s S%(season_number)02dE%(episode_number)02d:%(title)s"

# Use uploader as artist in embedded metadata
yt-dlp --parse-metadata "%(uploader|)s:%(meta_artist)s" --embed-metadata

# Replace spaces and underscores with hyphens
yt-dlp --replace-in-metadata "title,uploader" "[ _]" "-"
```

[Source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md#output-template]
