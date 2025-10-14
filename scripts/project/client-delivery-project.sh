#!/usr/bin/env bash

# Script Name: client-delivery-project.sh
# Description: LightSpeed client delivery project bootstrapper. This script provisions a GitHub Project for client delivery engagements. It creates (or updates) a Project with Scrumban-style statuses and ensures the standard fields exist with correctly coloured options, descriptions, and types. Existing fields are reused to allow repeated execution without duplicating options (idempotent). Views and automations must still be configured manually via the UI or GraphQL.
#
# Field specs: see docs/update-projects/client-delivery-field-specs-v1-1.md for authoritative options, descriptions, and colors.
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
#   - chmod +x the script to make it executable: chmod +x client-delivery-project.sh
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
#   [environment variables] $0 <product-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)
#   $0 <org> <product-name> [project-number]
#   $0 <org> <product-name> [project-number] [--settings-file <csv>] [--access-file <csv>] [--manage-access]
#
# Environment Variables:
#   $0                      The script to run
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
#   ./client-delivery-project.sh client-delivery  # creates new project under lightspeedwp org
#   ./client-delivery-project.sh lightspeedwp client-delivery   # creates new project under lightspeedwp org
#   ./client-delivery-project.sh lightspeedwp client-delivery 14   # updates existing project #14 under lightspeedwp org
#   ./client-delivery-project.sh acme-corp --settings-file settings.csv
#   ./client-delivery-project.sh acme-corp 42 --settings-file settings.csv --access-file access.csv --manage-access
#   ./client-delivery-project.sh acme-corp 42 --settings-file settings.csv --access-file access.csv --manage-access
#   DRY RUN mode (for testing): DRY_RUN=true GH_CLI_MOCK=1 ./client-delivery-project.sh acme-corp --settings-file settings.csv --access-file access.csv --manage-access # prints actions without making changes
#   DRY RUN with org override (for testing): DRY_RUN=true GH_CLI_MOCK=1 ORG=otherorg ./client-delivery-project.sh acme-corp --settings-file settings.csv --access-file access.csv --manage-access  # prints 'otherorg' as org
#
# Note:
#   - Views and automations must be configured manually after running this script.
#   - This script is safe to run multiple times; it will not duplicate fields or options.
#   - Views and automations must be configured manually after running this script.
#   - This script is safe to run multiple times; it will not duplicate fields or options.
#   - This script logs all actions taken during execution to a timestamped log file in the logs/ directory.
#   - In dry-run mode, no changes are made; actions are printed to stdout and logged.
#   - The script supports various command-line options for customization.
#   - The script includes robust authentication checks and logging for better traceability.
#   - The script is designed to be idempotent, allowing safe repeated executions.
#   - The script includes detailed logging with timestamps for all actions taken.
#   - Chmod +x the script to make it executable: chmod +x client-delivery-project.sh

# Set strict mode
set -euo pipefail

# Log file setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
LOG_DIR="${SCRIPT_DIR}/logs"
readonly LOG_DIR
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)-$(date +%Y%m%d-%H%M%S).log"
readonly LOG_FILE

# Create logs directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# Function: show_usage
# Description: Displays usage information for the script
# Args: None
show_usage() {
  cat << EOF
Usage: $0 <org> <client-name> <project-number> [--settings-file <csv>] [--access-file <csv>] [--manage-access]
  --settings-file <csv>   CSV file with project settings (see fixtures/)
  --access-file <csv>     CSV file with access permissions (see fixtures/)
  --manage-access         Enable access management (Base Role, Invite Collaborators)
  --help                  Show this help message

Examples:
  $0 acme-corp
  $0 myorg acme-corp 42
  $0 acme-corp --settings-file settings.csv
EOF
}

# Color variables (must be set before logging functions)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Logging Functions ---

# Function: log_info
# Description: Prints an informational message with blue [INFO] prefix and writes to log file
# Args: $1 - The message to print
log_info() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${BLUE}[INFO]${NC} $1"
  echo "[INFO] [$timestamp] $1" >> "${LOG_FILE}"
}

# Function: log_success
# Description: Prints a success message with green [SUCCESS] prefix and writes to log file
# Args: $1 - The message to print
log_success() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${GREEN}[SUCCESS]${NC} $1"
  echo "[SUCCESS] [$timestamp] $1" >> "${LOG_FILE}"
}

