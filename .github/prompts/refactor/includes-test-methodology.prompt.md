---
applyTo: '**'
description: 'Prompt for Bats test methodology for modular shell script includes.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['testing', 'bats', 'includes', 'shell']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Includes Test Methodology

## Role

You are a test automation specialist. Follow our LightSpeed WP Bats testing standards to create comprehensive test coverage for modular shell script includes.

## Purpose

Define systematic testing methodology for validating extracted shell script functions in includes files with comprehensive edge case coverage and integration testing.

## Checklist

## Current Repository State & Action Items

- Modular includes present: `common-functions.sh`, `git-functions.sh` in `scripts/includes/`. Additional includes recommended.
- No Bats test files for includes exist in `tests/includes/`; add for each include module.
- Folder structure: `/scripts/project/` and `/tests/project-scripts/` currently used; planned renaming for consistency.
- README files for includes and tests are incomplete; expand documentation.

**Action:** Create Bats test files for each include, expand documentation, and update folder names for consistency.

## Instructions

### Test Structure Requirements

#### Directory Organization

```
tests/includes/
├── test-logging.bats          # Tests for logging.sh
├── test-validation.bats       # Tests for validation.sh
├── test-cli-utils.bats        # Tests for cli-utils.sh
├── test-file-utils.bats       # Tests for file-utils.sh
├── test-path-utils.bats       # Tests for path-utils.sh
├── test-github-auth.bats      # Tests for github-auth.sh
├── test-env-utils.bats        # Tests for env-utils.sh
└── integration/
    ├── test-logging-integration.bats
    └── test-full-workflow.bats
```

#### Test File Template

```bash
#!/usr/bin/env bats

# Version: v1.0.0
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# Usage: bats test-module-name.bats
# Options:
#  - None

# Load test helpers
load "$(dirname "$BATS_TEST_FILENAME")/../test-helper.bash"

setup() {
    # Setup test environment for each test
    TEST_TEMP_DIR=$(mktemp -d)
    export TEST_TEMP_DIR

    # Load the include being tested
    source "$SCRIPTS_DIR/includes/module-name.sh"
}

teardown() {
    # Cleanup after each test
    [[ -n "$TEST_TEMP_DIR" && -d "$TEST_TEMP_DIR" ]] && rm -rf "$TEST_TEMP_DIR"
}
```

### Test Categories

#### 1. Unit Tests for Individual Functions

**Function Signature Testing**

- Verify function accepts correct number of arguments
- Test with no arguments (if applicable)
- Test with excessive arguments
- Validate argument type handling

**Success Path Testing**

- Test normal operation with valid inputs
- Verify expected output format
- Confirm return codes for success cases
- Validate side effects (file creation, etc.)

**Error Condition Testing**

- Test with invalid arguments
- Test with missing required files/directories
- Test permission denied scenarios
- Test with corrupted input data
- Verify appropriate error messages and return codes

**Edge Case Testing**

- Empty string inputs
- Very long string inputs
- Special characters in inputs
- Unicode and non-ASCII characters
- Boundary conditions (min/max values)

#### 2. Integration Tests

**Function Interaction Testing**

- Test functions that depend on other functions
- Verify shared state management
- Test function call chains
- Validate data flow between functions

**Environment Dependency Testing**

- Test with different environment variable settings
- Test with missing environment variables
- Test with readonly environment variables
- Verify environment cleanup

**File System Integration**

- Test with different file permissions
- Test with different file system types
- Test with network mounted directories
- Test disk space limitations

#### 3. Performance Tests

**Execution Time Testing**

- Measure function execution time
- Test with large input sets
- Identify performance regressions
- Validate timeout handling

**Memory Usage Testing**

- Monitor memory consumption
- Test with large data sets
- Verify memory cleanup
- Test memory leak detection

**Resource Usage Testing**

- File descriptor usage
- Process spawning limits
- Network connection handling
- Temporary file cleanup

### Specific Test Requirements by Module

#### Logging Functions Tests (`test-logging.bats`)

```bash
# ----- Section: Core Logging Functionality -----

# ============================================================================
# Test Name: "log_info writes to stderr and log file"
# Test Type: Unit Test
# Test Scope: Validates log_info function writes formatted message to both stderr and log file with proper timestamp and formatting.
# ============================================================================
@test "log_info writes to stderr and log file" {
    local test_message="Test info message"
    local expected_log_file="$TEST_TEMP_DIR/test.log"

    LOG_FILE="$expected_log_file" run log_info "$test_message"

    # Verify stderr output
    [[ "$output" == *"$test_message"* ]]

    # Verify log file creation and content
    [[ -f "$expected_log_file" ]]
    grep -q "$test_message" "$expected_log_file"
    grep -q "INFO" "$expected_log_file"

    # Verify timestamp format
    grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" "$expected_log_file"
}

# ============================================================================
# Test Name: "log_error returns correct exit code"
# Test Type: Unit Test
# Test Scope: Validates log_error function maintains proper exit codes and doesn't interfere with script flow.
# ============================================================================
@test "log_error returns correct exit code" {
    LOG_FILE="$TEST_TEMP_DIR/error.log" run log_error "Test error"
    [[ "$status" -eq 0 ]]  # log_error should not exit, just log
}

# ----- Section: Log File Management -----

# ============================================================================
# Test Name: "logging creates log directory if missing"
# Test Type: Integration Test
# Test Scope: Validates automatic log directory creation when LOG_FILE points to non-existent directory.
# ============================================================================
@test "logging creates log directory if missing" {
    local log_dir="$TEST_TEMP_DIR/logs/nested"
    local log_file="$log_dir/test.log"

    LOG_FILE="$log_file" run log_info "Directory creation test"

    [[ -d "$log_dir" ]]
    [[ -f "$log_file" ]]
}

# ----- Section: Color Output Testing -----

# Test color codes in output (when TTY available)
# Test color stripping (when no TTY)

# ----- Section: Error Conditions -----

# Test with readonly log directory
# Test with insufficient disk space simulation
# Test with invalid log file paths
```

