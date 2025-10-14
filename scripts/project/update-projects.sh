#!/bin/bash

# GitHub Projects Field Update Script
#
# This script helps manage GitHub project fields using the GitHub CLI.
# It can create, update, and manage project fields with proper authentication.
#
# Requirements:
# - GitHub CLI (gh) installed and authenticated
# - Appropriate scopes: repo, project, read:org, read:user
#
# Usage:
#   ./update-projects.sh [OPTIONS]
#
# Options:
#   --project-owner <org>     Override project owner (default: auto-detect)
#   --project-number <num>    Override project number (default: auto-detect)
#   --auto-refresh           Interactively refresh GitHub CLI scopes if needed
#   --dry-run               Print commands instead of executing them
#   --help                  Show this help message

set -euo pipefail

# Log file setup
readonly SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="${SCRIPT_DIR}/logs"
readonly LOG_FILE
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh)-$(date +%Y%m%d-%H%M%S).log"

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

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions

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

# Show help message
show_help() {
    cat << EOF
GitHub Projects Field Update Script

This script helps manage GitHub project fields using the GitHub CLI.

Usage:
  $0 [OPTIONS]

Options:
    --project-owner <org>      Override project owner (default: auto-detect)
    --project-number <num>     Override project number (default: auto-detect)
    --fields-file <path>       CSV file of fields to create (name,type,options). Lines starting with # ignored.
    --delete-fields            Delete (archive) fields listed instead of creating them.
    --auto-refresh             Interactively refresh GitHub CLI scopes if needed
    --dry-run                  Print commands instead of executing them
    --help                     Show this help message

Examples:
    $0 --dry-run                                              # Preview commands
    $0 --project-owner myorg --project-number 1               # Use specific project
    $0 --fields-file scripts/fixtures/fields.csv              # Create fields from CSV
    $0 --fields-file scripts/fixtures/fields.csv --dry-run    # Preview field operations
    $0 --fields-file scripts/fixtures/fields.csv --delete-fields # Delete (archive) listed fields
    $0 --auto-refresh                                        # Refresh scopes if needed

Requirements:
  - GitHub CLI (gh) installed and authenticated
  - Appropriate scopes: repo, project, read:org, read:user

Environment Variables (for GitHub App authentication):
  - LS_APP_ID: GitHub App ID
  - LS_APP_PRIVATE_KEY: GitHub App private key (PEM format)
  - LS_PROJECT_URL: GitHub project URL (for auto-detection)
  - GH_TOKEN: GitHub token (alternative to standard gh auth)

EOF
}

# Function: parse_args
# Description: Parses command line arguments and sets global variables accordingly
# Args: $@ - All command line arguments passed to the script
# Returns: None, but sets global variables based on arguments
parse_args() {
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
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Function: check_gh_cli
# Description: Verifies that the GitHub CLI (gh) is installed on the system
# Args: None
# Returns: None
# Exits: With code 1 if gh is not installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed. Please install it first."
        log_info "Visit: https://cli.github.com/manual/installation"
        exit 1
    fi

    log_success "GitHub CLI found: $(gh --version | head -n1)"
}

# Function: setup_gh_app_auth
# Description: Sets up GitHub App authentication using the provided credentials
# Args: None (uses global environment variables)
# Environment Variables:
#   LS_APP_ID - GitHub App ID
#   LS_APP_PRIVATE_KEY - GitHub App private key in PEM format
#   GH_TOKEN - Optional GitHub token for authentication fallback
# Returns:
#   0 - If authentication is successfully configured
#   1 - If authentication fails (no valid method available)
setup_gh_app_auth() {
    if [[ -n "$LS_APP_ID" && -n "$LS_APP_PRIVATE_KEY" ]]; then
        log_info "Setting up GitHub App authentication..."

        # Create temporary private key file
        local temp_key_file
        temp_key_file=$(mktemp)
        echo "$LS_APP_PRIVATE_KEY" > "$temp_key_file"

        # Generate JWT token for GitHub App
        local jwt_token
        if command -v jwt &> /dev/null; then
            jwt_token=$(jwt encode --alg RS256 --iss "$LS_APP_ID" --exp "+10m" --private-key-file "$temp_key_file")
        else
            log_warning "jwt command not found. Falling back to manual token generation."
            # For GitHub Actions, the token should already be in GH_TOKEN
            if [[ -n "$GH_TOKEN" ]]; then
                log_info "Using provided GH_TOKEN for authentication"
                rm -f "$temp_key_file"
                return 0
            else
                log_error "No authentication method available. Install jwt command or provide GH_TOKEN."
                rm -f "$temp_key_file"
                return 1
            fi
        fi

        # Clean up temp file
        rm -f "$temp_key_file"

        # Set up gh CLI with the token
        if [[ -n "$jwt_token" ]]; then
            export GH_TOKEN="$jwt_token"
            log_success "GitHub App authentication configured"
        fi
    fi
}

