#!/usr/bin/env bash
# Uninstall / prune Sky Feather global Cursor artifacts.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

MODE="all"
DRY_RUN=0
REPO_RULES_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all) MODE="all" ;;
    --legacy|--v1) MODE="legacy" ;;
    --v3|--current) MODE="v3" ;;
    --dry-run) DRY_RUN=1 ;;
    --repo-rules)
      shift
      REPO_RULES_DIR="${1:-}"
      if [[ -z "${REPO_RULES_DIR}" ]]; then
        echo "error: --repo-rules requires a directory path" >&2
        exit 1
      fi
      ;;
    -h|--help)
      echo "usage: $(basename "$0") [--all|--legacy|--v3] [--dry-run] [--repo-rules <dir>]"
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

remove_path() {
  local path="$1"
  if [[ -e "${path}" ]]; then
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      echo "would remove: ${path}"
    else
      rm -rf "${path}"
      echo "removed: ${path}"
    fi
  fi
}

CURSOR_HOME="$(sf_cursor_home)"

if [[ "${MODE}" == "all" || "${MODE}" == "legacy" ]]; then
  remove_path "$(sf_legacy_skill_dir)"
  remove_path "${CURSOR_HOME}/sky-feather/sky-feather-soul.mdc"
fi

if [[ "${MODE}" == "all" || "${MODE}" == "v3" ]]; then
  remove_path "$(sf_sky_feather_mirror)"
  remove_path "$(sf_skill_character_dir)"
  remove_path "$(sf_commands_dir)/character.md"
fi

if [[ -n "${REPO_RULES_DIR}" ]]; then
  if [[ ! -d "${REPO_RULES_DIR}" ]]; then
    echo "error: not a directory: ${REPO_RULES_DIR}" >&2
    exit 1
  fi
  while IFS= read -r rule_file; do
    remove_path "${rule_file}"
  done < <(find "${REPO_RULES_DIR}" -path '*/.cursor/rules/sky-feather-soul.mdc' 2>/dev/null || true)
fi

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo ""
  echo "Dry run complete. No files deleted."
else
  echo ""
  echo "Uninstall complete (${MODE})."
fi

cat <<'EOF'

Manual step: remove Sky Feather content from Cursor User Rules
  Settings → Rules → User Rules
  Delete the SOUL.md block or thin sky-feather-character stub.
  Start a new chat.

Never removed automatically:
  ~/.cursor/skills-cursor/ (Cursor internal built-ins)
EOF
