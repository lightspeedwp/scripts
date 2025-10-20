#!/bin/bash

#!/bin/bash
###############################################################################
#
# Script Name: run-deployment-tests.sh
# Description: Test runner for scripts/deployment scripts. Runs all deployment Bats tests in scripts/tests/deployment for each reciprocal script. Supports listing, running specific tests, dry-run mode, verbose/quiet output, and summary reporting.
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
#   - bats-core
#   - bash
#   - jq (optional, for JSON output)
#   - yq (optional, for YAML output)
#   - grep
#   - curl (optional, for downloading dependencies)
#
# Usage: ./run-deployment-tests.sh [options]
#
# Options:
#   --help                  Show this help message
#   --test <test_name>      Run a specific test file (without .bats extension)
#   --list                  List all available test files
#   --verbose               Enable verbose output
#   --debug                 Enable debug mode
#   --color                 Enable colored output
#   --no-color              Disable colored output
#   --log-file <file>       Specify a log file to write output
#   --timeout <seconds>     Set a timeout for each test
#   --parallel <number>     Run tests in parallel (specify number of jobs)
#   --filter <pattern>      Run tests matching a specific pattern
#   --exclude <pattern>     Exclude tests matching a specific pattern
#   --retry <number>        Retry failed tests a specified number of times
#   --coverage              Generate a coverage report
#   --junit <file>          Output results in JUnit XML format to specified file
#   --tap <file>            Output results in TAP format to specified file
#   --html <file>           Output results in HTML format to specified file
#   --json <file>           Output results in JSON format to specified file
#   --summary               Show a summary of test results
#   --detailed              Show detailed output for each test
#   --list-tests            List all individual tests in the test files
#   --list-suites           List all test suites (test files)
#   --list-tags             List all tags used in tests
#   --tag <tag>             Run tests with a specific tag
#   --exclude-tag <tag>     Exclude tests with a specific tag
#   --help-test             Show help for test-specific options
#   --help-general          Show help for general options
#   --version               Show script version
#   --update                Update the test runner script to the latest version
#   --install-deps          Install required dependencies
#   --check-deps            Check if required dependencies are installed
#   --dry-run               Show what would be done without executing tests
#   --force                 Force execution even if certain checks fail
#   --skip                  Skip certain tests or checks
#   --only                  Run only specified tests or checks
#   --config <file>         Specify a configuration file
#   --env <key=value>       Set environment variables for the test run
#   --list-env              List all environment variables set for the test run
#   --clear-env             Clear all environment variables set for the test run
#   --help-all              Show help for all options
#
# Examples:
#   ./run-deployment-tests.sh --test example-deployment
#   ./run-deployment-tests.sh --list
#   ./run-deployment-tests.sh --verbose --color
#   ./run-deployment-tests.sh --log-file deployment-tests.log
#   ./run-deployment-tests.sh --timeout 30 --parallel 4
#   ./run-deployment-tests.sh --filter "deploy*" --exclude "*fail*"
#   ./run-deployment-tests.sh --retry 2 --coverage
#   ./run-deployment-tests.sh --junit results.xml --html results.html
#   ./run-deployment-tests.sh --summary --detailed
#   ./run-deployment-tests.sh --list-tests
#   ./run-deployment-tests.sh --tag critical --exclude-tag slow
#   ./run-deployment-tests.sh --version
#   ./run-deployment-tests.sh --update
#   ./run-deployment-tests.sh --install-deps
#   ./run-deployment-tests.sh --check-deps
#   ./run-deployment-tests.sh --dry-run
#
# Notes:
#   - This script runs all Bats tests located in the scripts/tests/deployment directory.
#   - Each test file should correspond to a script in the scripts/deployment directory.
#   - Ensure all scripts under test are executable (chmod +x script.sh).
#   - Requires bats-core to be installed and available in PATH.
#
###############################################################################

# Set strict mode

# Standardized logging - LightSpeed WP
#
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
        echo -e "[DEBUG] $*" >&2
        echo "[DEBUG] ${timestamp}: $*" >> "${LOG_FILE}"
    fi
}

set -euo pipefail

# Determine script and repository root directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_help() {
    cat << EOF
Usage: $(basename "$0") [options]
Test runner for scripts/deployment scripts.

Options:
  --help                  Show this help message
  --test <test_name>      Run a specific test file (without .bats extension)
  --list                  List all available test files
  --verbose               Enable verbose output
  --debug                 Enable debug mode
  --color                 Enable colored output
  --no-color              Disable colored output
  --log-file <file>       Specify a log file to write output
  --timeout <seconds>     Set a timeout for each test
  --parallel <number>     Run tests in parallel (specify number of jobs)
  --filter <pattern>      Run tests matching a specific pattern
  --exclude <pattern>     Exclude tests matching a specific pattern
  --retry <number>        Retry failed tests a specified number of times
  --coverage              Generate a coverage report
  --junit <file>          Output results in JUnit XML format to specified file
  --tap <file>            Output results in TAP format to specified file
  --html <file>           Output results in HTML format to specified file
  --json <file>           Output results in JSON format to specified file
  --summary               Show a summary of test results
  --detailed              Show detailed output for each test
  --list-tests            List all individual tests in the test files
  --list-suites           List all test suites (test files)
  --list-tags             List all tags used in tests
  --tag <tag>             Run tests with a specific tag
  --exclude-tag <tag>     Exclude tests with a specific tag
  --help-test             Show help for test-specific options
  --help-general          Show help for general options
  --version               Show script version
  --update                Update the test runner script to the latest version
  --install-deps          Install required dependencies
  --check-deps            Check if required dependencies are installed
  --dry-run               Show what would be done without executing tests
  --force                 Force execution even if certain checks fail
  --skip                  Skip certain tests or checks
  --only                  Run only specified tests or checks
  --config <file>         Specify a configuration file
  --env <key=value>       Set environment variables for the test run
  --list-env              List all environment variables set for the test run
  --clear-env             Clear all environment variables set for the test run
  --help-all              Show help for all options
EOF
}

#############################################################################
# Function: log_info
# Description: Logs an informational message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stdout.
###############################################################################
# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

#############################################################################
# Function: log_success
# Description: Logs a success message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stdout.
###############################################################################
# Log success messages
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

#############################################################################
# Function: log_error
# Description: Logs an error message.
# Arguments:
#   $1 - The message to log.
# Output: Prints the message to stderr.
###############################################################################
# Log error messages
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

main() {
    if [[ "$#" -gt 0 ]] && [[ "$1" == "--help" ]]; then
        show_help
        exit 0
    fi

    # Check if bats is available
    if ! command -v bats &> /dev/null; then
        log_error "bats is not installed. Please install bats-core first."
        log_info "Visit: https://github.com/bats-core/bats-core"
        log_info "Or install with: git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh ~/.local"
        exit 1
    fi

    log_info "Running all deployment Bats tests..."

    TEST_DIR="$REPO_ROOT/tests/deployment"
    FAILED=0

    for test_file in "$TEST_DIR"/*.bats; do
        log_info "Running $(basename "$test_file")..."
        if bats "$test_file"; then
            log_success "$(basename "$test_file") passed."
        else
            log_error "$(basename "$test_file") failed!"
            FAILED=1
        fi
    done

    if [[ "$FAILED" -eq 0 ]]; then
        log_success "All deployment tests passed!"
        exit 0
    else
        log_error "Some deployment tests failed!"
        exit 1
    fi
}

main "$@"
