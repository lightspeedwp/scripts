#!/usr/bin/env bats
#
# Test Name: test-run-projects-tests.bats
# Description: Main test suite for project test runners (run-project-tests.sh). Validates project runner script functionality: listing, running, dry-run, verbose/quiet, summary reporting.
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
#    - bats test-run-projects-tests.bats
# Test Scope: Script validation, CLI invocation, bats references, main runner logic. Ensures all project runner output and help text reference 'project' not 'utility'.

load '../test-helper.bash'

setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    SCRIPT="$DIR/../../scripts/project/run-project-tests.sh"
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

@test "script runs all project bats tests and reports summary" {
    run "$SCRIPT"
    # Should print summary and not error out
    [[ "$output" == *"Running all project Bats tests..."* ]]
    [[ "$output" == *"Some project tests failed!"* || "$output" == *"All project tests passed!"* ]]
}

@test "script fails gracefully if bats is not installed" {
    run bash -c "PATH='/nonexistent' '$SCRIPT'"
    [ "$status" -eq 1 ]
    [[ "$output" == *"bats is not installed"* ]]
}

@test "script lists all test files with --list" {
    run "$SCRIPT" --list
    [ "$status" -eq 0 ]
    [[ "$output" == *"test-client-delivery-project.bats"* ]]
    [[ "$output" == *"test-product-dev-project.bats"* ]]
}

@test "script runs a specific test file with --test" {
    run "$SCRIPT" --test test-client-delivery-project
    [ "$status" -eq 0 ]
    [[ "$output" == *"Running test-client-delivery-project.bats"* ]]
}

@test "script supports --verbose and --quiet flags" {
    run "$SCRIPT" --verbose
    [ "$status" -eq 0 ]
    [[ "$output" == *"Running"* ]]
    run "$SCRIPT" --quiet
    [ "$status" -eq 0 ]
}

@test "script supports --dry-run mode" {
    run "$SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"DRY-RUN mode"* ]]
}
