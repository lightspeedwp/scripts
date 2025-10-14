

###############################################################################
# Test Name: test-utility-functions.bats
# Description: Bats test suite for utility-functions.sh script. Validates sourcing, branch detection, git repo checks, and file existence functions. Ensures compliance with LightSpeed WP standards for shell script documentation and test coverage.
# Version: v0.1.0
# Date: 2025-10-15
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Requirements:
#    - bats-core
#    - test-helper.bash
# Usage:
#    - bats tests/utility/test-utility-functions.bats
# Environment Variables:
#    None
# Options:
#    None
# Examples:
#    bats tests/utility/test-utility-functions.bats
# Notes:
#    - All core functions are tested
#    - Paths are resolved relative to test file
#    - Expand tests as new features are added
# Test Scope:
#    - Validates sourcing, branch detection, git repo checks, file existence
###############################################################################


# Load test helpers
load '../test-helper.bash'


# ----- Section: Sourcing and Basic Functionality Tests -----
###############################################################################
# Test Name: "utility-functions.sh sources without error"
# Test Type: Sourcing
# Test Scope: Verifies that utility-functions.sh can be sourced without error.
###############################################################################
@test "utility-functions.sh sources without error" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh'
  [ "$status" -eq 0 ]
}

###############################################################################
# Test Name: "get_current_branch returns a branch name"
# Test Type: Branch Detection
# Test Scope: Verifies that get_current_branch returns a valid branch name.
###############################################################################
@test "get_current_branch returns a branch name" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; get_current_branch'
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[a-zA-Z0-9._/-]+$ ]]
}


# ----- Section: Git Repo Detection Tests -----
###############################################################################
# Test Name: "is_git_repo returns 0 in a git repo"
# Test Type: Git Repo Detection
# Test Scope: Verifies that is_git_repo returns 0 when in a git repository.
###############################################################################
@test "is_git_repo returns 0 in a git repo" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; is_git_repo'
  [ "$status" -eq 0 ]
}

###############################################################################
# Test Name: "is_git_repo returns 1 outside a git repo"
# Test Type: Git Repo Detection
# Test Scope: Verifies that is_git_repo returns 1 when outside a git repository.
###############################################################################
@test "is_git_repo returns 1 outside a git repo" {
  run bash -c 'cd /tmp && source ../../scripts/scripts/utility/utility-functions.sh; is_git_repo'
  [ "$status" -eq 1 ]
}


# ----- Section: File Existence Tests -----
###############################################################################
# Test Name: "file_exists returns 0 for existing file"
# Test Type: File Existence
# Test Scope: Verifies that file_exists returns 0 for an existing file.
###############################################################################
@test "file_exists returns 0 for existing file" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; file_exists ../test-helper.bash'
  [ "$status" -eq 0 ]
}

###############################################################################
# Test Name: "file_exists returns 1 for non-existing file"
# Test Type: File Existence
# Test Scope: Verifies that file_exists returns 1 for a non-existing file.
###############################################################################
@test "file_exists returns 1 for non-existing file" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; file_exists /nonexistentfile'
  [ "$status" -eq 1 ]
}
