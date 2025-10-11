#!/usr/bin/env bash
# LightSpeed client‑delivery project bootstrapper
#
# This script provisions a GitHub Project for client delivery engagements. It
# creates (or updates) a Project with Scrumban‑style statuses and ensures the
# standard fields exist with correctly coloured options. Existing fields are
# reused to allow repeated execution without duplicating options. Views and
# automations must still be configured manually via the UI or GraphQL.
set -eo pipefail
# Default the organisation to 'lightspeedwp' if not provided as the first arg
ORG="${1:-lightspeedwp}"
CLIENT_NAME="${2:-}"
PROJECT_TITLE="Client – ${CLIENT_NAME}"
PROJECT_NUM="${3:-}"
if [[ -z "$CLIENT_NAME" ]]; then
  echo "Usage: $0 <client-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)" >&2
  echo "Or: $0 <org> <client-name> [project-number]" >&2
  exit 1
fi
if [[ -z "$PROJECT_NUM" ]]; then
  echo "Creating project '${PROJECT_TITLE}' under organisation '${ORG}' …"
  PROJECT_JSON=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --description "Scrumban delivery for ${CLIENT_NAME}" --format json)
  PROJECT_NUM=$(echo "$PROJECT_JSON" | jq -r '.number')
  echo "Created project #${PROJECT_NUM}"
else
  echo "Updating existing project #${PROJECT_NUM} ('${PROJECT_TITLE}') …"
fi
# Helper functions (same as product script)
ensure_single_select_field() {
  local field_name="$1"
  shift
  local options=("$@")
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r \
    --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    local names
    names=$(printf "%s\n" "${options[@]}" | sed 's/:.*//;t')
    IFS="," read -r -a arr <<< "$names"
    echo "  Creating field '$field_name' with options: ${arr[*]}"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type single_select --options "${names}" >/dev/null
    field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r \
      --arg name "$field_name" '.[] | select(.name==$name) | .id')
  else
    echo "  Field '$field_name' already exists"
  fi
  # Update colours
  # Attempt to find option ids via gh project field-list; colour assignment requires GraphQL or manual steps.
  for opt in "${options[@]}"; do
    local label="${opt%%:*}"
    local color="${opt##*:}"
    local option_id
    option_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg fld "$field_id" --arg lbl "$label" '.[] | select(.id==$fld) | .configuration.options[]? | select(.name==$lbl) | .id' 2>/dev/null || true)
    if [[ -z "$option_id" ]]; then
      echo "    Option id not found via gh project field-list; attempting GraphQL lookup"
      option_id=$(gh api graphql -f query='query($field: ID!) { node(id: $field) { ... on ProjectV2Field { configuration { ... on ProjectV2SingleSelectFieldConfiguration { options { id name } } } } } }' -F field="$field_id" | jq -r --arg lbl "$label" '.data.node.configuration.options[] | select(.name==$lbl) | .id') || true
    fi
    if [[ -n "$option_id" ]]; then
      echo "    Setting colour for $field_name:$label → $color"
      gh api graphql -f query='mutation($optionId: ID!, $color: String!) { updateProjectV2SingleSelectFieldOption(input: { id: $optionId, name: null, color: $color }) { singleSelectFieldOption { id name } } }' -F optionId="$option_id" -F color="$color" >/dev/null
    else
      echo "    (Warning) Could not determine option id for $field_name:$label; colour assignment skipped."
    fi
  done
}
ensure_numeric_field() {
  local field_name="$1"
  local data_type="$2"
  local existing
  existing=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$existing" ]]; then
    echo "  Creating $data_type field '$field_name'"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type "$data_type" >/dev/null
  else
    echo "  Field '$field_name' already exists"
  fi
}

# Status field: Backlog → Todo → In progress → In review → In QA → Done
ensure_single_select_field "Status" \
  "Backlog:#6E7781" \
  "Todo:#58A6FF" \
  "In progress:#DB6D28" \
  "In review:#A371F7" \
  "In QA:#D29922" \
  "Done:#3FB950"

# Issue Type field
ensure_single_select_field "Issue Type" \
  "Epic:#A371F7" \
  "Story:#58A6FF" \
  "Task:#6E7781" \
  "Bug:#F85149" \
  "Chore:#D29922" \
  "Design:#DB61A2" \
  "Research:#DB6D28"

# Priority field
ensure_single_select_field "Priority" \
  "P0 – Critical:#F85149" \
  "P1 – Important:#DB6D28" \
  "P2 – Normal:#58A6FF" \
  "P3 – Minor:#3FB950"

# Area field
ensure_single_select_field "Area" \
  "Frontend:#58A6FF" \
  "Backend:#3FB950" \
  "Content:#DB6D28" \
  "A11y:#A371F7" \
  "Analytics:#DB61A2" \
  "Build & CI:#D29922" \
  "DevOps:#6E7781"

# Theme field (client‑focused)
ensure_single_select_field "Theme" \
  "Checkout:#3FB950" \
  "Performance:#DB6D28" \
  "Editor UX:#A371F7" \
  "Migration:#58A6FF" \
  "Configuration:#6E7781" \
  "SEO:#DB61A2"

# Milestone/Phase (treated as free text list with placeholder)
ensure_single_select_field "Milestone" "Phase-1 UAT:#58A6FF" >/dev/null || true

# Numeric and date fields
ensure_numeric_field "Size" number
ensure_numeric_field "Time" number
ensure_numeric_field "Start Date" date
ensure_numeric_field "Deadline" date

# Environment field
ensure_single_select_field "Environment" \
  "Localhost:#6E7781" \
  "Prototype:#A371F7" \
  "Staging:#D29922" \
  "Live:#3FB950"

echo "Project #$PROJECT_NUM for ${CLIENT_NAME} prepared."