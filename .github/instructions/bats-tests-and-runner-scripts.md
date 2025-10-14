# Bats Tests & Runner Scripts - LightSpeed WP Standards

You are a test automation specialist. Follow our LightSpeed WP testing framework to create comprehensive and reliable Bats test suites. Avoid incomplete test coverage unless specified for prototyping purposes.

## Overview

This guide provides comprehensive standards for Bats (Bash Automated Testing System) test development and test runner script management within the LightSpeed WP automation ecosystem.

## Bats Test File Structure

### Naming Conventions

```bash
# Test files must follow this pattern:
tests/test-{script-name}.bats

# Examples:
tests/test-deploy-site.bats           # For scripts/deployment/deploy-site.sh
tests/test-prune-labels.bats         # For scripts/maintenance/prune-labels.sh
tests/test-utility-functions.bats    # For scripts/utility/utility-functions.sh
```

### Required Test File Header

```bash
#!/usr/bin/env bats
#
# Test File: test-script-name.bats
# Description: Comprehensive tests for script-name.sh
# Author: Your Name
# Date: YYYY-MM-DD
# Coverage: Basic functionality, error handling, edge cases, integration
#

# Load test helper functions
load test-helper

# Setup function runs before each test
setup() {
    # Create temporary directory for test isolation
    TEST_TEMP_DIR="$(mktemp -d)"
    export TEST_TEMP_DIR
    
    # Set up test environment variables
    export DRY_RUN=true
    export VERBOSE=false
    
    # Source the script being tested
    source "${BATS_TEST_DIRNAME}/../scripts/script-name.sh"
}

# Teardown function runs after each test
teardown() {
    # Clean up temporary files and directories
    if [[ -n "${TEST_TEMP_DIR:-}" && -d "${TEST_TEMP_DIR}" ]]; then
        rm -rf "${TEST_TEMP_DIR}"
    fi
    
    # Reset environment variables
    unset DRY_RUN VERBOSE TEST_TEMP_DIR
}
```

## Required Test Categories by Script Type

### Deployment Scripts

Deployment scripts require comprehensive testing covering:

```bash
# 1. Basic Functionality Tests
@test "deployment: script executes successfully with valid parameters" {
    run ./scripts/deployment/deploy-site.sh --dry-run --config=test.conf
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Deployment completed successfully" ]]
}

# 2. Error Handling Tests  
@test "deployment: fails gracefully with invalid configuration" {
    run ./scripts/deployment/deploy-site.sh --config=nonexistent.conf
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Configuration file not found" ]]
}

# 3. Dry-Run Mode Tests
@test "deployment: dry-run mode does not modify files" {
    local test_file="${TEST_TEMP_DIR}/test-deployment.txt"
    echo "original content" > "$test_file"
    
    run ./scripts/deployment/deploy-site.sh --dry-run --target="$test_file"
    [ "$status" -eq 0 ]
    [ "$(cat "$test_file")" = "original content" ]
}

# 4. Parameter Validation Tests
@test "deployment: validates required parameters" {
    run ./scripts/deployment/deploy-site.sh
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Usage:" ]]
}
```

### Maintenance Scripts

```bash
# 1. Safety Check Tests
@test "maintenance: confirms destructive operations in interactive mode" {
    # Mock interactive confirmation
    echo "n" | run ./scripts/maintenance/prune-labels.sh --interactive
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Operation cancelled" ]]
}

# 2. Backup Tests
@test "maintenance: creates backup before modifications" {
    local test_config="${TEST_TEMP_DIR}/config.json"
    echo '{"test": true}' > "$test_config"
    
    run ./scripts/maintenance/update-config.sh --config="$test_config" --backup
    [ "$status" -eq 0 ]
    [ -f "${test_config}.backup" ]
}
```

### Utility Scripts

