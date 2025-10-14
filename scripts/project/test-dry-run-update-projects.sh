#!/usr/bin/env bash

#!/usr/bin/env bash
###############################################################################
#
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
#   - This script is intended to be run in a test environment and does not perform actual API calls.
#   - It is primarily used to validate that the dry-run output contains expected commands.
#   - Ensure the script is executable: chmod +x test-dry-run-update-projects.sh
#   - This script does not modify any resources; it only simulates the update process.
#
# Usage: ./test-dry-run-update-projects.sh [options]
#
# Environment Variables:
#   None
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
# Notes:
#   - This script logs all actions taken during the dry-run for later inspection.
#   - It is recommended to run this script in a controlled test environment.
#   - The script checks for the presence of key dry-run commands to ensure correctness.
#   - Adjust the project numbers and owner as needed for your test setup.
#   - Ensure that the GitHub CLI is properly configured and authenticated before running this script.
#   - This script runs a dry-run harness for update-projects.sh in dry-run mode and verifies that key commands are printed for both projects.
#
###############################################################################

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

# Source the main script to test its helper functions
# shellcheck source=./update-projects.sh
source "$SCRIPT_DIR/update-projects.sh"

###############################################################################
# Function: main
# Description: Main function to run the script.
# Arguments:
#   $@ - Command-line arguments.
# Output: Prints messages to stdout and stderr.
###############################################################################
main() {
    # --- ARGUMENT PARSING ---
    local project_owner="lightspeedwp"
    local project_a="17"
    local project_b="14"
    local settings_file=""
    local auto_refresh=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-owner)
                project_owner="$2"
                shift
                ;;
            --project-a)
                project_a="$2"
                shift
                ;;
            --project-b)
                project_b="$2"
                shift
                ;;
            --settings-file)
                settings_file="$2"
                shift
                ;;
            --auto-refresh)
                auto_refresh="$2"
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown argument: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # --- MAIN LOGIC ---
    local output
    output=$(DRY_RUN=true "$SCRIPT_DIR/update-projects.sh" "$project_owner" "$project_a" "$project_b" ${settings_file:+"--settings-file" "$settings_file"} ${auto_refresh:+"--auto-refresh" "$auto_refresh"})

    # Check if the output contains the expected dry run commands
    local expected_commands=(
        "gh project field-create \"$project_a\""
        "gh project field-create \"$project_b\""
    )

    local all_found=true
    for cmd in "${expected_commands[@]}"; do
        if ! echo "$output" | grep -q "$cmd"; then
            log_error "Expected command not found in dry run output: $cmd"
            all_found=false
        fi
    done

    if [[ "$all_found" == "true" ]]; then
        log_success "All expected commands found in dry run output."
    else
        log_error "Some expected commands were missing from the dry run output."
        exit 1
    fi
}

# --- SCRIPT EXECUTION ---
main "$@"
