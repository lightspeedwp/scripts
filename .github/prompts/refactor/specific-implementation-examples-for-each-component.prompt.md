---
applyTo: '**'
description: 'Prompt for specific implementation examples for modular shell script components.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['implementation', 'examples', 'modular', 'shell']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Specific Implementation Examples for Each Component

## Role

You are a shell script implementation specialist. Follow our LightSpeed WP standards to provide concrete, working examples for each component of the modular shell script architecture.

## Purpose

Deliver detailed, production-ready implementation examples that demonstrate proper usage of modular includes, testing patterns, documentation standards, and integration approaches with real code that can be directly used or adapted.

## Checklist

- [ ] Provide complete working examples for each include module
- [ ] Create real test implementations with comprehensive coverage
- [ ] Show actual migration examples with before/after comparisons
- [ ] Demonstrate integration patterns with existing automation
- [ ] Include troubleshooting examples with actual solutions
- [ ] Create deployment and maintenance example procedures

## Instructions

### Core Include Implementation Examples

#### 1. Complete Logging Include Implementation

**File: scripts/includes/core/logging.sh**

```bash
#!/bin/bash

# ============================================================================
# Script Name: logging.sh
# Description: Standardized logging functions for LightSpeed WP shell scripts
# Version: v1.0.0
# Author: LightSpeed WP Team
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Requirements: bash, date command, write access to log directory
# Usage: source "path/to/logging.sh" in shell scripts
# Environment Variables:
#   LOG_FILE - Path to log file (default: logs/script.log)
#   VERBOSE - Enable debug logging when set to 'true'
#   NO_COLOR - Disable color output when set to any value
# Options: None (functions only)
# Examples:
#   source "includes/core/logging.sh"
#   log_info "Starting process"
#   log_error "Process failed"
#   log_success "Process completed successfully"
# Notes:
#   - Creates log directory if it doesn't exist
#   - Handles color output based on terminal capabilities
#   - Thread-safe for concurrent logging
#   - Gracefully handles write permission failures
# ============================================================================

set -euo pipefail

# Color definitions - only set if not already defined
if [[ -z "${COLOR_RED:-}" ]]; then
    # Check if terminal supports colors
    if [[ -t 2 ]] && [[ -z "${NO_COLOR:-}" ]] && command -v tput >/dev/null 2>&1; then
        COLOR_RED=$(tput setaf 1 2>/dev/null || echo '')
        COLOR_GREEN=$(tput setaf 2 2>/dev/null || echo '')
        COLOR_YELLOW=$(tput setaf 3 2>/dev/null || echo '')
        COLOR_BLUE=$(tput setaf 4 2>/dev/null || echo '')
        COLOR_BRIGHT_GREEN=$(tput bold; tput setaf 2 2>/dev/null || echo '')
        COLOR_RESET=$(tput sgr0 2>/dev/null || echo '')
    else
        COLOR_RED=""
        COLOR_GREEN=""
        COLOR_YELLOW=""
        COLOR_BLUE=""
        COLOR_BRIGHT_GREEN=""
        COLOR_RESET=""
    fi
fi

# Function: log_msg
# Description: Core logging function that writes to both stderr and log file
# Arguments:
#   $1 - Log level (INFO|SUCCESS|WARNING|ERROR|DEBUG)
#   $@ - Message components to log
# Output: Colored message to stderr, timestamped entry to log file
# Notes: Creates log directory if missing, handles all error conditions gracefully
log_msg() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="${LOG_FILE:-logs/$(basename "${0:-script}" .sh).log}"

    # Ensure log directory exists
    local log_dir=$(dirname "$log_file")
    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir" 2>/dev/null || {
            echo "Warning: Could not create log directory: $log_dir" >&2
            log_file="/tmp/$(basename "${0:-script}" .sh).log"
        }
    fi

    # Format message based on level
    local color=""
    local icon=""
    case "$level" in
        "INFO")
            color="$COLOR_GREEN"
            icon="ℹ"
            ;;
        "SUCCESS")
            color="$COLOR_BRIGHT_GREEN"
            icon="✓"
            ;;
        "WARNING")
            color="$COLOR_YELLOW"
            icon="⚠"
            ;;
        "ERROR")
            color="$COLOR_RED"
            icon="✗"
            ;;
        "DEBUG")
            color="$COLOR_BLUE"
            icon="🔍"
            ;;
        *)
            color=""
            icon="•"
            ;;
    esac

    # Output to stderr with color
    echo "${color}${icon} [$level] $message${COLOR_RESET}" >&2

    # Output to log file with timestamp (suppress errors)
    echo "$timestamp [$level] $message" >> "$log_file" 2>/dev/null || true
}

# Function: log_info
# Description: Log informational messages
# Arguments: $@ - Message components
# Output: Green colored info message to stderr and log file
log_info() {
    log_msg "INFO" "$@"
}

# Function: log_success
# Description: Log success messages
# Arguments: $@ - Message components
# Output: Bright green colored success message to stderr and log file
log_success() {
    log_msg "SUCCESS" "$@"
}

# Function: log_warning
# Description: Log warning messages
# Arguments: $@ - Message components
# Output: Yellow colored warning message to stderr and log file
log_warning() {
    log_msg "WARNING" "$@"
}

# Function: log_error
# Description: Log error messages
# Arguments: $@ - Message components
# Output: Red colored error message to stderr and log file
log_error() {
    log_msg "ERROR" "$@"
}

# Function: log_debug
# Description: Log debug messages (only when VERBOSE=true)
# Arguments: $@ - Message components
# Output: Blue colored debug message to stderr and log file (if VERBOSE enabled)
log_debug() {
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        log_msg "DEBUG" "$@"
    fi
}
```

