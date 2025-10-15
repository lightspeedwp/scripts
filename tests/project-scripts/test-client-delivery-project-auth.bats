#!/usr/bin/env bats
# ============================================================================
# Test Suite: test-client-delivery-project-auth.bats
# Description: Authentication and scope validation tests for client-delivery-project.sh
# Version: v0.1.0
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
#    - npx bats tests/project-scripts/test-client-delivery-project-auth.bats
# Test Scope: GitHub CLI authentication, required scopes, error handling.
# ============================================================================

# Load node modules
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

# ============================================================================
# BATS TEST: client-delivery-project.sh authentication and scope checks
#
# This test file verifies the authentication and scope-checking logic of the
# client-delivery-project.sh script. It uses mock environment variables to
# simulate various scenarios, including:
#
# - GitHub CLI not installed
# - Not authenticated with GitHub CLI
# - Missing required OAuth scopes
# - Successful authentication with all required scopes
#
# These tests ensure that the script fails gracefully when authentication
# requirements are not met and proceeds only when they are.
#
# Test Environment:
# - GH_CLI_MOCK=1: Enables mock mode to prevent real API calls.
# - GH_AUTH_FAIL=1: Simulates authentication failure.
# - GH_SCOPES: Simulates specific OAuth scopes.
# - PATH: Modified to simulate gh CLI not being installed.
#
# For more details on the script being tested, see:
# ./scripts/project/client-delivery-project.sh
#
# To run these tests:
# npx bats tests/project-scripts/test-client-delivery-project-auth.bats
#
# Related files:
# - scripts/project/client-delivery-project.sh
# - scripts/project/update-projects.sh
# - docs/update-projects/client-delivery-field-specs-v1-1.md
# ============================================================================

# --- SETUP & TEARDOWN ---

setup() {
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    SCRIPT="$DIR/../../scripts/project/client-delivery-project.sh"
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
    # Restore original PATH
    if [ -n "${ORIGINAL_PATH-}" ]; then
        export PATH="$ORIGINAL_PATH"
        unset ORIGINAL_PATH
    fi
}

# --- TEST CASES ---

# ============================================================================
# @test "errors if gh CLI is not installed"
# ============================================================================
# Simulates an environment where the GitHub CLI is not installed or not in the PATH.
# Verifies that the script exits with status 1 and reports the missing dependency.
#
# Environment:
#   - PATH: Prepended with a non-existent directory to simulate gh not being found.
#   - GH_CLI_MOCK: Enabled to prevent real API calls.
#
# Assertions:
#   - Exit status is 1.
#   - Output contains "GitHub CLI (gh) is not installed".
# ============================================================================
@test "errors if gh CLI is not installed" {
  export ORIGINAL_PATH="$PATH"
  export PATH="/nonexistent:$PATH"
  run "$SCRIPT" lightspeedwp testclient 99
  [ "$status" -eq 1 ]
  assert_output --partial "GitHub CLI (gh) is not installed"
}

# ============================================================================
# @test "errors if not authenticated with gh CLI"
# ============================================================================
# Simulates a scenario where the user is not authenticated with the GitHub CLI.
# Verifies that the script exits with status 1 and prompts the user to log in.
#
# Environment:
#   - GH_AUTH_FAIL: Set to 1 to simulate authentication failure.
# ============================================================================
@test "errors if not authenticated with gh CLI" {
  export GH_AUTH_FAIL=1
  run "$SCRIPT" lightspeedwp testclient 99
  [ "$status" -eq 1 ]
  assert_output --partial "GitHub CLI is not authenticated"
}

# ============================================================================
# @test "errors if required scopes are missing"
# ============================================================================
# Simulates a scenario where the authenticated user is missing required OAuth scopes.
# Verifies that the script exits with status 1 and lists the missing scopes.
#
# Environment:
#   - GH_SCOPES: Set to a subset of required scopes.
# ============================================================================
@test "errors if required scopes are missing" {
  export GH_SCOPES="read:user"
  run "$SCRIPT" lightspeedwp testclient 99
  [ "$status" -eq 1 ]
  assert_output --partial "Missing required GitHub CLI scopes"
}

# ============================================================================
# @test "succeeds if authenticated and all scopes present"
# ============================================================================
# Simulates a successful authentication scenario with all required scopes.
# Verifies that the script proceeds past the authentication checks.
#
# Environment:
#   - GH_AUTH_OK: Set to 1 to simulate successful authentication.
#   - GH_SCOPES: Set to include all required scopes.
# ============================================================================
@test "succeeds if authenticated and all scopes present" {
  export GH_AUTH_OK=1
  export GH_SCOPES="repo,project,read:org,read:user"
  run "$SCRIPT" lightspeedwp testclient 99
  [ "$status" -eq 0 ]
  assert_output --partial "GitHub CLI is authenticated"
  assert_output --partial "All required scopes are present"
}
