# Install Sky Feather on Cursor

Use **global** configuration so team repositories stay clean.

## Recommended: User Rules

1. Open **Cursor Settings → Rules → User Rules**.
2. Paste the full contents of [SOUL.md](../SOUL.md) from this repo.

Optional: prepend the activation block from [examples/cursor/sky-feather-soul.mdc](../examples/cursor/sky-feather-soul.mdc) so the mandatory voice rules appear first.

User Rules apply in every workspace and chat without touching project git.

## Optional: local mirror + install script

After cloning this repo:

```bash
./scripts/install-cursor-local.sh
# or with explicit clone path:
./scripts/install-cursor-local.sh /path/to/sky-feather-soul-md
```

This copies into:

- `~/.cursor/sky-feather/SOUL.md`
- `~/.cursor/sky-feather/sky-feather-soul.mdc` (activation + pointer)
- `~/.cursor/skills/sky-feather-soul/` (skill stub + SOUL.md)

Keep **User Rules** in sync with `SOUL.md` after `git pull`.

## Optional: Cursor skill (backup)

Copy manually:

```bash
mkdir -p ~/.cursor/skills/sky-feather-soul
cp examples/cursor/SKILL.md ~/.cursor/skills/sky-feather-soul/
cp SOUL.md ~/.cursor/skills/sky-feather-soul/
```

Skills may load on demand; **User Rules** are the most reliable always-on hook.

## Do not use in team repos

| Avoid | Why |
|-------|-----|
| `<team-repo>/.cursor/rules/sky-feather-soul.mdc` | Shows up in `git status` and PRs |
| Symlinking into many work clones | Accidental commits, reviewer confusion |

If symlinks were added previously, remove them with your personal cleanup script at `~/.cursor/sky-feather/uninstall-repo-rules.sh` (if installed) or delete the file under each repo’s `.cursor/rules/`.

## Verify

1. Start a **new** Cursor chat (not an old thread).
2. Ask a technical question (e.g. explain a circuit breaker).
3. Expect: precise engineering answer, short reaction beat, light operator flavor — not generic-assistant tone.

## Update

```bash
cd /path/to/sky-feather-soul-md
git pull
./scripts/install-cursor-local.sh
# Refresh User Rules if SOUL.md changed
```
