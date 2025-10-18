#!/bin/bash
# ============================================================================
# Script Name: common-functions.sh
# Description: Common functions used across LightSpeed WP automation scripts
# Version: v1.0.0
# Date: 2025-10-17
# Author: LightSpeed WP Team
# Github Contributors: LightSpeed WP Team
# Author URI: https://lightspeedwp.agency/
# License: MIT
# License URI: https://opensource.org/licenses/MIT
# Requirements: bash 4.0+, standard Unix utilities
# Usage: source scripts/includes/common-functions.sh
# Environment Variables: LOG_LEVEL (optional) - Set logging level (DEBUG, INFO, WARN, ERROR)
# Options: None - this is a library file
# Examples:
#   source scripts/includes/common-functions.sh
#   log_info "Starting process"
#   validate_required_tools "git" "curl"
# Notes: 
#   - All functions follow LightSpeed WP standards
#   - Error handling uses set -euo pipefail where appropriate
#   - Functions are designed to be idempotent
# ============================================================================

# Strict mode for safety
set -euo pipefail

# ============================================================================
# Function: log_info
# Description: Log informational messages with timestamp
# Arguments: $* - Message to log
# Output: Formatted log message to stdout and optional log file
# Notes: Uses LOG_FILE environment variable if set
# ============================================================================
log_info() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[INFO] $timestamp: $*"
    echo "$message"
    
    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "$message" >> "$LOG_FILE"
    fi
}

# ============================================================================
# Function: log_error
# Description: Log error messages with timestamp to stderr
# Arguments: $* - Error message to log
# Output: Formatted error message to stderr and optional log file
# Notes: Uses LOG_FILE environment variable if set
# ============================================================================
log_error() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[ERROR] $timestamp: $*"
    echo "$message" >&2
    
    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "$message" >> "$LOG_FILE"
    fi
}

# ============================================================================
# Function: log_warn
# Description: Log warning messages with timestamp
# Arguments: $* - Warning message to log
# Output: Formatted warning message to stdout and optional log file
# Notes: Uses LOG_FILE environment variable if set
# ============================================================================
log_warn() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[WARN] $timestamp: $*"
    echo "$message"
    
    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "$message" >> "$LOG_FILE"
    fi
}

# ============================================================================
# Function: log_success
# Description: Log success messages with timestamp
# Arguments: $* - Success message to log
# Output: Formatted success message to stdout and optional log file
# Notes: Uses LOG_FILE environment variable if set
# ============================================================================
log_success() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[SUCCESS] $timestamp: $*"
    echo "$message"
    
    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "$message" >> "$LOG_FILE"
    fi
}

# ============================================================================
# Function: validate_required_tools
# Description: Check if required command-line tools are available
# Arguments: $* - List of required commands/tools
# Output: Error messages for missing tools
# Notes: Exits with code 1 if any tools are missing
# ============================================================================
validate_required_tools() {
    local missing_tools=()
    
    for tool in "$@"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_error "Please install the missing tools and try again"
        exit 1
    fi
}

# ============================================================================
# Function: setup_logging
# Description: Initialize logging with a specific log file
# Arguments: $1 - Log file path
# Output: Creates log file and sets LOG_FILE environment variable
# Notes: Creates directory structure if needed
# ============================================================================
setup_logging() {
    local log_file="$1"
    local log_dir
    log_dir=$(dirname "$log_file")
    
    # Create log directory if it doesn't exist
    mkdir -p "$log_dir"
    
    # Set global log file
    export LOG_FILE="$log_file"
    
    # Initialize log file
    touch "$LOG_FILE"
    log_info "Logging initialized: $LOG_FILE"
}

# ============================================================================
# Function: check_dry_run
# Description: Check if script is running in dry-run mode
# Arguments: None
# Output: None
# Notes: Returns 0 if DRY_RUN=true, 1 otherwise
# ============================================================================
check_dry_run() {
    [[ "${DRY_RUN:-false}" == "true" ]]
}

# ============================================================================
# Function: execute_with_dry_run
# Description: Execute command or show what would be executed in dry-run mode
# Arguments: $* - Command to execute
# Output: Command execution or dry-run message
# Notes: Respects DRY_RUN environment variable
# ============================================================================
execute_with_dry_run() {
    if check_dry_run; then
        log_info "DRY RUN: Would execute: $*"
    else
        log_info "Executing: $*"
        "$@"
    fi
}

# ============================================================================
# Function: get_script_dir
# Description: Get the directory containing the current script
# Arguments: None
# Output: Absolute path to script directory
# Notes: Works with symlinks and sourced scripts
# ============================================================================
get_script_dir() {
    local source="${BASH_SOURCE[1]}"
    while [[ -h "$source" ]]; do
        local dir
        dir=$(cd -P "$(dirname "$source")" >/dev/null 2>&1 && pwd)
        source=$(readlink "$source")
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" >/dev/null 2>&1 && pwd
}

# ============================================================================
# Function: confirm_action
# Description: Prompt user for confirmation before proceeding
# Arguments: $1 - Message to display for confirmation
# Output: User prompt and response
# Notes: Returns 0 if user confirms, 1 otherwise
# ============================================================================
confirm_action() {
    local message="$1"
    local response
    
    echo "$message"
    read -r -p "Do you want to continue? [y/N]: " response
    
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ============================================================================
# Function: cleanup_temp_files
# Description: Clean up temporary files and directories
# Arguments: $* - List of temporary files/directories to clean
# Output: Log messages about cleanup operations
# Notes: Designed to be safe and idempotent
# ============================================================================
cleanup_temp_files() {
    for item in "$@"; do
        if [[ -e "$item" ]]; then
            log_info "Cleaning up: $item"
            rm -rf "$item"
        fi
    done
}

# ============================================================================
# Function: validate_file_exists
# Description: Check if a file exists and is readable
# Arguments: $1 - File path to validate
# Output: Error message if file doesn't exist
# Notes: Returns 0 if file exists and is readable, 1 otherwise
# ============================================================================
validate_file_exists() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        log_error "File does not exist: $file"
        return 1
    fi
    
    if [[ ! -r "$file" ]]; then
        log_error "File is not readable: $file"
        return 1
    fi
    
    return 0
}

# ============================================================================
# Function: validate_directory_exists
# Description: Check if a directory exists and is accessible
# Arguments: $1 - Directory path to validate
# Output: Error message if directory doesn't exist
# Notes: Returns 0 if directory exists and is accessible, 1 otherwise
# ============================================================================
validate_directory_exists() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        log_error "Directory does not exist: $dir"
        return 1
    fi
    
    if [[ ! -x "$dir" ]]; then
        log_error "Directory is not accessible: $dir"
        return 1
    fi
    
    return 0
}

# ============================================================================
# Function: create_backup
# Description: Create a backup of a file with timestamp
# Arguments: $1 - File to backup
# Output: Path to backup file
# Notes: Creates backup in same directory with .backup.YYYYMMDD-HHMMSS suffix
# ============================================================================
create_backup() {
    local file="$1"
    local timestamp
    timestamp=$(date '+%Y%m%d-%H%M%S')
    local backup_file="${file}.backup.${timestamp}"
    
    if [[ -f "$file" ]]; then
        cp "$file" "$backup_file"
        log_info "Created backup: $backup_file"
        echo "$backup_file"
    else
        log_error "Cannot backup non-existent file: $file"
        return 1
    fi
}