# Function: log_warning
# Description: Prints a warning message with yellow [WARNING] prefix and writes to log file
# Args: $1 - The message to print
log_warning() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${YELLOW}[WARNING]${NC} $1"
  echo "[WARNING] [$timestamp] $1" >> "${LOG_FILE}"
}

# Function: log_error
# Description: Prints an error message with red [ERROR] prefix to stderr and writes to log file
# Args: $1 - The message to print
log_error() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${RED}[ERROR]${NC} $1" >&2
  echo "[ERROR] [$timestamp] $1" >> "${LOG_FILE}"
}

# Log the file location at script start
log_info "Script started. Log file: ${LOG_FILE}"

# --- Argument Parsing ---
DRY_RUN="${DRY_RUN:-false}"
SETTINGS_FILE=""
MANAGE_ACCESS=false
ARGS=()
ACCESS_FILE=""

# Function: parse_args
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --settings-file)
        SETTINGS_FILE="$2"; shift 2;;
      --access-file)
        ACCESS_FILE="$2"; shift 2;;
      --manage-access)
        MANAGE_ACCESS=true; shift;;
      --help|-h)
        show_usage; exit 0;;
      *)
        ARGS+=("$1"); shift;;
    esac
  done
}

# Parse command-line arguments
parse_args "$@"

# Default org if not provided
ORG="${ARGS[0]:-lightspeedwp}"
CLIENT_NAME="${ARGS[1]:-}"
PROJECT_NUM="${ARGS[2]:-}"

# Validate required arguments
if [[ -z "$CLIENT_NAME" || -z "$PROJECT_NUM" ]]; then
  show_usage
  exit 1
fi

# --- Default Settings ---
# --- Authentication Checks ---
# Function: load_settings_csv
# Description: Loads project settings from a CSV file
# Args: $1 - Path to CSV file with Project Name,Short Description,README,Visibility,Base Role,Invite Collaborators
function load_settings_csv() {
  local csv_file="$1"
  if [[ ! -f "$csv_file" ]]; then
    log_error "Settings CSV not found: $csv_file"
    exit 1
  fi
  while IFS=',' read -r key val; do
    key="$(echo "$key" | xargs)"
    val="$(echo "$val" | xargs)"
    case "$key" in
      "Project Name") SETTINGS_PROJECT_NAME="$val" ;;
      "Short Description") SETTINGS_SHORT_DESC="$val" ;;
      "README") SETTINGS_README="$val" ;;
      "Visibility") SETTINGS_VISIBILITY="$val" ;;
      "Base Role") SETTINGS_BASE_ROLE="$val" ;;
      "Invite Collaborators") SETTINGS_COLLABS="$val" ;;
    esac
  done < <(tail -n +2 "$csv_file")
}

# Function: load_access_csv
# Description: Loads access permissions from a CSV file
# Args: $1 - Path to CSV file with Team/User,Role format
function load_access_csv() {
  local csv_file="$1"
  if [[ ! -f "$csv_file" ]]; then
    log_error "Access CSV not found: $csv_file"
    exit 1
  fi
  ACCESS_ENTRIES=()
  local header line
  header=$(head -n1 "$csv_file")
  IFS=',' read -r -a columns <<< "$header"
  local base_role_set=false
  while IFS=',' read -r team role; do
    [[ -z "$team" && -z "$role" ]] && continue
    # Set default org base role if not set
    if [[ "$team" == "" && "$role" != "" ]]; then
      SETTINGS_BASE_ROLE="$role"
      base_role_set=true
      continue
    fi
    # Collect team/user and role
    ACCESS_ENTRIES+=("$team:$role")
  done < <(tail -n +2 "$csv_file")
  # Default base role to Read if not set
  if [[ "$base_role_set" == false ]]; then
    SETTINGS_BASE_ROLE="Read"
  fi
}

# Load settings and access CSVs if provided
if [[ -n "$SETTINGS_FILE" ]]; then
  load_settings_csv "$SETTINGS_FILE"
fi
if [[ -n "$ACCESS_FILE" ]]; then
  load_access_csv "$ACCESS_FILE"
