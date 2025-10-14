#!/bin/bash
#
# Script Name: standardize-logging.sh
# Description: Adds or updates standardized logging to script files
#
# Version: v0.1.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Usage: ./standardize-logging.sh [--dry-run] [--verbose] [script_file]
#
# Requirements:
#   - Bash (version 4.0 or later)
#   - Core utilities (awk, sed, grep, etc.)
#
# Usage: ./standardize-logging.sh
#
# Options:
#   --dry-run      Preview changes without applying them
#   --verbose      Show detailed debug information
#   --help         Show this help message
#
# Note:
# - This script modifies other scripts to include standardized logging.

set -euo pipefail

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}.log"

readonly SCRIPT_DIR
readonly SCRIPT_NAME
readonly LOG_DIR
readonly LOG_FILE

# Script defaults
DRY_RUN=false
VERBOSE=false

# Colors for terminal output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Create log directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# Logging functions
function log_info() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${GREEN}[INFO]${NC} $*" >&2
    echo "[INFO] ${timestamp}: $*" >> "${LOG_FILE}"
}

function log_warn() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${YELLOW}[WARNING]${NC} $*" >&2
    echo "[WARNING] ${timestamp}: $*" >> "${LOG_FILE}"
}

function log_error() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${RED}[ERROR]${NC} $*" >&2
    echo "[ERROR] ${timestamp}: $*" >> "${LOG_FILE}"
}

function log_debug() {
    if [[ "${VERBOSE}" == "true" ]]; then
        local timestamp
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
        echo "[DEBUG] ${timestamp}: $*" >> "${LOG_FILE}"
    fi
}

function show_help() {
    cat << EOF
Usage: ${0} [OPTIONS] [SCRIPT_FILE]

Adds or updates standardized logging to script files in the repository.
If no script file is specified, scans the entire scripts directory.

Options:
  --dry-run      Preview changes without applying them
  --verbose      Show detailed debug information
  --help         Show this help message

Example:
  ${0} --dry-run ../project/update-projects.sh
  ${0} --verbose
EOF
}

function parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                SCRIPT_FILE="$1"
                shift
                ;;
        esac
    done
}

function generate_logging_code() {
    cat << 'EOF'
# Global variables for logging
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../logs"
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}.log"

readonly SCRIPT_NAME
readonly LOG_DIR
readonly LOG_FILE

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

readonly RED
readonly GREEN
readonly YELLOW
readonly BLUE
readonly NC

# Create log directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# Logging functions
function log_info() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${GREEN}[INFO]${NC} $*" >&2
    echo "[INFO] ${timestamp}: $*" >> "${LOG_FILE}"
}

function log_warn() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${YELLOW}[WARNING]${NC} $*" >&2
    echo "[WARNING] ${timestamp}: $*" >> "${LOG_FILE}"
}

function log_error() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${RED}[ERROR]${NC} $*" >&2
    echo "[ERROR] ${timestamp}: $*" >> "${LOG_FILE}"
}

function log_debug() {
    if [[ "${VERBOSE}" == "true" ]]; then
        local timestamp
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
        echo "[DEBUG] ${timestamp}: $*" >> "${LOG_FILE}"
    fi
}
EOF
}

function update_script_file() {
    local script_file="$1"
    local temp_file
    temp_file=$(mktemp)

    log_info "Processing ${script_file}"

    if [[ ! -f "${script_file}" ]]; then
        log_error "File not found: ${script_file}"
        return 1
    fi

    # Check if file is a shell script
    if ! head -n1 "${script_file}" | grep -q '#!/bin/bash'; then
        log_debug "Skipping non-bash file: ${script_file}"
        return 0
    fi

    # Check if logging is already set up
    if grep -q "LOG_FILE=" "${script_file}"; then
        log_debug "Logging already set up in ${script_file}"
        return 0
    fi

    # Find position after shebang and initial comments
    local insert_line
    insert_line=$(awk '
        /^#!/ {next}
        /^#/ {next}
        /^$/ {next}
        {print NR; exit}
    ' "${script_file}")

    # If position not found, use line 1
    if [[ -z "${insert_line}" ]]; then
        insert_line=1
    fi

    log_debug "Inserting logging code at line ${insert_line}"

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY RUN] Would update ${script_file} at line ${insert_line}"
        return 0
    fi

    # Create a backup
    cp "${script_file}" "${script_file}.bak"

    # Generate the new file with logging code
    {
        head -n "$((insert_line-1))" "${script_file}"
        echo ""
        generate_logging_code
        echo ""
        tail -n "+${insert_line}" "${script_file}"
    } > "${temp_file}"

    # Replace the original file
    mv "${temp_file}" "${script_file}"

    log_info "Updated ${script_file} with standardized logging"
}

function scan_directory() {
    local dir="$1"

    log_debug "Scanning directory: ${dir}"

    find "${dir}" -type f -name "*.sh" | while read -r script_file; do
        update_script_file "${script_file}"
    done
}

# Main function
function main() {
    parse_arguments "$@"

    log_info "Starting standardized logging setup"
    log_debug "Dry Run: ${DRY_RUN}, Verbose: ${VERBOSE}"

    if [[ -n "${SCRIPT_FILE:-}" ]]; then
        update_script_file "${SCRIPT_FILE}"
    else
        # Process all script directories
        scan_directory "${SCRIPT_DIR}/.."
    fi

    log_info "Standardized logging setup complete"
}

# Execute main function
main "$@"
