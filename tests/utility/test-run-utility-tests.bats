#!/usr/bin/env bats
#
# Test Name: test-run-utility-tests.bats
# Description: Main test suite for utility test runners (run-utility-tests.sh). Validates utility runner script functionality: listing, running, dry-run, verbose/quiet, summary reporting.
# Version: v0.1.1
# Date: 14-10-2025
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Github Author: @lightspeedwp / @ashleyshaw
# Requirements:
#    - bats-core
#    - test-helper.bash
# Usage:
#    - bats test-run-utility-tests.bats
# Test Scope: Script validation, CLI invocation, bats references, main runner logic. Ensures all utility runner output and help text reference 'utility' not 'project'.

load '../test-helper.bash'

setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    SCRIPT="$DIR/../../scripts/utility/run-utility-tests.sh"
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

@test "script has proper shebang" {
    head -n1 "$SCRIPT" | grep -q "#!/bin/bash"
}

@test "script uses set -euo pipefail for safety" {
    grep -q "set -euo pipefail" "$SCRIPT"
}

@test "script references bats testing framework" {
    grep -q "bats" "$SCRIPT"
}

@test "script can run basic test validation" {
    run "$SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "script runs all utility bats tests and reports summary" {
    run "$SCRIPT"
    # Should print summary and not error out
    [[ "$output" == *"Running all utility Bats tests..."* ]]
    [[ "$output" == *"Some utility tests failed!"* || "$output" == *"All utility tests passed!"* ]]
}


@test "script lists all test files with --list" {
    run "$SCRIPT" --list
    [ "$status" -eq 0 ]
    [[ "$output" =~ Listing\ all\ utility\ test\ files: ]]
    [[ "$output" =~ test-run-utility-tests\.bats ]]
}

@test "script runs a specific test file with --test" {
    # Use a known test file
    run "$SCRIPT" --test test-run-utility-tests
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    [[ "$output" =~ Running\ test-run-utility-tests\.bats ]]
}

@test "script supports --verbose and --quiet flags" {
    run "$SCRIPT" --verbose
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    [[ "$output" == *"Running"* ]]
    run "$SCRIPT" --quiet
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "script supports --dry-run mode" {
    run "$SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"DRY-RUN mode"* ]]
}

@test "script handles unknown options gracefully" {
    run "$SCRIPT" --unknown-option
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}
