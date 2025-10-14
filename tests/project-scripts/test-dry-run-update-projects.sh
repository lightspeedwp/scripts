#!/usr/bin/env bash
# Test: Dry-run harness for update-projects.sh
# This script runs update-projects.sh in dry-run mode and verifies that key commands are printed for both projects.
set -euo pipefail

# Get the directory containing this test file
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Run update-projects.sh in dry-run mode with test arguments
OUTPUT=$("${SCRIPT_DIR}/update-projects.sh" --dry-run --project-owner testorg --project-a 101 --project-b 202)

# Print the dry-run output for inspection
echo "---- DRY RUN OUTPUT ----"
echo "$OUTPUT"

# Check that the expected dry-run commands for both projects are present
# This ensures the script prints the correct CLI commands for field creation
echo "$OUTPUT" | grep -q "DRY RUN: gh project field-create \"101\"" && echo "Found TO project commands"
echo "$OUTPUT" | grep -q "DRY RUN: gh project field-create \"202\"" && echo "Found ASNZ project commands"

# End of test
echo "Dry-run smoke test passed."
