#!/usr/bin/env bats
#
# Test Name: test-product-dev-project-csv.bats
# Description: CSV import and dry-run output tests for product-dev-project.sh
# Requirements:
#    - bats-core
#    - test-helper.bash
# Usage:
#    - bats test-product-dev-project-csv.bats
# Test Scope: CSV import, dry-run, access management.

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
  export DRY_RUN=true
}

# Teardown function
teardown() {
  unset GH_CLI_MOCK
  unset DRY_RUN
}


@test "validates importing settings CSV and dry-run output (no access)" {
  run "$SCRIPT" lightspeedwp testproduct 99 --settings-file ../../scripts/project/fixtures/product-development-settings.csv
  [ "$status" -eq 0 ]
  contains "$output" "Updating project name to 'Product Development Project'"
  contains "$output" "Updating short description to 'Project for managing product development'"
  contains "$output" "Updating README for project #99"
  # Should NOT contain access management lines
  not_contains "$output" "Setting base role"
  not_contains "$output" "Inviting"
}


@test "validates importing settings CSV and dry-run output (with access)" {
  run "$SCRIPT" lightspeedwp testproduct 99 --settings-file ../../scripts/project/fixtures/product-development-manage-access.csv --manage-access
  [ "$status" -eq 0 ]
  contains "$output" "Setting base role to 'Admin'"
  contains "$output" "Inviting Interns with role: Admin"
  contains "$output" "Inviting Developers with role: Write"
  contains "$output" "Inviting ashleyshaw with role: Write"
}
