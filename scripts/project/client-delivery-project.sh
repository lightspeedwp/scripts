#!/usr/bin/env bash
###############################################################################
#
# Script Name: client-delivery-project.sh
# Description: Bootstraps and updates a standardized GitHub Project for client delivery engagements. Provisions a Project with Scrumban-style statuses, ensures standard fields exist with correct options, descriptions, and colors. Idempotent: existing fields reused, no duplicates. Views and automations must be configured manually via UI or GraphQL.
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
#   - chmod +x the script to make it executable: chmod +x client-delivery-project.sh
#   - GitHub CLI (gh) v2.0.0+
#   - jq, yq, curl
#   - Node.js tools: npx, markdown-toc, all-contributors, auto-changelog
#   - CSV fixtures for settings and access
#   - bats-core (for testing)
#   - test-helper.bash for test scripts
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#   - GitHub App authentication with SECRETS (optional, via LS_APP_ID and LS_APP_PRIVATE_KEY env vars)
#   - GraphQL support in gh CLI
#
# Usage:
#   [environment variables] ./client-delivery-project.sh [<org>] <product-name> [project-number] [--settings-file <csv>] [--access-file <csv>] [--manage-access] [--help]
#   ./client-delivery-project.sh <org> <product-name> [project-number]
#   ./client-delivery-project.sh <org> <product-name> [project-number] [--settings-file <csv>] [--access-file <csv>] [--manage-access]
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
# Examples:
#   ./client-delivery-project.sh product-name  # create new project in lightspeedwp org
#   ./client-delivery-project.sh lightspeedwp product-name  # create new project in lightspeedwp org
#   ./client-delivery-project.sh lightspeedwp product-name 17   # update existing project #17 in lightspeedwp org
#   ./client-delivery-project.sh lightspeedwp --settings-file settings.csv  # create new project with settings from CSV
#   ./client-delivery-project.sh lightspeedwp 17 --settings-file settings.csv --access-file access.csv --manage-access  # update existing project #17 with settings and access from CSV
#   DRY_RUN=true GH_CLI_MOCK=1 ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI
#   DRY_RUN=true GH_CLI_MOCK=1 ORG=otherorg ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and org override
#   DRY_RUN=true GH_CLI_MOCK=1 GH_AUTH_FAIL=1 ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and simulated auth failure
#   DRY_RUN=true GH_CLI_MOCK=1 GH_SCOPES="repo,project" ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and limited scopes
#   GH_CLI_MOCK=1 BATS_TEST_FILENAME=test-auth ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic only
#   GH_CLI_MOCK=1 PATH=/nonexistent BATS_TEST_FILENAME=test-auth ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic with gh CLI not found
#   GH_CLI_MOCK=1 GH_SCOPES="repo,read:org" BATS_TEST_FILENAME=test-auth ./client-delivery-project.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic with missing scopes
#
# Notes:
#   - Views and automations must be configured manually after running this script.
#   - This script is safe to run multiple times; it will not duplicate fields or options.
#   - This script logs all actions taken during execution to a timestamped log file in the logs/ directory.
#   - In dry-run mode, no changes are made; actions are printed to stdout and logged.
#   - The script supports various command-line options for customization.
#   - The script includes robust authentication checks and logging for better traceability.
#   - The script is designed to be idempotent, allowing safe repeated executions.
#   - The script includes detailed logging with timestamps for all actions taken.
#   - The script includes colorized output for better readability.
#   - Field specs: see docs/update-projects/client-delivery-field-specs-v1-1.md for authoritative options, descriptions, and colors.
###############################################################################

# Set strict mode
set -euo pipefail

# Source the shared project update script.
# The SCRIPT_DIR variable is defined within update-projects.sh, so we can locate it.
# shellcheck source=./update-projects.sh
source "$(dirname "${BASH_SOURCE[0]}")/update-projects.sh"

#
# --- Main Function ---
#
# Description:
#   Main entry point for the script.
#   This script is a wrapper around the core 'update-projects.sh' script.
#   It sets the project type to "Client Delivery" and passes all command-line
#   arguments to the core script for processing.
#
# Arguments:
#   $@ - All command-line arguments passed to this script.
#
# Usage:
#   See the header of this file for detailed usage instructions.
#
# Example:
#   ./client-delivery-project.sh my-client-project
#   ./client-delivery-project.sh my-org my-client-project 123 --settings-file settings.csv
#
main() {
    # Call the main function in update-projects.sh with "Client Delivery" as the project type
    # and forward all other arguments.
    update_projects_main "Client Delivery" "$@"
}

# --- SCRIPT EXECUTION ---
# Execute the main function, passing all script arguments.
main "$@"