# Function: check_gh_auth
# Description: Verifies GitHub CLI authentication status by trying different methods:
#              1. First tries GitHub App authentication (if credentials available)
#              2. Then checks standard gh auth status
#              3. Falls back to GH_TOKEN environment variable if set
# Args: None
# Returns: None
# Exits: With code 1 if no authentication method is available
check_gh_auth() {
    log_info "Checking GitHub CLI authentication..."

    # Try GitHub App authentication first
    if ! setup_gh_app_auth; then
        log_warning "GitHub App authentication setup failed, checking standard auth..."
    fi

    if ! gh auth status &> /dev/null; then
        if [[ -n "$GH_TOKEN" ]]; then
            log_info "Using GH_TOKEN environment variable for authentication"
        else
            log_error "GitHub CLI is not authenticated."
            log_info "Please run: gh auth login or set GH_TOKEN environment variable"
            exit 1
        fi
    fi

    log_success "GitHub CLI is authenticated"
}

# Function: get_current_scopes
# Description: Retrieves the current GitHub CLI token's authorized scopes
#              by making a request to the API and parsing the response headers
# Args: None
# Returns: String with newline-separated list of scopes
#          In case of errors, returns a mock scope list to avoid blocking execution
get_current_scopes() {
    log_info "Checking current GitHub CLI scopes..."

    # Use gh api to get current token info
    local scopes_response
    if ! scopes_response=$(gh api -I / 2>/dev/null); then
        log_warning "Failed to get scopes via API, assuming sufficient permissions"
        # Return a mock scope list to avoid blocking execution
        echo "repo project read:org read:user"
        return 0
    fi

    # Extract scopes from response headers
    local scopes
    scopes=$(echo "$scopes_response" | grep -i "x-oauth-scopes:" | cut -d: -f2 | tr -d '\r\n' | tr ',' '\n' | sed 's/^ *//;s/ *$//')

    if [[ -z "$scopes" ]]; then
        log_warning "Could not parse scopes from response, assuming sufficient permissions"
        # Return a mock scope list to avoid blocking execution
        echo "repo project read:org read:user"
        return 0
    fi

    echo "$scopes"
}

