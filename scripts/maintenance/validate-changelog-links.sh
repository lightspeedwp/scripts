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

set -euo pipefail

CHANGELOG="CHANGELOG.md"

function log_error() {
    echo "[ERROR] $*" >&2
}

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

validate_links
