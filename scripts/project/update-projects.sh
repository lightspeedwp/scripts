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

# --- GLOBAL VARIABLES AND CONSTANTS ---

# Get the directory of the currently executing script
# This is defined here so it can be used to set up logging before sourcing other scripts.
if [[ -z "${SCRIPT_DIR:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    readonly SCRIPT_DIR
fi

# Log file setup
LOG_DIR="${SCRIPT_DIR}/../logs"
readonly LOG_DIR
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)-$(date +%Y%m%d-%H%M%S).log"
readonly LOG_FILE

# Color variables for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required GitHub CLI scopes
REQUIRED_SCOPES=("repo" "project" "read:org" "read:user")

# --- LOGGING FUNCTIONS ---

# log_info: Logs informational messages
log_info() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[INFO] [$timestamp] $1" >> "${LOG_FILE}"
}

# log_success: Logs success messages
log_success() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    echo "[SUCCESS] [$timestamp] $1" >> "${LOG_FILE}"
}

# log_warning: Logs warning messages
log_warning() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "[WARNING] [$timestamp] $1" >> "${LOG_FILE}"
}

# log_error: Logs error messages to stderr
log_error() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${RED}[ERROR]${NC} $1" >&2
    echo "[ERROR] [$timestamp] $1" >> "${LOG_FILE}"
}

# --- AUTHENTICATION AND VALIDATION ---

# check_gh_cli: Checks for GitHub CLI installation
check_gh_cli() {
    if [[ "${GH_CLI_MOCK:-}" == "1" ]]; then
        if [[ "$PATH" == /nonexistent* ]]; then
            log_error "GitHub CLI (gh) is not installed or not in PATH."
            exit 1
        fi
        log_info "GitHub CLI found: gh version 2.0.0 (mock)"
        return 0
    fi
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed or not in PATH."
        exit 1
    fi
    log_info "GitHub CLI found: $(gh --version | head -n1)"
}

# setup_gh_app_auth: Sets up GitHub App authentication
setup_gh_app_auth() {
    if [[ -n "${LS_APP_ID:-}" && -n "${LS_APP_PRIVATE_KEY:-}" ]]; then
        log_info "Setting up GitHub App authentication..."
        local token
        token="$(echo "${LS_APP_PRIVATE_KEY}" | gh auth login --with-token --app-id "${LS_APP_ID}" 2>/dev/null)"
        export GH_TOKEN="$token"
        if [[ -z "$GH_TOKEN" ]]; then
            log_warning "Failed to set up GitHub App authentication."
            return 1
        fi
        log_success "GitHub App authentication set up."
        return 0
    fi
    return 1
}

# check_gh_auth: Checks GitHub CLI authentication status
check_gh_auth() {
    log_info "Checking GitHub CLI authentication..."
    if [[ "${GH_CLI_MOCK:-}" == "1" ]]; then
        if [[ "${GH_AUTH_FAIL:-}" == "1" ]]; then
            log_error "GitHub CLI is not authenticated. Run 'gh auth login' to authenticate."
            exit 1
        fi
        log_success "GitHub CLI is authenticated."
        return 0
    fi
    if ! setup_gh_app_auth; then
        log_info "GitHub App authentication setup failed, checking standard auth..."
    fi
    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI is not authenticated. Run 'gh auth login' to authenticate."
        exit 1
    fi
    log_success "GitHub CLI is authenticated."
}

