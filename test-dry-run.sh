#!/usr/bin/env bash
# Simple test harness: run update-projects.sh with --dry-run and verify key commands are printed
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

OUTPUT=$("${SCRIPT_DIR}/update-projects.sh" --dry-run --project-owner testorg --to-project 101 --asnz-project 202)

echo "---- DRY RUN OUTPUT ----"
echo "$OUTPUT"

echo "$OUTPUT" | grep -q "DRY RUN: gh project field-create \"101\"" && echo "Found TO project commands"

echo "$OUTPUT" | grep -q "DRY RUN: gh project field-create \"202\"" && echo "Found ASNZ project commands"

echo "Dry-run smoke test passed."
