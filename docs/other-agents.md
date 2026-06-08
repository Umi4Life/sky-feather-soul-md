# Install Sky Feather on other agents

Pattern for every tool: **clone this repo → copy an example stub to a global/user path → include or reference full [SOUL.md](../SOUL.md)**. Avoid checking persona files into team repositories.

## OpenAI Codex / generic `AGENTS.md`

Some agents read `AGENTS.md` at the project root.

**Personal / sandbox repo:**

```bash
cp examples/agents/AGENTS.md AGENTS.md
# Append SOUL.md or link to clone path in README
```

**Global:** check your agent’s docs for a user-level instructions file; paste activation block + SOUL there if supported.

## Windsurf

```bash
# Project (personal sandbox only):
cp examples/other/windsurf-rules.md .windsurfrules

# Or global rules path per Windsurf documentation (varies by version)
```

See Windsurf docs for “rules” / “memories” location on your machine.

## Cline

```bash
cp examples/other/clinerules.md .clinerules
```

Place in home directory or project root per [Cline](https://github.com/cline/cline) docs. Prefer **global** for personal persona.

## Aider

```bash
cp examples/other/aider-conventions.md CONVENTIONS.md
```

Or merge into `.aider.conf.yml` / repo conventions as documented by Aider. Reference `SOUL.md` path in a short header.

## Gemini CLI

If you use `GEMINI.md` or similar project context files:

```bash
cp examples/agents/AGENTS.md GEMINI.md
# Adapt header; paste SOUL below activation block
```

## Keeping one source of truth

| Do | Don't |
|----|--------|
| Maintain one `SOUL.md` in this git repo | Duplicate full SOUL in five tools and let them drift |
| Use short activation stubs in `examples/` | Commit stubs to team service repos without agreement |
| `git pull` here, refresh global copies | Symlink SOUL into 40+ work clones |

## Verify

New session → technical question → engineering clarity + light seasoning per SOUL hard limits.