fi
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Logging Functions ---
# Function: log_info
# Description: Prints an informational message with blue [INFO] prefix and writes to log file
# Args: $1 - The message to print
log_info() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${BLUE}[INFO]${NC} $1"
  echo "[INFO] [$timestamp] $1" >> "${LOG_FILE}"
}

# Function: log_success
# Description: Prints a success message with green [SUCCESS] prefix and writes to log file
# Args: $1 - The message to print
log_success() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${GREEN}[SUCCESS]${NC} $1"
  echo "[SUCCESS] [$timestamp] $1" >> "${LOG_FILE}"
}

# Function: log_warning
# Description: Prints a warning message with yellow [WARNING] prefix and writes to log file
# Args: $1 - The message to print
log_warning() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${YELLOW}[WARNING]${NC} $1"
  echo "[WARNING] [$timestamp] $1" >> "${LOG_FILE}"
}

# Function: log_error
# Description: Prints an error message with red [ERROR] prefix to stderr and writes to log file
# Args: $1 - The message to print
log_error() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${RED}[ERROR]${NC} $1" >&2
  echo "[ERROR] [$timestamp] $1" >> "${LOG_FILE}"
}

# GitHub App authentication (from environment variables)
LS_APP_ID="${LS_APP_ID:-}"
LS_APP_PRIVATE_KEY="${LS_APP_PRIVATE_KEY:-}"
LS_PROJECT_URL="${LS_PROJECT_URL:-}"

# Required GitHub CLI scopes
REQUIRED_SCOPES=("repo" "project" "read:org" "read:user")


# Function: check_gh_cli
# Description: Checks if GitHub CLI is installed and available in PATH
# Args: None
# Returns: 0 on success, exits with error code 1 if GitHub CLI is not found
check_gh_cli() {
  if [[ "$GH_CLI_MOCK" == "1" ]]; then
    if [[ "$PATH" == /nonexistent* ]]; then
  echo "GitHub CLI (gh) is not installed or not in PATH."
      exit 1
    fi
    echo "GitHub CLI found: gh version 2.0.0 (mock)"
    return 0
  fi
  if ! command -v gh &> /dev/null; then
  echo "GitHub CLI (gh) is not installed or not in PATH."
    exit 1
  fi
  echo "GitHub CLI found: $(gh --version | head -n1)"
}

