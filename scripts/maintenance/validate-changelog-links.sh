#!/bin/bash

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
# Requirements: CHANGELOG.md in the root of repo
#
# Usage: ./validate-changelog-links.sh
#
# Options:
#
#
# Note:
#   -

# Fail on errors
set -euo pipefail

# File to validate
CHANGELOG="CHANGELOG.md"

# Ensure CHANGELOG.md exists
if [ ! -f "$CHANGELOG" ]; then
    echo "CHANGELOG.md not found!"
    exit 1 # Exit with error if changelog is missing
fi

# Logging function
function log_error() {
    echo "[ERROR] $*" >&2
}

# Validate links in changelog
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

# Run validation
validate_links
if [ $? -ne 0 ]; then
    echo "Changelog validation failed. Please fix the above issues."
else
    echo "Changelog validation passed."
fi

# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
