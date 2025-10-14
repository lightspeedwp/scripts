#!/usr/bin/env bats
# ============================================================================
# Test Suite: test-product-dev-project-auth.bats
# Description: Authentication and scope validation tests for product-dev-project.sh
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
#    - npx bats tests/project-scripts/test-product-dev-project-auth.bats
# Test Scope: GitHub CLI authentication, required scopes, error handling.
# ============================================================================

load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

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
  unset GH_AUTH_FAIL
  unset GH_SCOPES
  unset GH_AUTH_OK
  if [ -n "${ORIGINAL_PATH-}" ]; then
      export PATH="$ORIGINAL_PATH"
      unset ORIGINAL_PATH
  fi
}

# ============================================================================
@test "errors if gh CLI is not installed" {
  export ORIGINAL_PATH="$PATH"
  export PATH="/nonexistent:$PATH"
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  assert_output --partial "GitHub CLI (gh) is not installed"
}

# ============================================================================
# @test "errors if not authenticated with gh CLI"
# ============================================================================
@test "errors if not authenticated with gh CLI" {
  export GH_AUTH_FAIL=1
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  assert_output --partial "GitHub CLI is not authenticated"
}

# ============================================================================
# @test "errors if required scopes are missing"
# ============================================================================
@test "errors if required scopes are missing" {
  export GH_SCOPES="read:user"
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  assert_output --partial "Missing required GitHub CLI scopes"
}

# ============================================================================
# @test "succeeds if authenticated and all scopes present"
# ============================================================================
@test "succeeds if authenticated and all scopes present" {
  export GH_AUTH_OK=1
  export GH_SCOPES="repo,project,read:org,read:user"
  run "$SCRIPT" lightspeedwp testproduct 99
  [ "$status" -eq 0 ]
  assert_output --partial "GitHub CLI is authenticated"
  assert_output --partial "All required scopes are present"
}