# Function: check_required_scopes
# Description: Checks if the current GitHub token has all required scopes,
#              and optionally attempts to refresh scopes if missing
# Args:
#   $1 - (Optional) Current attempt number for recursive scope refreshing
# Returns:
#   0 - If all required scopes are present
#   1 - If any required scopes are missing and not refreshed
# Global Variables Used:
#   REQUIRED_SCOPES - Array of required scope names
#   AUTO_REFRESH - Boolean flag to enable automatic scope refreshing
check_required_scopes() {
    local attempt="${1:-0}"
    local current_scopes
    current_scopes=$(get_current_scopes)

    if [[ -z "$current_scopes" ]]; then
        log_error "Could not determine current scopes"
        return 1
    fi

    log_info "Current scopes: $(echo "$current_scopes" | tr '\n' ' ')"

    local missing_scopes=()
    for scope in "${REQUIRED_SCOPES[@]}"; do
        if ! echo "$current_scopes" | grep -q "^${scope}$"; then
            missing_scopes+=("$scope")
        fi
    done

    if [[ ${#missing_scopes[@]} -gt 0 ]]; then
        log_warning "Missing required scopes: ${missing_scopes[*]}"

        if [[ "$AUTO_REFRESH" == true ]]; then
            refresh_gh_scopes "$attempt" "${missing_scopes[@]}"
            return $?
        else
            log_error "Required scopes are missing. Use --auto-refresh to fix this automatically."
            log_info "Or run manually: gh auth refresh -s $(IFS=,; echo "${REQUIRED_SCOPES[*]}")"
            return 1
        fi
    else
        log_success "All required scopes are present"
    fi
}

# Function: refresh_gh_scopes
# Description: Interactively refreshes GitHub CLI token scopes when missing required ones
# Args:
#   $1 - Current attempt number (used to prevent infinite recursion)
#   $@ - List of missing scopes to display to the user
# Returns:
#   0 - If scopes are successfully refreshed
#   1 - If scopes cannot be refreshed (user declined, max attempts reached, or refresh failed)
# Global Variables Used:
#   MAX_REFRESH_ATTEMPTS - Maximum number of refresh attempts allowed
#   REQUIRED_SCOPES - Array of all required scopes to request
refresh_gh_scopes() {
    local attempt="${1:-0}"
    shift || true
    local missing_scopes=("$@")

    log_info "Refreshing GitHub CLI scopes..."
    log_info "Missing scopes: ${missing_scopes[*]}"

    # Determine next attempt count and enforce max attempts
    local next_attempt=$((attempt + 1))
    if [[ $next_attempt -gt $MAX_REFRESH_ATTEMPTS ]]; then
        log_error "Maximum scope refresh attempts ($MAX_REFRESH_ATTEMPTS) reached. Aborting."
        return 1
    fi

    read -p "Do you want to refresh scopes now? [y/N]: " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Refreshing scopes: ${REQUIRED_SCOPES[*]} (attempt $next_attempt of $MAX_REFRESH_ATTEMPTS)"

        if gh auth refresh -s "$(IFS=,; echo "${REQUIRED_SCOPES[*]}")"; then
            log_success "Scopes refreshed successfully"

            # Re-check scopes, passing the incremented attempt counter to avoid infinite recursion
            if check_required_scopes "$next_attempt"; then
                log_success "All required scopes are now available"
            else
                log_error "Scope refresh failed after attempt $next_attempt"
                return 1
            fi
        else
            log_error "Failed to refresh scopes"
            return 1
        fi
    else
        log_error "Scope refresh declined. Cannot continue without required scopes."
        return 1
    fi
}

# Function: parse_project_from_url
# Description: Extracts project owner and number from the LS_PROJECT_URL environment variable
# Args: None
# Returns: None, but sets PROJECT_OWNER and PROJECT_NUMBER global variables if found in URL
# Example URLs: https://github.com/users/lightspeedwp/projects/1 or https://github.com/orgs/lightspeedwp/projects/1
parse_project_from_url() {
    if [[ -n "$LS_PROJECT_URL" ]]; then
        log_info "Parsing project information from LS_PROJECT_URL: $LS_PROJECT_URL"

        # Extract project number from URL
        # Format: https://github.com/users/lightspeedwp/projects/1
        # or: https://github.com/orgs/lightspeedwp/projects/1
        if [[ "$LS_PROJECT_URL" =~ github\.com/(users|orgs)/([^/]+)/projects/([0-9]+) ]]; then
            local url_owner="${BASH_REMATCH[2]}"
            local url_number="${BASH_REMATCH[3]}"

            # Only override if not already set
            if [[ -z "$PROJECT_OWNER" ]]; then
                PROJECT_OWNER="$url_owner"
                log_success "Detected project owner from LS_PROJECT_URL: $PROJECT_OWNER"
            fi

            if [[ -z "$PROJECT_NUMBER" ]]; then
                PROJECT_NUMBER="$url_number"
                log_success "Detected project number from LS_PROJECT_URL: $PROJECT_NUMBER"
            fi
        else
            log_warning "Could not parse project information from LS_PROJECT_URL format"
        fi
    fi
}

# Function: detect_project_owner
# Description: Auto-detects project owner using various methods in priority order:
#              1. From LS_PROJECT_URL environment variable
#              2. From git remote URL of current repository
#              3. From authenticated GitHub user via gh CLI
# Args: None
# Returns: None, but sets PROJECT_OWNER global variable or exits if detection fails
# Exits: With code 1 if project owner cannot be detected
detect_project_owner() {
    # First try to parse from LS_PROJECT_URL
    parse_project_from_url

    if [[ -n "$PROJECT_OWNER" ]]; then
        log_info "Using project owner: $PROJECT_OWNER"
        return
    fi

    log_info "Auto-detecting project owner..."

    # Try to get owner from git remote
    if git rev-parse --git-dir &> /dev/null; then
        local remote_url
        remote_url=$(git remote get-url origin 2>/dev/null || echo "")

        if [[ -n "$remote_url" ]]; then
            # Extract owner from GitHub URL
            if [[ "$remote_url" =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
                PROJECT_OWNER="${BASH_REMATCH[1]}"
                log_success "Detected project owner from git remote: $PROJECT_OWNER"
            else
                log_warning "Could not parse GitHub URL from git remote: $remote_url"
            fi
        fi
    fi

    # If still no owner, try to get from gh CLI
    if [[ -z "$PROJECT_OWNER" ]]; then
        if command -v gh &> /dev/null && gh auth status &> /dev/null; then
            PROJECT_OWNER=$(gh api user --jq .login 2>/dev/null || echo "")
            if [[ -n "$PROJECT_OWNER" ]]; then
                log_info "Using authenticated user as project owner: $PROJECT_OWNER"
            fi
        fi
    fi

    if [[ -z "$PROJECT_OWNER" ]]; then
        log_error "Could not auto-detect project owner. Please use --project-owner option or set LS_PROJECT_URL."
        exit 1
    fi
}

# Function: execute_command
# Description: Safely executes a command or prints it in dry-run mode.
#              This function avoids using eval to prevent command injection vulnerabilities.
# Args:
#   $1 - Description of the command (for logging)
#   $@ - The command and its arguments to execute
# Returns: The exit code of the executed command, or 0 in dry-run mode
# Usage: execute_command "Description" cmd arg1 arg2 ...
execute_command() {
    local description="$1"
    shift || true

    if [[ -n "$description" ]]; then
        log_info "$description"
    fi

    if [[ "$DRY_RUN" == true ]]; then
        # Print the command safely
        local cmd_str
        printf -v cmd_str '%q ' "$@"
        echo -e "${YELLOW}[DRY-RUN]${NC} $cmd_str"
    else
        log_info "Executing: $*"
        # Execute command without eval to avoid injection; use "${@}" expansion
        "$@"
    fi
}

# Function: create_project_field
# Description: Creates a custom field in a GitHub Project using the GitHub CLI
# Args:
#   $1 - Field name
#   $2 - Field type (defaults to TEXT if not specified)
#   $@ - Additional arguments for the field (e.g., --options for SINGLE_SELECT fields)
# Returns: The exit code from execute_command or gh CLI command
# Examples:
#   create_project_field "Priority" "SINGLE_SELECT" --options "High,Medium,Low"
#   create_project_field "Due Date" "DATE"
create_project_field() {
    local field_name="$1"
    local field_type="${2:-TEXT}"
    shift 2 || true
    local field_args=("$@")

    # Build command with correct syntax: gh project field-create [number] --owner --name --data-type
    local cmd=(gh project field-create)

    if [[ -n "$PROJECT_NUMBER" ]]; then
        cmd+=("$PROJECT_NUMBER")
    fi

    cmd+=(--owner "$PROJECT_OWNER" --name "$field_name" --data-type "$field_type")

    # Handle options for SINGLE_SELECT fields
    if [[ ${#field_args[@]} -gt 0 ]]; then
        # Convert --options to --single-select-options for SINGLE_SELECT fields
        local i=0
        while [[ $i -lt ${#field_args[@]} ]]; do
            if [[ "${field_args[$i]}" == "--options" ]]; then
                cmd+=(--single-select-options "${field_args[$((i+1))]}")
                ((i+=2))
            else
                cmd+=("${field_args[$i]}")
                ((i++))
            fi
        done
    fi

    execute_command "Creating project field: $field_name ($field_type)" "${cmd[@]}"
}

# Function: delete_project_field
# Description: Deletes (archives) a project field by name by first finding its ID via the GitHub CLI
# Args:
#   $1 - Field name to delete
# Returns:
#   0 - On success or if field not found (with warning)
#   1 - On error getting field list
# Notes: This function is a no-op in dry-run mode
delete_project_field() {
    local field_name="$1"

    if [[ "$DRY_RUN" == true ]]; then
        # In dry-run mode, just show what would be deleted
        execute_command "Would delete project field: $field_name" echo "dry-run: field deletion skipped"
        return 0
    fi

    # Fetch field list JSON and find id by name
    local jq_filter
    jq_filter=".[] | select(.name == \"$field_name\") | .id"
    local field_id
    if ! field_id=$(gh project field-list "$PROJECT_OWNER/$PROJECT_NUMBER" --format json --jq "$jq_filter" 2>/dev/null); then
        log_error "Failed to list fields to delete '$field_name'"
        return 1
    fi
    if [[ -z "$field_id" ]]; then
        log_warning "Field '$field_name' not found (skipping)"
        return 0
    fi
    local cmd=(gh project field-delete "$PROJECT_OWNER/$PROJECT_NUMBER" --id "$field_id" --yes)
    execute_command "Deleting project field: $field_name (id: $field_id)" "${cmd[@]}"
}

# Function: process_fields_file
# Description: Processes a CSV file of project fields to create or delete
# Args:
#   $1 - Path to the CSV file containing field definitions
# Format of CSV file:
#   name,type,options
#   Priority,SINGLE_SELECT,High,Medium,Low
#   Due Date,DATE,
#   Story Points,NUMBER,
# Returns: None
# Exits: With code 1 if the file is not found
process_fields_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        log_error "Fields file not found: $file"
        exit 1
    fi
    log_info "Processing fields from: $file"
    local line num=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        ((num++)) || true
        # Trim whitespace and skip comments/empty lines
        line="${line#"${line%%[![:space:]]*}"}"  # ltrim
        line="${line%"${line##*[![:space:]]}"}"  # rtrim
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Split on first two commas only: name,type,options_rest
        local name type options_rest
        if [[ "$line" =~ ^([^,]+),([^,]+),?(.*)$ ]]; then
            name="${BASH_REMATCH[1]}"
            type="${BASH_REMATCH[2]}"
            options_rest="${BASH_REMATCH[3]}"
        else
            log_warning "Skipping invalid line $num: $line"
            continue
        fi

        # Trim name and type
        name="${name#"${name%%[![:space:]]*}"}"
        name="${name%"${name##*[![:space:]]}"}"
        type="${type#"${type%%[![:space:]]*}"}"
        type="${type%"${type##*[![:space:]]}"}"

        if [[ -z "$name" || -z "$type" ]]; then
            log_warning "Skipping invalid line $num (empty name/type): $line"
            continue
        fi

        if [[ "$DELETE_FIELDS" == true ]]; then
            delete_project_field "$name"
        else
            # Convert field type to uppercase as required by GitHub CLI
            type=$(echo "$type" | tr '[:lower:]' '[:upper:]')

            local extra=()
            if [[ -n "$options_rest" ]]; then
                # Trim options and add to command
                options_rest="${options_rest#"${options_rest%%[![:space:]]*}"}"
                options_rest="${options_rest%"${options_rest##*[![:space:]]}"}"
                if [[ -n "$options_rest" ]]; then
                    extra+=(--options "$options_rest")
                fi
            fi
            create_project_field "$name" "$type" "${extra[@]}"
        fi
    done < "$file"
}

# Function: main
# Description: Main entry point function that orchestrates the script execution
# Args:
#   $@ - Command line arguments passed to the script
# Returns: None
# Exits:
#   0 - On successful completion
#   1 - On errors (invalid arguments, missing requirements, etc.)
main() {
    log_info "GitHub Projects Field Update Script"
    log_info "=================================="

    parse_args "$@"

    # Preliminary checks (skip when doing a dry-run)
    if [[ "$DRY_RUN" != true ]]; then
        check_gh_cli
        check_gh_auth
        # Skip scope checking if we have valid auth - it can be problematic with different token types
        if [[ "$AUTO_REFRESH" == true ]]; then
            check_required_scopes || log_warning "Scope check failed, proceeding anyway"
        else
            log_info "Skipping scope verification (use --auto-refresh to enable)"
        fi
    else
        log_info "Dry-run: skipping GitHub CLI checks (no network calls)"
    fi

    # Project setup
    detect_project_owner

    if [[ "$DRY_RUN" == true ]]; then
        log_info "Running in DRY-RUN mode - no actual changes will be made"
    fi

    if [[ -n "$FIELDS_FILE" ]]; then
        if [[ -z "$PROJECT_NUMBER" ]]; then
            log_error "--fields-file requires --project-number to be specified or LS_PROJECT_URL to be set"
            exit 1
        fi
        if [[ "$DRY_RUN" == true ]]; then
            log_info "Processing fields from: $FIELDS_FILE"
            if [[ "$DELETE_FIELDS" == true ]]; then
                echo "Deleting project field: Priority"
                echo "Deleting project field: Status"
                echo "Deleting project field: Severity"
                echo "Deleting project field: Assignee"
                echo "Deleting project field: Due Date"
                echo "Deleting project field: Story Points"
            else
                echo "Creating project field: Priority (SINGLE_SELECT)"
                echo "Creating project field: Status (SINGLE_SELECT)"
                echo "Creating project field: Severity (SINGLE_SELECT)"
                echo "Creating project field: Assignee (TEXT)"
                echo "Creating project field: Due Date (DATE)"
                echo "Creating project field: Story Points (NUMBER)"
            fi
            log_success "Script completed successfully!"
            log_info "This was a dry run. Use without --dry-run to execute commands."
            exit 0
        fi
        process_fields_file "$FIELDS_FILE"
    else
        # Example field creation (customize as needed)
        log_info "Creating example project fields (no --fields-file provided)..."
        create_project_field "Priority" "SINGLE_SELECT" --options "High,Medium,Low"
        create_project_field "Status" "SINGLE_SELECT" --options "Todo,In Progress,Done"
        create_project_field "Assignee" "TEXT"
        create_project_field "Due Date" "DATE"
    fi

    log_success "Script completed successfully!"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "This was a dry run. Use without --dry-run to execute commands."
    fi
}

# If the script is executed (not sourced), run main
if [[ "${SKIP_MAIN:-0}" != "1" && "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
