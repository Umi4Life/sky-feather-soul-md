#!/usr/bin/env bash
# Switch active Sky Feather character on Hermes (~/.hermes/SOUL.md).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

PRESET_ONLY=0
CHAR_INPUT=""
REPO_ROOT="$(sf_repo_root)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --preset-only)
      PRESET_ONLY=1
      shift
      ;;
    -h|--help)
      cat <<EOF
Usage: $0 <character-id-or-alias> [--preset-only] [REPO_ROOT]

Regenerate ~/.hermes/SOUL.md for the given character (CORE + profile).

Examples:
  $0 sky-feather
  $0 setsuna
  $0 kaede
EOF
      exit 0
      ;;
    *)
      if [[ -z "${CHAR_INPUT}" ]]; then
        CHAR_INPUT="$1"
      else
        REPO_ROOT="$(cd "$1" && pwd)"
      fi
      shift
      ;;
  esac
done

if [[ -z "${CHAR_INPUT}" ]]; then
  echo "error: character id or alias required" >&2
  exit 1
fi

CHAR_ID="$(sf_resolve_character_id "${CHAR_INPUT}")"
MIRROR="$(sf_hermes_mirror)"
SOUL_PATH="$(sf_hermes_soul_path)"

if [[ ! -d "${MIRROR}" ]]; then
  echo "error: Hermes mirror not found at ${MIRROR}" >&2
  echo "Run ./scripts/install-hermes-global.sh first." >&2
  exit 1
fi

if [[ "${PRESET_ONLY}" -eq 1 ]]; then
  sf_build_hermes_soul_file "${REPO_ROOT}" "${MIRROR}/presets/${CHAR_ID}.md" "${CHAR_ID}"
  echo "Wrote preset body → ${MIRROR}/presets/${CHAR_ID}.md"
  exit 0
fi

sf_build_hermes_soul_file "${REPO_ROOT}" "${SOUL_PATH}" "${CHAR_ID}"
cp "${SOUL_PATH}" "${MIRROR}/active-soul.md"
sf_write_hermes_manifest "${MIRROR}" "${CHAR_ID}"

echo "Active character: ${CHAR_ID} ($(sf_hermes_discord_label "${CHAR_ID}"))"
echo "Updated: ${SOUL_PATH}"
echo "Restart Hermes or start a new session for reliable application."
