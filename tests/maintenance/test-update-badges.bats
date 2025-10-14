#!/usr/bin/env bats
#
# Test Name: test-update-badges.bats
# Description: Bats tests for update-badges.sh maintenance script.
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
#    - bats test-update-badges.bats
# Test Scope: badge update in README.md.

# Load test helpers
load ../test-helper.bash

@test "update-badges.sh updates badges in README.md" {
	run ../../scripts/maintenance/update-badges.sh
	[ "$status" -eq 0 ]
	[[ $output =~ Badges\ updated\ in\ README\.md ]]
}