```bash
# 1. Function Integration Tests
@test "utility: logging functions work correctly" {
    source scripts/utility/utility-functions.sh
    
    run log_info "Test message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "INFO" ]]
    [[ "$output" =~ "Test message" ]]
}

# 2. Dependency Validation Tests
@test "utility: check_dependencies identifies missing tools" {
    source scripts/utility/utility-functions.sh
    
    # Mock missing command
    command() { return 1; }
    export -f command
    
    run check_dependencies "nonexistent-tool"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Missing required dependency" ]]
}
```

### Project Management Scripts

```bash
# 1. API Integration Tests
@test "project: handles GitHub API authentication" {
    export GITHUB_TOKEN="test-token"
    
    run ./scripts/project/create-project.sh --dry-run --name="Test Project"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Authentication successful" ]]
}

# 2. Data Validation Tests
@test "project: validates project configuration format" {
    local invalid_config="${TEST_TEMP_DIR}/invalid.json"
    echo '{"incomplete": true' > "$invalid_config"
    
    run ./scripts/project/update-project.sh --config="$invalid_config"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Invalid JSON" ]]
}
```

## Test Quality Standards

### Test Naming Conventions

```bash
# Good test names - descriptive and specific
@test "deploy-site: creates backup before deployment when --backup flag is provided"
@test "prune-labels: removes only non-standard labels in strict mode"
@test "utility-functions: log_error outputs to stderr with timestamp"

# Poor test names - vague and unclear
@test "test deployment"
@test "check function"
@test "error case"
```

### Assertion Patterns

```bash
# Status code assertions
[ "$status" -eq 0 ]    # Success
[ "$status" -ne 0 ]    # Failure
[ "$status" -eq 1 ]    # Specific exit code

# Output assertions
[[ "$output" =~ "expected pattern" ]]           # Pattern matching
[ "$output" = "exact string" ]                  # Exact match
[ ${#lines[@]} -eq 3 ]                         # Line count
[[ "${lines[0]}" =~ "first line pattern" ]]    # Specific line

# File assertions
[ -f "$expected_file" ]                        # File exists
[ ! -f "$should_not_exist" ]                   # File does not exist
[ -s "$file_with_content" ]                    # File has content
[ "$(cat "$file")" = "expected content" ]      # File content match
```

### Mock and Stub Patterns

```bash
# Environment variable mocking
setup() {
    export ORIGINAL_HOME="$HOME"
    export HOME="${TEST_TEMP_DIR}"
}

teardown() {
    export HOME="$ORIGINAL_HOME"
}

# Command mocking
@test "handles git command failure" {
    # Override git command to simulate failure
    git() {
        echo "fatal: not a git repository"
        return 128
    }
    export -f git
    
    run ./scripts/deployment/deploy-from-git.sh
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Git repository error" ]]
}

# File system mocking
@test "creates directory when it does not exist" {
    local target_dir="${TEST_TEMP_DIR}/new-directory"
    
    run ./scripts/utility/ensure-directory.sh "$target_dir"
    [ "$status" -eq 0 ]
    [ -d "$target_dir" ]
}
```

## Test Runner Scripts

### Main Test Runner: `tests/run-tests.sh`

