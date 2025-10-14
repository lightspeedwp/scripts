#!/usr/bin/env bats
#
# Test Name: test-update-readme-and-changelog.bats
# Description: Tests update-readme-and-changelog.sh for updating README and CHANGELOG files.
# Requirements:
#    - bats-core
#    - test-helper.bash
# Usage:
#    - bats test-update-readme-and-changelog.bats
# Test Scope: README and CHANGELOG file updating.

# Load test helpers
load ../test-helper.bash

@test "update-readme-and-changelog.sh updates README and CHANGELOG" {
	run ../../scripts/maintenance/update-readme-and-changelog.sh
	[ "$status" -eq 0 ]
	[[ $output =~ Badges\ updated\ in\ README\. ]]
}

@test "test-pr-labeler.sh outputs labeler message and exits 0" {
	run ../../scripts/maintenance/test-pr-labeler.sh
	[ "$status" -eq 0 ]
	[[ $output =~ PR\ should\ be\ labeled\ with\ 'scripts' ]]
}
