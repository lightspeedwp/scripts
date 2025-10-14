#!/usr/bin/env bats
#
# Test Name: test-product-dev-project-auth.bats
# Description: Authentication and scope validation tests for product-dev-project.sh
# Requirements:
#    - bats-core
#    - test-helper.bash
# Usage:
#    - bats test-product-dev-project-auth.bats
# Test Scope: GitHub CLI authentication, required scopes, error handling.

# Load test helpers
load '../test-helper.bash'

# ----- Setup and Teardown functions -----

# Get the directory containing this test file
setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  SCRIPT="$DIR/../../scripts/project/product-dev-project.sh"
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
  export GH_CLI_MOCK=1
}

teardown() {
  unset GH_CLI_MOCK
}

@test "errors if not authenticated with gh CLI" {
  export GH_AUTH_FAIL=1
  run "$SCRIPT" lightspeedwp testproduct 99
  [[ "$output" =~ "GitHub CLI is not authenticated" ]]
}

@test "errors if required scopes are missing" {
  export GH_SCOPES="read:user"
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Missing required GitHub CLI scopes" ]]
}

@test "succeeds if authenticated and all scopes present" {
  export GH_AUTH_OK=1
  export GH_SCOPES="repo,project,read:org,read:user"
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 0 ]
  [[ "$output" =~ "GitHub CLI is authenticated" ]]
  [[ "$output" =~ "All required scopes are present" ]]
}
