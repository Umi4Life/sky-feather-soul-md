# Switch Sky Feather character profile

Switch the global Cursor character profile (V3.2). Engineering standards stay the same; delivery style changes.

## Valid character IDs

| ID | Aliases |
|----|---------|
| `sky-feather` | feather, sky, default |
| `sumeragi-setsuna` | setsuna, architect |
| `aihara-tsubaki` | tsubaki, pair |
| `suzushima-arisu` | arisu, lab |
| `ousaka-akane` | akane, brainstorm |
| `kujo-kaede` | kaede, ops |
| `inohara-koboshi` | koboshi, automation |

## Instructions

1. Ask the user which character ID (or alias) they want if not specified.
2. Run the switch script for the host OS from the sky-feather repo (or any clone):
   - **Windows PowerShell:** `.\scripts\switch-character.ps1 <id>`
   - **macOS / Linux / Git Bash:** `./scripts/switch-character.sh <id>`
3. After the script succeeds, **read** `~/.cursor/skills/sky-feather-character/SKILL.md` (or `%USERPROFILE%\.cursor\skills\sky-feather-character\SKILL.md` on Windows).
4. Adopt that character's voice for the rest of this thread.

## Limitation

Mid-chat switching is best-effort. Prior messages may still carry the old voice. Recommend starting a **new chat** after switching for reliable results.
