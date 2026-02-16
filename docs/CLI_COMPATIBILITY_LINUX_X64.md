# Adosi CLI Compatibility (Railway Linux x86_64)

Last verified: 2026-02-16
Service: `openclaw-railway-template` (project `adosi`)

## ✅ Installed and available in runtime

- bird
- clawhub
- curl
- date
- ffmpeg
- gemini
- gh
- gifgrep
- gog
- goplaces
- himalaya
- jq
- nu (nushell)
- nvim (neovim)
- oracle
- ordercli
- python3
- rg
- sag
- songsee
- spogo
- summarize
- tmux
- wacli

## ❌ Missing in runtime

- blogwatcher
- codexbar
- eightctl
- grizzly
- imsg
- memo
- nano-pdf
- obsidian-cli
- op
- openhue
- peekaboo
- railway
- remindctl
- spotify_player
- things
- uv
- whisper

## 🚫 Architecture/platform constrained (arm64 macOS in tap formulas)

These are intentionally excluded from Linux image install attempts:

- blu (skill: blucli)
- camsnap (skill: camsnap)
- mcporter (skill: mcporter)
- sonos (skill: sonoscli)

Why: corresponding Homebrew tap formulae are packaged as macOS arm64-only binaries (`depends_on arch: :arm64`).

## Custom Adosi skills status

- bird → `bird` ✅
- summarize → `summarize` ✅
- trello → `jq` ✅
- model-usage → `codexbar` ❌ (not available in Linux runtime)

## Operational policy for this image

1. Do not attempt to install arm64-only formulae in Linux builds.
2. Prefer Linux-compatible sources (apt/Homebrew Linux/npm) only.
3. Treat unavailable/mac-only tools as non-blocking unless the user explicitly requests platform migration.
