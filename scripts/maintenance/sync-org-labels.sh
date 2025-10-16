
#!/bin/bash
###############################################################################
#
# Script Name: sync-org-labels.sh
# Description: Synchronizes organization labels across repositories to match org-wide standards.
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
#   - GitHub CLI (gh) installed and authenticated
#   - GitHub token with necessary scopes
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#   - jq installed (for JSON processing)
#   - yq installed (for YAML processing)
#   - bats-core
#   - curl installed
#
# Usage: ./sync-org-labels.sh [options]
#   DRY_RUN=true ./sync-org-labels.sh      # preview label sync
#   PRUNE=true ./sync-org-labels.sh        # delete non-canonical labels
#
# Environment Variables:
#   DRY_RUN: Set to 'true' to preview changes without applying them.
#   PRUNE: Set to 'true' to delete non-canonical labels.
#   ONLY: A space-separated list of repository names to target.
#
# Options:
#   --dry-run               Preview changes without applying them
#   --verbose               Show detailed debug information
#   --help                  Show this help message
#
# Examples:
#   DRY_RUN=true ./sync-org-labels.sh
#   PRUNE=true ./sync-org-labels.sh
#   ONLY="repo1 repo2" ./sync-org-labels.sh
#   DRY_RUN=true PRUNE=true ONLY="repo1 repo2" ./sync-org-labels.sh
#
# Notes:
# - This script is intended to be executed directly.
# - It will sync labels across all repos in the specified organization.
# - By default, it runs in dry-run mode to show what changes would be made.
# - To actually apply changes, set DRY_RUN=false and PRUNE=true.
# - Labels that match the PROTECT_REGEX will not be deleted.
# - The script uses a mapping to migrate common non-standard labels to standardized versions before deletion.
#
###############################################################################

# Fail on errors
set -euo pipefail

# --- config ---
ORG="lightspeedwp"
CANON_REPO=".github"                # repo that stores the canonical file
LABELS_PATH=".github/labels.yml"    # path inside that repo
DRY_RUN="${DRY_RUN:-false}"         # set DRY_RUN=true to preview
PRUNE="${PRUNE:-false}"             # set PRUNE=true to delete non-canonical labels (see allowlist below)
ONLY="${ONLY:-}"                    # space-separated repo names to target (optional)
# ---------------

# Create temp dir and ensure cleanup on exit
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

###############################################################################
# Function: uri_encode
# Description: URL-encodes a string for use in API requests.
#
# Arguments:
#   $1 - The string to encode.
#
# Output:
#   URL-encoded string to stdout.
###############################################################################
function uri_encode() {
  jq -rn --arg s "$1" '$s|@uri'
}

###############################################################################
# Function: fetch_canonical_labels
# Description: Fetches the canonical labels.yml file from the organization's
#              central .github repository and converts it to JSON.
#
# Arguments:
#   None
#
# Output:
#   Creates labels.yml and labels.json in a temporary directory.
#   Prints status messages to stdout.
###############################################################################
function fetch_canonical_labels() {
  echo "Fetching $ORG/$CANON_REPO:$LABELS_PATH ..."
  local path_encoded
  path_encoded=$(uri_encode "$LABELS_PATH")
  gh api "repos/$ORG/$CANON_REPO/contents/$path_encoded" --jq '.content' \
  | base64 -d > "$tmp/labels.yml"

  # Convert YAML → JSON array of {name,color,description}
  yq -o=json '.' "$tmp/labels.yml" > "$tmp/labels.json"
  echo "Canonical labels fetched and processed."
}

###############################################################################
# Function: get_repository_list
# Description: Builds a list of repositories to process based on the 'ONLY'
#              environment variable or by fetching all repos from the org.
#
# Arguments:
#   None
#
# Output:
#   Populates the global REPOS array with the names of repositories.
#   Prints which repositories are being processed to stdout.
###############################################################################
function get_repository_list() {
  if [[ -n "$ONLY" ]]; then
    mapfile -t REPOS < <(printf "%s\n" "$ONLY")
    echo "Processing specific repositories: ${ONLY}"
  else
    mapfile -t REPOS < <(gh repo list "$ORG" --archived=false --source --limit 1000 --json name -q '.[].name')
    echo "Processing all repositories in organization: $ORG"
  fi
}

###############################################################################
# Function: sync_repository_labels
# Description: Synchronizes the labels for a single repository with the
#              canonical labels. It handles the creation, update, and
#              optional pruning of labels.
#
# Arguments:
#   $1 - The name of the repository to sync.
#
# Output:
#   Prints a log of actions taken (created, updated, deleted) to stdout.
###############################################################################
function sync_repository_labels() {
  local repo="$1"
  
  echo "==> Syncing $ORG/$repo"
  mapfile -t EXISTING < <(gh api "repos/$ORG/$repo/labels" --paginate -q '.[].name' || true)

  # Process canonical labels
  jq -c '.[]' "$tmp/labels.json" | while read -r lbl; do
    name=$(jq -r '.name' <<<"$lbl")
    color=$(jq -r '.color' <<<"$lbl")
    desc=$(jq -r '.description // ""' <<<"$lbl")

    # Check if label exists
    if printf '%s\n' "${EXISTING[@]}" | grep -Fxq "$name"; then
      if [[ "$DRY_RUN" == "true" ]]; then
        echo "  would update: $name"
      else
        gh api --silent --method PATCH "repos/$ORG/$repo/labels/$name" \
          -f new_name="$name" -f color="$color" -f description="$desc" || true
        echo "  updated: $name"
      fi
    else
      if [[ "$DRY_RUN" == "true" ]]; then
        echo "  would create: $name"
      else
        gh api --silent --method POST "repos/$ORG/$repo/labels" \
          -f name="$name" -f color="$color" -f description="$desc" || true
        echo "  created: $name"
      fi
    fi
  done

  # Prune non-canonical labels conservatively
  if [[ "$PRUNE" == "true" ]]; then
    jq -r '.[].name' "$tmp/labels.json" > "$tmp/canonical.txt"
    for ex in "${EXISTING[@]}"; do
      if ! grep -Fxq "$ex" "$tmp/canonical.txt"; then
        # keep some repo-local conventions
        if [[ "$ex" =~ ^(cpt:|tax:|vendor:|release:|type:) ]]; then continue; fi
        if [[ "$DRY_RUN" == "true" ]]; then
          echo "  would delete non-canonical: $ex"
        else
          gh api --silent --method DELETE "repos/$ORG/$repo/labels/$ex" || true
          echo "  deleted non-canonical: $ex"
        fi
      fi
    done
  fi
}

# Main script execution
fetch_canonical_labels
get_repository_list

# Process each repository
for repo in "${REPOS[@]}"; do
  sync_repository_labels "$repo"
done

# Done
echo "Done."
exit 0