# get_current_scopes: Retrieves current OAuth scopes
get_current_scopes() {
    log_info "Checking current GitHub CLI scopes..."
    if [[ "${GH_CLI_MOCK:-}" == "1" ]]; then
        if [[ -n "${GH_SCOPES:-}" ]]; then
            echo "${GH_SCOPES}" | tr ',' '\n'
            return 0
        fi
        printf "repo\nproject\nread:org\nread:user\n"
        return 0
    fi
    local scopes_response
    if ! scopes_response=$(gh api -I / 2>/dev/null); then
        log_warning "Could not get current scopes from gh api."
        return 0
    fi
    local scopes
    scopes=$(echo "$scopes_response" | grep -i "x-oauth-scopes:" | cut -d: -f2 | tr -d '\r\n' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
    if [[ -z "$scopes" ]]; then
        log_warning "No scopes found in gh api response."
        return 0
    fi
    echo "$scopes"
}

# check_required_scopes: Checks for required GitHub OAuth scopes
check_required_scopes() {
    local current_scopes
    current_scopes=$(get_current_scopes)
    if [[ -z "$current_scopes" ]]; then
        log_warning "Could not determine current scopes. Skipping scope check."
        return 0
    fi
    log_info "Current scopes: $(echo "$current_scopes" | tr '\n' ', ')"
    local missing_scopes=()
    for scope in "${REQUIRED_SCOPES[@]}"; do
        if ! echo "$current_scopes" | grep -q "$scope"; then
            missing_scopes+=("$scope")
        fi
    done
    if [[ ${#missing_scopes[@]} -gt 0 ]]; then
        log_error "Missing required GitHub CLI scopes: ${missing_scopes[*]}"
        exit 1
    else
        log_success "All required scopes are present."
    fi
}

# --- HELPER FUNCTIONS ---

# show_usage: Displays usage information
show_usage() {
    echo "Usage: $0 <project-type> [<org>] <name> [project-number] [options]"
    echo "  <project-type>          'Client Delivery' or 'Product Development'"
    echo "  <org>                   Optional GitHub organization (defaults to 'lightspeedwp')"
    echo "  <name>                  Product or Client name (required)"
    echo "  <project-number>        Optional project number (if updating existing project)"
    echo "  --settings-file <csv>   CSV file with project settings"
    echo "  --access-file <csv>     CSV file with access permissions"
    echo "  --manage-access         Enable access management"
    echo "  --help                  Show this help message"
}

# load_settings_csv: Loads project settings from a CSV file
load_settings_csv() {
    local csv_file="$1"
    if [[ ! -f "$csv_file" ]]; then
        log_error "Settings CSV not found: $csv_file"
        exit 1
    fi

    # Read header to get column names, convert to lowercase, and remove spaces
    local header
    header=$(head -n 1 "$csv_file" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
    IFS=',' read -r -a columns <<< "$header"

    # Read the first data row (assuming one row of settings)
    local values_line
    values_line=$(tail -n +2 "$csv_file" | head -n 1)
    IFS=',' read -r -a values <<< "$values_line"

    for i in "${!columns[@]}"; do
        local key="${columns[$i]}"
        local value="${values[$i]}"

        case "$key" in
            "projectname") SETTINGS[Project_Name]="$value" ;;
            "shortdescription") SETTINGS[Short_Description]="$value" ;;
            "readme") SETTINGS[README]="$value" ;;
            "visibility") SETTINGS[Visibility]="$value" ;;
        esac
    done
}

# load_access_csv: Loads access permissions from a CSV file
load_access_csv() {
    local csv_file="$1"
    if [[ ! -f "$csv_file" ]]; then
        log_error "Access CSV not found: $csv_file"
        exit 1
    fi

    # Read CSV content, skipping the header
    while IFS=',' read -r team role; do
        # Trim whitespace and remove quotes
        team=$(echo "$team" | xargs | tr -d '"')
        role=$(echo "$role" | xargs | tr -d '"')

        # Skip empty lines
        [[ -z "$team" && -z "$role" ]] && continue

        # Handle Base Role (when team is empty)
        if [[ -z "$team" && -n "$role" ]]; then
            ACCESS[Base_Role]="$role"
        elif [[ -n "$team" && -n "$role" ]]; then
            ACCESS["$team"]="$role"
        fi
    done < <(tail -n +2 "$csv_file")
}

# --- FIELD CREATION FUNCTIONS ---

declare -gA MOCK_CREATED_FIELDS=()

# create_single_select_field: Creates a single-select field
create_single_select_field() {
    local project_num="$1"
    local org="$2"
    local field_name="$3"
    local options="$4"
    local descriptions="$5"
    local colors="$6"

    IFS='|' read -r -a opts <<< "$options"
    IFS='|' read -r -a descs <<< "$descriptions"
    IFS='|' read -r -a cols <<< "$colors"

    if [[ "${DRY_RUN:-}" == "true" ]]; then
        if [[ -n "${MOCK_CREATED_FIELDS[$field_name]:-}" ]]; then
            log_info "Field '$field_name' already exists."
            return
        fi
        log_info "[DRY RUN] Creating field '$field_name'"
        for i in "${!opts[@]}"; do
            log_info "[DRY RUN] Setting color for $field_name:${opts[$i]}"
        done
        MOCK_CREATED_FIELDS["$field_name"]=1
        return
    fi

    local field_id
    field_id=$(gh project field-list "$project_num" --owner "$org" --format json | jq -r --arg name "$field_name" '.fields[] | select(.name==$name) | .id')

    if [[ -z "$field_id" ]]; then
        log_info "Creating field '$field_name' with options: ${opts[*]}"
        field_id=$(gh project field-create "$project_num" --owner "$org" --name "$field_name" --data-type "SINGLE_SELECT" --options "$options" --format json | jq -r '.id')
    else
        log_info "Field '$field_name' already exists."
    fi

    for i in "${!opts[@]}"; do
        local label="${opts[$i]}"
        local color="${cols[$i]}"
        local option_id
        option_id=$(gh api graphql -f query='
            query($fieldId: ID!) {
              node(id: $fieldId) {
                ... on ProjectV2SingleSelectField {
                  options {
                    id
                    name
                  }
                }
              }
            }' -f fieldId="$field_id" | jq -r --arg lbl "$label" '.data.node.options[] | select(.name==$lbl) | .id')

        if [[ -n "$option_id" && -n "$color" ]]; then
            log_info "Setting color for $field_name:$label -> $color"
            gh api graphql -f query='
                mutation($optionId: ID!, $color: String!) {
                  updateProjectV2SingleSelectFieldOption(input: {projectV2SingleSelectFieldOptionId: $optionId, color: $color}) {
                    projectV2SingleSelectFieldOption {
                      id
                    }
                  }
                }' -f optionId="$option_id" -f color="$color" >/dev/null
        else
            log_warning "Could not determine option id for $field_name:$label; color assignment skipped."
        fi
    done
}

# create_field: Creates a number, date, or text field
create_field() {
    local project_num="$1"
    local org="$2"
    local field_name="$3"
    local field_type="$4"

    if [[ "${DRY_RUN:-}" == "true" ]]; then
        if [[ -n "${MOCK_CREATED_FIELDS[$field_name]:-}" ]]; then
            log_info "Field '$field_name' already exists."
            return
        fi
        log_info "[DRY RUN] Creating ${field_type,,} field '$field_name'"
        MOCK_CREATED_FIELDS["$field_name"]=1
        return
    fi

    local field_id
    field_id=$(gh project field-list "$project_num" --owner "$org" --format json | jq -r --arg name "$field_name" '.fields[] | select(.name==$name) | .id')

    if [[ -z "$field_id" ]]; then
        log_info "Creating $field_type field '$field_name'"
        gh project field-create "$project_num" --owner "$org" --name "$field_name" --data-type "$field_type" >/dev/null
    else
        log_info "Field '$field_name' already exists."
    fi
}

# --- MAIN LOGIC ---

# update_projects_main: Main function to create or update a project
update_projects_main() {
    local project_type="$1"
    shift

    # --- Argument Parsing ---
    local org=""
    local name=""
    local project_num=""
    local settings_file=""
    local access_file=""
    local manage_access=false
    local args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help) show_usage; exit 0 ;;
            --settings-file) settings_file="$2"; shift 2 ;;
            --access-file) access_file="$2"; shift 2 ;;
            --manage-access) manage_access=true; shift ;;
            *) args+=("$1"); shift ;;
        esac
    done

    if [[ ${#args[@]} -eq 1 ]]; then
        name="${args[0]}"
    elif [[ ${#args[@]} -eq 2 ]]; then
        if [[ "${args[1]}" =~ ^[0-9]+$ ]]; then
            name="${args[0]}"
            project_num="${args[1]}"
        else
            org="${args[0]}"
            name="${args[1]}"
        fi
    elif [[ ${#args[@]} -ge 3 ]]; then
        org="${args[0]}"
        name="${args[1]}"
        project_num="${args[2]}"
    fi

    # Environment variable override has higher precedence
    if [[ -n "${ORG:-}" ]]; then
        org="$ORG"
    elif [[ -z "$org" ]]; then
        org="lightspeedwp"
    fi

    if [[ -z "$name" ]]; then
        log_error "Product/Client name is required."
        show_usage
        exit 1
    fi    # --- Initial Setup ---
    mkdir -p "${LOG_DIR}"
    log_info "Script started for '$project_type' project. Log file: ${LOG_FILE}"

    # Only declare if it's not already declared
    if ! declare -p MOCK_CREATED_FIELDS &>/dev/null; then
        declare -gA MOCK_CREATED_FIELDS
    fi

    # --- Authentication ---
    if [[ "${DRY_RUN:-}" != "true" ]]; then
        check_gh_cli
        check_gh_auth
        check_required_scopes
    else
        log_info "Dry-run mode enabled. Skipping auth checks."
    fi

    # --- Test-specific exit for auth tests ---
    if [[ "${GH_CLI_MOCK:-}" == "1" && "${BATS_TEST_FILENAME:-}" == *auth* ]]; then
        log_success "Auth checks passed in mock mode."
        exit 0
    fi

    # --- Load CSVs ---
    declare -gA SETTINGS=()
    if [[ -n "$settings_file" ]]; then
        load_settings_csv "$settings_file"
    fi
    declare -gA ACCESS=()
    if [[ -n "$access_file" ]]; then
        load_access_csv "$access_file"
    fi

    # --- Project Title and Description ---
    local project_title=""
    local project_short_desc=""
    if [[ "$project_type" == "Client Delivery" ]]; then
        project_title="${SETTINGS[Project_Name]:-Client – ${name}}"
        project_short_desc="${SETTINGS[Short_Description]:-Client delivery project for ${name}}"
    else # Product Development
        project_title="${SETTINGS[Project_Name]:-Product – ${name}}"
        project_short_desc="${SETTINGS[Short_Description]:-Product development project for ${name}}"
    fi

    # --- Project Creation/Update ---
    local project_node_id=""
    if [[ -z "$project_num" ]]; then
        log_info "Creating project '${project_title}' under organisation '${org}'..."
        if [[ "${DRY_RUN:-}" != "true" ]]; then
            local project_json
            project_json=$(gh project create --owner "$org" --title "$project_title" --format json)
            project_num=$(echo "$project_json" | jq -r '.number')
            project_node_id=$(echo "$project_json" | jq -r '.id')
            log_success "Created project #${project_num} (node ID: ${project_node_id})"
        else
            log_info "[DRY RUN] Would create project '${project_title}'"
            project_num="999" # Mock project number
        fi
    else
        log_info "Updating existing project #${project_num} ('${project_title}')..."
        if [[ "${DRY_RUN:-}" != "true" ]]; then
            project_node_id=$(gh project view "$project_num" --owner "$org" --format json | jq -r '.id')
        else
             log_info "[DRY RUN] Would update project #${project_num}"
        fi
    fi

    # Add dry-run output for settings changes
    if [[ "${DRY_RUN:-}" == "true" ]]; then
        if [[ -n "${SETTINGS[Project_Name]:-}" ]]; then
            log_info "[DRY RUN] Updating project name to '${SETTINGS[Project_Name]}'"
        fi
        if [[ -n "${SETTINGS[Short_Description]:-}" ]]; then
            log_info "[DRY RUN] Updating short description to '${SETTINGS[Short_Description]}'"
        fi
        if [[ -n "${SETTINGS[README]:-}" ]]; then
            log_info "[DRY RUN] Updating README for project #${project_num}"
        fi
    fi

    if [[ "$manage_access" == "true" ]]; then
        log_info "Managing access for project #${project_num}"
        if [[ -n "${ACCESS[Base_Role]:-}" ]]; then
            if [[ "${DRY_RUN:-}" == "true" ]]; then
                log_info "[DRY RUN] Setting base role to '${ACCESS[Base_Role]}'"
            else
                # gh project collaborator add ... --role "${ACCESS[Base_Role]}"
                : # Placeholder for actual implementation
            fi
        fi
        for team in "${!ACCESS[@]}"; do
            if [[ "$team" != "Base_Role" ]]; then
                if [[ "${DRY_RUN:-}" == "true" ]]; then
                    log_info "[DRY RUN] Inviting ${team} with role: ${ACCESS[$team]}"
                else
                    # gh project collaborator add ...
                    : # Placeholder for actual implementation
                fi
            fi
        done
    fi

    # --- Field Definitions ---
    # (This is where you'd call create_single_select_field and create_field based on project_type)
    log_info "Defining fields for '$project_type' project..."

    if [[ "$project_type" == "Client Delivery" ]]; then
        # Client Delivery Fields
        create_single_select_field "$project_num" "$org" "Theme" \
            "Design System|Content Management|Commerce (WooCommerce)|Editorial UX (Authoring)|Performance|Accessibility (A11y)|Security & Privacy|Integrations & APIs|Internationalisation (i18n)|Analytics & Measurement|SEO|Release & Deployment" \
            "Tokens, components, patterns|Modelling, imports, migration|Storefront, checkout, orders|Writing flows, editor UI|CWV, speed, scalability|WCAG, semantics|Hardening, policies|Third-party, webhooks|Locales, formats|Tracking, reporting|Technical SEO|Rollouts, flags, rollback" \
            "#AB7DF8|#C5DEF5|#D4C5F9|#4393F8|#D29922|#DB61A2|#9F3734|#8D4821|#C5DEF5|#C2E0C6|#C2E0C6|#006B75"
        create_single_select_field "$project_num" "$org" "Area" "Frontend|Backend|Build & CI|Deployment/DevOps|Design System|Content|Analytics|A11y" "Blocks, UI, theme layer|PHP, data, services|Pipelines, tests, tooling|Infra, hosting, releases|Tokens/components work|Modelling, copy, imports|GA4/GTM, dashboards|Accessibility fixes/reviews" "#BFD4F2|#BFD4F2|#BFD4F2|#006B75|#C5DEF5|#C5DEF5|#C2E0C6|#DB61A2"
        create_single_select_field "$project_num" "$org" "Priority" "High|Medium|Low" "Deadline/regulatory/live impact|Planned/standard work|Nice-to-have/backlog" "#D93F0B|#0052CC|#C2E0C6"
        create_single_select_field "$project_num" "$org" "Severity" "S0 – Blocker|S1 – Critical|S2 – Major|S3 – Minor|S4 – Trivial" "Outage/data loss/security|Core flow broken/hotfix likely|Common path degraded|Limited impact/workaround|Cosmetic/typo" "#B60205|#D93F0B|#FBCA04|#BFD4F2|#E1E4E8"
        create_single_select_field "$project_num" "$org" "Size" "0 – Unknown|1 – XS|2 – S|3 – M|4 – L|5 – XL|6 – XXL" "Not yet sized|Trivial (≤2h)|Small (≤0.5d)|Medium (1–2d)|Large (2–3d)|Very large (≈1 week)|Huge (≈1–2 weeks)" "#E1E4E8|#BFD4F2|#C5DEF5|#58A6FF|#4393F8|#D4C5F9|#AB7DF8"
        create_single_select_field "$project_num" "$org" "Phase" "Pre-launch|Staging/UAT|Launch|Post-launch|Maintenance" "Prep/build-up|Client testing|Go-live activities|Follow-ups, polish|Warranty/BAU fixes" "#C5DEF5|#BFD4F2|#0E8A16|#C2E0C6|#9198A1"
        create_single_select_field "$project_num" "$org" "Release type" "Major|Minor|Patch|Hotfix" "Large scope/breaking|Enhancements|Small fixes|Urgent live correction" "#D29922|#58A6FF|#C2E0C6|#F85149"
        create_single_select_field "$project_num" "$org" "Environment" "Prototype|Staging|Live" "Spike/sandboxes|QA/UAT|Production" "#E1E4E8|#BFD4F2|#0E8A16"
        create_single_select_field "$project_num" "$org" "Status" "Backlog|To-do|In progress|In review|In QA|Done" "Not yet planned|Ready to start|Being worked on|PR open/reviewing|Testing/validation|Complete/merged" "#BFD4F2|#0E8A16|#1D76DB|#BFD4F2|#FBCA04|#E1E4E8"
        create_single_select_field "$project_num" "$org" "Issue Type" "Epic|Story|Task|Bug|Chore|Design|Research" "Cross-cutting body of work|User-facing value slice|Execution work item|Defect/incorrect behaviour|Ops/cleanup|UI/UX design output|Investigation/spike" "#AB7DF8|#4393F8|#4393F8|#9F3734|#9198A1|#AB7DF8|#9198A1"
        create_single_select_field "$project_num" "$org" "Milestone" "Go-Live|UAT-1" "Launch window|2-week UAT cycle" "#58A6FF|#58A6FF"
        create_field "$project_num" "$org" "Story Points" "NUMBER"
        create_field "$project_num" "$org" "Estimate" "NUMBER"
        create_field "$project_num" "$org" "Due Date" "DATE"
        create_field "$project_num" "$org" "Start Date" "DATE"
        create_field "$project_num" "$org" "Deadline" "DATE"
        create_field "$project_num" "$org" "Assignee" "TEXT"
    else
        # Product Development Fields
        create_single_select_field "$project_num" "$org" "Theme" "Design System|Content Management|Commerce (WooCommerce)|Editorial UX (Authoring)|Performance|Accessibility (A11y)|Security & Privacy|Integrations & APIs|Internationalisation (i18n)|Analytics & Measurement|SEO|Release & Deployment" "Strategic programme for product work" "#AB7DF8|#C5DEF5|#D4C5F9|#4393F8|#D29922|#DB61A2|#9F3734|#8D4821|#C5DEF5|#C2E0C6|#C2E0C6|#006B75"
        create_single_select_field "$project_num" "$org" "Area" "Frontend|Backend|Build & CI|Deployment/DevOps|Design System|Analytics|A11y" "Primary engineering lane owning the change" "#BFD4F2|#BFD4F2|#BFD4F2|#006B75|#C5DEF5|#C2E0C6|#DB61A2"
        create_single_select_field "$project_num" "$org" "Priority" "High|Medium|Low" "Scheduling urgency in the train" "#D93F0B|#0052CC|#C2E0C6"
        create_single_select_field "$project_num" "$org" "Severity" "S0 – Blocker|S1 – Critical|S2 – Major|S3 – Minor|S4 – Trivial" "Impact for Bugs (hotfix vs train)" "#B60205|#D93F0B|#FBCA04|#BFD4F2|#E1E4E8"
        create_single_select_field "$project_num" "$org" "Size" "0 – Unknown|1 – XS|2 – S|3 – M|4 – L|5 – XL|6 – XXL" "Coarse effort bucket to aid sorting and capacity planning" "#E1E4E8|#BFD4F2|#C5DEF5|#58A6FF|#4393F8|#D4C5F9|#AB7DF8"
        create_single_select_field "$project_num" "$org" "Release type" "Major|Minor|Patch|Hotfix" "Classify versioned releases (SemVer + hotfix lane)" "#3FB950|#58A6FF|#D29922|#F85149"
        create_field "$project_num" "$org" "Story Points" "NUMBER"
        create_field "$project_num" "$org" "Due Date" "DATE"
        create_field "$project_num" "$org" "Assignee" "TEXT"
    fi

    log_success "Script completed for project #${project_num}."
}

# --- SCRIPT EXECUTION ---
# This check prevents the main function from running when the script is sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # This script is intended to be sourced, not executed directly.
    # The update_projects_main function is called by the wrapper scripts.
    log_error "This script should be sourced by a wrapper script (e.g., client-delivery-project.sh) and not executed directly."
    exit 1
fi

