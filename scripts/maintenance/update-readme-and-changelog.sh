#!/bin/bash
set -euo pipefail

# Find and print all README files in the repo
echo "Scanning for README files..."
find . -type f -iname 'README*.md'


# Update table of contents in README.md
npx markdown-toc -i README.md

# Update contributors table in README
npx all-contributors generate

# Update CHANGELOG.md
npx auto-changelog -p --commit-limit 20 --output CHANGELOG.md

# Update workflow badges in README.md
REPO="lightspeedwp/scripts"
BRANCH="develop"
README="README.md"
BADGES_START="<!-- BADGES-START -->"
BADGES_END="<!-- BADGES-END -->"

BADGES=()
for wf in .github/workflows/*.yml; do
  WF_NAME=$(basename "$wf" .yml)
  BADGE_URL="https://github.com/$REPO/actions/workflows/$WF_NAME.yml/badge.svg?branch=$BRANCH"
  BADGES+=("<a href=\"https://github.com/$REPO/actions/workflows/$WF_NAME.yml\"><img src=\"$BADGE_URL\" alt=\"$WF_NAME\" /></a>")
done

BADGES_BLOCK="$BADGES_START\n"
for badge in "${BADGES[@]}"; do
  BADGES_BLOCK+="$badge\n"
done
BADGES_BLOCK+="$BADGES_END"

awk -v badges="$BADGES_BLOCK" -v start="$BADGES_START" -v end="$BADGES_END" '
  BEGIN {printed=0}
  {if ($0 ~ start) {print badges; printed=1} else if ($0 ~ end) {if (!printed) print badges; printed=1} else if (!printed) print $0}
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "Badges updated in $README."

# --- Copilot/Agent Instructions Table Generation ---
INSTRUCTIONS_TABLE_START="<!-- INSTRUCTIONS-TABLE-START -->"
INSTRUCTIONS_TABLE_END="<!-- INSTRUCTIONS-TABLE-END -->"

# Find Copilot instructions, prompts, chat modes, and agent files
INSTRUCTION_FILES=(
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
INSTRUCTIONS_TABLE="${INSTRUCTIONS_TABLE_START}\n| File | Purpose |\n|------|---------|\n"

# Add each file and a brief description
for f in "${INSTRUCTION_FILES[@]}"; do
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
  INSTRUCTIONS_TABLE+="| [$f]($f) | $desc |\n"
done
INSTRUCTIONS_TABLE+="${INSTRUCTIONS_TABLE_END}"

# Insert table into README.md after the main documentation/meta files table
awk -v table="$INSTRUCTIONS_TABLE" -v start="<!-- INSTRUCTIONS-TABLE-START -->" -v end="<!-- INSTRUCTIONS-TABLE-END -->" '
  BEGIN {printed=0}
  {if ($0 ~ start) {print table; printed=1} else if ($0 ~ end) {if (!printed) print table; printed=1} else if (!printed) print $0}
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

# Also update copilot-instructions.md with the new table
awk -v table="$INSTRUCTIONS_TABLE" -v start="<!-- INSTRUCTIONS-TABLE-START -->" -v end="<!-- INSTRUCTIONS-TABLE-END -->" '
  BEGIN {printed=0}
  {if ($0 ~ start) {print table; printed=1} else if ($0 ~ end) {if (!printed) print table; printed=1} else if (!printed) print $0}
' .github/copilot-instructions.md > .github/copilot-instructions.tmp && mv .github/copilot-instructions.tmp .github/copilot-instructions.md

# Stage changes
git add README.md CHANGELOG.md

# Commit if there are changes
if ! git diff --cached --quiet; then
  git commit -m "docs: update README and changelog [skip ci]"
  git push
else
  echo "No changes to commit."
fi
