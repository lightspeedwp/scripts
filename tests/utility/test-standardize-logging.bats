#
# Script Name: test-standardize-logging.bats
# Description: Bats tests for standardize-logging.sh utility script.
# Requirements: bats-core, test-helper.bash
# Usage: bats test-standardize-logging.bats
# Options: None
# Github Author: @lightspeedwp / @ashleyshaw
# Date: 14-10-2025
#
load '../test-helper.bash'

SCRIPT_PATH="${BATS_TEST_DIRNAME}/../scripts/utility/standardize-logging.sh"
TEST_SCRIPT_PATH="${BATS_TEST_DIRNAME}/../../scripts/scripts/utility/run-tests.sh"

setup() {
    # Create test directory
    mkdir -p "${BATS_TEST_DIRNAME}/fixtures"

    # Create test script without logging
    cat > "${TEST_SCRIPT_PATH}" << EOF
#!/bin/bash
#
# Test script for standardize-logging.sh
#

set -euo pipefail

function main() {
    echo "This is a test script"
}

main "\$@"
EOF

    chmod +x "${TEST_SCRIPT_PATH}"
}

teardown() {
    # Clean up test script
    rm -f "${TEST_SCRIPT_PATH}"
    rm -f "${TEST_SCRIPT_PATH}.bak"
}

@test "script exists and is executable" {
    [ -x "${SCRIPT_PATH}" ]
}

@test "script shows help with --help flag" {
    run "${SCRIPT_PATH}" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "script shows error for unknown option" {
    run "${SCRIPT_PATH}" --unknown-option
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown option" ]]
}

@test "script runs in dry run mode without making changes" {
    run "${SCRIPT_PATH}" --dry-run "${TEST_SCRIPT_PATH}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \[DRY\ RUN\] ]]

    # Verify the file wasn't changed
    run grep "LOG_FILE" "${TEST_SCRIPT_PATH}"
    [ "$status" -ne 0 ]
}

@test "script adds logging to a script file" {
    run "${SCRIPT_PATH}" "${TEST_SCRIPT_PATH}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Updated" ]]

    # Verify logging was added
    run grep "LOG_FILE" "${TEST_SCRIPT_PATH}"
    [ "$status" -eq 0 ]

    # Verify backup file was created
    [ -f "${TEST_SCRIPT_PATH}.bak" ]
}

@test "script skips already processed files" {
    # First run to add logging
    run "${SCRIPT_PATH}" "${TEST_SCRIPT_PATH}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Updated" ]]

    # Second run should skip
    run "${SCRIPT_PATH}" "${TEST_SCRIPT_PATH}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "already set up" ]] || [[ "$output" =~ "Logging already" ]]
}

@test "script runs in verbose mode" {
    run "${SCRIPT_PATH}" --verbose --dry-run "${TEST_SCRIPT_PATH}"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \[DEBUG\] ]]
}

@test "script handles non-existent file" {
    run "${SCRIPT_PATH}" "/path/to/nonexistent/file.sh"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "File not found" ]]
}
