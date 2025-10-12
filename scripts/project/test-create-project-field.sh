
#!/usr/bin/env bash
#
# Script Name: test-create-project-field.sh
# Description: Test to verify build_project_field_cmd and dry-run output for project field creation.
# Usage: ./test-create-project-field.sh
# Author: LightSpeed WP Team
# Date: 2025-10-12
#
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT="$SCRIPT_DIR/update-projects.sh"

# Ensure script is executable
chmod +x "$SCRIPT"

# Source the script to load helper functions without running main
SKIP_MAIN=1 source "$SCRIPT"

PROJECT_OWNER=lightspeedwp
PROJECT_NUMBER=32

# Capture command parts from helper
mapfile -t parts < <(build_project_field_cmd "Priority" "single_select" --options "High,Medium,Low")

echo "Command parts:"
for p in "${parts[@]}"; do
  echo "$p"
done

# Ensure the expected tokens are present (portable grep usage)
printf "%s\n" "${parts[@]}" | grep -E "\bgh\b" && echo "has gh"
printf "%s\n" "${parts[@]}" | grep -E "\bproject\b" && echo "has project"
printf "%s\n" "${parts[@]}" | grep -E "\bfield-create\b" && echo "has field-create"
printf "%s\n" "${parts[@]}" | grep -F -- "--name" && echo "has --name"
printf "%s\n" "${parts[@]}" | grep -F -- "--data-type" && echo "has --data-type"

# Run the script in dry-run (separate process) and show output for inspection
# Use SKIP_MAIN=1 and DRY_RUN=true so the script does not perform network/auth checks
echo "\nRunning script in dry-run to show printed commands:"
DRY_RUN=true SKIP_MAIN=1 "$SCRIPT" --dry-run --project-owner testorg --project-number 123

echo "\nTest complete." 