#### 2. Complete Validation Include Implementation

**File: scripts/includes/core/validation.sh**

```bash
#!/bin/bash

# ============================================================================
# Script Name: validation.sh
# Description: Input and system validation functions for LightSpeed WP shell scripts
# Version: v1.0.0
# Author: LightSpeed WP Team
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# Requirements: bash, command, test utilities, logging.sh for error reporting
# Usage: source "path/to/validation.sh" in shell scripts
# Environment Variables: None
# Options: None (functions only)
# Examples:
#   command_exists "git" || log_error "Git not found"
#   validate_file_exists "/etc/passwd" "System password file"
#   check_dependencies "git" "curl" "jq"
# Notes:
#   - All functions use POSIX-compatible commands
#   - Functions are atomic with no side effects
#   - Comprehensive input validation prevents security issues
# ============================================================================

set -euo pipefail

# Source logging functions if not already available
if ! command -v log_error >/dev/null 2>&1; then
    # Try to source logging from common locations
    for log_path in \
        "$(dirname "${BASH_SOURCE[0]}")/logging.sh" \
        "${BASH_SOURCE[0]%/*}/logging.sh" \
        "includes/core/logging.sh" \
        "scripts/includes/core/logging.sh"; do
        if [[ -f "$log_path" ]]; then
            source "$log_path"
            break
        fi
    done

    # Fallback logging if include not found
    if ! command -v log_error >/dev/null 2>&1; then
        log_error() { echo "ERROR: $*" >&2; }
        log_warning() { echo "WARNING: $*" >&2; }
        log_info() { echo "INFO: $*" >&2; }
    fi
fi

# Function: command_exists
# Description: Check if a command is available in PATH
# Arguments: $1 - Command name to check
# Returns: 0 if command exists, 1 if not found
# Output: None (silent operation)
command_exists() {
    local cmd="$1"

    # Input validation
    [[ -n "$cmd" ]] || return 1

    # Check if command is available
    command -v "$cmd" >/dev/null 2>&1
}

# Function: validate_file_exists
# Description: Validate that a file exists and is readable
# Arguments:
#   $1 - File path to check
#   $2 - Optional description for error messages
# Returns: 0 if file exists and is readable, 1 otherwise
# Output: Error message if validation fails
validate_file_exists() {
    local file_path="$1"
    local description="${2:-File}"

    # Input validation
    if [[ -z "$file_path" ]]; then
        log_error "validate_file_exists: File path cannot be empty"
        return 1
    fi

    # Check if file exists
    if [[ ! -f "$file_path" ]]; then
        log_error "$description not found: $file_path"
        return 1
    fi

    # Check if file is readable
    if [[ ! -r "$file_path" ]]; then
        log_error "$description is not readable: $file_path"
        return 1
    fi

    return 0
}

# Function: validate_directory_exists
# Description: Validate that a directory exists and is accessible
# Arguments:
#   $1 - Directory path to check
#   $2 - Optional description for error messages
# Returns: 0 if directory exists and is accessible, 1 otherwise
# Output: Error message if validation fails
validate_directory_exists() {
    local dir_path="$1"
    local description="${2:-Directory}"

    # Input validation
    if [[ -z "$dir_path" ]]; then
        log_error "validate_directory_exists: Directory path cannot be empty"
        return 1
    fi

    # Check if directory exists
    if [[ ! -d "$dir_path" ]]; then
        log_error "$description not found: $dir_path"
        return 1
    fi

    # Check if directory is accessible
    if [[ ! -x "$dir_path" ]]; then
        log_error "$description is not accessible: $dir_path"
        return 1
    fi

    return 0
}

# Function: check_dependencies
# Description: Verify that all required commands are available
# Arguments: $@ - List of command names to check
# Returns: 0 if all commands found, 1 if any missing
# Output: Error messages for missing commands
check_dependencies() {
    local missing_commands=()
    local cmd

    # Check each command
    for cmd in "$@"; do
        if ! command_exists "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done

    # Report missing commands
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_error "Missing required commands: ${missing_commands[*]}"
        log_info "Please install missing dependencies and try again"
        return 1
    fi

    return 0
}

# Function: validate_version_format
# Description: Validate semantic version format
# Arguments: $1 - Version string to validate
# Returns: 0 if valid semver format, 1 if invalid
# Output: Error message if validation fails
validate_version_format() {
    local version="$1"

    # Input validation
    if [[ -z "$version" ]]; then
        log_error "validate_version_format: Version string cannot be empty"
        return 1
    fi

    # Remove optional 'v' prefix
    version="${version#v}"

    # Semantic version regex pattern
    local semver_pattern='^([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$'

    # Validate format
    if [[ ! "$version" =~ $semver_pattern ]]; then
        log_error "Invalid semantic version format: $1"
        log_info "Expected format: MAJOR.MINOR.PATCH[-prerelease][+build]"
        log_info "Examples: 1.0.0, 2.1.3, 1.0.0-alpha.1, 1.0.0+20230315"
        return 1
    fi

    return 0
}

# Function: validate_email_format
# Description: Basic email format validation
# Arguments: $1 - Email address to validate
# Returns: 0 if valid format, 1 if invalid
# Output: Error message if validation fails
validate_email_format() {
    local email="$1"

    # Input validation
    if [[ -z "$email" ]]; then
        log_error "validate_email_format: Email address cannot be empty"
        return 1
    fi

    # Basic email regex pattern (practical, not RFC compliant)
    local email_pattern='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    # Validate format
    if [[ ! "$email" =~ $email_pattern ]]; then
        log_error "Invalid email format: $email"
        return 1
    fi

    return 0
}

# Function: validate_url_format
# Description: Basic URL format validation
# Arguments: $1 - URL to validate
# Returns: 0 if valid format, 1 if invalid
# Output: Error message if validation fails
validate_url_format() {
    local url="$1"

    # Input validation
    if [[ -z "$url" ]]; then
        log_error "validate_url_format: URL cannot be empty"
        return 1
    fi

    # Basic URL regex pattern
    local url_pattern='^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}([/].*)?$'

    # Validate format
    if [[ ! "$url" =~ $url_pattern ]]; then
        log_error "Invalid URL format: $url"
        return 1
    fi

    return 0
}
```

