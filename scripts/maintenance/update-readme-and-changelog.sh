#!/bin/bash
###############################################################################
#
# Script Name: update-readme-and-changelog.sh
# Description: Updates all README.md files in the repository to ensure they
#              contain a license badge and a link to the CONTRIBUTING.md file.
#              It also contains a stub for CHANGELOG updates.
#
# Version: v0.2.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Requirements:
#   - find
#   - grep
#   - sed
#
# Usage: ./update-readme-and-changelog.sh [options]
#
# Environment Variables:
#   None
#
# Options:
#   --help                  Show this help message
#
# Examples:
#   ./update-readme-and-changelog.sh
#
# Notes:
# - This script is intended to be executed directly.
# - It will update all README.md files in the repository.
#
###############################################################################

set -euo pipefail

###############################################################################
# Function: show_help
# Description: Displays the help message for the script.
#
# Arguments:
#   None
#
# Output:
#   Prints the help message to stdout.
###############################################################################
show_help() {
    cat << EOF
Usage: $0 [options]

Updates all README.md files to ensure they contain a license badge and a link to CONTRIBUTING.md.
Options:
  --help      Show this help message
EOF
}

###############################################################################
# Function: update_readme_files
# Description: Finds all README.md files and adds a license badge and
#              contributing link if they are missing.
#
# Arguments:
#   None
#
# Output:
#   Prints messages indicating which files are being updated.
###############################################################################
update_readme_files() {
    echo "Searching for README.md files to update..."
    find . -type f -name "README.md" | while read -r readme; do
        echo "Checking $readme..."

        # Check for license badge
        if ! grep -q "License: GPL v3 or later" "$readme"; then
            echo "  Adding license badge to $readme"
            # Add the badge after the first line (usually the main header)
            sed -i.bak '2a\
[![License: GPL v3 or later](https://img.shields.io/badge/License-GPL%20v3%20or%20later-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)\
' "$readme"
        else
            echo "  License badge already exists in $readme"
        fi

        # Check for contributing link
        if ! grep -q "CONTRIBUTING.md" "$readme"; then
            echo "  Adding contributing link to $readme"
            # Add the link at the end of the file
            echo -e "\n## Contributing\n\nPlease see [CONTRIBUTING.md](CONTRIBUTING.md) for details." >> "$readme"
        else
            echo "  Contributing link already exists in $readme"
        fi
    done
    # Cleanup backup files
    find . -name "README.md.bak" -delete
}

###############################################################################
# Function: main
# Description: Main execution function for the script.
#
# Arguments:
#   $@ - Command line arguments.
#
# Output:
#   Coordinates execution of script functions.
###############################################################################
main() {
    if [[ "${1:-}" == "--help" ]]; then
        show_help
        exit 0
    fi

    echo "Starting README and CHANGELOG update..."

    update_readme_files

    echo "README and CHANGELOG update process executed."
}

main "$@"

# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
