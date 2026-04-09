# Documentation Prompt for `gencon-audiobook`

This is a standalone prompt to generate all documentation for the gencon-audiobook project. Copy this into a Claude Code session running in the gencon-audiobook repo.

---

## Prompt

Create all documentation for this project. Read the existing source code first to understand what's been implemented, then create the following files. The documentation must accurately reflect the actual code, not hypothetical features.

**Be brutally honest.** If you find the code is missing something referenced in these specs, note it in the docs as "planned" or "not yet implemented" rather than documenting features that don't exist.

---

## File 1: `docs/user-guide.md`

**Audience**: Someone who has never used a terminal, pip, or Python. ELI5 level.

**Tone**: Patient, friendly, zero jargon without explanation.

**Required sections**:

### 1. What is this tool?
Plain-English explanation: "This tool downloads General Conference talks and turns them into an audiobook you can listen to on your phone, and an ebook you can read."

### 2. What you need first
Python installation instructions for each platform:
- **Windows**: "Go to python.org, download the installer, **check 'Add to PATH'**, click Install." Emphasize the PATH checkbox — this is the #1 source of "command not found" errors.
- **macOS**: "Open Terminal, type `brew install python` or download from python.org."
- **Linux**: "Python is probably already installed. Open a terminal and type `python3 --version` to check."

### 3. Installing the tool
```
pip install gencon-audiobook
```
Show the exact command. Show what success looks like. Show the common "pip not found" error and how to fix it (`pip3` or `python -m pip`).

### 4. Running the tool
```
gencon-audiobook
```
Show the expected output step by step — scraping, downloading, converting, done. Show `--output ~/Books` for custom directory. Show `--skip-epub` and `--skip-audiobook` flags.

### 5. Finding your files
Explain the default output directory. Give file-explorer navigation instructions for Windows, macOS, and Linux.

### 6. Listening to your audiobook
- **iPhone/iPad**: "Open the Files app, find the .m4b file, tap it. It opens in Apple Books. You'll see chapters for each talk."
- **Android**: "Install **Smart AudioBook Player** from the Play Store. Open it and find the .m4b file. **Important**: the default music app and Google Play Books do NOT work with .m4b files."
- **Computer**: "On Mac, double-click → Apple Books. On Windows, double-click → iTunes. VLC plays it but won't show chapters."

### 7. Reading the epub
- **iPhone/iPad**: "Tap the .epub file → Apple Books."
- **Android**: "Open with Google Play Books, Moon+ Reader, or ReadEra."
- **Kindle**: "Use Amazon's 'Send to Kindle' to transfer the epub. It appears in your Kindle library."
- **Computer**: "Open with Calibre (free at calibre-ebook.com) or double-click."

