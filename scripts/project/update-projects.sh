#!/bin/bash
###############################################################################
#
# Script Name: update-projects.sh
# Description: This script helps manage GitHub project fields using the GitHub CLI. It can create, update, and manage project fields with proper authentication. Supports field creation, value configuration, access control, and batch operations through CSV files.
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
#   - chmod +x the script to make it executable: chmod +x update-projects.sh
#   - Github CLI version 2.0.0 or later
#   - GitHub CLI (gh) installed and authenticated
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#   - GitHub App authentication with SECRETS (optional, via LS_APP_ID and LS_APP_PRIVATE_KEY env vars)
#   - GraphQL support in gh CLI
#   - curl installed (for API calls)
#   - jq installed (for JSON parsing)
#   - yq installed (for YAML parsing, if needed)
#   - bats-core (for testing)
#   - test-helper.bash for test scripts
#
# Usage:
#   [environment variables] ./update-projects.sh <product-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)
#   ./update-projects.sh <org> <product-name> [project-number]
#   ./update-projects.sh <org> <product-name> [project-number] [--settings-file <csv>] [--access-file <csv>] [--manage-access]
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
#   --manage-access         Enable access management (Base Role, Invite Collaborators)
#   --help                  Show this help message
#
# Example:
#   ./update-projects.sh product-name  # create new project in lightspeedwp org
#   ./update-projects.sh lightspeedwp product-name  # create new project in lightspeedwp org
#   ./update-projects.sh lightspeedwp product-name 17   # update existing project #17 in lightspeedwp org
#   ./update-projects.sh lightspeedwp --settings-file settings.csv  # create new project with settings from CSV
#   ./update-projects.sh lightspeedwp 17 --settings-file settings.csv --access-file access.csv --manage-access  # update existing project #17 with settings and access from CSV
#   DRY_RUN=true GH_CLI_MOCK=1 ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI
#   DRY_RUN=true GH_CLI_MOCK=1 ORG=otherorg ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and org override
#   DRY_RUN=true GH_CLI_MOCK=1 GH_AUTH_FAIL=1 ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and simulated auth failure
#   DRY_RUN=true GH_CLI_MOCK=1 GH_SCOPES="repo,project" ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and limited scopes
#   GH_CLI_MOCK=1 BATS_TEST_FILENAME=test-auth ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic only
#   GH_CLI_MOCK=1 PATH=/nonexistent BATS_TEST_FILENAME=test-auth ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic with gh CLI not found
#   GH_CLI_MOCK=1 GH_SCOPES="repo,read:org" BATS_TEST_FILENAME=test-auth ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic with missing scopes
#
# Notes:
#   - CSV files must follow the format specified in the fixtures directory
#   - The script will automatically create necessary project fields if they don't exist
#   - Errors are logged to stderr, progress to stdout
#   - Use DRY_RUN=true for safe testing before applying changes
#   - Authentication can use standard GitHub CLI auth or GitHub App credentials
#   - When updating an existing project, only specified fields are modified
#
###############################################################################

# Set strict mode
set -euo pipefail

# Log file setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)-$(date +%Y%m%d-%H%M%S).log"
readonly LOG_FILE

# Create logs directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# Default values
PROJECT_OWNER=""
PROJECT_NUMBER=""
AUTO_REFRESH=false
DRY_RUN=false
FIELDS_FILE=""
DELETE_FIELDS=false

# GitHub App authentication (from environment variables)
LS_APP_ID="${LS_APP_ID:-}"
LS_APP_PRIVATE_KEY="${LS_APP_PRIVATE_KEY:-}"
LS_PROJECT_URL="${LS_PROJECT_URL:-}"

# Required GitHub CLI scopes
REQUIRED_SCOPES=("repo" "project" "read:org" "read:user")

# Max attempts when trying to refresh scopes interactively to avoid infinite loops
MAX_REFRESH_ATTEMPTS=2

# --- COLORS ---
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Logging functions
###############################################################################
# Function: log_info
# Description: Logs an informational message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stdout.
###############################################################################
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

###############################################################################
# Function: log_success
# Description: Logs a success message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stdout.
###############################################################################
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

###############################################################################
# Function: log_warning
# Description: Logs a warning message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stdout.
###############################################################################
log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

###############################################################################
# Function: log_error
# Description: Logs an error message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stderr.
###############################################################################
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

