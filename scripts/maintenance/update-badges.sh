
#!/bin/bash
#
# Script Name: update-badges.sh
# Description: Updates workflow badges in README.md for all workflows in the repository.
# Usage: ./update-badges.sh
# Author: LightSpeed WP Team
# Date: 2025-10-12
#
set -euo pipefail

REPO="lightspeedwp/scripts"
BRANCH="develop"
README="README.md"
BADGES_START="<!-- BADGES-START -->"
BADGES_END="<!-- BADGES-END -->"

# Find all workflow files
declare -a BADGES
for wf in .github/workflows/*.yml; do
  WF_NAME=$(basename "$wf" .yml)
  BADGE_URL="https://github.com/$REPO/actions/workflows/$WF_NAME.yml/badge.svg?branch=$BRANCH"
  BADGES+=("<a href=\"https://github.com/$REPO/actions/workflows/$WF_NAME.yml\"><img src=\"$BADGE_URL\" alt=\"$WF_NAME\" /></a>")
done

# Build badges block
BADGES_BLOCK="$BADGES_START\n"
for badge in "${BADGES[@]}"; do
  BADGES_BLOCK+="$badge\n"
done
BADGES_BLOCK+="$BADGES_END"

# Update README.md badges section
awk -v badges="$BADGES_BLOCK" -v start="$BADGES_START" -v end="$BADGES_END" '
  BEGIN {printed=0}
  {if ($0 ~ start) {print badges; printed=1} else if ($0 ~ end) {if (!printed) print badges; printed=1} else if (!printed) print $0}
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "Badges updated in $README."