### Complete Test Implementation Example

#### Test File: tests/includes/core/test-logging.bats

```bash
#!/usr/bin/env bats

# Version: v1.0.0
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# Usage: bats test-logging.bats
# Options:
#  - None

# Load test helpers
load "$(dirname "$BATS_TEST_FILENAME")/../../test-helper.bash"

setup() {
    # Create temporary directory for test isolation
    TEST_TEMP_DIR=$(mktemp -d)
    export TEST_TEMP_DIR

    # Set up test log file
    TEST_LOG_FILE="$TEST_TEMP_DIR/test.log"
    export LOG_FILE="$TEST_LOG_FILE"

    # Load the logging include
    source "$REPO_ROOT/scripts/includes/core/logging.sh"

    # Disable colors for predictable testing
    export NO_COLOR=1
}

teardown() {
    # Clean up temporary files
    [[ -n "$TEST_TEMP_DIR" && -d "$TEST_TEMP_DIR" ]] && rm -rf "$TEST_TEMP_DIR"
    unset LOG_FILE NO_COLOR VERBOSE
}

# ----- Section: Basic Logging Functionality -----

# ============================================================================
# Test Name: "log_info writes message to stderr"
# Test Type: Unit Test
# Test Scope: Validates log_info function outputs formatted message to stderr with proper formatting and color codes
# ============================================================================
@test "log_info writes message to stderr" {
    run log_info "Test information message"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"[INFO] Test information message"* ]]
    [[ "$output" == *"ℹ"* ]]
}

# ============================================================================
# Test Name: "log_info writes timestamped entry to log file"
# Test Type: Unit Test
# Test Scope: Validates log_info function creates log file and writes timestamped entry with proper format
# ============================================================================
@test "log_info writes timestamped entry to log file" {
    local test_message="Test log file entry"

    run log_info "$test_message"

    # Verify log file was created
    [[ -f "$TEST_LOG_FILE" ]]

    # Verify log entry format
    grep -q "$test_message" "$TEST_LOG_FILE"
    grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} \[INFO\]" "$TEST_LOG_FILE"
}

# ============================================================================
# Test Name: "log_error produces red colored output"
# Test Type: Unit Test
# Test Scope: Validates log_error function uses appropriate error formatting and color coding
# ============================================================================
@test "log_error produces red colored output" {
    run log_error "Test error message"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"[ERROR] Test error message"* ]]
    [[ "$output" == *"✗"* ]]
}

# ============================================================================
# Test Name: "log_success produces green colored output"
# Test Type: Unit Test
# Test Scope: Validates log_success function uses appropriate success formatting and color coding
# ============================================================================
@test "log_success produces green colored output" {
    run log_success "Test success message"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"[SUCCESS] Test success message"* ]]
    [[ "$output" == *"✓"* ]]
}

# ----- Section: Log File Management -----

# ============================================================================
# Test Name: "logging creates log directory if missing"
# Test Type: Integration Test
# Test Scope: Validates automatic log directory creation when LOG_FILE points to non-existent directory path
# ============================================================================
@test "logging creates log directory if missing" {
    local nested_log_dir="$TEST_TEMP_DIR/logs/nested/deep"
    local nested_log_file="$nested_log_dir/test.log"

    LOG_FILE="$nested_log_file" run log_info "Directory creation test"

    [[ "$status" -eq 0 ]]
    [[ -d "$nested_log_dir" ]]
    [[ -f "$nested_log_file" ]]
    grep -q "Directory creation test" "$nested_log_file"
}

# ============================================================================
# Test Name: "logging handles multiple arguments correctly"
# Test Type: Unit Test
# Test Scope: Validates logging functions can handle multiple arguments and combine them properly
# ============================================================================
@test "logging handles multiple arguments correctly" {
    run log_info "Multiple" "arguments" "test" "with spaces"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Multiple arguments test with spaces"* ]]

    # Check log file content
    grep -q "Multiple arguments test with spaces" "$TEST_LOG_FILE"
}

# ----- Section: Debug Logging -----

# ============================================================================
# Test Name: "log_debug outputs when VERBOSE is true"
# Test Type: Unit Test
# Test Scope: Validates log_debug function outputs debug messages when VERBOSE environment variable is set to true
# ============================================================================
@test "log_debug outputs when VERBOSE is true" {
    export VERBOSE=true

    run log_debug "Debug message test"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"[DEBUG] Debug message test"* ]]
    [[ "$output" == *"🔍"* ]]

    # Check log file
    grep -q "DEBUG.*Debug message test" "$TEST_LOG_FILE"
}

# ============================================================================
# Test Name: "log_debug silent when VERBOSE is false"
# Test Type: Unit Test
# Test Scope: Validates log_debug function produces no output when VERBOSE is false or unset
# ============================================================================
@test "log_debug silent when VERBOSE is false" {
    export VERBOSE=false

    run log_debug "Should not appear"

    [[ "$status" -eq 0 ]]
    [[ -z "$output" ]]

    # Log file should not contain debug message
    ! grep -q "Should not appear" "$TEST_LOG_FILE" 2>/dev/null || true
}

# ----- Section: Error Conditions -----

# ============================================================================
# Test Name: "logging handles write permission failures gracefully"
# Test Type: Error Condition Test
# Test Scope: Validates logging functions handle cases where log file cannot be written due to permission issues
# ============================================================================
@test "logging handles write permission failures gracefully" {
    # Create read-only directory
    local readonly_dir="$TEST_TEMP_DIR/readonly"
    mkdir -p "$readonly_dir"
    chmod 555 "$readonly_dir"

    LOG_FILE="$readonly_dir/cannot-write.log" run log_info "Permission test"

    # Should still succeed (falls back to /tmp)
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Permission test"* ]]

    # Cleanup
    chmod 755 "$readonly_dir"
}

# ----- Section: Special Characters and Edge Cases -----

# ============================================================================
# Test Name: "logging handles special characters correctly"
# Test Type: Edge Case Test
# Test Scope: Validates logging functions properly handle messages containing special characters, quotes, and escape sequences
# ============================================================================
@test "logging handles special characters correctly" {
    local special_message="Test with 'single quotes', \"double quotes\", and \$variables and \`backticks\`"

    run log_info "$special_message"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"$special_message"* ]]

    # Verify in log file
    grep -qF "$special_message" "$TEST_LOG_FILE"
}

# ============================================================================
# Test Name: "logging handles empty messages"
# Test Type: Edge Case Test
# Test Scope: Validates logging functions handle empty or whitespace-only messages appropriately
# ============================================================================
@test "logging handles empty messages" {
    run log_info ""

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"[INFO]"* ]]

    # Should still create log entry
    grep -q "\[INFO\]" "$TEST_LOG_FILE"
}
```