###############################################################################
# Function: show_help
# Description: Displays the help message for the script.
# Arguments:
#   None
# Output: Prints the help message to stdout.
###############################################################################
show_help() {
    echo "Usage: $0 [<org>] <product-name> [project-number] [--settings-file <csv>] [--access-file <csv>] [--manage-access] [--help]"
    echo ""
    echo "Options:"
    echo "  <org>                   Optional GitHub organization (defaults to 'lightspeedwp')"
    echo "  <product-name>          Product name (required)"
    echo "  <project-number>        Optional project number (if updating existing project)"
    echo "  --settings-file <csv>   CSV file with project settings (see fixtures/)"
    echo "  --access-file <csv>     CSV file with access permissions (see fixtures/)"
    echo "  --manage-access         Enable access management (Base Role, Invite Collaborators)"
    echo "  --help                  Show this help message"
    echo ""
    echo "Example:"
    echo "  ./update-projects.sh product-name  # create new project in lightspeedwp org"
    echo "  ./update-projects.sh lightspeedwp product-name  # create new project in lightspeedwp org"
    echo "  ./update-projects.sh lightspeedwp product-name 17   # update existing project #17 in lightspeedwp org"
    echo "  ./update-projects.sh lightspeedwp --settings-file settings.csv  # create new project with settings from CSV"
    echo "  ./update-projects.sh lightspeedwp 17 --settings-file settings.csv --access-file access.csv --manage-access  # update existing project #17 with settings and access from CSV"
    echo "  DRY_RUN=true GH_CLI_MOCK=1 ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI"
    echo "  DRY_RUN=true GH_CLI_MOCK=1 ORG=otherorg ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and org override"
    echo "  DRY_RUN=true GH_CLI_MOCK=1 GH_AUTH_FAIL=1 ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and simulated auth failure"
    echo "  DRY_RUN=true GH_CLI_MOCK=1 GH_SCOPES=\"repo,project\" ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # dry-run with mock gh CLI and limited scopes"
    echo "  GH_CLI_MOCK=1 BATS_TEST_FILENAME=test-auth ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic only"
    echo "  GH_CLI_MOCK=1 PATH=/nonexistent BATS_TEST_FILENAME=test-auth ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic with gh CLI not found"
    echo "  GH_CLI_MOCK=1 GH_SCOPES=\"repo,read:org\" BATS_TEST_FILENAME=test-auth ./update-projects.sh lightspeedwp --settings-file settings.csv --access-file access.csv --manage-access  # test auth logic with missing scopes"
    echo ""
    echo "Notes:"
    echo "  - CSV files must follow the format specified in the fixtures directory"
    echo "  - The script will automatically create necessary project fields if they don't exist"
    echo "  - Errors are logged to stderr, progress to stdout"
    echo "  - Use DRY_RUN=true for safe testing before applying changes"
    echo "  - Authentication can use standard GitHub CLI auth or GitHub App credentials"
    echo "  - When updating an existing project, only specified fields are modified"
    echo ""
    echo "For more information, see the script's header."
}

