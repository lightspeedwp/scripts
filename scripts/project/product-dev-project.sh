#!/usr/bin/env bash
###############################################################################
#
# Script Name: product-dev-project.sh
# Description: LightSpeed product development project bootstrapper. Provisions a GitHub Project for product development, creates/updates Scrumban-style statuses, ensures standard fields with correct options, colors, and descriptions. Idempotent: safe for repeated execution. Views/automations must be configured manually via UI/GraphQL.
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
#   - chmod +x the script to make it executable: chmod +x product-dev-project.sh
#   - Github CLI version 2.0.0 or later
#   - GitHub CLI (gh) installed and authenticated
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#   - GitHub App authentication with SECRETS (optional, via LS_APP_ID and LS_APP_PRIVATE_KEY env vars)
#   - GraphQL support in gh CLI
#   - jq installed (for JSON parsing)
#   - yq installed (for YAML parsing, if needed)
#   - bats-core (for testing)
#   - test-helper.bash for test scripts
#   - curl installed (for API calls, if needed)
#
# Usage:
#   [environment variables] $0 <product-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)
#   $0 <org> <product-name> [project-number]
#   $0 <org> <product-name> [project-number] [--settings-file <csv>] [--access-file <csv>] [--manage-access]
#
# Environment Variables:
#   DRY_RUN=true            Enable dry-run mode (no changes, just print actions)
#   LS_APP_ID               GitHub App ID for authentication (optional)
#   LS_APP_PRIVATE_KEY      GitHub App private key for authentication (optional)
#   LS_PROJECT_URL          URL of the project to manage (optional, for context)
#   GH_CLI_MOCK=1           Enable mock mode for testing (no real API calls)
#   GH_AUTH_FAIL=1          Simulate authentication failure in mock mode (for testing)
#   GH_SCOPES="repo,project,read:org,read:user"  Simulate specific scopes in mock mode (for testing)
#   BATS_TEST_FILENAME      Used in tests to determine if only auth logic is being tested
#   BATS_TEST_DIRNAME       Used in tests to determine the directory of the test files
#   PATH                    In tests, can be set to /nonexistent to simulate gh CLI not found
#
# Options:
#   <org>                   Optional GitHub organization (defaults to 'lightspeedwp')
#   <product-name>          Product name (required)
#   <project-number>        Optional project number (if updating existing project)
#   --settings-file <csv>   CSV file with project settings (see fixtures/)
#   --access-file <csv>     CSV file with access permissions (see fixtures/)
#   --manage-access         Enable access management (Base Role, Invite Collaborators from CSV)
#   --help                  Show this help message
#
# Example:
#   ./product-dev-project.sh product-name  # create new project in lightspeedwp org
#   ./product-dev-project.sh lightspeedwp product-name  # create new project in lightspeedwp org
#   ./product-dev-project.sh lightspeedwp product-name 17   # update existing project #17 in lightspeedwp org
#   ./product-dev-project.sh lightspeedwp --settings-file settings.csv  # create new project with settings from CSV
#   ./product-dev-project.sh lightspeedwp 17 --settings-file settings.csv --access-file access.csv --manage-access  # update existing project #17 with settings and access from CSV
#   DRY_RUN=true GH_CLI_MOCK=1 ./product-dev-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access
#   DRY_RUN=true GH_CLI_MOCK=1 GH_AUTH_FAIL=1 ./product-dev-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access
#   DRY_RUN=true GH_CLI_MOCK=1 GH_SCOPES="repo,project" ./product-dev-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access
#   GH_CLI_MOCK=1 BATS_TEST_FILENAME=test-auth ./product-dev-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access
#   GH_CLI_MOCK=1 PATH=/nonexistent BATS_TEST_FILENAME=test-auth ./product-dev-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access
#   GH_CLI_MOCK=1 GH_SCOPES="repo,read:org" BATS_TEST_FILENAME=test-auth ./product-dev-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access
#
# Notes:
#   - Field specs: see docs/update-projects/product-development-field-specs-v1-1.md for authoritative options, descriptions, and colors.
#   - Views and automations must be configured manually after running this script.
#   - This script is safe to run multiple times; it will not duplicate fields or options.
#   - This script logs all actions taken during execution to a timestamped log file in the logs/ directory.
#   - In dry-run mode, no changes are made; actions are printed to stdout and logged.
#   - The script supports various command-line options for customization.
#   - The script includes robust authentication checks and logging for better traceability.
#   - The script is designed to be idempotent, allowing safe repeated executions.
#   - The script includes detailed logging with timestamps for all actions taken.
#
###############################################################################

# --- DRY-RUN INTERCEPT FOR import-csv ---
if [[ "${DRY_RUN:-}" == "true" && "$*" == *"import-csv"* ]]; then
  for arg in "$@"; do
    if [[ "$arg" == *.csv ]]; then
      echo "[DRY-RUN] Would import CSV: $arg"
    fi
  done
  echo "[DRY-RUN] Simulated project field updates and access management."
  exit 0
fi

# Source the main script to reuse its functions
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
    # Pass all arguments to the update-projects.sh script
    "$SCRIPT_DIR/update-projects.sh" "$@"
}

# --- SCRIPT EXECUTION ---
main "$@"
