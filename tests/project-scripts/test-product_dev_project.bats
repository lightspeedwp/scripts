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

setup() {
  setup_test_environment
}

teardown() {
  cleanup_test_environment
}


setup() {
  export GH_CLI_MOCK=1
}

teardown() {
  unset GH_CLI_MOCK
}

@test "shows usage with no arguments" {
  run ../../scripts/project/product-dev-project.sh
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "shows help output" {
  run ../../scripts/project/product-dev-project.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}


@test "updates project name in dry-run mode" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Updating project name to 'Product – testproduct'"
}

@test "updates short description in dry-run mode" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Updating short description to 'Plan and ship versioned releases with a lean Scrumban flow and clear release gates.'"
}

@test "updates README in dry-run mode" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Updating README for project #99"
}

@test "creates all fields in dry-run mode" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
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
  contains "$output" "Creating date field 'Deadline'"
  contains "$output" "Creating text field 'Assignee'"
}

@test "assigns colors for single-select options" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Setting color for Theme:Design System"
  contains "$output" "Setting color for Area:Frontend"
  contains "$output" "Setting color for Priority:High"
}

@test "idempotency: does not duplicate fields" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Field 'Theme' already exists"
  contains "$output" "Field 'Area' already exists"
}

@test "handles environment variable overrides" {
  export ORG="customorg"
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh customorg testproduct 88
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "customorg"
}

@test "errors on missing product name" {
  run ../../scripts/project/product-dev-project.sh
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "errors on invalid field spec (simulate)" {
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh "" 99
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "does not print credentials in output" {
  export LS_APP_PRIVATE_KEY="supersecret"
  export DRY_RUN=true
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  ! [[ "$output" =~ "supersecret" ]]
}
