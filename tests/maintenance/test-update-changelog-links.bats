#!/usr/bin/env bats
#
# Test Name: test-update-changelog-links.bats
# Description: Bats tests for validate-changelog-links.sh maintenance script.
# Requirements:
#    - bats-core
#    - test-helper.bash
# Usage:
#    - bats test-update-changelog-links.bats
# Test Scope: changelog link validation.

# Load test helpers
load ../test-helper.bash

@test "validate-changelog-links.sh reports missing links" {
	run ../../scripts/maintenance/validate-changelog-links.sh
	[ "$status" -eq 0 ] || [[ $output =~ Missing\ PR/Issue/Commit\ link ]]
}
