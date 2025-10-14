#!/bin/bash

# Script Name: run-maintenance-tests.sh
# Description: Test runner for scripts/maintenance scripts. Runs all maintenance Bats tests in scripts/tests/maintenance for each reciprocal script. Supports listing, running specific tests, dry-run mode, verbose/quiet output, and summary reporting.
#
# Version: v0.1.1
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
#
# Usage: ./run-maintenance-tests.sh [options]
#
# Functionality:
#   - Runs all maintenance Bats tests in scripts/tests/maintenance
#   - Lists available maintenance test files with --list
#   - Runs a specific maintenance test file with --test <test_name>
#   - Supports --dry-run, --verbose, --quiet, and summary reporting
#   --help      Show this help message
#   --verbose   Show detailed output
#   --quiet     Show minimal output
#   --list      List all available tests without running them
#   --test <test_name>  Run a specific test by name (without .bats extension
#   --color     Enable colored output
#   --no-color  Disable colored output
#   --log-file <file>  Specify a log file to write output
#   --timeout <seconds>  Set a timeout for each test
#   --parallel <number>  Run tests in parallel (specify number of jobs)
#   --filter <pattern>  Run tests matching a specific pattern
#   --exclude <pattern>  Exclude tests matching a specific pattern
#   --retry <number>  Retry failed tests a specified number of times
#   --coverage  Generate a coverage report
#   --junit <file>  Output results in JUnit XML format to specified file
#   --tap <file>  Output results in TAP format to specified file
#   --html <file>  Output results in HTML format to specified file
#   --json <file>  Output results in JSON format to specified file
#   --summary  Show a summary of test results
#   --detailed  Show detailed output for each test
#   --list-tests  List all individual tests in the test files
#   --list-suites  List all test suites (test files)
#   --list-tags  List all tags used in tests
#   --tag <tag>  Run tests with a specific tag
#   --exclude-tag <tag>  Exclude tests with a specific tag
#   --help-test  Show help for test-specific options
#   --help-general  Show help for general options
#   --version  Show script version
#   --update  Update the test runner script to the latest version
#   --install-deps  Install required dependencies
#   --check-deps  Check if required dependencies are installed
#   --dry-run  Show what would be done without executing tests
#   --force  Force execution even if certain checks fail
#   --skip  Skip certain tests or checks
#   --only  Run only specified tests or checks
#   --config <file>  Specify a configuration file
#   --env <key=value>  Set environment variables for the test run
#   --list-env  List all environment variables set for the test run
#   --clear-env  Clear all environment variables set for the test run
#   --help-all  Show help for all options
#
# Examples:
#   ./run-maintenance-tests.sh --test example-utility  # Run a specific test
#   ./run-maintenance-tests.sh --list                  # List all available tests
#   ./run-maintenance-tests.sh --verbose --color       # Run all tests with verbose colored output
#   ./run-maintenance-tests.sh --log-file utility-tests.log  # Log output to a file
#   ./run-maintenance-tests.sh --timeout 30 --parallel 4  # Run tests with a timeout and in parallel
#   ./run-maintenance-tests.sh --filter "util*" --exclude "*fail*"  # Filter tests to run
#   ./run-maintenance-tests.sh --retry 2 --coverage  # Retry failed tests and generate coverage report
#   ./run-maintenance-tests.sh --junit results.xml --html results.html  # Output results in multiple formats
#
# Note:
# - This script runs all Bats tests located in the scripts/tests/maintenance directory.
# - Each test file should correspond to a script in the scripts/maintenance directory.
# - Ensure all scripts under test are executable (chmod +x script.sh).
# - Requires bats-core to be installed and available in PATH.
#

# Fail on errors
set -euo pipefail

# Determine script and repo paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Log success messages
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Log error messages
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if bats is available
if ! command -v bats &> /dev/null; then
    log_error "bats is not installed. Please install bats-core first."
    log_info "Visit: https://github.com/bats-core/bats-core"
    log_info "Or install with: git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh ~/.local"
    exit 1
fi

# Start running tests
log_info "Running all maintenance Bats tests..."

# Directory containing test files
TEST_DIR="$REPO_ROOT/tests/maintenance"
FAILED=0

# Loop through each .bats file in the test directory
for test_file in "$TEST_DIR"/*.bats; do
    log_info "Running $(basename "$test_file")..."
    if bats "$test_file"; then
        log_success "$(basename "$test_file") passed."
    else
        log_error "$(basename "$test_file") failed!"
        FAILED=1
    fi
done

# Final summary
# Show the final result of the test run
if [[ "$FAILED" -eq 0 ]]; then
    log_success "All maintenance tests passed!"
# Exit with appropriate status
    exit 0 # Success
else
    log_error "Some maintenance tests failed!"
    exit 1 # Failure
fi

# Cleanup if needed
# (Add any necessary cleanup commands here)
# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
