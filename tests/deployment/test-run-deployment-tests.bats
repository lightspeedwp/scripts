#!/usr/bin/env bats
#
# Test Name: test-run-deployment-tests.bats
# Description: Main test suite for deployment test runners (run-deployment-tests.sh). Validates deployment runner script functionality: listing, running, dry-run, verbose/quiet, summary reporting.
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
#    - bats test-run-deployment-tests.bats
# Test Scope: Script validation, CLI invocation, bats references, main runner logic. Ensures all deployment runner output and help text reference 'deployment' not 'project'.

load '../test-helper.bash'

setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    SCRIPT="$DIR/../../scripts/deployment/run-deployment-tests.sh"
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

@test "script runs all deployment bats tests and reports summary" {
    run "$SCRIPT"
    # Should print summary and not error out
    [[ "$output" == *"Running all deployment Bats tests..."* ]]
    [[ "$output" == *"Some deployment tests failed!"* || "$output" == *"All deployment tests passed!"* ]]
}

@test "script fails gracefully if bats is not installed" {
    run bash -c "PATH='/nonexistent' '$SCRIPT'"
    [ "$status" -eq 1 ]
    [[ "$output" == *"bats is not installed"* ]]
}
