
#!/bin/bash
#
# Script Name: prune-labels.sh
# Description: Conservative, REST-only label sync and optional prune for GitHub repositories.
# Usage:
#   DRY_RUN=true ./prune-labels.sh        # default; shows what would happen
#   DRY_RUN=false STRICT_PRUNE=true ./prune-labels.sh  # actually delete non-canonical labels
# Author: LightSpeed WP Team
# Date: 2025-10-12
#
set -euo pipefail

# --- config (override with env vars) ---
ORG="lightspeedwp"
CANON_REPO=".github"
LABELS_PATH=".github/labels.yml"
DRY_RUN="${DRY_RUN:-true}"
STRICT_PRUNE="${STRICT_PRUNE:-false}"
PROTECT_REGEX="${PROTECT_REGEX:-}"
ONLY="${ONLY:-}"

# Mapping for common non-standard labels to standardized versions
declare -A LABEL_MAPPINGS=(
  ["php"]="lang:php"
  ["js"]="lang:js"
  ["javascript"]="lang:js"
  ["css"]="lang:css"
  ["bash"]="lang:bash"
  ["shell"]="lang:bash"
  ["python"]="lang:python"
  ["documentation"]="area:documentation"
  ["docs"]="area:documentation"
)
# ----------------------------------------

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

uri() { jq -rn --arg s "$1" '$s|@uri'; }

echo "Fetching canonical labels from $ORG/$CANON_REPO:$LABELS_PATH ..."
gh api "repos/$ORG/$CANON_REPO/contents/$(uri "$LABELS_PATH")" --jq '.content' \
  | base64 -d > "$tmpdir/labels.yml"

# YAML → JSON array of {name,color,description}
yq -o=json '.' "$tmpdir/labels.yml" > "$tmpdir/labels.json"
jq -r '.[].name' "$tmpdir/labels.json" > "$tmpdir/canonical.txt"

# Repo list
if [[ -n "$ONLY" ]]; then
  mapfile -t REPOS < <(printf "%s\n" $ONLY)
else
  mapfile -t REPOS < <(gh repo list "$ORG" --archived=false --source --limit 1000 --json name -q '.[].name')
fi

for repo in "${REPOS[@]}"; do
  echo "==> Syncing $ORG/$repo"
  mapfile -t EXISTING < <(gh api "repos/$ORG/$repo/labels?per_page=100" --paginate -q '.[].name' || true)

  # 1) Ensure all canonical labels exist & are up-to-date
  jq -c '.[]' "$tmpdir/labels.json" | while read -r lbl; do
    name=$(jq -r '.name' <<<"$lbl")
    color=$(jq -r '.color' <<<"$lbl")
    desc=$(jq -r '.description // ""' <<<"$lbl")
    enc=$(uri "$name")

    if printf '%s\n' "${EXISTING[@]}" | grep -Fxq "$name"; then
      if [[ "$DRY_RUN" == "true" ]]; then
        echo "  would update: $name"
      else
        gh api --silent --method PATCH "repos/$ORG/$repo/labels/$enc" \
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

  # 2) Prune non-canonical labels conservatively
  for ex in "${EXISTING[@]}"; do
    # skip canonical
    if grep -Fxq "$ex" "$tmpdir/canonical.txt"; then
      continue
    fi

    # respect protect regex
    if [[ -n "$PROTECT_REGEX" ]] && [[ "$ex" =~ $PROTECT_REGEX ]]; then
      echo "  keeping protected: $ex"
      continue
    fi
    
    # Check if this label has a standardized version
    if [[ -n "${LABEL_MAPPINGS[$ex]:-}" ]]; then
      standardized="${LABEL_MAPPINGS[$ex]}"
      if grep -Fxq "$standardized" "$tmpdir/canonical.txt"; then
        if [[ "$DRY_RUN" == "true" ]]; then
          echo "  would migrate: $ex → $standardized"
        else
          # Get issues with this label
          tmpfile="$tmpdir/issues_$ex.json"
          gh api "repos/$ORG/$repo/issues?labels=$(uri "$ex")&state=all&per_page=100" --paginate > "$tmpfile"
          
          # Add standardized label to those issues
          jq -r '.[].number' "$tmpfile" | while read -r issue_num; do
            gh api --method POST "repos/$ORG/$repo/issues/$issue_num/labels" -f "labels[]=$standardized"
            echo "  added $standardized to issue #$issue_num"
          done
          
          # Delete the non-standard label
          gh api --silent --method DELETE "repos/$ORG/$repo/labels/$(uri "$ex")" || true
          echo "  migrated: $ex → $standardized"
        fi
        continue
      fi
    fi

    if [[ "$STRICT_PRUNE" == "true" ]]; then
      if [[ "$DRY_RUN" == "true" ]]; then
        echo "  would delete (strict): $ex"
      else
        gh api --silent --method DELETE "repos/$ORG/$repo/labels/$(uri "$ex")" || true
        echo "  deleted (strict): $ex"
      fi
    else
      echo "  skipping non-canonical (not strict): $ex"
    fi
  done
done

echo "Done."
