#!/usr/bin/env bash
# Switch active Sky Feather character on Hermes (~/.hermes/SOUL.md).
# Legacy ops path — prefer /personality <preset> in Discord (Route B).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

PRESET_ONLY=0
PERSONALITY_ONLY=0
CHAR_INPUT=""
REPO_ROOT="$(sf_repo_root)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --preset-only)
      PRESET_ONLY=1
      shift
      ;;
    --personality-only)
      PERSONALITY_ONLY=1
      shift
      ;;
    -h|--help)
      cat <<EOF
Usage: $0 <character-id-or-alias> [--preset-only | --personality-only] [REPO_ROOT]

Legacy: regenerate ~/.hermes/SOUL.md with full CORE + character (server-wide).
Requires: sudo systemctl restart hermes-gateway

Preferred Discord switch (Route B):
  /personality <preset-key>
  Example: /personality setsuna

Options:
  --personality-only   Print /personality preset key for Discord (no SOUL write)
  --preset-only        Write personality preset body to mirror presets/ (debug)

Examples:
  $0 setsuna --personality-only
  $0 kaede
  $0 sky-feather --preset-only
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
PRESET_KEY="$(sf_get_character_personality_key "${CHAR_ID}")"
DISCORD_LABEL="$(sf_hermes_discord_label "${CHAR_ID}")"

if [[ ! -d "${MIRROR}" ]]; then
  echo "error: Hermes mirror not found at ${MIRROR}" >&2
  echo "Run bash scripts/install-hermes-global.sh first." >&2
  exit 1
fi

if [[ "${PERSONALITY_ONLY}" -eq 1 ]]; then
  echo "Use /personality ${PRESET_KEY} in Discord"
  echo "  Label: ${DISCORD_LABEL}"
  echo "  Character id: ${CHAR_ID}"
  exit 0
fi

if [[ "${PRESET_ONLY}" -eq 1 ]]; then
  mkdir -p "${MIRROR}/presets"
  sf_build_hermes_personality_preset "${REPO_ROOT}" "${CHAR_ID}" > "${MIRROR}/presets/${CHAR_ID}.md"
  echo "Wrote preset body → ${MIRROR}/presets/${CHAR_ID}.md"
  echo "Preset key: ${PRESET_KEY}"
  exit 0
fi

sf_build_hermes_soul_file "${REPO_ROOT}" "${SOUL_PATH}" "${CHAR_ID}"
cp "${SOUL_PATH}" "${MIRROR}/active-soul.md"
sf_write_hermes_manifest "${MIRROR}" "${CHAR_ID}"

echo "Active character: ${CHAR_ID} (${DISCORD_LABEL})"
echo "Updated: ${SOUL_PATH}"
echo ""
echo "Legacy server-wide SOUL switch — restart Hermes:"
echo "  sudo systemctl restart hermes-gateway"
echo ""
echo "Preferred: /personality ${PRESET_KEY} in Discord (no restart required)"
