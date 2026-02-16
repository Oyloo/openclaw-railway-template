# Adosi CLI Compatibility (Railway Linux x86_64)

Last verified: 2026-02-16
Service: `openclaw-railway-template` (project `adosi`)

## ✅ Installed and available in runtime (30)

| CLI | Source | Skill |
|-----|--------|-------|
| bird | npm (`@steipete/bird`) | — |
| clawhub | npm | clawhub |
| codexbar | brew (`steipete/tap`) | model-usage |
| curl | apt | — |
| date | coreutils | — |
| ffmpeg | apt | video-frames |
| gemini | npm (`@google/gemini-cli`) | gemini |
| gh | apt | github |
| gifgrep | brew (`steipete/tap`) | gifgrep |
| gog | brew (`steipete/tap`) | gog |
| goplaces | brew (`steipete/tap`) | — |
| himalaya | brew | himalaya |
| jq | apt | trello |
| nu | brew (nushell) | — |
| nvim | apt (neovim) | — |
| obsidian-cli | brew (`yakitrak/yakitrak`) | obsidian |
| openhue | brew (`openhue/cli`) | openhue |
| oracle | brew (`steipete/tap`) | — |
| ordercli | brew (`steipete/tap`) | ordercli |
| python3 | apt | — |
| railway | npm (`@railway/cli`) | railway |
| rg | apt (ripgrep) | — |
| sag | brew (`steipete/tap`) | — |
| songsee | brew (`steipete/tap`) | songsee |
| spogo | brew (`steipete/tap`) | — |
| spotify_player | symlink → spogo | — |
| summarize | npm (`@steipete/summarize`) | summarize |
| tmux | apt | tmux |
| uv | curl (astral.sh) | — |
| wacli | brew (`steipete/tap`) | wacli |

## ❌ Missing — macOS-only (cannot run on Linux)

| CLI | Reason | Skill |
|-----|--------|-------|
| grizzly | Bear notes CLI — macOS `bear-notes` only | bear-notes |
| imsg | macOS iMessage framework (`depends_on macos: :sonoma`) | imsg |
| memo | Apple Notes/Reminders — macOS Python bridges | apple-notes |
| peekaboo | macOS screenshots (`depends_on macos: :sonoma`) | peekaboo |
| remindctl | Apple Reminders (`depends_on macos: :sonoma`) | apple-reminders |
| things | Things 3 URL scheme — macOS only | things-mac |

## ❌ Missing — no Linux package found

| CLI | Notes | Skill |
|-----|-------|-------|
| blogwatcher | no npm/brew/binary release found | blogwatcher |
| eightctl | no npm/brew/binary release for Linux | eightctl |
| nano-pdf | no npm/brew/binary release found | nano-pdf |
| whisper | requires pytorch + llvm — too heavy for Docker | openai-whisper |

## ⚠️ Available but not installed (optional)

| CLI | Notes | Skill |
|-----|-------|-------|
| op | 1Password CLI — available via apt, needs auth setup | 1password |

## 🚫 Architecture constrained (arm64 macOS only in tap)

| CLI | Skill |
|-----|-------|
| blu | blucli |
| camsnap | camsnap |
| mcporter | mcporter |
| sonos | sonoscli |

## Summary

- **30** CLIs installed and verified
- **6** macOS-only (cannot port)
- **4** no Linux package exists
- **1** available but optional (op)
- **4** arm64-macOS only (excluded)
