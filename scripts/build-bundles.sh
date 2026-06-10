#!/usr/bin/env bash
# Build flat character bundles into a target directory.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

REPO_ROOT="$(sf_repo_root)"
OUTPUT_DIR="${1:-$(sf_sky_feather_mirror)/bundles}"

echo "Building bundles from: ${REPO_ROOT}"
echo "Output directory: ${OUTPUT_DIR}"

sf_build_all_bundles "${REPO_ROOT}" "${OUTPUT_DIR}"

echo "Built bundles:"
sf_list_character_ids | while IFS= read -r id; do
  echo "  ${OUTPUT_DIR}/${id}.md"
done
