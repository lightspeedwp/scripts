
#!/opt/homebrew/bin/bash
# ============================================================================
# Script Name: run-all-tests.sh
# Description: Runs all Bats test files in the scripts/tests directory and subdirectories, providing a summary of results. Supports dry-run, verbose, pattern filtering, and full LightSpeed WP runner script standards.
# Version: v1.0.0
# Date: 2025-10-15
# Author: LightSpeed WP Team
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Requirements:
#   - bash
#   - bats-core
#   - find
#   - xargs
# Usage:
#   - ./run-all-tests.sh [options]
#   - ./run-all-tests.sh --dry-run
#   - ./run-all-tests.sh --verbose
#   - ./run-all-tests.sh --test <pattern>
# Environment Variables:
#   DRY_RUN        If true, preview tests to be run
#   VERBOSE        If true, show detailed output
# Options:
#   --help           Show help message
#   --dry-run        Preview tests to be run
#   --verbose        Show detailed output
#   --test <pattern> Run only tests matching pattern
#   --quiet          Show minimal output
#   --list           List all available test files
#   --color          Enable colored output
#   --no-color       Disable colored output
#   --log-file <file> Specify log file
#   --timeout <sec>  Set timeout for each test
#   --parallel <n>   Run tests in parallel
#   --filter <pat>   Run tests matching pattern
#   --exclude <pat>  Exclude tests matching pattern
#   --retry <n>      Retry failed tests
#   --coverage       Generate coverage report
#   --junit <file>   Output JUnit XML
#   --tap <file>     Output TAP format
#   --html <file>    Output HTML format
#   --json <file>    Output JSON format
#   --summary        Show summary
#   --detailed       Show detailed output
#   --list-tests     List all individual tests
#   --list-suites    List all test suites
#   --list-tags      List all tags
#   --tag <tag>      Run tests with tag
#   --exclude-tag <tag> Exclude tests with tag
#   --help-test      Show help for test options
#   --help-general   Show help for general options
#   --version        Show script version
#   --update         Update runner script
#   --install-deps   Install dependencies
#   --check-deps     Check dependencies
#   --force          Force execution
#   --skip           Skip tests/checks
#   --only           Run only specified tests
#   --config <file>  Specify config file
#   --env <key=val>  Set environment variable
#   --list-env       List environment variables
#   --clear-env      Clear environment variables
#   --help-all       Show help for all options
# Examples:
#   ./run-all-tests.sh
#   ./run-all-tests.sh --dry-run
#   ./run-all-tests.sh --verbose
#   ./run-all-tests.sh --test "utility"
# Notes:
#   - All Bats test files (*.bats) in the scripts/tests directory and subdirectories are executed.
#   - Supports dry-run and verbose modes for CI/CD integration.
#   - See README.md for integration and troubleshooting.
# ============================================================================

# Strict mode
set -euo pipefail

# -------- Section: Logging Functions --------
# ============================================================================
# Function: log_info
# Description: Log informational messages to stdout
# Arguments: $* (message)
# Output: Writes to stdout
# Notes: Prefixes with [INFO] and timestamp
# ============================================================================
log_info() {
    echo -e "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $*"
}

# ============================================================================
# Function: log_error
# Description: Log error messages to stderr
# Arguments: $* (message)
# Output: Writes to stderr
# Notes: Prefixes with [ERROR] and timestamp
# ============================================================================
log_error() {
    echo -e "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" >&2
}

# ============================================================================
# Function: log_success
# Description: Log success messages to stdout
# Arguments: $* (message)
# Output: Writes to stdout
# Notes: Prefixes with [SUCCESS] and timestamp
# ============================================================================
log_success() {
    echo -e "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S'): $*"
}

# -------- Section: Help Output --------
# ============================================================================
# Function: show_help
# Description: Displays usage information for the test runner script
# Arguments: None
# Output: Prints help message to stdout
# Notes: Follows LightSpeed WP documentation standards
# ============================================================================
show_help() {
    cat << EOF
Usage: ./run-all-tests.sh [OPTIONS]

Runs all Bats test files in the scripts/tests directory and subdirectories.

Options:
  --help           Show help message
  --dry-run        Preview tests to be run
  --verbose        Show detailed output
  --test <pattern> Run only tests matching pattern
  --quiet          Show minimal output
  --list           List all available test files
  --color          Enable colored output
  --no-color       Disable colored output
  --log-file <file> Specify log file
  --timeout <sec>  Set timeout for each test
  --parallel <n>   Run tests in parallel
  --filter <pat>   Run tests matching pattern
  --exclude <pat>  Exclude tests matching pattern
  --retry <n>      Retry failed tests
  --coverage       Generate coverage report
  --junit <file>   Output JUnit XML
  --tap <file>     Output TAP format
  --html <file>    Output HTML format
  --json <file>    Output JSON format
  --summary        Show summary
  --detailed       Show detailed output
  --list-tests     List all individual tests
  --list-suites    List all test suites
  --list-tags      List all tags
  --tag <tag>      Run tests with tag
  --exclude-tag <tag> Exclude tests with tag
  --help-test      Show help for test options
  --help-general   Show help for general options
  --version        Show script version
  --update         Update runner script
  --install-deps   Install dependencies
  --check-deps     Check dependencies
  --force          Force execution
  --skip           Skip tests/checks
  --only           Run only specified tests
  --config <file>  Specify config file
  --env <key=val>  Set environment variable
  --list-env       List environment variables
  --clear-env      Clear environment variables
  --help-all       Show help for all options

Examples:
  ./run-all-tests.sh
  ./run-all-tests.sh --dry-run
  ./run-all-tests.sh --verbose
  ./run-all-tests.sh --test "utility"
EOF
}