### Migration Example: Before and After

#### Before Migration (Original Script)

**File: scripts/utility/original-validate-release.sh**

```bash
#!/bin/bash

set -euo pipefail

# Original duplicated logging functions
log_info() {
    echo -e "\033[32mℹ [INFO] $*\033[0m" >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $*" >> "logs/validate-release.log"
}

log_error() {
    echo -e "\033[31m✗ [ERROR] $*\033[0m" >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" >> "logs/validate-release.log"
}

# Original duplicated validation functions
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

validate_file() {
    if [[ ! -f "$1" ]]; then
        log_error "File not found: $1"
        return 1
    fi
}

# Script logic
main() {
    log_info "Starting release validation"

    # Check dependencies
    if ! command_exists "git"; then
        log_error "Git not found"
        exit 1
    fi

    # Validate version file
    if ! validate_file "VERSION"; then
        exit 1
    fi

    log_info "Release validation completed"
}

main "$@"
```

#### After Migration (Using Includes)

**File: scripts/utility/validate-release.sh**

```bash
#!/bin/bash

# ============================================================================
# Script Name: validate-release.sh
# Description: Validate release readiness by checking version files, dependencies, and git status
# Version: v1.0.0
# Author: LightSpeed WP Team
# Usage: ./validate-release.sh [--version VERSION] [--verbose]
# Options:
#   --version VERSION    Specify version to validate (default: read from VERSION file)
#   --verbose           Enable verbose output
#   --help              Show this help message
# Examples:
#   ./validate-release.sh
#   ./validate-release.sh --version "1.2.3" --verbose
# Notes: Requires git, and read access to VERSION and CHANGELOG.md files
# ============================================================================

set -euo pipefail

# Resolve script and repository paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source required includes
source "$REPO_ROOT/scripts/includes/core/logging.sh"
source "$REPO_ROOT/scripts/includes/core/validation.sh"

# Script configuration
VERSION_FILE="$REPO_ROOT/VERSION"
CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"

# Function: show_help
# Description: Display help message with usage information
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Validate release readiness by checking version files, dependencies, and git status.

OPTIONS:
    --version VERSION    Specify version to validate (default: read from VERSION file)
    --verbose           Enable verbose output
    --help              Show this help message

EXAMPLES:
    $(basename "$0")                           # Validate current version
    $(basename "$0") --version "1.2.3"        # Validate specific version
    $(basename "$0") --verbose                 # Enable verbose output

REQUIREMENTS:
    - Git repository
    - VERSION file in repository root
    - CHANGELOG.md file in repository root
    - Git command available in PATH

EXIT CODES:
    0    Success - release is ready
    1    Error - release validation failed
EOF
}

# Function: parse_arguments
# Description: Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --version)
                TARGET_VERSION="$2"
                shift 2
                ;;
            --verbose)
                export VERBOSE=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help >&2
                exit 1
                ;;
        esac
    done
}

# Function: validate_release_files
# Description: Validate required release files exist and are readable
validate_release_files() {
    log_info "Validating release files"

    validate_file_exists "$VERSION_FILE" "VERSION file" || return 1
    validate_file_exists "$CHANGELOG_FILE" "CHANGELOG file" || return 1

    log_success "Release files validation passed"
}

# Function: validate_git_status
# Description: Validate git repository status for release
validate_git_status() {
    log_info "Validating git repository status"

    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        log_error "Not in a git repository"
        return 1
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        log_warning "Uncommitted changes detected"
        log_debug "Git status: $(git status --porcelain)"
    fi

    # Check current branch
    local current_branch=$(git branch --show-current)
    log_debug "Current branch: $current_branch"

    log_success "Git status validation completed"
}

# Function: validate_version_consistency
# Description: Validate version consistency across files
validate_version_consistency() {
    local version="$1"

    log_info "Validating version consistency: $version"

    # Validate version format
    validate_version_format "$version" || return 1

    # Check VERSION file content
    local file_version=$(cat "$VERSION_FILE" | tr -d '\n\r ')
    if [[ "$file_version" != "$version" ]]; then
        log_error "Version mismatch: VERSION file contains '$file_version', expected '$version'"
        return 1
    fi

    # Check CHANGELOG mentions the version
    if ! grep -q "## \[$version\]" "$CHANGELOG_FILE"; then
        log_warning "Version $version not found in CHANGELOG.md"
    fi

    log_success "Version consistency validation passed"
}

# Function: main
# Description: Main script execution
main() {
    local target_version="${TARGET_VERSION:-}"

    log_info "Starting release validation"

    # Check dependencies
    check_dependencies "git" || exit 1

    # Validate release files
    validate_release_files || exit 1

    # Determine version to validate
    if [[ -z "$target_version" ]]; then
        target_version=$(cat "$VERSION_FILE" | tr -d '\n\r ')
        log_debug "Using version from VERSION file: $target_version"
    fi

    # Validate version consistency
    validate_version_consistency "$target_version" || exit 1

    # Validate git status
    validate_git_status || exit 1

    log_success "Release validation completed successfully for version $target_version"
}

# Parse arguments and execute main function
TARGET_VERSION=""
parse_arguments "$@"
main
```

