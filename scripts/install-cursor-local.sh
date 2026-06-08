#!/usr/bin/env bash
# Copy Sky Feather files from this repo into ~/.cursor/ (personal global install).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -n "${1:-}" ]]; then
  REPO_ROOT="$(cd "$1" && pwd)"
fi

DEST="${HOME}/.cursor/sky-feather"
SKILL_DEST="${HOME}/.cursor/skills/sky-feather-soul"

mkdir -p "${DEST}" "${SKILL_DEST}"

cp "${REPO_ROOT}/SOUL.md" "${DEST}/SOUL.md"
cp "${REPO_ROOT}/examples/cursor/sky-feather-soul.mdc" "${DEST}/sky-feather-soul.mdc"
cp "${REPO_ROOT}/examples/cursor/SKILL.md" "${SKILL_DEST}/SKILL.md"
cp "${REPO_ROOT}/SOUL.md" "${SKILL_DEST}/SOUL.md"

echo "Installed:"
echo "  ${DEST}/SOUL.md"
echo "  ${DEST}/sky-feather-soul.mdc"
echo "  ${SKILL_DEST}/SKILL.md"
echo "  ${SKILL_DEST}/SOUL.md"
echo ""
echo "Also paste SOUL.md into Cursor Settings → Rules → User Rules for always-on behavior."
