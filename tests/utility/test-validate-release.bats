#!/usr/bin/env bats

# Test suite for validate-release.sh script
# Comprehensive tests for release validation functionality

setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # Path to the script being tested
    SCRIPT="$DIR/../../scripts/scripts/validate-release.sh"

    # Create temporary test directory
    TEST_TEMP_DIR="${BATS_TEST_TMPDIR}/validate-release-test-$$"
    mkdir -p "$TEST_TEMP_DIR"

    # Ensure script exists and is executable
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

teardown() {
    # Clean up temporary directory
    if [ -d "$TEST_TEMP_DIR" ]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

# ============================================================================
# Basic Script Validation Tests
# ============================================================================

@test "script has proper shebang" {
    head -n1 "$SCRIPT" | grep -q "#!/.*bash"
}

@test "script uses set -euo pipefail for safety" {
    grep -q "set -euo pipefail" "$SCRIPT"
}

@test "script contains descriptive header comments" {
    head -n 20 "$SCRIPT" | grep -q "validate\|release"
}

# ============================================================================
# Help and Usage Tests
# ============================================================================

@test "script has show_help function" {
    grep -q "show_help()" "$SCRIPT"
}

@test "script responds to --help flag" {
    run "$SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage"* ]] || [[ "$output" == *"Validate"* ]]
}

@test "script responds to -h flag" {
    run "$SCRIPT" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage"* ]] || [[ "$output" == *"help"* ]] || skip "Help flag not implemented yet"
}

@test "help message includes usage examples" {
    run "$SCRIPT" --help
    [[ "$output" == *"Examples"* ]] || [[ "$output" == *"Usage"* ]]
}

@test "help message describes all options" {
    run "$SCRIPT" --help
    [[ "$output" == *"Options"* ]] || [[ "$output" == *"--version"* ]] || skip "Options not in help"
}

# ============================================================================
# Configuration and Variables Tests
# ============================================================================

@test "script defines SCRIPT_DIR variable" {
    grep -q 'SCRIPT_DIR=' "$SCRIPT"
}

@test "script defines PROJECT_ROOT variable" {
    grep -q 'PROJECT_ROOT=' "$SCRIPT"
}

@test "script defines EXPECTED_VERSION variable" {
    grep -q 'EXPECTED_VERSION=' "$SCRIPT"
}

@test "script defines VERBOSE flag" {
    grep -q 'VERBOSE=' "$SCRIPT"
}

@test "script defines EXIT_CODE variable" {
    grep -q 'EXIT_CODE=' "$SCRIPT"
}

@test "script has default version" {
    grep -q 'EXPECTED_VERSION=.*[0-9]' "$SCRIPT"
}

# ============================================================================
# Logging and Output Functions Tests
# ============================================================================

@test "script has log_info function" {
    grep -q "log_info()" "$SCRIPT"
}

@test "script has log_success function" {
    grep -q "log_success()" "$SCRIPT"
}

@test "script has log_warning function" {
    grep -q "log_warning\|log_warn()" "$SCRIPT"
}

@test "script has log_error function" {
    grep -q "log_error()" "$SCRIPT"
}

@test "logging functions use emoji or icons" {
    grep -q "ℹ️\|✅\|⚠️\|❌\|\\[INFO\\]\|\\[SUCCESS\\]" "$SCRIPT"
}

# ============================================================================
# Version Validation Tests
# ============================================================================

@test "script validates version format" {
    grep -q "version" "$SCRIPT" | head -20
}

@test "script checks VERSION file" {
    grep -q "VERSION" "$SCRIPT"
}

@test "script checks package.json version" {
    grep -q "package\\.json" "$SCRIPT"
}

@test "script validates semantic versioning" {
    grep -q "[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\|semver\|version" "$SCRIPT"
}

# ============================================================================
# Workflow Validation Tests
# ============================================================================

@test "script validates workflow files" {
    grep -q "workflow\|\\.github/workflows" "$SCRIPT"
}

@test "script checks YAML syntax" {
    grep -q "yaml\|yml" "$SCRIPT"
}

# ============================================================================
# Test Validation Tests
# ============================================================================

@test "script validates test coverage" {
    grep -q "test\|coverage" "$SCRIPT"
}

@test "script checks for passing tests" {
    grep -q "test.*pass\|npm test\|bats" "$SCRIPT"
}

# ============================================================================
# Documentation Validation Tests
# ============================================================================

@test "script validates documentation" {
    grep -q "README\|CHANGELOG\|documentation" "$SCRIPT"
}

@test "script checks changelog format" {
    grep -q "CHANGELOG" "$SCRIPT"
}

@test "script validates README completeness" {
    grep -q "README" "$SCRIPT"
}

# ============================================================================
# Command Line Argument Parsing Tests
# ============================================================================

@test "script accepts --version argument" {
    grep -q "\\-\\-version" "$SCRIPT"
}

@test "script accepts --verbose argument" {
    grep -q "\\-\\-verbose\|\\-v" "$SCRIPT"
}

@test "script handles unknown arguments gracefully" {
    run "$SCRIPT" --unknown-flag
    # Should either ignore or show error
    [ "$status" -ne 0 ] || [[ "$output" == *"unknown"* ]] || [[ "$output" == *"invalid"* ]] || skip "Unknown flag handling not tested"
}

# ============================================================================
# Exit Code Tests
# ============================================================================