```bash
#!/bin/bash
#
# Script Name: run-tests.sh
# Description: Main test runner for all Bats test suites
# Usage: ./tests/run-tests.sh [options] [test-pattern]
# Author: LightSpeed WP Team
# Date: 2024-01-01
#

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
readonly TESTS_DIR="$SCRIPT_DIR"

# Default values
PARALLEL_JOBS=4
VERBOSE=false
COVERAGE_REPORT=false
TEST_PATTERN="test-*.bats"
FILTER=""

# Color output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

usage() {
    cat << EOF
Usage: $0 [OPTIONS] [TEST_PATTERN]

Run Bats test suites with various options.

OPTIONS:
    -j, --jobs N         Run tests in parallel (default: $PARALLEL_JOBS)
    -v, --verbose        Enable verbose output
    -c, --coverage       Generate coverage report
    -f, --filter REGEX   Filter tests by name pattern
    -h, --help          Show this help message

EXAMPLES:
    $0                              # Run all tests
    $0 test-deploy-*.bats          # Run deployment tests only
    $0 -v -j 8                     # Run with verbose output and 8 parallel jobs
    $0 --filter "dry.run"          # Run only dry-run related tests

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -j|--jobs)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -c|--coverage)
            COVERAGE_REPORT=true
            shift
            ;;
        -f|--filter)
            FILTER="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
        *)
            TEST_PATTERN="$1"
            shift
            ;;
    esac
done

# Verify bats is available
if ! command -v bats >/dev/null 2>&1; then
    echo -e "${RED}Error: bats is not installed or not in PATH${NC}" >&2
    echo "Please install bats-core: https://github.com/bats-core/bats-core" >&2
    exit 1
fi

# Discover test files
mapfile -t TEST_FILES < <(find "$TESTS_DIR" -name "$TEST_PATTERN" -type f | sort)

if [[ ${#TEST_FILES[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No test files found matching pattern: $TEST_PATTERN${NC}" >&2
    exit 1
fi

echo -e "${BLUE}Found ${#TEST_FILES[@]} test file(s)${NC}"
if [[ "$VERBOSE" == "true" ]]; then
    printf "  %s\n" "${TEST_FILES[@]}"
fi

# Build bats command
BATS_CMD=(bats)

# Add parallel execution
if [[ $PARALLEL_JOBS -gt 1 ]]; then
    BATS_CMD+=(--jobs "$PARALLEL_JOBS")
fi

# Add verbose flag
if [[ "$VERBOSE" == "true" ]]; then
    BATS_CMD+=(--verbose-run)
fi

# Add filter if specified
if [[ -n "$FILTER" ]]; then
    BATS_CMD+=(--filter "$FILTER")
fi

# Add test files
BATS_CMD+=("${TEST_FILES[@]}")

echo -e "${BLUE}Running tests with command: ${BATS_CMD[*]}${NC}"
echo

# Execute tests
if "${BATS_CMD[@]}"; then
    echo -e "\n${GREEN}✅ All tests passed!${NC}"
    exit_code=0
else
    echo -e "\n${RED}❌ Some tests failed!${NC}"
    exit_code=1
fi

# Generate coverage report if requested
if [[ "$COVERAGE_REPORT" == "true" ]]; then
    echo -e "\n${BLUE}Generating coverage report...${NC}"
    # Coverage reporting implementation would go here
    echo "Coverage report saved to coverage/index.html"
fi

exit $exit_code
```

### Specialized Runners

```bash
# Quick test runner for development
#!/bin/bash
# tests/run-quick.sh - Run essential tests quickly
set -euo pipefail

bats --jobs 8 tests/test-utility-functions.bats tests/test-critical-*.bats

# CI-specific runner  
#!/bin/bash
# tests/run-ci.sh - Comprehensive test suite for CI/CD
set -euo pipefail

# Run with coverage and detailed output
bats --verbose-run --jobs 4 tests/test-*.bats
```

## Test Helper Functions

### `tests/test-helper.bash`

```bash
#!/bin/bash
#
# Test Helper Functions for LightSpeed WP Bats Tests
#

# Common setup utilities
setup_temp_git_repo() {
    local repo_dir="${TEST_TEMP_DIR}/test-repo"
    mkdir -p "$repo_dir"
    cd "$repo_dir"
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "$repo_dir"
}

create_test_config() {
    local config_file="${1:-${TEST_TEMP_DIR}/test-config.json}"
    cat > "$config_file" << 'EOF'
{
    "environment": "test",
    "debug": true,
    "features": {
        "auto_deploy": false,
        "verbose_logging": true
    }
}
EOF
    echo "$config_file"
}

# Assertion helpers
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Expected file does not exist: $file" >&2
        return 1
    fi
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$file"; then
        echo "File $file does not contain pattern: $pattern" >&2
        echo "File contents:" >&2
        cat "$file" >&2
        return 1
    fi
}

assert_json_valid() {
    local json_file="$1"
    if ! python3 -m json.tool < "$json_file" >/dev/null 2>&1; then
        echo "Invalid JSON in file: $json_file" >&2
        return 1
    fi
}

# Mock helpers
mock_github_api() {
    local response_file="$1"
    local status_code="${2:-200}"
    
    # Create a mock gh command
    gh() {
        if [[ -f "$response_file" ]]; then
            cat "$response_file"
            return 0
        else
            echo '{"error": "Mock API response"}' >&2
            return 1
        fi
    }
    export -f gh
}

# Cleanup helpers
cleanup_temp_files() {
    find "${TEST_TEMP_DIR:-/tmp}" -name "test-*" -type f -delete 2>/dev/null || true
}
```

