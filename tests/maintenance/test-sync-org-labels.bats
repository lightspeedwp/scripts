#!/usr/bin/env bats
#
# Test Name: test-sync-org-labels.bats
# Description: Tests sync-org-labels.sh for dry-run and label sync output
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
#    - bats test-sync-org-labels.bats
# Test Scope: dry-run, label sync, error handling.

# Load test helpers
load ../test-helper.bash

setup() {
  # Get the root directory of the repository
  local REPO_ROOT
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  # Path to the script being tested
  SCRIPT="$REPO_ROOT/scripts/maintenance/sync-org-labels.sh"

  # Ensure script exists and is executable
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

# ============================================================================
# Test Name: sync-org-labels.sh runs in dry-run mode and outputs label sync
# Test Type: Functional
# Test Scope: Verifies that the sync-org-labels.sh script runs in dry-run mode and outputs label sync.
# ============================================================================
@test "sync-org-labels.sh runs in dry-run mode and outputs label sync" {
	export DRY_RUN=true
	run "$SCRIPT"
	[ "$status" -eq 0 ]
		[[ $output =~ Fetching ]]
		[[ $output =~ Syncing ]]
}
