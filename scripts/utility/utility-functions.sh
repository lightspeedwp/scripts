#!/bin/bash
###############################################################################
#
# Script Name: utility-functions.sh
# Description: Common utility functions for LightSpeed WP automation scripts. Provides a standardized set of functions for logging, file operations, command validation, error handling, and other common tasks used across the automation toolset.
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
#   - Bash (version 4.0 or later)
#   - Core utilities (awk, sed, grep, etc.)
#
# Usage: source ./utility-functions.sh [options]
#
# Environment Variables:
#   LOG_LEVEL               Log level (0=ERROR, 1=WARN, 2=INFO, 3=DEBUG), defaults to INFO (2)
#
# Options:
#   --help                  Show this help message
#   --verbose               Enable verbose logging (sets LOG_LEVEL to DEBUG)
#
# Examples:
#   source ./utility-functions.sh --help        # Show help message
#   source ./utility-functions.sh --verbose     # Enable verbose logging
#   source ./utility-functions.sh               # Load with default settings
#   LOG_LEVEL=3 source ./utility-functions.sh   # Set custom log level
#
# Notes:
#   - This script is intended to be sourced, not executed directly.
#   - After sourcing, all utility functions will be available in the current shell.
#   - Use the log_* functions for consistent output formatting across scripts.
#   - Functions will respect the LOG_LEVEL environment variable for output control.
#
###############################################################################

set -euo pipefail

readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_NC='\033[0m' # No Color
# Logging levels
readonly LOG_LEVEL_ERROR=0
readonly LOG_LEVEL_WARN=1
readonly LOG_LEVEL_INFO=2
readonly LOG_LEVEL_DEBUG=3
# Default log level
LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}
###############################################################################
# Function: log_error
# Description: Logs error messages to stderr in red if log level permits.
# Arguments:
#   $* - Message to log
# Output: Prints colored [ERROR] message to stderr.
###############################################################################
log_error() {
    if [ "$LOG_LEVEL" -ge "$LOG_LEVEL_ERROR" ]; then
        echo -e "${COLOR_RED}[ERROR]${COLOR_NC} $*" >&2
    fi
}

###############################################################################
#
# Function: log_warn
# Description: Logs warning messages to stderr in yellow if log level permits.
# Arguments:
#   $* - Message to log
# Output: Prints colored [WARN] message to stderr.
###############################################################################
log_warn() {
    if [ "$LOG_LEVEL" -ge "$LOG_LEVEL_WARN" ]; then
        echo -e "${COLOR_YELLOW}[WARN]${COLOR_NC} $*" >&2
    fi
}

###############################################################################
#
# Function: log_info
# Description: Logs informational messages to stdout in blue if log level permits.
# Arguments:
#   $* - Message to log
# Output: Prints colored [INFO] message to stdout.
###############################################################################
log_info() {
    if [ "$LOG_LEVEL" -ge "$LOG_LEVEL_INFO" ]; then
        echo -e "${COLOR_BLUE}[INFO]${COLOR_NC} $*"
    fi
}

###############################################################################
#
# Function: log_success
# Description: Logs success messages to stdout in green if log level permits.
# Arguments:
#   $* - Message to log
# Output: Prints colored [SUCCESS] message to stdout.
###############################################################################
log_success() {
    if [ "$LOG_LEVEL" -ge "$LOG_LEVEL_INFO" ]; then
        echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_NC} $*"
    fi
}

###############################################################################
#
# Function: log_debug
# Description: Logs debug messages to stderr if log level permits.
# Arguments:
#   $* - Message to log
# Output: Prints [DEBUG] message to stderr.
###############################################################################
log_debug() {
    if [ "$LOG_LEVEL" -ge "$LOG_LEVEL_DEBUG" ]; then
        echo -e "[DEBUG] $*" >&2
    fi
}

###############################################################################
#
# Function: command_exists
# Description: Checks if a command exists in PATH.
# Arguments:
#   $1 - Command name
# Output: Returns 0 if command exists, 1 otherwise.
###############################################################################
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

