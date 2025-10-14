
#!/bin/bash
###############################################################################
#
# Script Name: update-readme-and-changelog.sh
# Description: Updates README.md with table of contents, contributors, workflow badges, and regenerates CHANGELOG.md.
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
#   - Node.js and npm
#   - markdown-toc package
#   - all-contributors-cli package
#   - auto-changelog package
#   - awk
#   - find
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
# - This script updates documentation files automatically
# - Generates table of contents for README.md
# - Updates contributor lists using all-contributors
# - Generates CHANGELOG.md from git history
# - Updates workflow badges in README.md
#
###############################################################################

# Fail on errors
set -euo pipefail

###############################################################################
# Function: update_workflow_badges
# Description: Updates workflow badges in README.md for all GitHub Action workflows.
# Arguments:
#   None
# Output:
#   Updated README.md with workflow badges.
# Notes:
#   Uses HTML comment markers to locate the badge section.
#   Automatically detects all workflow files in .github/workflows/.
###############################################################################
function update_workflow_badges() {
  local repo="lightspeedwp/scripts"
  local branch="develop"
  local readme="README.md"
  local badges_start="<!-- BADGES-START -->"
  local badges_end="<!-- BADGES-END -->"

  local badges=()
  for wf in .github/workflows/*.yml; do
    local wf_name
    wf_name=$(basename "$wf" .yml)
    local badge_url="https://github.com/$repo/actions/workflows/$wf_name.yml/badge.svg?branch=$branch"
    badges+=("<a href=\"https://github.com/$repo/actions/workflows/$wf_name.yml\"><img src=\"$badge_url\" alt=\"$wf_name\" /></a>")
  done

  # Call the update_section function
  update_section "$readme" "$badges_start" "$badges_end" "${badges[@]}"
  echo "Badges updated in $readme."
}

###############################################################################
# Function: update_section
# Description: Updates a section in a file between two marker comments.
# Arguments:
#   $1 - File path
#   $2 - Start marker string
#   $3 - End marker string
#   $@ - Content items to place between markers (each as separate line)
# Output:
#   Updated file with new content between markers.
# Notes:
#   Uses awk to safely update the file with new content.
#   Preserves all content outside the markers.
###############################################################################
function update_section() {
  local file="$1"
  local start_marker="$2"
  local end_marker="$3"
  shift 3
  local items=("$@")
  
  local content_block="$start_marker\n"
  for item in "${items[@]}"; do
    content_block+="$item\n"
  done
  content_block+="$end_marker"
  
  awk -v content="$content_block" -v start="$start_marker" -v end="$end_marker" '
    BEGIN {printed=0}
    $0 ~ start {print content; printed=1; next}
    $0 ~ end {if (!printed) print content; printed=1; next}
    !printed {print}
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

###############################################################################
# Function: generate_instructions_table
# Description: Generates a table of Copilot instruction files with descriptions.
# Arguments:
#   None
# Output:
#   Markdown table for insertion into documentation files.
# Notes:
#   Handles specific file types with custom descriptions.
#   Updates both README.md and copilot-instructions.md.
###############################################################################
function generate_instructions_table() {
  local instructions_table_start="<!-- INSTRUCTIONS-TABLE-START -->"
  local instructions_table_end="<!-- INSTRUCTIONS-TABLE-END -->"
  
  # Find Copilot instructions, prompts, chat modes, and agent files
  local instruction_files=(
    ".github/copilot-instructions.md"
    ".github/custom-instructions.md"
    ".github/prompts/prompts.md"
    ".github/chatmodes/chatmodes.md"
    ".github/instructions/contributor-types.md"
    ".github/instructions/shell-script-copilot.md"
    ".github/instructions/markdown-copilot.md"
    ".github/instructions/js-copilot.md"
    ".github/instructions/python-copilot.md"
    ".github/instructions/playwright-copilot.md"
  )

  # Table header
  local table="${instructions_table_start}\n| File | Purpose |\n|------|---------|\n"

  # Add each file and a brief description
  for f in "${instruction_files[@]}"; do
    local desc
    case "$f" in
      *.github/copilot-instructions.md)
        desc="Main Copilot & CodeRabbit integration, file index, and standards cross-reference";;
      *.github/custom-instructions.md)
        desc="Copilot custom instructions, role-based configuration";;
      *.github/prompts/prompts.md)
        desc="Reusable prompt templates for Copilot Chat/CLI";;
      *.github/chatmodes/chatmodes.md)
        desc="Scenario-based chat modes for development contexts";;
      *.github/instructions/contributor-types.md)
        desc="Role-specific contributor standards and prompts";;
      *.github/instructions/shell-script-copilot.md)
        desc="Shell script automation standards and patterns";;
      *.github/instructions/markdown-copilot.md)
        desc="Markdown/documentation standards and accessibility";;
      *.github/instructions/js-copilot.md)
        desc="JavaScript/Node.js workflow standards";;
      *.github/instructions/python-copilot.md)
        desc="Python scripting standards";;
      *.github/instructions/playwright-copilot.md)
        desc="Playwright-specific Copilot instructions and MCP server automation";;
      *)
        desc="Copilot/agent instructions";;
    esac
    table+="| [$f]($f) | $desc |\n"
  done
  table+="${instructions_table_end}"
  
  # Update README.md
  update_section "README.md" "$instructions_table_start" "$instructions_table_end" "$table"
  
  # Update copilot-instructions.md
  update_section ".github/copilot-instructions.md" "$instructions_table_start" "$instructions_table_end" "$table"
  
  echo "Instructions tables updated in README.md and copilot-instructions.md"
}

###############################################################################
# Function: commit_changes
# Description: Commits and pushes changes to README and CHANGELOG if any changes exist.
# Arguments:
#   None
# Output:
#   Git commit message and status.
# Notes:
#   Uses [skip ci] to prevent triggering CI/CD pipelines.
#   Only commits if actual changes are detected.
###############################################################################
function commit_changes() {
  # Stage changes
  git add README.md CHANGELOG.md .github/copilot-instructions.md
  
  # Commit if there are changes
  if ! git diff --cached --quiet; then
    git commit -m "docs: update README and changelog [skip ci]"
    git push
    echo "Changes committed and pushed."
  else
    echo "No changes to commit."
  fi
}

###############################################################################
# Function: main
# Description: Main execution function to coordinate document updates.
# Arguments:
#   None
# Output:
#   Coordinated execution of all document update functions.
# Notes:
#   Ensures proper sequence of operations.
#   Handles errors gracefully to prevent CI/CD failures.
###############################################################################
function main() {
  echo "Starting documentation update process..."
  
  # Find and print all README files
  echo "Scanning for README files..."
  find . -type f -iname 'README*.md'
  
  # Update table of contents
  echo "Updating table of contents..."
  npx markdown-toc -i README.md
  
  # Update contributors
  echo "Updating contributors..."
  npx all-contributors generate
  
  # Update CHANGELOG.md
  echo "Updating changelog..."
  npx auto-changelog -p --commit-limit 20 --output CHANGELOG.md
  
  # Update workflow badges
  update_workflow_badges
  
  # Update instructions tables
  generate_instructions_table
  
  # Commit changes
  commit_changes
  
  echo "Documentation update complete."
}

# Execute main function
main

# Done
echo "Done."
exit 0 # Always exit 0 to not break CI/CD, errors are logged above
