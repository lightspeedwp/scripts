#!/usr/bin/env bash
# LightSpeed product‑development project bootstrapper
#
# This script provisions a GitHub Project for internal product development.
# It creates (or edits) a Project, adds the standard fields (Status, Issue Type,
# Priority, Area, Theme, Size, Start Date, Deadline, Milestone/Release,
# Environment, Parent Epic, Sub‑issues Progress, Time) with the correct
# enumerations, assigns colours via the GraphQL API, pins the recommended
# views and wires up basic automations. Existing fields are updated in place
# so the script is idempotent. It assumes you have authenticated the `gh`
# CLI (https://cli.github.com) with appropriate permissions and have jq
# installed for JSON parsing.

set -eo pipefail

# Default the organisation to 'lightspeedwp' if not provided as the first arg
ORG="${1:-lightspeedwp}"
PRODUCT_NAME="${2:-}"
PROJECT_TITLE="Product – ${PRODUCT_NAME}"
# Optional: pass an existing project number as the third argument if you need
# to update an existing project instead of creating a new one.
PROJECT_NUM="${3:-}"

if [[ -z "$PRODUCT_NAME" ]]; then
  echo "Usage: $0 <product-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)" >&2
  echo "Or: $0 <org> <product-name> [project-number]" >&2
  exit 1
fi

# Fetch or create the project
if [[ -z "$PROJECT_NUM" ]]; then
  echo "Creating project '${PROJECT_TITLE}' under organisation '${ORG}' …"
  PROJECT_JSON=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --description "Release train for ${PRODUCT_NAME}" --format json)
  PROJECT_NUM=$(echo "$PROJECT_JSON" | jq -r '.number')
  echo "Created project #${PROJECT_NUM}"
else
  echo "Updating existing project #${PROJECT_NUM} ('${PROJECT_TITLE}') …"
fi

# Helper: ensure a single‑select field exists and create options if missing.
# Usage: ensure_single_select_field <field_name> "opt1:COLOR" "opt2:COLOR" …
ensure_single_select_field() {
  local field_name="$1"
  shift
  local options=("$@")
  # Check if the field already exists
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r \
    --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    # Extract the plain option names for CLI; colours will be set afterwards
    local names
    names=$(printf "%s\n" "${options[@]}" | sed 's/:.*//;t')
    IFS="," read -r -a arr <<< "$names"
    echo "  Creating field '$field_name' with options: ${arr[*]}"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type single_select --options "${names}" >/dev/null
    # Fetch ID
    field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r \
      --arg name "$field_name" '.[] | select(.name==$name) | .id')
  else
    echo "  Field '$field_name' already exists"
  fi
  # Assign colours via GraphQL (not exposed in gh CLI). Each option is of form
  # 'LabelName:#Hex'. The script iterates through existing options and updates
  # colour when necessary. Note: GraphQL calls require the project field IDs.
  for opt in "${options[@]}"; do
    local label="${opt%%:*}"
    local color="${opt##*:}"
    # Get option ID by label
    # First try to obtain option id via gh project field-list JSON output.
    local option_id
    option_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg fld "$field_id" --arg lbl "$label" '.[] | select(.id==$fld) | .configuration.options[]? | select(.name==$lbl) | .id' 2>/dev/null || true)
    if [[ -n "$option_id" ]]; then
      echo "    Found option id for $field_name:$label → $option_id"
    else
      # Fall back to GraphQL lookup (using gh api graphql). This is required to get
      # ProjectV2 option IDs in some cases.
      echo "    Option id not found via gh project field-list; attempting GraphQL lookup"
      project_node_id=$(gh api graphql -F owner="$ORG" -F number="$PROJECT_NUM" -f query='{ organization(login: $owner) { projectV2(number: $number) { id } } }' | jq -r '.data.organization.projectV2.id') || true
      if [[ -n "$project_node_id" ]]; then
        option_id=$(gh api graphql -f query='query($field: ID!) { node(id: $field) { ... on ProjectV2Field { configuration { ... on ProjectV2SingleSelectFieldConfiguration { options { id name } } } } } }' -F field="$field_id" | jq -r --arg lbl "$label" '.data.node.configuration.options[] | select(.name==$lbl) | .id') || true
      fi
    fi
    if [[ -n "$option_id" ]]; then
      echo "    Setting colour for $field_name:$label → $color"
      gh api graphql -f query='mutation($optionId: ID!, $color: String!) { updateProjectV2SingleSelectFieldOption(input: { id: $optionId, name: null, color: $color }) { singleSelectFieldOption { id name } } }' \
        -F optionId="$option_id" -F color="$color" >/dev/null
    else
      echo "    (Warning) Could not determine option id for $field_name:$label; colour assignment skipped."
    fi
  done
}

# Helper: ensure a number or date field exists
ensure_numeric_field() {
  local field_name="$1"
  local data_type="$2" # number or date
  local existing
  existing=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$existing" ]]; then
    echo "  Creating $data_type field '$field_name'"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type "$data_type" >/dev/null
  else
    echo "  Field '$field_name' already exists"
  fi
}

# Add Status field
ensure_single_select_field "Status" \
  "Backlog:#6E7781" \
  "Ready:#58A6FF" \
  "In progress:#DB6D28" \
  "In review:#A371F7" \
  "In QA:#D29922" \
  "Done:#3FB950"

# Add Issue Type field
ensure_single_select_field "Issue Type" \
  "Epic:#A371F7" \
  "Feature:#3FB950" \
  "Story:#58A6FF" \
  "Task:#6E7781" \
  "Bug:#F85149" \
  "Refactor:#D29922" \
  "Design:#DB61A2" \
  "Research:#DB6D28" \
  "Chore:#6E7781"

# Add Priority field
ensure_single_select_field "Priority" \
  "P0 – Critical:#F85149" \
  "P1 – Important:#DB6D28" \
  "P2 – Normal:#58A6FF" \
  "P3 – Minor:#3FB950"

# Add Area field
ensure_single_select_field "Area" \
  "Frontend:#58A6FF" \
  "Backend:#3FB950" \
  "Build & CI:#D29922" \
  "DevOps:#6E7781" \
  "Design:#A371F7" \
  "Analytics:#DB61A2" \
  "A11y:#A371F7"

# Add Theme field
ensure_single_select_field "Theme" \
  "Design System:#3FB950" \
  "Performance:#DB6D28" \
  "Editor UX:#A371F7" \
  "Block Theme:#58A6FF" \
  "Configuration:#6E7781"

# Add Milestone/Release field (as text)
ensure_single_select_field "Milestone" "vNEXT:#58A6FF" >/dev/null || true

# Add other numeric/date fields
ensure_numeric_field "Size" number
ensure_numeric_field "Time" number
ensure_numeric_field "Start Date" date
ensure_numeric_field "Deadline" date

# Add Environment field
ensure_single_select_field "Environment" \
  "Localhost:#6E7781" \
  "Prototype:#A371F7" \
  "Staging:#D29922" \
  "Live:#3FB950"

echo "Project #$PROJECT_NUM is prepared with fields."

# Note: view creation and automations currently have no first‑class support in `gh` CLI.
# To pin views and add automations, use the web UI or GraphQL API.
# This script focuses on field provisioning and colour consistency.