---
description: Reference for yt-dlp command-line usage, configuration, format selection, output templates, and debugging.
---

# yt-dlp

yt-dlp is a feature-rich command-line audio/video downloader forked from youtube-dl, supporting thousands of sites. It is typically invoked as `yt-dlp [OPTIONS] URL [URL...]`.

Reach for this skill when you need to:

- Construct or troubleshoot yt-dlp commands from the terminal.
- Choose formats, write output templates, or configure post-processing.
- Debug download, extraction, network, or format-selection failures.
- Understand site-specific extractor options (especially YouTube) or configuration file behavior.

## Reference Files

- `cli-basics.md` — core invocation, general options, network/geo options, verbosity/simulation, workarounds, and preset aliases. Start here for everyday CLI commands.
- `download-and-filesystem.md` — video selection, download options, filesystem behavior, cookies/cache, thumbnails, and internet shortcuts.
- `formats-and-postprocessing.md` — format selection syntax, filtering/sorting, subtitle/auth options, post-processing, SponsorBlock, and extractor options.
- `output-templates-and-metadata.md` — output template syntax and field reference, plus metadata modification with `--parse-metadata` and `--replace-in-metadata`.
- `configuration.md` — config file locations and format, environment variables, `.netrc` auth, and extractor arguments (especially YouTube).
- `debugging.md` — troubleshooting workflow, verbose output, simulation, common failure patterns, update channels, compat options, and issue reporting.

## Quick Reminders

- Default invocation downloads the best available quality: `yt-dlp "URL"`.
- Use `-F` to list formats, `-s` to simulate, and `-v` for debug output.
- Update to the recommended `nightly` channel when a site stops working: `yt-dlp --update-to nightly`.
- Output template default: `%(title)s [%(id)s].%(ext)s`.
- Format selection default: `bestvideo*+bestaudio/best`.

[Source: https://deepwiki.com/yt-dlp/yt-dlp (DeepWiki mirror); canonical source: https://github.com/yt-dlp/yt-dlp/blob/master/README.md]
