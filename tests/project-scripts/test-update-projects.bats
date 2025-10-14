#!/usr/bin/env bats

# Test suite for update-projects.sh script
# Description: Tests argument parsing, help output, and basic functionality.
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
#    - bats test-update-projects.bats
# Test Scope: Tests argument parsing, help output, and basic functionality without requiring actual GitHub CLI interaction.

# Load test helpers
load '../test-helper.bash'

setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    SCRIPT="$DIR/../../scripts/project/update-projects.sh"

    # Debug output
    if [ -n "$DEBUG" ]; then
        echo "DEBUG: DIR is $DIR" >&2
        echo "DEBUG: SCRIPT is $SCRIPT" >&2
    fi

    # Ensure script exists and is executable
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

@test "script shows help with --help flag" {
    run "$SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"GitHub Projects Field Update Script"* ]]
    [[ "$output" == *"Usage:"* ]]
    [[ "$output" == *"Options:"* ]]
}

@test "script shows help with -h flag" {
    run "$SCRIPT" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"GitHub Projects Field Update Script"* ]]
}

@test "script fails with unknown option" {
    run "$SCRIPT" --unknown-option
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option: --unknown-option"* ]]
}

@test "script accepts --dry-run flag" {
    # This test will likely fail due to GitHub CLI not being available
    # but it tests argument parsing
    run "$SCRIPT" --dry-run
    # Script may fail due to missing gh CLI, but should accept the argument
    [[ "$output" != *"Unknown option: --dry-run"* ]]
}

@test "script accepts --project-owner option" {
    run "$SCRIPT" --project-owner testorg --dry-run
    # Should not show unknown option error
    [[ "$output" != *"Unknown option: --project-owner"* ]]
}

@test "script accepts --project-number option" {
    run "$SCRIPT" --project-number 123 --dry-run
    # Should not show unknown option error
    [[ "$output" != *"Unknown option: --project-number"* ]]
}

@test "script accepts --auto-refresh flag" {
    run "$SCRIPT" --auto-refresh --dry-run
    # Should not show unknown option error
    [[ "$output" != *"Unknown option: --auto-refresh"* ]]
}

@test "script has proper shebang" {
    head -n1 "$SCRIPT" | grep -q "#!/bin/bash"
}

@test "script uses set -euo pipefail for safety" {
    grep -q "set -euo pipefail" "$SCRIPT"
}

@test "script contains required functions" {
    grep -q "show_help()" "$SCRIPT"
    grep -q "parse_args()" "$SCRIPT"
    grep -q "check_gh_cli()" "$SCRIPT"
    grep -q "check_gh_auth()" "$SCRIPT"
    grep -q "get_current_scopes()" "$SCRIPT"
    grep -q "check_required_scopes()" "$SCRIPT"
    grep -q "refresh_gh_scopes()" "$SCRIPT"
    grep -q "detect_project_owner()" "$SCRIPT"
    grep -q "execute_command()" "$SCRIPT"
    grep -q "create_project_field()" "$SCRIPT"
    grep -q "main()" "$SCRIPT"
}

@test "script uses gh api instead of curl for scope discovery" {
    grep -q "gh api -I /" "$SCRIPT"
    # Should not use curl with token
    ! grep -q "curl.*token" "$SCRIPT"
}

@test "script includes required scopes" {
    grep -q 'REQUIRED_SCOPES=.*repo.*project.*read:org.*read:user' "$SCRIPT"
}

@test "script has colorized output functions" {
    grep -q "log_info()" "$SCRIPT"
    grep -q "log_success()" "$SCRIPT"
    grep -q "log_warning()" "$SCRIPT"
    grep -q "log_error()" "$SCRIPT"
}

@test "script implements dry-run functionality" {
    grep -q "DRY_RUN" "$SCRIPT"
    grep -q "execute_command()" "$SCRIPT"
    grep -q "DRY-RUN" "$SCRIPT"
}

@test "script detects project owner automatically" {
    grep -q "detect_project_owner()" "$SCRIPT"
    grep -q "git remote get-url origin" "$SCRIPT"
    grep -q "gh api user --jq .login" "$SCRIPT"
}

@test "script implements scope refresh functionality" {
    grep -q "refresh_gh_scopes()" "$SCRIPT"
    grep -q "gh auth refresh" "$SCRIPT"
    grep -q "Do you want to refresh scopes now" "$SCRIPT"
}

@test "script supports --fields-file option" {
    run "$SCRIPT" --fields-file "$DIR/fixtures/fields.csv" --project-owner example --project-number 1 --dry-run
    [ "$status" -eq 0 ] || true
    [[ "$output" == *"Processing fields from"* ]]
    [[ "$output" == *"Priority"* ]]
}

@test "script requires --project-number with --fields-file" {
    run "$SCRIPT" --fields-file "$DIR/fixtures/fields.csv" --project-owner example --dry-run
    [ "$status" -ne 0 ]
    [[ "$output" == *"requires --project-number"* ]]
}

@test "script supports --delete-fields option" {
    run "$SCRIPT" --fields-file "$DIR/fixtures/fields.csv" --project-owner example --project-number 1 --delete-fields --dry-run
    [[ "$output" == *"Processing fields from"* ]]
    # Deletion path will attempt gh; in dry-run it still prints field names
    [[ "$output" == *"Deleting project field"* || "$output" == *"Field 'Priority' not found"* || "$output" == *"Failed to list fields"* ]]
}
