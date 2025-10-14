#!/usr/bin/env bats
#
# Test Name: test-client-delivery-project-csv.bats
# Description: CSV import and dry-run output tests for client-delivery-project.sh
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
#    - bats test-client-delivery-project-csv.bats
# Test Scope: CSV import, dry-run, access management.

# Load test helpers
load '../test-helper.bash'

# ----- Setup and Teardown functions -----

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  SCRIPT="$DIR/../../scripts/project/client-delivery-project.sh"
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

# General test environment setup
@test "validates importing settings CSV and dry-run output (no access)" {
  run "$SCRIPT" lightspeedwp acme-corp 42 --settings-file ../../scripts/project/fixtures/client-delivery-settings.csv
  [ "$status" -eq 0 ]
  contains "$output" "Updating project name to 'Client Delivery Project'"
  contains "$output" "Updating short description to 'Project for managing client delivery engagements'"
  contains "$output" "Updating README for project #42"
  # Should NOT contain access management lines
  not_contains "$output" "Setting base role"
  not_contains "$output" "Inviting"
}

# General test environment setup
@test "validates importing settings CSV and dry-run output (with access)" {
  run "$SCRIPT" lightspeedwp acme-corp 42 --settings-file ../../scripts/project/fixtures/client-delivery-settings.csv --access-file ../../scripts/project/fixtures/client-delivery-manage-access.csv --manage-access
  [ "$status" -eq 0 ]
  contains "$output" "Setting base role to 'Write'"
  contains "$output" "Inviting Interns with role: Write"
  contains "$output" "Inviting Developers with role: Write"
  contains "$output" "Inviting ashleyshaw with role: Write"
}