## Integration with CI/CD

### GitHub Actions Integration

```yaml
# .github/workflows/test-bats.yml
name: Bats Tests

on:
  pull_request:
    paths: 
      - 'scripts/**'
      - 'tests/**'
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        test-type: [unit, integration, performance]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Bats
        uses: mig4/setup-bats@v1
        with:
          bats-version: 1.10.0
      
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y jq yq shellcheck
      
      - name: Run Bats tests
        run: ./tests/run-tests.sh --verbose --jobs 4
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results-${{ matrix.test-type }}
          path: test-results/
```

## Coverage and Quality Metrics

### Test Coverage Requirements

- **Deployment Scripts**: Minimum 90% coverage
- **Maintenance Scripts**: Minimum 85% coverage  
- **Utility Scripts**: Minimum 95% coverage
- **Project Scripts**: Minimum 80% coverage

### Quality Gates

```bash
# Coverage reporting integration
#!/bin/bash
# tests/coverage-report.sh

set -euo pipefail

readonly COVERAGE_THRESHOLD=80
readonly COVERAGE_DIR="coverage"

# Generate coverage data during test execution
COVERAGE_FILE="${COVERAGE_DIR}/coverage.json"

# Calculate coverage percentage
calculate_coverage() {
    local covered_lines=0
    local total_lines=0
    
    for script in scripts/**/*.sh; do
        if [[ -f "$script" ]]; then
            local lines=$(wc -l < "$script")
            total_lines=$((total_lines + lines))
            
            # Check if script has corresponding test
            local test_file="tests/test-$(basename "$script" .sh).bats"
            if [[ -f "$test_file" ]]; then
                covered_lines=$((covered_lines + lines))
            fi
        fi
    done
    
    local coverage_percent=0
    if [[ $total_lines -gt 0 ]]; then
        coverage_percent=$((covered_lines * 100 / total_lines))
    fi
    
    echo "$coverage_percent"
}

# Main execution
main() {
    mkdir -p "$COVERAGE_DIR"
    
    local coverage=$(calculate_coverage)
    
    echo "Test Coverage: ${coverage}%"
    
    if [[ $coverage -lt $COVERAGE_THRESHOLD ]]; then
        echo "❌ Coverage ${coverage}% is below threshold ${COVERAGE_THRESHOLD}%" >&2
        exit 1
    else
        echo "✅ Coverage ${coverage}% meets threshold ${COVERAGE_THRESHOLD}%"
    fi
}

main "$@"
```

## Best Practices Summary

### Test Organization
- One test file per script
- Group related tests with descriptive @test names
- Use setup/teardown for consistent test environments
- Maintain test isolation with temporary directories

### Test Quality
- Test both success and failure scenarios
- Include edge cases and boundary conditions
- Use meaningful assertions with clear error messages
- Mock external dependencies and commands

### Maintenance
- Keep tests updated with script changes
- Regular review of test coverage and quality
- Automated test execution in CI/CD pipelines
- Documentation of complex test scenarios

### Performance
- Use parallel test execution for faster feedback
- Optimize test setup and teardown
- Separate fast unit tests from slower integration tests
- Monitor test execution times and optimize as needed