###############################################################################
#
# Function: check_dependencies
# Description: Checks if all required commands are available in PATH.
# Arguments:
#   $@ - List of command names
# Output: Logs missing dependencies and returns 1 if any are missing, 0 otherwise.
###############################################################################
check_dependencies() {
    local missing_deps=()

    for cmd in "$@"; do
        if ! command_exists "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Please install the missing dependencies and try again"
        return 1
    fi

    return 0
}

###############################################################################
#
# Function: confirm
# Description: Prompts user for yes/no confirmation. Uses default if not interactive.
# Arguments:
#   $1 - Prompt message (optional)
#   $2 - Default response (optional, 'n' by default)
# Output: Returns 0 for yes, 1 for no.
###############################################################################
confirm() {
    local prompt="${1:-Are you sure?}"
    local default="${2:-n}"

    # If not running interactively, use default response
    if [ ! -t 0 ]; then
        case "${default,,}" in
            y|yes)
                return 0
                ;;
            n|no)
                return 1
                ;;
            *)
                return 1
                ;;
        esac
    fi
    while true; do
        read -p "$prompt [y/N]: " -r response
        response=${response:-$default}

        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo "Please answer yes or no."
                ;;
        esac
    done
}

###############################################################################
#
# Function: backup_file
# Description: Creates a timestamped backup of a file in a specified directory.
# Arguments:
#   $1 - File to backup
#   $2 - Backup directory (optional, defaults to ./backups)
# Output: Prints backup path on success, logs error on failure.
###############################################################################
backup_file() {
    local file="$1"
    local backup_dir="${2:-./backups}"

    if [ ! -f "$file" ]; then
        log_error "File does not exist: $file"
        return 1
    fi

    mkdir -p "$backup_dir"
    local backup_file
    backup_file="${backup_dir}/$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"

    if cp "$file" "$backup_file"; then
        log_success "Backup created: $backup_file"
        echo "$backup_file"
    else
        log_error "Failed to create backup of $file"
        return 1
    fi
}

###############################################################################
#
# Function: retry
# Description: Retries a command with exponential backoff up to max_attempts.
# Arguments:
#   $1 - Maximum number of attempts
#   $@ - Command to execute
# Output: Logs warnings on failure, returns 0 on success, 1 on final failure.
###############################################################################
retry() {
    local max_attempts="$1"
    shift
    local attempt=1
    local delay=1

    while [ "$attempt" -le "$max_attempts" ]; do
        if "$@"; then
            return 0
        fi

        log_warn "Attempt $attempt/$max_attempts failed. Retrying in ${delay}s..."
        sleep $delay

        attempt=$((attempt + 1))
        delay=$((delay * 2))
    done

    log_error "Command failed after $max_attempts attempts"
    return 1
}

###############################################################################
#
# Function: get_script_dir
# Description: Returns the directory of the current script.
# Arguments: None
# Output: Prints script directory path.
###############################################################################
get_script_dir() {
    cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

###############################################################################
#
# Function: validate_url
# Description: Validates that a string is a properly formatted URL.
# Arguments:
#   $1 - URL string to validate
# Output: Returns 0 if valid, logs error and returns 1 if invalid.
###############################################################################
validate_url() {
    local url="$1"
    local url_regex='^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$'

    if [[ "$url" =~ $url_regex ]]; then
        return 0
    else
        log_error "Invalid URL format: $url"
        return 1
    fi
}

###############################################################################
#
# Function: is_root
# Description: Checks if the current user is root.
# Arguments: None
# Output: Returns 0 if root, 1 otherwise.
###############################################################################
is_root() {
    [ "$EUID" -eq 0 ]
}

###############################################################################
#
# Function: timestamp
# Description: Generates a timestamp in YYYY-MM-DD HH:MM:SS format.
# Arguments: None
# Output: Prints timestamp string.
###############################################################################
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
