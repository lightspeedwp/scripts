#!/opt/homebrew/bin/bash
set -euo pipefail

# --- config ---
ORG="lightspeedwp"
CANON_REPO=".github"                # repo that stores the canonical file
LABELS_PATH=".github/labels.yml"    # path inside that repo
DRY_RUN="${DRY_RUN:-false}"         # set DRY_RUN=true to preview
PRUNE="${PRUNE:-false}"             # set PRUNE=true to delete non-canonical labels (see allowlist below)
ONLY="${ONLY:-}"                    # space-separated repo names to target (optional)
# ---------------

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

echo "Fetching $ORG/$CANON_REPO:$LABELS_PATH ..."
gh api "repos/$ORG/$CANON_REPO/contents/$LABELS_PATH" --jq '.content' \
| base64 -d > "$tmp/labels.yml"

# Convert YAML → JSON array of {name,color,description}
yq -o=json '.' "$tmp/labels.yml" > "$tmp/labels.json"

# Build repo list
if [[ -n "$ONLY" ]]; then
  mapfile -t REPOS < <(printf "%s\n" $ONLY)
else
  mapfile -t REPOS < <(gh repo list "$ORG" --archived=false --source --limit 1000 --json name -q '.[].name')
fi

for repo in "${REPOS[@]}"; do
  echo "==> Syncing $ORG/$repo"
  mapfile -t EXISTING < <(gh api "repos/$ORG/$repo/labels" --paginate -q '.[].name' || true)

  jq -c '.[]' "$tmp/labels.json" | while read -r lbl; do
    name=$(jq -r '.name' <<<"$lbl")
    color=$(jq -r '.color' <<<"$lbl")
    desc=$(jq -r '.description // ""' <<<"$lbl")

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
done

echo "Done."
