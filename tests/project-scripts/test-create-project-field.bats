#!/usr/bin/env bats
#
# Test Name: test-create-project-field.bats
# Description: Basic CLI and help output tests for test-create-project-field.sh
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
#    - bats test-create-project-field.bats
# Test Scope: CLI invocation, help output.

# Load test helpers
load '../test-helper.bash'

@test "test-create-project-field.sh runs with no arguments" {
  run ../../scripts/project/test-create-project-field.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "test-create-project-field.sh shows help" {
  run ../../scripts/project/test-create-project-field.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