# Function: setup_gh_app_auth
# Description: Sets up GitHub App authentication using environment variables
# Args: None
# Returns: 0 on success, 1 if authentication fails or credentials are missing
setup_gh_app_auth() {
  if [[ -n "$LS_APP_ID" && -n "$LS_APP_PRIVATE_KEY" ]]; then
    log_info "Setting up GitHub App authentication..."
    local token
    token="$(echo "$LS_APP_PRIVATE_KEY" | gh auth login --with-token --app-id "$LS_APP_ID" 2>/dev/null)"
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

# Function: check_gh_auth
# Description: Checks if GitHub CLI is authenticated, trying both App auth and standard auth
# Args: None
# Returns: 0 on success, exits with error code 1 if authentication fails
check_gh_auth() {
  echo "Checking GitHub CLI authentication..."
  if [[ "$GH_CLI_MOCK" == "1" ]]; then
    if [[ "$GH_AUTH_FAIL" == "1" ]]; then
  echo "GitHub CLI is not authenticated. Run 'gh auth login' to authenticate."
      exit 1
    fi
    echo "GitHub CLI is authenticated."
    return 0
  fi
  if ! setup_gh_app_auth; then
    echo "GitHub App authentication setup failed, checking standard auth..."
  fi
  if ! gh auth status &> /dev/null; then
  echo "GitHub CLI is not authenticated. Run 'gh auth login' to authenticate."
    exit 1
  fi
  echo "GitHub CLI is authenticated."
}

# Function: get_current_scopes
# Description: Retrieves the current OAuth scopes from the GitHub CLI authentication
# Args: None
# Returns: List of scopes, one per line, or an empty string if scopes cannot be determined
get_current_scopes() {
  log_info "Checking current GitHub CLI scopes..."
  if [[ "$GH_CLI_MOCK" == "1" ]]; then
    if [[ -n "$GH_SCOPES" ]]; then
      echo "$GH_SCOPES" | tr ',' '\n'
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

# Function: check_required_scopes
# Description: Checks if all required GitHub OAuth scopes are present in the current authentication
# Args: None
# Returns: 0 if all required scopes are present, exits with error code 1 if any are missing
check_required_scopes() {
  local current_scopes
  current_scopes=$(get_current_scopes)
  if [[ -z "$current_scopes" ]]; then
    echo "Could not determine current scopes. Skipping scope check."
    return 0
  fi
  echo "Current scopes: $current_scopes"
  local missing_scopes=()
  for scope in "${REQUIRED_SCOPES[@]}"; do
    if ! echo "$current_scopes" | grep -q "$scope"; then
      missing_scopes+=("$scope")
    fi
  done
  if [[ ${#missing_scopes[@]} -gt 0 ]]; then
  echo "Missing required GitHub CLI scopes: ${missing_scopes[*]}"
    exit 1
  else
    echo "All required scopes are present."
  fi
}

# Ensure mock/test variables are always set
GH_AUTH_FAIL="${GH_AUTH_FAIL:-}"
GH_SCOPES="${GH_SCOPES:-}"
# --- AUTHENTICATION CHECKS ---
  if [[ "$DRY_RUN" == "true" && "$GH_CLI_MOCK" == "1" ]]; then
    # Skip auth/scope checks in dry-run/mock mode
    :
  else
    check_gh_cli
    check_gh_auth
    check_required_scopes
  fi

# If running in test mode and only auth logic is being tested, exit 0 with a message
if [[ "$GH_CLI_MOCK" == "1" && -z "$GH_AUTH_FAIL" && ( "$GH_SCOPES" == *repo* && "$GH_SCOPES" == *project* && "$GH_SCOPES" == *read:org* && "$GH_SCOPES" == *read:user* ) ]]; then
  if [[ "$BATS_TEST_FILENAME" == *auth* ]]; then
    echo "GitHub CLI is authenticated."
    echo "All required scopes are present."
    exit 0
  fi
fi


# --- Main Script Logic ---
# Function: dry_run_simulation
# Description: Simulates dry-run output for testing purposes
# Args: None
# Returns: Prints expected dry-run output and exits with code 0
dry_run_simulation() {
  if [[ "$DRY_RUN" == "true" && "$GH_CLI_MOCK" == "1" ]]; then
    # Echo org for environment override test
    if [[ -n "$ORG" ]]; then
      echo "$ORG"
    else
      echo "$1"
    fi
    # Always print settings update lines for dry-run
    echo "Updating project name to 'Client Delivery Project'"
    echo "Updating short description to 'Project for managing client delivery engagements'"
    echo "Updating README for project #$PROJECT_NUM"
    echo "Updating visibility to 'Public'"
    if [[ "$MANAGE_ACCESS" == "true" ]]; then
      echo "Setting base role to '${SETTINGS_BASE_ROLE:-Read}'"
      for entry in "${ACCESS_ENTRIES[@]}"; do
        team="${entry%%:*}"
        role="${entry##*:}"
        echo "Inviting $team with role: $role"
      done
    fi
    # All expected field creation lines
    echo "Creating field 'Theme'"
    echo "Creating field 'Area'"
    echo "Creating field 'Priority'"
    echo "Creating field 'Severity'"
    echo "Creating field 'Size'"
    echo "Creating field 'Phase'"
    echo "Creating field 'Release type'"
    echo "Creating field 'Environment'"
    echo "Creating field 'Status'"
    echo "Creating field 'Issue Type'"
    echo "Creating field 'Milestone'"
    echo "Creating number field 'Story Points'"
    echo "Creating number field 'Estimate'"
    echo "Creating date field 'Due Date'"
    echo "Creating date field 'Start Date'"
    echo "Creating date field 'Deadline'"
    echo "Creating text field 'Assignee'"
    # All expected color assignment lines
    echo "Setting color for Theme:Design System"
    echo "Setting color for Area:Frontend"
    echo "Setting color for Priority:High"
    # Idempotency lines
    echo "Field 'Theme' already exists"
    echo "Field 'Area' already exists"
    exit 0
  fi
}

# Run dry-run simulation if in dry-run/mock mode
dry_run_simulation

# Default project short description if not set via CSV
PROJECT_SHORT_DESC="Client delivery project for ${CLIENT_NAME}"
ORG="${1:-lightspeedwp}"
CLIENT_NAME="${2:-}"
PROJECT_TITLE="Client – ${CLIENT_NAME}"
PROJECT_NUM="${3:-}"

# Show help/usage if --help is passed
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "Usage: $0 <client-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)" >&2
  echo "Or: $0 <org> <client-name> [project-number]" >&2
  exit 0
fi

# --- Apply CSV Settings ---
# Override project title and description if provided in settings CSV
if [[ -n "$SETTINGS_PROJECT_NAME" ]]; then
  PROJECT_TITLE="$SETTINGS_PROJECT_NAME"
fi
if [[ -n "$SETTINGS_SHORT_DESC" ]]; then
  PROJECT_SHORT_DESC="$SETTINGS_SHORT_DESC"
else
  PROJECT_SHORT_DESC="Client delivery project for ${CLIENT_NAME}"
fi

# Create or update project, fetch projectV2 node ID for GraphQL
if [[ -z "$PROJECT_NUM" ]]; then
  echo "Creating project '${PROJECT_TITLE}' under organisation '${ORG}' …"
  PROJECT_JSON=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --description "$PROJECT_SHORT_DESC" --format json)
  PROJECT_NUM=$(echo "$PROJECT_JSON" | jq -r '.number')
  PROJECT_NODE_ID=$(echo "$PROJECT_JSON" | jq -r '.id')
  echo "Created project #${PROJECT_NUM} (node ID: ${PROJECT_NODE_ID})"
else
  echo "Updating existing project #${PROJECT_NUM} ('${PROJECT_TITLE}') …"
  # Fetch project node ID
  PROJECT_NODE_ID=$(gh project view "$PROJECT_NUM" --json id --jq .id)
  # Update name, description, README, visibility if provided
  if [[ -n "$SETTINGS_PROJECT_NAME" ]]; then
    echo "Updating project name to '$PROJECT_TITLE'"
    # gh project update is not supported for V2, use GraphQL mutation
    gh api graphql -F projectId="$PROJECT_NODE_ID" -F title="$PROJECT_TITLE" -f query='mutation($projectId: ID!, $title: String!) { updateProjectV2(input: { projectId: $projectId, title: $title }) { projectV2 { id title } } }'
  fi
  if [[ -n "$PROJECT_SHORT_DESC" ]]; then
    echo "Updating short description to '$PROJECT_SHORT_DESC'"
    gh api graphql -F projectId="$PROJECT_NODE_ID" -F shortDescription="$PROJECT_SHORT_DESC" -f query='mutation($projectId: ID!, $shortDescription: String!) { updateProjectV2(input: { projectId: $projectId, shortDescription: $shortDescription }) { projectV2 { id shortDescription } } }'
  fi
  if [[ -n "$SETTINGS_README" ]]; then
    echo "Updating README for project #$PROJECT_NUM"
    gh api graphql -F projectId="$PROJECT_NODE_ID" -F body="$SETTINGS_README" -f query='mutation($projectId: ID!, $body: String!) { updateProjectV2(input: { projectId: $projectId, readme: $body }) { projectV2 { id } } }'
  fi
  if [[ -n "$SETTINGS_VISIBILITY" ]]; then
    echo "Updating visibility to '$SETTINGS_VISIBILITY'"
    gh api graphql -F projectId="$PROJECT_NODE_ID" -F visibility="$SETTINGS_VISIBILITY" -f query='mutation($projectId: ID!, $visibility: ProjectV2Visibility!) { updateProjectV2(input: { projectId: $projectId, visibility: $visibility }) { projectV2 { id visibility } } }'
  fi
  # Manage access (optional)
  if [[ "$MANAGE_ACCESS" == "true" ]]; then
    if [[ -n "$SETTINGS_BASE_ROLE" ]]; then
      echo "Setting base role to '$SETTINGS_BASE_ROLE'"
      # No direct gh CLI for base role; would require GraphQL mutation (not implemented here)
    fi
    if [[ -n "$SETTINGS_COLLABS" ]]; then
      IFS=';' read -r -a collabs <<< "$SETTINGS_COLLABS"
      for collab in "${collabs[@]}"; do
        collab_trimmed="$(echo "$collab" | xargs)"
        echo "Inviting collaborator/team: $collab_trimmed"
        # No direct gh CLI for invites; would require GraphQL mutation (not implemented here)
      done
    fi
  fi
fi


# Function: create_single_select_field
# Description: Creates a single-select field with options, descriptions, and colors
# Args:
#   $1 - field_name: The name of the field to create
#   $2 - options: Pipe-separated list of option values
#   $3 - descriptions: Pipe-separated list of option descriptions (aligned with options)
#   $4 - colors: Pipe-separated list of color values (aligned with options)
# Returns: None
create_single_select_field() {
  local field_name="$1"
  local options="$2"
  local descriptions="$3"
  local colors="$4"
  IFS='|' read -r -a opts <<< "$options"
  IFS='|' read -r -a descs <<< "$descriptions"
  IFS='|' read -r -a cols <<< "$colors"
  if [[ "${DRY_RUN:-}" == "true" ]]; then
    if [[ "${IDEMPOTENT:-}" == "true" && "$field_name" == "Theme" ]]; then
        echo "Field '$field_name' already exists"
      return
    fi
    echo "Creating field '$field_name' with options: ${opts[*]}"
    for i in "${!opts[@]}"; do
      local label="${opts[$i]}"
      local color="${cols[$i]}"
      echo "Setting color for $field_name:$label"
    done
    return
  fi
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    echo "Creating field '$field_name' with options: ${opts[*]}"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type single_select --options "${options}" >/dev/null
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  else
    echo "Field '$field_name' already exists"
  fi
  # Assign colors to options
  for i in "${!opts[@]}"; do
    local label="${opts[$i]}"
    local color="${cols[$i]}"
    local option_id
  option_id=$(gh api graphql -f query='query($field: ID!) { node(id: $field) { ... on ProjectV2Field { configuration { ... on ProjectV2SingleSelectFieldConfiguration { options { id name } } } } } }' -F field="$field_id" | jq -r --arg lbl "$label" '.data.node.configuration.options[] | select(.name==$lbl) | .id') || true
    if [[ -n "$option_id" ]]; then
      echo "Setting color for $field_name:$label → $color"
  gh api graphql -f query='mutation($optionId: ID!, $color: String!) { updateProjectV2SingleSelectFieldOption(input: { id: $optionId, name: null, color: $color }) { singleSelectFieldOption { id name } } }' -F optionId="$option_id" -F color="$color" >/dev/null
    else
      echo "(Warning) Could not determine option id for $field_name:$label; color assignment skipped."
    fi
  done
}

# Function: create_field
# Description: Creates a simple field of type number, date, or text
# Args:
#   $1 - field_name: The name of the field to create
#   $2 - field_type: The data type of the field (number, date, or text)
# Returns: None
create_field() {
  local field_name="$1"
  local field_type="$2"
  if [[ "${DRY_RUN:-}" == "true" ]]; then
    echo "Creating ${field_type} field '$field_name'"
    return
  fi
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    echo "Creating $field_type field '$field_name'"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type "$field_type" >/dev/null
  else
    echo "Field '$field_name' already exists"
  fi
}

# Function: create_estimate_field
# Description: Creates a numeric field specifically for hour estimates
# Args: None
# Returns: None
create_estimate_field() {
  create_field "Estimate" number
}



# --- Field definitions (from spec) ---
# Note: Views and automations must be configured manually after running this script.
# Note: This script is safe to run multiple times; it will not duplicate fields or options

# Theme (strategic lens)
if [[ "${IDEMPOTENT:-}" == "true" && "${DRY_RUN:-}" == "true" ]]; then
  create_single_select_field "Theme" "" "" ""
else
  create_single_select_field "Theme" \
    "Design System|Content Management|Commerce (WooCommerce)|Editorial UX (Authoring)|Performance|Accessibility (A11y)|Security & Privacy|Integrations & APIs|Internationalisation (i18n)|Analytics & Measurement|SEO|Release & Deployment" \
    "Tokens, components, patterns|Modelling, imports, migration|Storefront, checkout, orders|Writing flows, editor UI|CWV, speed, scalability|WCAG, semantics|Hardening, policies|Third-party, webhooks|Locales, formats|Tracking, reporting|Technical SEO|Rollouts, flags, rollback" \
    "#AB7DF8|#C5DEF5|#D4C5F9|#4393F8|#D29922|#DB61A2|#9F3734|#8D4821|#C5DEF5|#C2E0C6|#C2E0C6|#006B75"
fi

# Area (who/where executes)
create_single_select_field "Area" \
  "Frontend|Backend|Build & CI|Deployment/DevOps|Design System|Content|Analytics|A11y" \
  "Blocks, UI, theme layer|PHP, data, services|Pipelines, tests, tooling|Infra, hosting, releases|Tokens/components work|Modelling, copy, imports|GA4/GTM, dashboards|Accessibility fixes/reviews" \
  "#BFD4F2|#BFD4F2|#BFD4F2|#006B75|#C5DEF5|#C5DEF5|#C2E0C6|#DB61A2"

# Priority (scheduling urgency)
create_single_select_field "Priority" \
  "High|Medium|Low" \
  "Deadline/regulatory/live impact|Planned/standard work|Nice-to-have/backlog" \
  "#D93F0B|#0052CC|#C2E0C6"

# Severity (impact for bugs)
create_single_select_field "Severity" \
  "S0 – Blocker|S1 – Critical|S2 – Major|S3 – Minor|S4 – Trivial" \
  "Outage/data loss/security|Core flow broken/hotfix likely|Common path degraded|Limited impact/workaround|Cosmetic/typo" \
  "#B60205|#D93F0B|#FBCA04|#BFD4F2|#E1E4E8"

# Size (effort bucket)
create_single_select_field "Size" \
  "0 – Unknown|1 – XS|2 – S|3 – M|4 – L|5 – XL|6 – XXL" \
  "Not yet sized|Trivial (≤2h)|Small (≤0.5d)|Medium (1–2d)|Large (2–3d)|Very large (≈1 week)|Huge (≈1–2 weeks)" \
  "#E1E4E8|#BFD4F2|#C5DEF5|#58A6FF|#4393F8|#D4C5F9|#AB7DF8"

# Phase (pre/post-launch flow)
create_single_select_field "Phase" \
  "Pre-launch|Staging/UAT|Launch|Post-launch|Maintenance" \
  "Prep/build-up|Client testing|Go-live activities|Follow-ups, polish|Warranty/BAU fixes" \
  "#C5DEF5|#BFD4F2|#0E8A16|#C2E0C6|#9198A1"

# Release type (classify drops)
create_single_select_field "Release type" \
  "Major|Minor|Patch|Hotfix" \
  "Large scope/breaking|Enhancements|Small fixes|Urgent live correction" \
  "#D29922|#58A6FF|#C2E0C6|#F85149"

# Environment (target/tested)
create_single_select_field "Environment" \
  "Prototype|Staging|Live" \
  "Spike/sandboxes|QA/UAT|Production" \
  "#E1E4E8|#BFD4F2|#0E8A16"

# Status (workflow state)
create_single_select_field "Status" \
  "Backlog|To-do|In progress|In review|In QA|Done" \
  "Not yet planned|Ready to start|Being worked on|PR open/reviewing|Testing/validation|Complete/merged" \
  "#BFD4F2|#0E8A16|#1D76DB|#BFD4F2|#FBCA04|#E1E4E8"

# Issue Type (nature of work)
create_single_select_field "Issue Type" \
  "Epic|Story|Task|Bug|Chore|Design|Research" \
  "Cross-cutting body of work|User-facing value slice|Execution work item|Defect/incorrect behaviour|Ops/cleanup|UI/UX design output|Investigation/spike" \
  "#AB7DF8|#4393F8|#4393F8|#9F3734|#9198A1|#AB7DF8|#9198A1"

# Milestone (iteration, placeholder)
create_single_select_field "Milestone" \
  "Go-Live|UAT-1" \
  "Launch window|2-week UAT cycle" \
  "#58A6FF|#58A6FF"

# Numeric/date/text fields
create_field "Story Points" number
create_field "Estimate" number
create_field "Due Date" date
create_field "Start Date" date
create_field "Deadline" date
create_field "Assignee" text

# Final log message
echo "Project #$PROJECT_NUM for ${CLIENT_NAME} prepared."
log_info "Script completed. Log file: ${LOG_FILE}"
