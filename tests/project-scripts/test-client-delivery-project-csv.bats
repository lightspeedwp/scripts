#!/usr/bin/env bats
# ============================================================================
# Test Suite: test-client-delivery-project-csv.bats
# Description: CSV import and dry-run output tests for client-delivery-project.sh
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
#    - npx bats tests/project-scripts/test-client-delivery-project-csv.bats
# Test Scope: CSV import, dry-run, access management.
# ============================================================================

load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

# ----- Section: Setup function -----
# ============================================================================
# setup()
# Sets up the test environment for CSV import and dry-run tests.
# - Resolves script path
# - Ensures script exists and is executable
# - Sets GH_CLI_MOCK and DRY_RUN for test isolation
# ============================================================================
setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  SCRIPT="$DIR/../../scripts/project/client-delivery-project.sh"
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
  export SCRIPT
  export GH_CLI_MOCK=1
  export DRY_RUN=true
}

# ----- Section: Teardown function -----
# ============================================================================
# teardown()
# Cleans up the test environment after each test.
# - Unsets GH_CLI_MOCK and DRY_RUN
# ============================================================================
teardown() {
  unset GH_CLI_MOCK
  unset DRY_RUN
}

# ----- Section: CSV Import and Access Management Tests -----
# ============================================================================
# @test "validates importing settings CSV and dry-run output (no access)"
# Validates importing settings CSV and dry-run output when access management is not enabled.
# - Runs script with settings file only
# - Checks for expected output and absence of access management lines
# ============================================================================
@test "validates importing settings CSV and dry-run output (no access)" {
  run "$SCRIPT" lightspeedwp testclient 99 --settings-file "$DIR/../../scripts/project/fixtures/client-delivery-settings.csv"
  [ "$status" -eq 0 ]
  assert_output --partial "Updating short description to 'Project for managing client delivery engagements'"
  assert_output --partial "Updating README for project #99"
  refute_output --partial "Managing access for"
}

# ============================================================================
# @test "validates importing settings CSV and dry-run output (with access)"
# ============================================================================
# Validates importing settings CSV and dry-run output when access management is enabled.
# - Runs script with settings file and --manage-access
# - Checks for expected access management output
# ============================================================================
@test "validates importing settings CSV and dry-run output (with access)" {
  run "$SCRIPT" lightspeedwp testclient 99 --settings-file "$DIR/../../scripts/project/fixtures/client-delivery-settings.csv" --manage-access
  [ "$status" -eq 0 ]
  assert_output --partial "Managing access for project #99"
}

# ============================================================================
# @test "validates importing access CSV directly"
# ============================================================================
# Validates importing an access CSV file directly via the --access-file flag.
# - Runs script with the access file flag
# - Checks for expected access management output
# ============================================================================
@test "validates importing access CSV directly" {
  run "$SCRIPT" lightspeedwp testclient 99 --access-file "$DIR/../../scripts/project/fixtures/client-delivery-manage-access.csv" --manage-access
  [ "$status" -eq 0 ]
  assert_output --partial "Managing access for project #99"
}

# ============================================================================
# @test "validates importing fields CSV directly"
# ============================================================================
# Validates importing a fields CSV file directly via the --fields-file flag.
# - Runs script with the fields file flag
# - Checks for expected field creation output
# ============================================================================
@test "validates importing fields CSV directly" {
  run "$SCRIPT" lightspeedwp testclient 99 --fields-file "$DIR/../../scripts/project/fixtures/client-delivery-fields.csv"
  [ "$status" -eq 0 ]
  assert_output --partial "Creating field 'Theme'"
  assert_output --partial "Creating field 'Area'"
  assert_output --partial "Creating field 'Priority'"
}