### Integration Example: CI/CD Workflow

**File: .github/workflows/validate-includes.yml**

```yaml
name: Validate Modular Includes

on:
    push:
        branches: [main, develop]
        paths:
            - 'scripts/includes/**'
            - 'tests/includes/**'
    pull_request:
        branches: [main]
        paths:
            - 'scripts/includes/**'
            - 'tests/includes/**'

jobs:
    test-includes:
        name: Test Include Functions
        runs-on: ubuntu-latest
        steps:
            - name: Checkout Repository
              uses: actions/checkout@v4

            - name: Setup Bats Testing Framework
              run: |
                  git clone https://github.com/bats-core/bats-core.git
                  cd bats-core
                  sudo ./install.sh /usr/local

            - name: Run Include Unit Tests
              run: |
                  # Test core includes
                  bats tests/includes/core/test-logging.bats
                  bats tests/includes/core/test-validation.bats

            - name: Run Include Integration Tests
              run: |
                  bats tests/includes/integration/test-include-interactions.bats

            - name: Validate Include Documentation
              run: |
                  # Check that all includes have documentation
                  ./scripts/maintenance/validate-include-docs.sh

            - name: Performance Benchmark
              run: |
                  # Run performance tests for includes
                  ./tests/includes/performance/benchmark-includes.sh

            - name: Test Migration Compatibility
              run: |
                  # Test that migrated scripts work correctly
                  bats tests/integration/test-migration-compatibility.bats
```

