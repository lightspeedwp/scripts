#!/bin/bash

# Script Name: test-pr-labeler.sh
# Description: Simple test script to verify PR labeler workflow
#
# Version: v0.1.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Requirements: Requires bats-core to be installed.
# Usage: ./test-pr-labeler.sh
# Options:
#   --help                  Show this help message
#

# Fail on errors
set -euo pipefail

# Simple output to verify the script runs
echo "This is a test script to verify PR labeler workflow"
echo "PR should be labeled with 'scripts' automatically"

# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