#### Validation Functions Tests (`test-validation.bats`)

```bash
# ----- Section: Command Existence Validation -----

@test "command_exists returns 0 for existing commands" {
    run command_exists "bash"
    [[ "$status" -eq 0 ]]

    run command_exists "ls"
    [[ "$status" -eq 0 ]]
}

@test "command_exists returns 1 for non-existent commands" {
    run command_exists "non_existent_command_12345"
    [[ "$status" -eq 1 ]]
}

# ----- Section: File Validation -----

@test "validate_file_exists succeeds for existing files" {
    local test_file="$TEST_TEMP_DIR/test.txt"
    echo "content" > "$test_file"

    run validate_file_exists "$test_file"
    [[ "$status" -eq 0 ]]
}

@test "validate_file_exists fails for missing files" {
    run validate_file_exists "/non/existent/file.txt"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"File not found"* ]]
}

# ----- Section: Version Format Validation -----

@test "validate_version_format accepts valid semver" {
    run validate_version_format "1.0.0"
    [[ "$status" -eq 0 ]]

    run validate_version_format "v1.2.3"
    [[ "$status" -eq 0 ]]

    run validate_version_format "2.0.0-alpha.1"
    [[ "$status" -eq 0 ]]
}

@test "validate_version_format rejects invalid versions" {
    run validate_version_format "1"
    [[ "$status" -eq 1 ]]

    run validate_version_format "1.2"
    [[ "$status" -eq 1 ]]

    run validate_version_format "invalid"
    [[ "$status" -eq 1 ]]
}
```

#### CLI Utility Tests (`test-cli-utils.bats`)

```bash
# ----- Section: Help Display -----

@test "show_help displays formatted help message" {
    run show_help "test-script" "Test description" "test-script [options]" \
        "--help    Show help" \
        "--verbose Enable verbose mode"

    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Usage: test-script [options]"* ]]
    [[ "$output" == *"Test description"* ]]
    [[ "$output" == *"--help"* ]]
}

# ----- Section: Argument Parsing -----

@test "parse_common_args sets VERBOSE flag" {
    run parse_common_args "--verbose" "arg1"
    [[ "$status" -eq 0 ]]
    [[ "$VERBOSE" == "true" ]]
}

@test "parse_common_args handles unknown options" {
    run parse_common_args "--unknown-option"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"Unknown option"* ]]
}
```

### Test Data Management

#### Test Fixtures

- Create standardized test data files
- Use predictable test input patterns
- Version control test fixtures
- Document test data requirements

#### Mock Services

- Mock GitHub API responses
- Simulate network failures
- Mock file system errors
- Create test doubles for external commands

#### Environment Isolation

- Use temporary directories for all file operations
- Clean up environment variables after tests
- Reset global state between tests
- Prevent test interference

### Test Execution Standards

#### Continuous Integration Integration

```yaml
# .github/workflows/test-includes.yml
name: Test Include Functions
on: [push, pull_request]
jobs:
    test-includes:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v4
            - name: Install Bats
              run: npm install -g bats
            - name: Run Include Tests
              run: bats tests/includes/
            - name: Run Integration Tests
              run: bats tests/includes/integration/
```

#### Coverage Requirements

- Minimum 90% line coverage for all include functions
- 100% coverage for error conditions
- All public functions must have tests
- All edge cases must be documented and tested

#### Test Reporting

- Generate test coverage reports
- Create test execution summaries
- Log test performance metrics
- Track test reliability over time

## System Constraints

- All tests must be deterministic and repeatable
- Tests must not require external network access
- Test execution must be fast (under 30 seconds for full suite)
- Tests must clean up all resources
- Tests must be compatible with CI/CD environments

## Example First Message to Copilot

```
Create comprehensive Bats test suite for extracted shell script functions. Implement unit tests, integration tests, and error condition testing following the methodology specifications. Ensure all include modules have full test coverage with proper setup/teardown and test data management.
```

## Verification Steps

- [ ] All include functions have corresponding unit tests
- [ ] Error conditions are comprehensively tested
- [ ] Integration tests verify function interactions
- [ ] Performance tests identify bottlenecks
- [ ] Test coverage meets minimum requirements
- [ ] CI/CD integration is functional

## References

- [Bats Tests and Runner Scripts Instructions](../.github/instructions/bats-tests-and-runner-scripts.instructions.md)
- [Shell Script Copilot Instructions](../.github/instructions/shell-script-copilot.instructions.md)
- [Script Functions Breakdown Spec](./script-functions-breakdown-spec.md)

## Closing Statement

Comprehensive testing methodology ensures extracted functions maintain reliability and correctness while enabling confident refactoring and continuous improvement of the automation codebase.
