#!/usr/bin/env bats
#
# Test Name: test-find-readmes.bats
# Description: Tests find-readmes.sh for listing all README files
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
#    - bats test-find-readmes.bats
# Test Scope: README file listing.

# Load test helpers
load ../test-helper.bash

setup() {
  # Get the directory containing this test file
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  # Path to the script being tested
  SCRIPT="$DIR/../scripts/maintenance/find-readmes.sh"

  # Ensure script exists and is executable
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

@test "find-readmes.sh lists all README files" {
  run scripts/maintenance/find-readmes.sh
  [ "$status" -eq 0 ]
  [[ "$output" =~ "README.md" ]]
}