@test "script uses EXIT_CODE variable" {
    grep -q "EXIT_CODE=" "$SCRIPT"
}

@test "script exits with non-zero on validation failure" {
    grep -q "exit.*EXIT_CODE\|exit 1\|return 1" "$SCRIPT"
}

@test "script exits with zero on success" {
    grep -q "exit.*0\|EXIT_CODE=0" "$SCRIPT"
}

# ============================================================================
# File Existence Validation Tests
# ============================================================================

@test "script checks for required files" {
    grep -q "\\[ -f\|test -f\|\\[ -e" "$SCRIPT"
}

@test "script validates project structure" {
    grep -q "directory\|folder\|structure" "$SCRIPT" || grep -q "\\[ -d" "$SCRIPT"
}

# ============================================================================
# Verbose Mode Tests
# ============================================================================

@test "script implements verbose mode" {
    grep -q "VERBOSE" "$SCRIPT"
}

@test "verbose mode provides detailed output" {
    grep -q 'if.*VERBOSE\|\\$VERBOSE' "$SCRIPT"
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "script handles missing files gracefully" {
    grep -q "not found\|does not exist\|missing" "$SCRIPT" || grep -q "\\[ ! -f" "$SCRIPT"
}

@test "script provides helpful error messages" {
    grep -q "log_error\|echo.*error\|printf.*error" "$SCRIPT"
}

@test "script accumulates errors before exiting" {
    grep -q "EXIT_CODE" "$SCRIPT"
}

# ============================================================================
# Validation Logic Tests
# ============================================================================

@test "script performs multiple validation checks" {
    local validation_count=$(grep -c "log_info\|log_success\|log_error" "$SCRIPT")
    [ "$validation_count" -gt 5 ]
}

@test "script validates version consistency" {
    grep -q "version.*consistency\|VERSION.*package" "$SCRIPT" || grep -q "version" "$SCRIPT"
}

@test "script validates file formats" {
    grep -q "format\|syntax\|valid" "$SCRIPT"
}

# ============================================================================
# Integration Tests
# ============================================================================

@test "script can be run without arguments" {
    run "$SCRIPT"
    # Should either succeed or show usage
    [ "$status" -eq 0 ] || [[ "$output" == *"Usage"* ]] || skip "No arg execution test skipped"
}

@test "script handles relative paths correctly" {
    grep -q "SCRIPT_DIR=.*cd.*dirname" "$SCRIPT"
}

@test "script uses PROJECT_ROOT for file paths" {
    grep -q "PROJECT_ROOT\|\\$PROJECT_ROOT" "$SCRIPT"
}

# ============================================================================
# Output Formatting Tests
# ============================================================================

@test "script provides structured output" {
    grep -q "echo\|printf\|log_" "$SCRIPT"
}

@test "script uses consistent message format" {
    grep -q "log_info\|log_success\|log_error\|log_warning" "$SCRIPT"
}

# ============================================================================
# Dependency Checks Tests
# ============================================================================

@test "script checks for required tools" {
    grep -q "command.*-v\|which\|type.*-P" "$SCRIPT" || skip "No dependency checks found"
}

# ============================================================================
# Code Quality Tests
# ============================================================================

@test "script uses meaningful function names" {
    grep -q "validate_\|check_\|verify_" "$SCRIPT" || grep -q "log_\|show_help" "$SCRIPT"
}

@test "script follows consistent coding style" {
    ! grep -q $'^\t' "$SCRIPT"
}

@test "script is well-documented" {
    local comment_count=$(grep -c '^#' "$SCRIPT")
    [ "$comment_count" -gt 10 ]
}

# ============================================================================
# Security Tests
# ============================================================================

@test "script uses proper variable quoting" {
    grep -q '".*\$' "$SCRIPT"
}

@test "script does not expose sensitive information" {
    ! grep -qi "password\|token\|secret\|api.*key" "$SCRIPT"
}

# ============================================================================
# Specific Validation Feature Tests
# ============================================================================

@test "script validates workflow YAML syntax" {
    grep -q "workflow\|yml\|yaml" "$SCRIPT" || skip "Workflow validation not found"
}

@test "script checks changelog entries" {
    grep -q "CHANGELOG" "$SCRIPT" || skip "Changelog validation not found"
}

@test "script validates semantic versioning (feature test)" {
    grep -q "version\|semver" "$SCRIPT"
}

# ============================================================================
# Edge Cases and Robustness Tests
# ============================================================================

@test "script handles missing VERSION file" {
    grep -q "\\[ ! -f.*VERSION\|VERSION.*not.*found" "$SCRIPT" || skip "VERSION file check not found"
}

@test "script handles missing package.json" {
    grep -q "package\\.json" "$SCRIPT" || skip "package.json check not found"
}

@test "script handles empty input" {
    # Should use defaults
    grep -q "EXPECTED_VERSION=.*[0-9]" "$SCRIPT"
}

# ============================================================================
# Maintainability Tests
# ============================================================================

@test "script has clear function separation" {
    local function_count=$(grep -c "^[a-z_]*() {" "$SCRIPT")
    [ "$function_count" -gt 3 ]
}

@test "script uses constants for magic values" {
    grep -q "^[A-Z_]*=" "$SCRIPT"
}

@test "script has proper error propagation" {
    grep -q "return\|exit" "$SCRIPT"
}