### 8. Troubleshooting
Q&A format for common problems:
- "It says 'command not found'" → PATH issue on Windows (didn't check the box during Python install). Fix: reinstall Python with "Add to PATH" checked.
- "It says 'pip not found'" → Try `pip3` or `python -m pip install gencon-audiobook`
- "It says 'connection error'" → Check internet connection. The Church website may also be temporarily down.
- "The audiobook has no chapters" → You're using the wrong player. Use Apple Books (iOS/Mac), Smart AudioBook Player (Android), or iTunes (Windows). VLC plays the audio but ignores chapters.
- "It stopped working / 'website may have changed'" → The Church updated their website. Open a GitHub issue at https://github.com/XeroIP/gencon-audiobook/issues
- "It's really slow" → The tool adds a polite delay between downloads to be respectful to the Church's servers. A full conference takes a few minutes.

### 9. Updating
```
pip install --upgrade gencon-audiobook
```

---

## File 2: `docs/listening-guide.md`

**Audience**: Someone who received the .m4b and .epub files from a family member or friend. They did NOT run the tool. They may not be comfortable with technology.

**Tone**: Warm, patient, practical. Think "helping a parent figure out their phone."

**Must be**: Printable-friendly. Clean formatting. No code blocks. No terminal commands. No jargon.

**Required sections**:

### 1. Your files
"Someone has shared General Conference with you as an audiobook and an ebook. Here's how to use them on your devices."

Explain the two files:
- **The .m4b file** = the audiobook (every talk, in order, with chapters)
- **The .epub file** = the ebook (full text of every talk, with speaker photos)

### 2. The audiobook (.m4b)

**What it is**: "This is the complete General Conference as a single audiobook file. Each talk is a separate chapter, so you can skip between talks easily."

**iPhone / iPad**:
- Tap the file → it opens in Apple Books
- Find it later: Open Apple Books → Library → Audiobooks
- How to navigate: tap the chapter icon to see all talks listed by name and speaker

**Android**:
- You need an audiobook app. The regular music app will NOT work. Google Play Books will NOT work.
- We recommend **Smart AudioBook Player** (free on the Play Store)
- Open Smart AudioBook Player → find the file → play
- Chapters will show each talk's name and speaker

**Computer**:
- Mac: double-click → opens in Apple Books
- Windows: double-click → opens in iTunes or Windows Media Player
- Any computer: VLC can play it, but will not show chapter names

**How chapters work**: "Each talk is its own chapter, labeled with the talk title and speaker name. You can skip forward or backward by chapter to jump between talks."

### 3. The ebook (.epub)

**What it is**: "This is the full text of every General Conference talk, organized by session, with speaker photos."

**iPhone / iPad**: Tap the file → opens in Apple Books

**Android**: Open with Google Play Books (usually built in), or install Moon+ Reader for a better reading experience

**Kindle**: Email the .epub file to your Send-to-Kindle email address. It will appear in your Kindle library. (To find your Send-to-Kindle address: go to Amazon.com → Account → Devices → Kindle email)

**Computer**: Open with Calibre (free at calibre-ebook.com) or any ebook reader

### 4. Tips
- "Listen to the audiobook during your commute and follow along in the ebook at home"
- "The ebook is great for searching for a specific quote or scripture reference"
- "Both files work offline — no internet needed once you have them"

---

## File 3: `docs/technical-decisions.md`

**Audience**: Developers, contributors, and technically curious users.

**Purpose**: Document every significant decision with: what was chosen, what alternatives existed, and why. This is the project's institutional memory.

**Required sections** (each must explain the decision, alternatives considered, and rationale):

### 1. Language: Python
- Chosen: Python 3.10+
- Alternatives: Node.js/TypeScript, Go, Rust
- Why: Best library ecosystem for web scraping (requests + BeautifulSoup), audio metadata (mutagen), epub generation (ebooklib), and CLI tools (click). Largest pool of potential open-source contributors. Cross-platform without compilation.

### 2. ffmpeg: auto-download via static-ffmpeg
- Chosen: `static-ffmpeg` Python package (auto-downloads platform-specific binary)
- Alternatives: require user to install ffmpeg manually; bundle ffmpeg in release archives
- Why: Zero user setup. Manual install is the #1 source of issues in open source audio tools (PATH problems, wrong version, missing codecs). Bundling inflates releases by ~80MB per platform and has LGPL licensing implications.

### 3. Distribution: PyPI
- Chosen: `pip install gencon-audiobook`
- Alternatives: standalone binaries (PyInstaller), Docker, Homebrew
- Why: Standard Python distribution. Easy updates via `pip install --upgrade`. Works on all platforms where Python works. Standalone binaries are fragile to build and maintain cross-platform. Docker adds unnecessary complexity for a simple CLI tool.

### 4. Audio format: m4b with AAC-LC 64kbps / 44.1kHz / mono
- Chosen: AAC-LC profile, 64 kbps bitrate, 44.1 kHz sample rate, mono
- Alternatives: HE-AAC v2, higher bitrates (128k, 256k), stereo
- Why:
  - AAC-LC (not HE-AAC): HE-AAC has spotty support on older Android audiobook players. AAC-LC is universally decoded.
  - 64 kbps: Matches Audible's "Enhanced" quality tier. Diminishing returns above this for speech. ~29 MB/hour.
  - 44.1 kHz: Maximum device compatibility. Some older devices have issues with 22.05 kHz.
  - Mono: Conference talks are spoken word. Stereo doubles file size for zero benefit.
- Platform compatibility: Apple Books (iOS/Mac), Smart AudioBook Player (Android), Sirin (Android), BookPlayer (iOS), Bound (iOS), iTunes (Windows). Google Play Books does NOT support m4b.

### 5. Epub: EPUB 3 with reflowable layout
- Chosen: EPUB 3.0, reflowable, JPEG/PNG images only, no hardcoded CSS colors/fonts/sizes
- Alternatives: EPUB 2, fixed layout, include WebP images
- Why:
  - EPUB 3 over EPUB 2: All modern readers support EPUB 3. It's the current W3C standard.
  - Reflowable over fixed: Android renders fixed-layout epub as garbled text. Reflowable adapts to screen size.
  - JPEG/PNG only: WebP is not yet a core EPUB media type. Older readers ignore it.
  - No hardcoded styles: Deferring colors, fonts, and sizes to the reader ensures dark mode, sepia mode, accessibility modes, and custom fonts all work automatically.
- Kindle: Amazon accepts EPUB natively via "Send to Kindle" (auto-converts to AZW3). MOBI is dead (Amazon stopped accepting it in 2022). Valid, error-free EPUBs produce clean Kindle conversions.

### 6. Scraping: requests + BeautifulSoup
- Chosen: `requests` for HTTP, `beautifulsoup4` + `lxml` for parsing
- Alternatives: Selenium/Playwright (headless browser), scrapy
- Why: The Church website serves static HTML with embedded JSON state. No JavaScript execution required. A headless browser would add ~400MB of dependencies and 10x the runtime for zero benefit. Scrapy is designed for multi-site crawling — overkill for a single-site tool.

### 7. Chapter metadata: "Title — Speaker" format
- Chosen: Chapter titles formatted as `"Talk Title — Speaker Name"`
- Alternatives: title only, separate metadata fields
- Why: The m4b chapter specification has no per-chapter "author" field — only a title string. Embedding the speaker name in the chapter title (with an em-dash separator) is the only way to surface this information in audiobook players. Every major player (Apple Books, Smart AudioBook Player, Sirin) displays the chapter title prominently.

### 8. Testing strategy
- Chosen: Fixture-based unit tests + live smoke tests + weekly CI cron
- Why:
  - **Fixtures**: Fast, deterministic, document what the scraper expects. Run on every commit.
  - **Live smoke tests**: Verify the tool still works against the real website. Marked `@pytest.mark.live`, skipped in normal CI.
  - **Weekly cron**: Auto-runs live tests and opens a GitHub issue if they fail. Early warning when the Church updates their website.
  - **Fixture update script**: `scripts/update_fixtures.py` makes it easy to refresh HTML snapshots when the site changes.

### 9. Copyright handling
- Downloaded content is © Intellectual Reserve, Inc. Tool code is MIT licensed.
- m4b metadata `comment` field contains copyright notice
- epub includes a copyright page after the cover
- README has a prominent disclaimer
- `LICENSE-CONTENT.md` explains the distinction
- Copyright year is determined dynamically from the conference year

### 10. Rate limiting: 0.5s delay
- Chosen: 500ms delay between HTTP requests
- Why: Respectful of the Church's servers. One full conference is ~35 talk pages + 35 MP3s + 35 images ≈ 105 requests. At 0.5s delay, that's ~52 seconds of delay — adds about a minute to runtime. Removing the delay would hit the server with 105 rapid-fire requests, which is rude and risks IP bans.

### 11. User-Agent transparency
- Chosen: `gencon-audiobook/<version> (open source; github.com/XeroIP/gencon-audiobook)`
- Alternatives: impersonate a browser User-Agent
- Why: Ethical obligation to be identifiable. Allows the Church's infrastructure team to identify and contact the project if needed. The GitHub URL in the User-Agent string provides easy contact.

### 12. Security decisions
- URL allowlisting: Only fetch from `churchofjesuschrist.org` and `*.ldscdn.org`. Prevents the scraper from following unexpected redirects to third-party domains.
- Filename sanitization: Characters outside `[a-zA-Z0-9 ._-]` are stripped. Prevents path traversal and OS-specific filename issues.
- No eval/exec: The Church website embeds base64-encoded JSON in page state. We decode and JSON-parse only — never execute.
- SSL always on: Never `verify=False`. If a cert fails, that's a real problem worth surfacing.

### 13. Logging & Troubleshooting
Document the logging architecture:
- **Default output** (INFO via `rich`): What the user sees during a normal run. Show example output.
- **Verbose mode** (`--verbose`): Enables DEBUG-level console output. Shows URLs fetched, CSS selectors matched, ffmpeg commands, file paths, timing.
- **Log file** (`<output_dir>/gencon-audiobook.log`): Full DEBUG-level log written on every run. Persists after completion.
- **Log format**: `%(asctime)s [%(levelname)s] %(name)s: %(message)s`
- **Common troubleshooting scenarios** and what to look for in the log:
  - "Scraper found 0 talks" → look for WARNING/ERROR about CSS selectors
  - "Download failed" → look for HTTP status codes, timeout messages, retry attempts
  - "ffmpeg error" → look for the exact ffmpeg command and stderr output
  - "epub validation failed" → look for epubcheck errors
- **How to file a bug report**: Include the relevant log section, Python version, OS, and tool version.

---

## File 4: `docs/architecture.md`

**Audience**: Contributors and developers who want to understand or modify the codebase.

**Required sections**:

### 1. Data flow diagram
Show the complete pipeline as text/ASCII:
```
churchofjesuschrist.org
        ↓
   [scraper.py] → Fetch conference listing → Parse talk metadata
        ↓                                          ↓
   [scraper.py] → Fetch each talk page → Extract MP3 URL, transcript, speaker photo URL
        ↓
   [models.py] → Conference object (Sessions → Talks)
        ↓
   [downloader.py] → Download MP3s, cover image, speaker photos (with retry + progress)
        ↓
   ┌────────────────────────┐
   │                        │
   [audio.py]          [epub_builder.py]
   ↓                        ↓
   ffmpeg: MP3→AAC     EPUB 3 with transcripts,
   Concatenate          speaker photos, cover,
   Add chapters         table of contents
   Embed cover
   ↓                        ↓
   .m4b audiobook      .epub ebook
```

### 2. Module responsibilities
One paragraph per module explaining its purpose, public API, and what it depends on. Read the actual source files to write this accurately.

### 3. Error handling strategy
- Where errors are caught vs. propagated
- How user-facing errors are formatted
- How the tool decides to skip a single failed talk vs. abort entirely
- The retry strategy for network requests

### 4. Extensibility points
Document where future features should plug in:
- **Multi-language**: What changes in the scraper URL construction, filename generation, and epub language metadata
- **Arbitrary conference selection**: What changes in the CLI args and scraper entry point
- **Batch mode**: How multiple conferences could be processed in a loop
- **Alternative audio sources**: How the downloader could accept URLs from a different source

---

## File 5: Verify and update `README.md`

Read the existing README.md. Ensure it includes ALL of the following. Add anything missing:

1. **Project description** — one paragraph, references [original project](https://github.com/ChurchofJesusChristDev/General-Conference-to-Audiobook) as inspiration
2. **Disclaimer** (prominent, near top):
   > **Disclaimer**: This is an unofficial tool not affiliated with The Church of Jesus Christ of Latter-day Saints. General Conference content is © Intellectual Reserve, Inc. All rights reserved. This tool downloads content for personal, noncommercial use as permitted by the Church's Terms of Use.
3. **Quick start** — pip install + run (3 lines max)
4. **Platform notes**:
   - Android: need Smart AudioBook Player or Sirin (Google Play Books doesn't support m4b)
   - iOS: Apple Books works natively
   - Kindle: epub supported via "Send to Kindle"
5. **CLI options** — `--output`, `--skip-epub`, `--skip-audiobook`, `--verbose`, `--version`
6. **Links to docs** — user guide, listening guide, technical decisions, architecture
7. **Contributing link** → CONTRIBUTING.md
8. **License** — MIT for tool, content is © Intellectual Reserve, Inc.

---

## File 6: Verify and update `CONTRIBUTING.md`

Read the existing CONTRIBUTING.md. Ensure it includes:

1. **Dev setup** — clone, create venv, `pip install -e ".[dev]"`
2. **Running tests** — unit tests, live tests, integration tests, coverage
3. **When the website changes** — step-by-step guide:
   a. Run `python scripts/update_fixtures.py` to refresh HTML snapshots
   b. Run `pytest tests/test_scraper.py` — see what breaks
   c. Update CSS selectors in `scraper.py`
   d. Run tests again until they pass
   e. Run `pytest tests/test_scraper_live.py` to verify against live site
   f. Submit PR with updated fixtures and scraper
4. **PR requirements** — tests pass, fixtures updated if scraper changed
5. **Code style** — type hints, Google docstrings, logging conventions

---

## Code Standards (apply to all source files)

After writing the docs, audit the existing source code in `src/gencon_audiobook/` and ensure it meets these standards. Fix any gaps:

### Logging
Every module must have `logger = logging.getLogger(__name__)` near the top. Use:
- **DEBUG**: URLs fetched, CSS selectors matched, file paths, ffmpeg commands, timing
- **INFO**: "Scraping conference...", "Downloading 34 talks...", "Building audiobook...", "Done."
- **WARNING**: Missing speaker photo, fallback selector used, retry attempt
- **ERROR**: Single file failed after retries, single talk parse failed (skip and continue)
- **CRITICAL**: No talks found, ffmpeg unavailable, output dir not writable

Two destinations:
1. Console via `rich`: INFO by default, DEBUG with `--verbose`
2. Log file `<output_dir>/gencon-audiobook.log`: Always DEBUG. Persists after run.

Format for log file: `%(asctime)s [%(levelname)s] %(name)s: %(message)s`

### Docstrings & Comments
- Module-level docstring (one sentence) at top of every `.py` file
- Google-style docstrings on all public functions with `Args`, `Returns`, `Raises`
- Type hints on all function signatures (`from __future__ import annotations`)
- Comments explain WHY, not WHAT. No commented-out code.
- TODO only with GitHub issue reference: `# TODO(#42): Add multi-language support`

---

## Verification

After creating all docs:
1. Read each doc file back and verify it's accurate to the actual codebase
2. Verify all internal links work (doc-to-doc references, GitHub URLs)
3. Verify the README links to all four docs files
4. Verify CONTRIBUTING.md test commands actually work: `pip install -e ".[dev]" && pytest tests/ -v`
5. Spot-check 3 source files for logging and docstring compliance
