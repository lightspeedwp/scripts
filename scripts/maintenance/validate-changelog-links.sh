#!/bin/bash
###############################################################################
#
# Script Name: validate-changelog-links.sh
# Description: Validates that all changelog entries under [Unreleased] include a linked PR, Issue, or Commit
#
# Version: v0.1.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Requirements:
#   - CHANGELOG.md in the root of repo
#   - awk
#   - grep
#
# Usage: ./validate-changelog-links.sh [options]
#
# Environment Variables:
#   None
#
# Options:
#   --help                  Show this help message
#
# Examples:
#   ./validate-changelog-links.sh
#
# Notes:
# - This script ensures all changelog entries include proper links
# - Focuses on the [Unreleased] section for validation
# - Checks for PR references, Issue links, and commit references
# - Returns success only when all entries have proper links
#
###############################################################################

# Fail on errors
set -euo pipefail

# File to validate
CHANGELOG="CHANGELOG.md"

# Ensure CHANGELOG.md exists
if [ ! -f "$CHANGELOG" ]; then
    echo "CHANGELOG.md not found!"
    exit 1 # Exit with error if changelog is missing
fi

###############################################################################
# Function: log_error
# Description: Logs error messages to stderr with an [ERROR] prefix.
#
# Arguments:
#   $* - The error message to log.
#
# Output:
#   Prints the formatted error message to stderr.
###############################################################################
function log_error() {
    echo "[ERROR] $*" >&2
}

###############################################################################
# Function: validate_links
# Description: Validates that all changelog entries under the [Unreleased]
#              section include a linked PR, Issue, or Commit.
#
# Arguments:
#   None
#
# Output:
#   Prints error messages for entries that are missing the required links.
#   Returns 1 if any links are missing, 0 otherwise.
###############################################################################
function validate_links() {
    local missing=0
    local block
    block=$(awk '/^## \[Unreleased\]/{flag=1;next}/^## \[/{flag=0}flag' "$CHANGELOG")

    # Check each entry under each section
    while IFS= read -r line; do
        # Only check lines that look like changelog entries
        if [[ "$line" =~ ^- ]]; then
            # Look for PR (#123), Issue (#123), or Commit ([`abcdef1`](...))
            if ! echo "$line" | grep -Eq '(#[0-9]+|\[PR #[0-9]+\]|\[.*\]\(https://github.com/.*/pull/[0-9]+\)|\[.*\]\(https://github.com/.*/issues/[0-9]+\)|\[.*\]\(https://github.com/.*/commit/[a-f0-9]{7,}\))'; then
                log_error "Missing PR/Issue/Commit link: $line"
                missing=1
            fi
        fi
    done <<< "$block"
    return $missing
}

###############################################################################
# Function: main
# Description: Main function that orchestrates the changelog validation process.
#
# Arguments:
#   None
#
# Output:
#   Prints success or failure messages for the changelog validation.
#   Exits with status 0 on success, 1 on failure.
###############################################################################
main() {
    # Run validation
    validate_links
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Changelog validation failed. Please fix the above issues."
        return 1
    else
        echo "Changelog validation passed."
        return 0
    fi
}

# Execute the main function
main
status=$?

# Done
echo "Done."
exit $status # Exit with the status from main function