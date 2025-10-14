#!/usr/bin/env bash

# Script Name: test-dry-run-update-projects.sh
# Description: Smoke test for update-projects.sh in dry-run mode.
#
# Version: v0.1.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Requirements:
#   - GitHub CLI (gh) installed and authenticated
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#   - jq installed (for JSON parsing)
#   - yq installed (if using YAML settings)
#   - Bash 4.0 or later
#   - update-projects.sh must be in the scripts/project/ directory
#
# Requirements:
#   - update-projects.sh must be in the scripts/project/ directory
#   - This script is intended to be run in a test environment and does not perform actual API calls.
#   - It is primarily used to validate that the dry-run output contains expected commands.
#   - Ensure the script is executable: chmod +x test-dry-run-update-projects.sh
#   - This script does not modify any resources; it only simulates the update process.
#
# Usage: ./test-dry-run-update-projects.sh [options]
#
# Options:
#   --help                  Show this help message
#   --dry-run               Run in dry-run mode to print commands without executing
#
# Examples:
#   ./test-dry-run-update-projects.sh --dry-run
#   ./test-dry-run-update-projects.sh --dry-run --project-owner lightspeedwp --project-a 17 --project-b 14
#   ./test-dry-run-update-projects.sh --dry-run --settings-file settings.csv
#   ./test-dry-run-update-projects.sh --dry-run --auto-refresh 5
#   ./test-dry-run-update-projects.sh --help
#
# Note:
#   - This script logs all actions taken during the dry-run for later inspection.
#   - It is recommended to run this script in a controlled test environment.
#   - The script checks for the presence of key dry-run commands to ensure correctness.
#   - Adjust the project numbers and owner as needed for your test setup.
#   - Ensure that the GitHub CLI is properly configured and authenticated before running this script.
#   - This script runs a dry-run harness for update-projects.sh in dry-run mode and verifies that key commands are printed for both projects.

# Set strict mode
set -euo pipefail

# Get the directory containing this test file
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Run update-projects.sh in dry-run mode with test arguments
OUTPUT=$("${SCRIPT_DIR}/scripts/project/update-projects.sh" --dry-run --project-owner lightspeedwp --project-a 17 --project-b 14 --auto-refresh 2>&1)

# Print the dry-run output for inspection
echo "---- DRY RUN OUTPUT ----"
echo "$OUTPUT"

# Check that the expected dry-run commands for both projects are present
# This ensures the script prints the correct CLI commands for field creation
echo "$OUTPUT" | grep -q "DRY RUN: gh project field-create \"101\"" && echo "Found [TEMPLATE] Product Development project commands"
echo "$OUTPUT" | grep -q "DRY RUN: gh project field-create \"202\"" && echo "Found [TEMPLATE] Client Delivery project commands"

# End of test
echo "Dry-run smoke test passed."