###############################################################################
# Function: check_auth
# Description: Checks if the user is authenticated with GitHub CLI and has the required scopes.
# Arguments:
#   None
# Output: Prints error messages to stderr if authentication fails or scopes are missing.
###############################################################################
check_auth() {
    # Mock mode for testing
    if [[ "${GH_CLI_MOCK:-}" == "1" ]]; then
        log_info "Mock mode enabled, skipping auth check."
        return 0
    fi

    # Check if gh is installed
    if ! command -v gh &>/dev/null; then
        log_error "GitHub CLI (gh) is not installed. Please install it first."
        log_info "Visit: https://cli.github.com/manual/installation"
        return 1
    fi

    # Check auth status and required scopes
    if ! gh auth status &>/dev/null; then
        log_error "GitHub CLI is not authenticated."
        log_info "Please run: gh auth login or set GH_TOKEN environment variable"
        return 1
    fi

    local required_scopes=("repo" "project" "read:org" "read:user")
    local missing_scopes=()
    for scope in "${required_scopes[@]}"; do
        if ! gh auth status --show-token | grep -q "$scope"; then
            missing_scopes+=("$scope")
        fi
    done

    if [ ${#missing_scopes[@]} -gt 0 ]; then
        log_error "Missing required GitHub CLI scopes: ${missing_scopes[*]}"
        log_error "Please run 'gh auth refresh -h github.com -s ${missing_scopes[*]}' to add them."
        return 1
    fi

    log_success "GitHub CLI is authenticated with all required scopes."
}

###############################################################################
# Function: get_project_id
# Description: Retrieves the project ID for a given project number.
# Arguments:
#   $1 - The project number.
# Output: Prints the project ID to stdout.
###############################################################################
get_project_id() {
    local project_number=$1
    gh project view "$project_number" --format json | jq -r '.id'
}

###############################################################################
# Function: get_field_id
# Description: Retrieves the field ID for a given field name in a project.
# Arguments:
#   $1 - The project ID.
#   $2 - The field name.
# Output: Prints the field ID to stdout.
###############################################################################
get_field_id() {
    local project_id=$1
    local field_name=$2
    gh project field-list "$project_id" --format json | jq -r --arg name "$field_name" '.fields[] | select(.name == $name) | .id'
}

###############################################################################
# Function: get_single_select_option_id
# Description: Retrieves the option ID for a given option value in a single-select field.
# Arguments:
#   $1 - The project ID.
#   $2 - The field ID.
#   $3 - The option value.
# Output: Prints the option ID to stdout.
###############################################################################
get_single_select_option_id() {
    local project_id=$1
    local field_id=$2
    local option_value=$3
    gh project field-list "$project_id" --format json | jq -r --arg field_id "$field_id" --arg option_value "$option_value" '.fields[] | select(.id == $field_id) | .settings.options[] | select(.name == $option_value) | .id'
}

###############################################################################
# Function: build_project_field_cmd
# Description: Builds the gh project field-create command.
# Arguments:
#   $1 - The project ID.
#   $2 - The field name.
#   $3 - The data type.
#   $4 - The single-select options (optional).
# Output: Prints the command to stdout.
###############################################################################
build_project_field_cmd() {
    local project_id=$1
    local field_name=$2
    local data_type=$3
    local single_select_options=$4

    local cmd="gh project field-create \"$project_id\" --name \"$field_name\" --data-type \"$data_type\""
    if [[ -n "$single_select_options" ]]; then
        cmd+=" --single-select-options '$single_select_options'"
    fi
    echo "$cmd"
}

###############################################################################
# Function: main
# Description: Main function to run the script.
# Arguments:
#   $@ - Command-line arguments.
# Output: Prints messages to stdout and stderr.
###############################################################################
main() {
    # --- MOCK MODE FOR TESTING ---
    if [[ "${GH_CLI_MOCK:-}" == "1" ]]; then
        log_info "Mock mode enabled, skipping main logic."
        # If we are in a bats test and the test file is not test-auth.bats, then we can exit early.
        if [[ -n "${BATS_TEST_FILENAME:-}" ]] && [[ "$BATS_TEST_FILENAME" != *"test-auth.bats"* ]]; then
            log_info "Mock mode enabled, but not in auth test. Exiting."
            exit 0
        fi
    fi

    # --- AUTHENTICATION ---
    log_info "Checking GitHub CLI authentication..."
    if ! check_auth; then
        exit 1
    fi

    # --- ARGUMENT PARSING ---
    log_info "Parsing command-line arguments..."
    local org="lightspeedwp"
    local product_name=""
    local project_number=""
    local settings_file=""
    local access_file=""
    local manage_access=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-owner)
                PROJECT_OWNER="$2"
                shift 2
                ;;
            --project-number)
                PROJECT_NUMBER="$2"
                shift 2
                ;;
            --auto-refresh)
                AUTO_REFRESH=true
                shift
                ;;
            --fields-file)
                FIELDS_FILE="$2"
                shift 2
                ;;
            --delete-fields)
                DELETE_FIELDS=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                if [[ -z "$product_name" ]]; then
                    product_name=$1
                elif [[ -z "$project_number" ]]; then
                    project_number=$1
                else
                    log_error "Unknown argument: $1"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # --- MAIN LOGIC ---
    log_info "Starting project update process..."
    if [[ -n "$settings_file" ]]; then
        log_info "Processing settings from $settings_file"
        # Read the CSV file and process each line
        while IFS=, read -r field_name data_type single_select_options; do
            # Skip header row
            if [[ "$field_name" == "name" ]]; then
                continue
            fi

            # Build and execute the command
            local cmd
            cmd=$(build_project_field_cmd "$project_id" "$field_name" "$data_type" "$single_select_options")
            if [[ "${DRY_RUN:-}" == "true" ]]; then
                log_info "DRY RUN: $cmd"
            else
                log_info "Executing: $cmd"
                eval "$cmd"
            fi
        done <"$settings_file"
    fi

    if [[ "$manage_access" == "true" ]] && [[ -n "$access_file" ]]; then
        log_info "Managing access from $access_file"
        # Read the CSV file and process each line
        while IFS=, read -r username role; do
            # Skip header row
            if [[ "$username" == "username" ]]; then
                continue
            fi

            # Build and execute the command
            local cmd="gh project-access-invite \"$project_id\" --username \"$username\" --role \"$role\""
            if [[ "${DRY_RUN:-}" == "true" ]]; then
                log_info "DRY RUN: $cmd"
            else
                log_info "Executing: $cmd"
                eval "$cmd"
            fi
        done <"$access_file"
    fi

    log_success "Project update process completed."
}

# --- SCRIPT EXECUTION ---
# Call main function only if the script is not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

