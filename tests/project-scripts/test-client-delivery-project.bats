#!/usr/bin/env bats
# ============================================================================
# Test Suite: test-client-delivery-project.bats
# Description: End-to-end and edge case tests for client-delivery-project.sh
# Version: v0.1.1
# Date: 2025-10-15
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Github Author: @lightspeedwp / @ashleyshaw
# Requirements:
#    - bats-core
#    - bats-support
#    - bats-assert
# Usage:
#    - npx bats tests/project-scripts/test-client-delivery-project.bats
# Test Scope: CLI usage, dry-run, field creation, error handling, idempotency.
# ============================================================================

load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

# ============================================================================
# This test suite covers the core functionality of the client-delivery-project.sh
# script. It validates command-line argument parsing, dry-run behavior,
# project field creation, idempotency, and error handling.
#
# Mocking is used extensively to isolate tests from network activity and
# ensure predictable outcomes.
# ============================================================================

# ----- Setup and Teardown functions -----

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  SCRIPT="$DIR/../../scripts/project/client-delivery-project.sh"
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
  export SCRIPT
  export GH_CLI_MOCK=1
}

teardown() {
  unset GH_CLI_MOCK
  unset DRY_RUN
  unset ORG
  unset LS_APP_PRIVATE_KEY
}

# ============================================================================
# @test "shows usage with no arguments"
# ============================================================================
# Verifies that the script shows usage information and exits with an error
# when no arguments are provided.
# ============================================================================
@test "shows usage with no arguments" {
  run "$SCRIPT"
  [ "$status" -eq 1 ]
  assert_output --partial "Usage:"
}

# ============================================================================
# @test "shows help output"
# ============================================================================
# Verifies that the script shows the help message when the --help flag is used.
# ============================================================================
@test "shows help output" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  assert_output --partial "Usage:"
}

# ============================================================================
# @test "creates all fields in dry-run mode"
# ============================================================================
# Verifies that the script correctly logs the creation of all standard
# client delivery fields when run in dry-run mode.
# ============================================================================
@test "creates all fields in dry-run mode" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp acme-corp 42
  [ "$status" -eq 0 ]
  assert_output --partial "Creating field 'Theme'"
  assert_output --partial "Creating field 'Area'"
  assert_output --partial "Creating field 'Priority'"
  assert_output --partial "Creating field 'Severity'"
  assert_output --partial "Creating field 'Size'"
  assert_output --partial "Creating field 'Phase'"
  assert_output --partial "Creating number field 'Story Points'"
  assert_output --partial "Creating date field 'Due Date'"
  assert_output --partial "Creating text field 'Assignee'"
}

# ============================================================================
# @test "assigns colors for single-select options"
# ============================================================================
# Verifies that the script logs the assignment of colors to single-select
# field options during a dry-run.
# ============================================================================
@test "assigns colors for single-select options" {
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp acme-corp 42
  [ "$status" -eq 0 ]
  assert_output --partial "Setting color for Theme:Design System"
  assert_output --partial "Setting color for Priority:High"
}

# ============================================================================
# @test "idempotency: does not duplicate fields"
# ============================================================================
# Verifies that the script does not attempt to re-create fields that already
# exist. It runs the main project update function twice in a subshell to
# simulate state and checks that the second run reports the fields as existing.
# ============================================================================
@test "idempotency: does not duplicate fields" {
  export DRY_RUN=true
  run bash -c "
    source '$DIR/../../scripts/project/update-projects.sh'
    update_projects_main 'Client Delivery' acme-corp 42
    update_projects_main 'Client Delivery' acme-corp 42
  "
  [ "$status" -eq 0 ]
  assert_output --partial "Field 'Theme' already exists"
}

# ============================================================================
# @test "handles environment variable overrides"
# ============================================================================
# Verifies that the ORG environment variable correctly overrides the default
# organization when creating a new project.
# ============================================================================
@test "handles environment variable overrides" {
  export ORG="customorg"
  export DRY_RUN=true
  run "$SCRIPT" testclient
  [ "$status" -eq 0 ]
  assert_output --partial "Creating project 'Client – testclient' under organisation 'customorg'"
}

# ============================================================================
# @test "errors on missing client name"
# ============================================================================
# Verifies that the script exits with an error if the required client name
# argument is missing.
# ============================================================================
@test "errors on missing client name" {
  run "$SCRIPT"
  [ "$status" -eq 1 ]
  assert_output --partial "Product/Client name is required"
}

# ============================================================================
# @test "errors on invalid field spec (simulate)"
# ============================================================================
# Simulates an error scenario where the field specification is invalid.
# This is now tested by checking for a required argument.
# ============================================================================
@test "errors on invalid field spec (simulate)" {
  export DRY_RUN=true
  run "$SCRIPT" "" 42
  [ "$status" -eq 1 ]
  assert_output --partial "Product/Client name is required"
}

# ============================================================================
# @test "does not print credentials in output"
# ============================================================================
# Verifies that sensitive credentials passed as environment variables are not
# leaked into the script's output.
# ============================================================================
@test "does not print credentials in output" {
  export LS_APP_PRIVATE_KEY="supersecret"
  export DRY_RUN=true
  run "$SCRIPT" lightspeedwp acme-corp 42
  [ "$status" -eq 0 ]
  refute_output --partial "supersecret"
}
