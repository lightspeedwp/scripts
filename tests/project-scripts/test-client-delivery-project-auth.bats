#!/usr/bin/env bats
#
# Test Name: test-client-delivery-project-auth.bats
# Description: Authentication and scope validation tests for client-delivery-project.sh
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
#    - bats test-client-delivery-project-auth.bats
# Test Scope: GitHub CLI authentication, required scopes, error handling.

# Load test helpers
load '../test-helper.bash'

# ----- Setup and Teardown functions -----

# Get the directory containing this test file
setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
        # Path to the script being tested (relative to repo root)
        SCRIPT="$DIR/../../scripts/project/client-delivery-project.sh"

    # Ensure script exists and is executable
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

# General test environment setup
setup() {
  export GH_CLI_MOCK=1
}

# Teardown function
teardown() {
  unset GH_CLI_MOCK
}

# General test environment setup
@test "errors if gh CLI is not installed" {
  PATH="/nonexistent:$PATH"
  run ../../scripts/project/client-delivery-project.sh lightspeedwp acme-corp 42
  [ "$status" -eq 1 ]
  [[ "$output" =~ "GitHub CLI (gh) is not installed" ]]
}

@test "errors if not authenticated with gh CLI" {
  export GH_AUTH_FAIL=1
  run ../../scripts/project/client-delivery-project.sh lightspeedwp acme-corp 42
  [ "$status" -eq 1 ]
  [[ "$output" =~ "GitHub CLI is not authenticated" ]]
}

@test "errors if required scopes are missing" {
  export GH_SCOPES="read:user"
  run ../../scripts/project/client-delivery-project.sh lightspeedwp acme-corp 42
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Missing required GitHub CLI scopes" ]]
}

@test "succeeds if authenticated and all scopes present" {
  export GH_AUTH_OK=1
  export GH_SCOPES="repo,project,read:org,read:user"
  run ../../scripts/project/client-delivery-project.sh lightspeedwp acme-corp 42
  [ "$status" -eq 0 ]
  [[ "$output" =~ "GitHub CLI is authenticated" ]]
  [[ "$output" =~ "All required scopes are present" ]]
}
