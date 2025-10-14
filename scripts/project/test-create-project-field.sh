#!/usr/bin/env bash

# Script Name: test-create-project-field.sh
# Description: Test script to validate project field command helpers.
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
#   - Bash 4+
#   - GitHub CLI (gh) installed and authenticated
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#   - jq installed
#   - This script is intended to be run in a test environment and does not perform actual API calls.
#   - It is primarily used in Bats tests to validate helper logic and output.
#
# Usage: ./test-create-project-field.sh [options]
#
# Options:
#   --help                  Show this help message
#   --dry-run               Run in dry-run mode to print commands without executing
#
# Examples:
#   ./test-create-project-field.sh --dry-run
#   ./test-create-project-field.sh --help
#
# Note:
#   - This script is intended to be run in a test environment and does not perform actual API calls.
#   - It is primarily used in Bats tests to validate helper logic and output.
#   - Ensure the script is executable: chmod +x test-create-project-field.sh
#   - This script does not modify any resources; it only tests helper functions.
#   - Test to verify build_project_field_cmd and dry-run output for project field creation.
#   - This script tests the project field command building functionality from update-projects.sh.
#   - It sources the update-projects.sh script to access helper functions without executing the main logic, then tests that the field creation command is properly constructed.
#   - It also runs the script in dry-run mode to show the printed commands for inspection.

# Set strict mode
set -euo pipefail

# Show help/usage if --help is passed
if [[ "$1" == "--help" ]]; then
  echo "test-create-project-field.sh: Test for project field command helpers."
  echo "Usage: $0 [--help]"
  echo "  --help    Show this help message."
  exit 0
fi
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT="$SCRIPT_DIR/update-projects.sh"

# Ensure script is executable
chmod +x "$SCRIPT"

# Source the script to load helper functions without running main
SKIP_MAIN=1 source "$SCRIPT"

PROJECT_OWNER=lightspeedwp
PROJECT_NUMBER=17

# Capture command parts from helper
mapfile -t parts < <(build_project_field_cmd "Priority" "single_select" --options "High,Medium,Low")

echo "Command parts:"
for p in "${parts[@]}"; do
  echo "$p"
done

# Ensure the expected tokens are present (portable grep usage)
printf "%s\n" "${parts[@]}" | grep -E "\bgh\b" && echo "has gh"
printf "%s\n" "${parts[@]}" | grep -E "\bproject\b" && echo "has project"
printf "%s\n" "${parts[@]}" | grep -E "\bfield-create\b" && echo "has field-create"
printf "%s\n" "${parts[@]}" | grep -F -- "--name" && echo "has --name"
printf "%s\n" "${parts[@]}" | grep -F -- "--data-type" && echo "has --data-type"

# Run the script in dry-run (separate process) and show output for inspection
# Use SKIP_MAIN=1 and DRY_RUN=true so the script does not perform network/auth checks
echo "\nRunning script in dry-run to show printed commands:"
DRY_RUN=true SKIP_MAIN=1 "$SCRIPT" --dry-run --project-owner testorg --project-number 123

echo "\nTest complete."