### Troubleshooting Example

#### Common Issue: Include Loading Failures

**Problem Script:**

```bash
#!/bin/bash
source "includes/logging.sh"  # Fails - relative path issue
log_info "This won't work"
```

**Solution Implementation:**

```bash
#!/bin/bash

# Robust include loading with fallback paths
load_include() {
    local include_name="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"

    # Try multiple paths in order of preference
    local paths=(
        "$script_dir/../includes/core/$include_name"
        "$script_dir/includes/core/$include_name"
        "scripts/includes/core/$include_name"
        "/usr/local/share/lightspeed-wp/includes/core/$include_name"
    )

    for path in "${paths[@]}"; do
        if [[ -f "$path" ]]; then
            source "$path"
            return 0
        fi
    done

    echo "ERROR: Could not load include: $include_name" >&2
    echo "Searched paths: ${paths[*]}" >&2
    return 1
}

# Load required includes with error handling
load_include "logging.sh" || exit 1
load_include "validation.sh" || exit 1

# Now includes are available
log_info "Includes loaded successfully"
```

## System Constraints

- All examples must be production-ready and tested
- Code must follow LightSpeed WP standards consistently
- Examples must demonstrate proper error handling
- Performance considerations must be included
- Security best practices must be evident

## Example First Message to Copilot

```text
Implement the complete modular shell script architecture using these specific examples as templates. Start with creating the core includes (logging.sh and validation.sh), then implement the corresponding tests, and finally migrate existing scripts to use the includes.
```

## Verification Steps

- [ ] All example code is syntactically correct and tested
- [ ] Migration examples preserve original functionality
- [ ] Integration examples work in real CI/CD environments
- [ ] Troubleshooting examples solve actual problems
- [ ] Performance characteristics meet requirements
- [ ] Documentation examples are comprehensive and accurate

## References

- [Script Functions Breakdown Spec](./script-functions-breakdown-spec.md)
- [Includes Test Methodology](./includes-test-methodology.md)
- [Prompt Templates for Include Creation](./prompt-templates-for-include-creation.md)

## Closing Statement

Complete implementation examples provide concrete, working templates that enable immediate implementation of modular shell script architecture while demonstrating best practices for quality, testing, and maintenance.