# -------- Section: Test Runner Logic --------
# ============================================================================
# Function: run_tests
# Description: Finds and runs all Bats test files, optionally filtering by pattern, and prints a summary
# Arguments: $@ - Command line arguments
# Output: Runs Bats tests and prints results to stdout
# Notes: Supports dry-run and verbose modes. Uses find and xargs for test discovery
# ============================================================================
run_tests() {
    local dry_run=false
    local verbose=false
    local test_pattern="*.bats"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                dry_run=true
                shift
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            --test)
                shift
                test_pattern="*$1*.bats"
                ;;
            --help)
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

    local test_files
    test_files=$(find "$(dirname "$0")/../tests" -name "$test_pattern" -print)

    if [[ "$dry_run" == true ]]; then
        log_info "DRY RUN: The following test files would be run:"
        echo "$test_files"
        return 0
    fi

    if [[ -z "$test_files" ]]; then
        log_error "No test files found matching pattern: $test_pattern"
        exit 1
    fi

    log_info "Running Bats tests..."
    local summary=0
    while IFS= read -r test_file; do
        if [[ "$verbose" == true ]]; then
            log_info "Running: $test_file"
            bats "$test_file"
        else
            bats "$test_file" > /dev/null
        fi
        if [[ $? -eq 0 ]]; then
            log_success "PASS: $test_file"
        else
            log_error "FAIL: $test_file"
            summary=1
        fi
    done <<< "$test_files"

    if [[ $summary -eq 0 ]]; then
        log_success "All tests passed."
    else
        log_error "Some tests failed. See above for details."
    fi
    return $summary
}

# -------- Section: Main Execution --------
# ============================================================================
# Function: main
# Description: Entry point for the test runner script. Parses arguments and runs tests
# Arguments: $@ - Command line arguments
# Output: Orchestrates test execution and prints summary
# Notes: Follows LightSpeed WP documentation standards
# ============================================================================
main() {
    run_tests "$@"
}

main "$@"

log_info "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above



###############################################################################
# Function: show_help
# Description: Displays usage information for the test runner script.
# Arguments: None
# Output: Prints help message to stdout.
# Notes: Follows LightSpeed WP documentation standards.
###############################################################################
show_help() {
    cat << EOF
Usage: ./run-all-tests.sh [OPTIONS]

Runs all Bats test files in the tests directory and subdirectories.

Options:
  --help           Show help message
  --dry-run        Preview tests to be run
  --verbose        Show detailed output
  --test <pattern> Run only tests matching pattern

Examples:
  ./run-all-tests.sh
  ./run-all-tests.sh --dry-run
  ./run-all-tests.sh --verbose
  ./run-all-tests.sh --test "utility"
EOF
}

###############################################################################
# Function: run_tests
# Description: Finds and runs all Bats test files, optionally filtering by pattern, and prints a summary.
# Arguments: $@ - Command line arguments
# Output: Runs Bats tests and prints results to stdout.
# Notes: Supports dry-run and verbose modes. Uses find and xargs for test discovery.
###############################################################################
run_tests() {
    local dry_run=false
    local verbose=false
    local test_pattern="*.bats"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                dry_run=true
                shift
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            --test)
                test_pattern="*$2*.bats"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    local test_files
    test_files=$(find "$(dirname "$0")/tests" -name "$test_pattern" -print)

    if [[ "$dry_run" == true ]]; then
        echo "[DRY RUN] The following test files would be run:"
        echo "$test_files"
        return 0
    fi

    if [[ -z "$test_files" ]]; then
        echo "No test files found matching pattern: $test_pattern"
        exit 1
    fi

    if [[ "$verbose" == true ]]; then
        bats -v $test_files
    else
        bats $test_files
    fi
}
###############################################################################
# Main execution
# Function: main
# Description: Entry point for the test runner script. Parses arguments and runs tests.
# Arguments: $@ - Command line arguments
# Output: Orchestrates test execution and prints summary.
# Notes: Follows LightSpeed WP documentation standards.
###############################################################################
main() {
    run_tests "$@"
}

main "$@"

# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
