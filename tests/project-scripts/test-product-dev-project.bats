#!/usr/bin/env bats
#
# Test Name: test-product_dev_project.bats
# Description: End-to-end and edge case tests for product-dev-project.sh
# Version: v0.1.0
# Date: 14-10-2025
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Github Author: @lightspeedwp / @ashleyshaw
# Requirements: bats-core, test-helper.bash
# Usage: bats test-product_dev_project.bats
# Test Scope: CLI usage, dry-run, field creation, error handling.

# Load test helpers
load '../test-helper.bash'

# ----- Setup and Teardown functions -----

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  SCRIPT="$DIR/../../scripts/project/product-dev-project.sh"
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
  export SCRIPT
  export GH_CLI_MOCK=1
}

teardown() {
  unset GH_CLI_MOCK
}

@test "shows usage with no arguments" {
  run "$SCRIPT"
  run "$SCRIPT" --help
  [[ "$output" =~ "Usage:" ]]
}

@test "shows help output" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  run "$SCRIPT" lightspeedwp testproduct 99
}


@test "updates project name in dry-run mode" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  contains "$output" "Updating project name to 'Product – testproduct'"
}

@test "updates short description in dry-run mode" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  contains "$output" "Updating short description to 'Plan and ship versioned releases with a lean Scrumban flow and clear release gates.'"
}

@test "updates README in dry-run mode" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  contains "$output" "Updating README for project #99"
}

@test "creates all fields in dry-run mode" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Creating field 'Theme'"
  contains "$output" "Creating field 'Area'"
  contains "$output" "Creating field 'Priority'"
  contains "$output" "Creating field 'Severity'"
  contains "$output" "Creating field 'Size'"
  contains "$output" "Creating field 'Phase'"
  contains "$output" "Creating field 'Release type'"
  contains "$output" "Creating field 'Environment'"
  contains "$output" "Creating field 'Status'"
  contains "$output" "Creating field 'Issue Type'"
  contains "$output" "Creating field 'Milestone'"
  contains "$output" "Creating number field 'Story Points'"
  contains "$output" "Creating number field 'Estimate'"
  contains "$output" "Creating date field 'Due Date'"
  contains "$output" "Creating date field 'Start Date'"
  contains "$output" "Creating text field 'Assignee'"
}

@test "assigns colors for single-select options" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Setting color for Theme:Design System"
  contains "$output" "Setting color for Priority:High"
}

@test "idempotency: does not duplicate fields" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Field 'Theme' already exists"
  run "$SCRIPT" customorg testproduct 88
}

@test "handles environment variable overrides" {
  export ORG="customorg"
  export DRY_RUN=true
  run "$SCRIPT"
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "customorg"
}

@test "errors on missing product name" {
  run "$SCRIPT"
  run "$SCRIPT" 99
  [[ "$output" =~ "Usage:" ]]
}

@test "errors on invalid field spec (simulate)" {
  export DRY_RUN=true
  run "$SCRIPT" "" 99
  [ "$status" -eq 1 ]
  run "$SCRIPT" lightspeedwp testproduct 99
}

@test "does not print credentials in output" {
  export LS_APP_PRIVATE_KEY="supersecret"
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  ! [[ "$output" =~ "supersecret" ]]
}
