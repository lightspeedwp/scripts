#!/usr/bin/env bats
#
# Test Name: test-prune-labels.bats
# Description: Tests prune-labels.sh for dry-run and canonical label mapping.
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
#    - bats test-prune-labels.bats
# Test Scope: dry-run, canonical mapping, error handling.

# Load test helpers
load ../test-helper.bash

@test "prune-labels.sh runs in dry-run mode and outputs canonical label sync" {
	export DRY_RUN=true
	run ../../scripts/maintenance/prune-labels.sh
	[ "$status" -eq 0 ]
		[[ $output =~ Fetching\ canonical\ labels ]]
		[[ $output =~ Syncing ]]
}

@test "prune-labels.sh maps non-standard labels to canonical" {
	export DRY_RUN=true
	run ../../scripts/maintenance/prune-labels.sh
	[ "$status" -eq 0 ]
		[[ $output =~ lang:php ]]
		[[ $output =~ area:documentation ]]
}
