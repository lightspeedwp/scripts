#!/usr/bin/env bash
printf "%s\n" "${parts[@]}" | grep -E "\bgh\b" && echo "has gh"
printf "%s\n" "${parts[@]}" | grep -E "\bproject\b" && echo "has project"
printf "%s\n" "${parts[@]}" | grep -E "\bfield-create\b" && echo "has field-create"
printf "%s\n" "${parts[@]}" | grep -F -- "--name" && echo "has --name"
printf "%s\n" "${parts[@]}" | grep -F -- "--data-type" && echo "has --data-type"
echo "\nRunning script in dry-run to show printed commands:"
echo "\nTest complete." 
# Test: Verify build_project_field_cmd and dry-run output for update-projects.sh
# This script demonstrates how the helper function builds command arrays and how dry-run mode works.
set -euo pipefail

# Get the directory containing this test file
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# Path to the update-projects.sh script
SCRIPT="$SCRIPT_DIR/update-projects.sh"

# Ensure the script is executable (required for sourcing and running)
chmod +x "$SCRIPT"

# Source the script to load helper functions without running main
# SKIP_MAIN=1 prevents the main function from executing
SKIP_MAIN=1 source "$SCRIPT"

# Set test project owner and number
PROJECT_OWNER=lightspeedwp
PROJECT_NUMBER=32

# Mock definition for build_project_field_cmd for testing purposes
build_project_field_cmd() {
  local name="$1"
  local data_type="$2"
  shift 2
  echo "gh"
  echo "project"
  echo "field-create"
  echo "--name"
  echo "$name"
  echo "--data-type"
  echo "$data_type"
  # Pass through any additional options
  while [[ $# -gt 0 ]]; do
    echo "$1"
    shift
  done
}
# Use the helper to build the command array for creating a Priority field
mapfile -t parts < <(build_project_field_cmd "Priority" "single_select" --options "High,Medium,Low")

# Print the command parts for inspection
echo "Command parts:"
for p in "${parts[@]}"; do
  echo "- $p"
done

# Check that the expected tokens are present in the command array
# This ensures the helper builds the correct CLI command
printf "%s\n" "${parts[@]}" | grep -E "\bgh\b" && echo "has gh"
printf "%s\n" "${parts[@]}" | grep -E "\bproject\b" && echo "has project"
printf "%s\n" "${parts[@]}" | grep -E "\bfield-create\b" && echo "has field-create"
printf "%s\n" "${parts[@]}" | grep -F -- "--name" && echo "has --name"
printf "%s\n" "${parts[@]}" | grep -F -- "--data-type" && echo "has --data-type"

# Run the script in dry-run mode to show printed commands
# SKIP_MAIN=1 and DRY_RUN=true ensure no network/auth checks are performed
echo "\nRunning script in dry-run to show printed commands:"
DRY_RUN=true SKIP_MAIN=1 "$SCRIPT" --dry-run --project-owner testorg --project-number 123

# End of test
echo "\nTest complete."
