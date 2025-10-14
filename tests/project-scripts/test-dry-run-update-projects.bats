#!/usr/bin/env bats
#
# Test Name: test-client-delivery-project-auth.bats
# Description: Test dry-run update projects script.
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
#    - bats test-dry-run-update-projects.bats
# Test Scope: CLI invocation, help output.

# Load test helpers
load '../test-helper.bash'

# ----- Setup and Teardown functions -----

# Get the directory containing this test file
setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
        # Path to the script being tested (relative to repo root)
        SCRIPT="$DIR/../../scripts/project/test-dry-run-update-projects.sh"

    # Ensure script exists and is executable
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}



