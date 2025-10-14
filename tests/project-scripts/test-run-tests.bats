#!/usr/bin/env bats
#
# Test Name: test-run-tests.bats
# Description: Test suite for run-tests.sh project test runner
# Version: v0.1.0
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
#    - bats test-run-tests.bats
# Test Scope: Script validation, CLI invocation, bats references.

# Load test helpers
load '../test-helper.bash'

# ----- Setup and Teardown functions -----

# Setup and Teardown functions
setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # Path to the script being tested
    SCRIPT="$DIR/../../scripts/project/run-tests.sh"

    # Ensure script exists and is executable
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
    # Should contain references to bats
    grep -q "bats" "$SCRIPT"
}

@test "script can run basic test validation" {
    # Run the test runner to see if it executes without error
    run bash "$SCRIPT" --help
    # Should return 0 for help command
    [ "$status" -eq 0 ]
    # Should contain usage information
    [[ "$output" == *"Usage:"* ]]
}
