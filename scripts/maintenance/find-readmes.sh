
#!/bin/bash

# Script Name: find-readmes.sh
# Description: Finds all README files in the repository.
#
# Version: v0.1.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Requirements: None
#
# Usage: ./find-readmes.sh [options]
#
# Options:
#   --help                  Show this help message
#
# Examples:
#   ./find-readmes.sh
#   ./find-readmes.sh --help
#
# Notes:
# - This script is intended to be executed directly.
# - It will search for all README files in the current directory and its subdirectories.

# Fail on errors
set -euo pipefail

# Find all README files in the repo
find . -type f -iname 'README*.md'

# Cleanup if needed
# (Add any necessary cleanup commands here)
# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
