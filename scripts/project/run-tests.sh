#!/bin/bash
#
# Test runner for project scripts
# Simple wrapper around bats test execution for project-specific tests
#
# Requirements:
#   - bats-core
#   - bash
#
# Usage: ./run-tests.sh [options]
#
# Options:
#   --help      Show this help message
#   --dry-run   Show what would be done without executing tests
#   --verbose   Show detailed output
#   --quiet     Show minimal output
#
# Examples:
#   ./run-tests.sh           # Run all tests
#   ./run-tests.sh --help    # Show help
#   ./run-tests.sh --dry-run # Show what tests would be run
#

# Set strict mode for safety
set -euo pipefail

# Determine script directory and repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Default options
DRY_RUN=false
VERBOSE=false
QUIET=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    if [[ "$QUIET" != "true" ]]; then
        echo -e "${BLUE}[INFO]${NC} $1"
    fi
}

log_success() {
    if [[ "$QUIET" != "true" ]]; then
        echo -e "${GREEN}[SUCCESS]${NC} $1"
    fi
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warning() {
    if [[ "$QUIET" != "true" ]]; then
        echo -e "${YELLOW}[WARNING]${NC} $1"
    fi
}

# Show help message
show_help() {
    cat << EOF
Usage: $0 [options]

Test runner for project scripts using bats framework.

Options:
  --help      Show this help message
  --dry-run   Show what would be done without executing tests
  --verbose   Show detailed output
  --quiet     Show minimal output

Examples:
  $0           # Run all tests
  $0 --help    # Show help
  $0 --dry-run # Show what tests would be run

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --quiet|-q)
                QUIET=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Main function
main() {
    parse_args "$@"
    
    local test_dir="$REPO_ROOT/tests/project-scripts"
    
    # Check if bats is available (either directly or via npx)
    local bats_cmd=""
    if command -v bats &> /dev/null; then
        bats_cmd="bats"
    elif command -v npx &> /dev/null; then
        bats_cmd="npx bats"
        log_info "Using npx bats (bats not directly available)"
    else
        log_error "bats is not installed and npx is not available. Please install bats-core first."
        log_info "Visit: https://github.com/bats-core/bats-core"
        exit 1
    fi
    
    # Check if test directory exists
    if [[ ! -d "$test_dir" ]]; then
        log_error "Test directory not found: $test_dir"
        exit 1
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY-RUN mode: Would run the following bats tests:"
        for test_file in "$test_dir"/*.bats; do
            if [[ -f "$test_file" ]]; then
                echo "  - $(basename "$test_file")"
            fi
        done
        exit 0
    fi
    
    log_info "Running project script bats tests..."
    
    local failed=0
    local total=0
    
    for test_file in "$test_dir"/*.bats; do
        if [[ -f "$test_file" ]]; then
            ((total++))
            local test_name=$(basename "$test_file")
            
            if [[ "$VERBOSE" == "true" ]]; then
                log_info "Running $test_name..."
            fi
            
            if $bats_cmd "$test_file" ${VERBOSE:+--verbose} ${QUIET:+--quiet}; then
                if [[ "$VERBOSE" == "true" ]]; then
                    log_success "$test_name passed"
                fi
            else
                log_error "$test_name failed"
                ((failed++))
            fi
        fi
    done
    
    # Summary
    if [[ $failed -eq 0 ]]; then
        log_success "All $total project tests passed!"
        exit 0
    else
        log_error "$failed out of $total project tests failed!"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"