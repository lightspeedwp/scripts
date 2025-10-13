

#!/usr/bin/env bash

# LightSpeed client-delivery project bootstrapper
#
# This script provisions a GitHub Project for client delivery engagements.
# It creates (or updates) a Project with Scrumban-style statuses and ensures the
# standard fields exist with correctly coloured options, descriptions, and types.
# Existing fields are reused to allow repeated execution without duplicating options (idempotent).
# Views and automations must still be configured manually via the UI or GraphQL.
#
# Field specs: see docs/update-projects/client-delivery-field-specs-v1-1.md for authoritative options, descriptions, and colors.
#
# Usage:
#   $0 <client-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)
#   $0 <org> <client-name> [project-number]
#
# Example:
#   ./client-delivery-project.sh acme-corp
#   ./client-delivery-project.sh myorg acme-corp 42
#
# Requirements:
#   - GitHub CLI (gh) installed and authenticated
#   - jq installed
#   - Appropriate GitHub scopes: repo, project, read:org, read:user
#
# Note:
#   - Views and automations must be configured manually after running this script.
#   - This script is safe to run multiple times; it will not duplicate fields or options.


set -euo pipefail

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
  PROJECT_JSON=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --description "Client delivery project for ${CLIENT_NAME}" --format json)
  PROJECT_NUM=$(echo "$PROJECT_JSON" | jq -r '.number')
  echo "Created project #${PROJECT_NUM}"
else
  echo "Updating existing project #${PROJECT_NUM} ('${PROJECT_TITLE}') …"
fi


# Helper: create single-select field with options, descriptions, and colors
# Arguments:
#   $1: Field name
#   $2: Pipe-separated options
#   $3: Pipe-separated descriptions
#   $4: Pipe-separated colors
create_single_select_field() {
  local field_name="$1"
  local options="$2"
  local descriptions="$3"
  local colors="$4"
  IFS='|' read -r -a opts <<< "$options"
  IFS='|' read -r -a descs <<< "$descriptions"
  IFS='|' read -r -a cols <<< "$colors"
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    echo "Creating field '$field_name' with options: ${opts[*]}"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type single_select --options "${options}" >/dev/null
    field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  else
    echo "Field '$field_name' already exists"
  fi
  # Assign colors to options
  for i in "${!opts[@]}"; do
    local label="${opts[$i]}"
    local color="${cols[$i]}"
    local option_id
    option_id=$(gh api graphql -f query='query($field: ID!) { node(id: $field) { ... on ProjectV2Field { configuration { ... on ProjectV2SingleSelectFieldConfiguration { options { id name } } } } } }' -F field="$field_id" | jq -r --arg lbl "$label" '.data.node.configuration.options[] | select(.name==$lbl) | .id') || true
    if [[ -n "$option_id" ]]; then
      echo "Setting color for $field_name:$label → $color"
      gh api graphql -f query='mutation($optionId: ID!, $color: String!) { updateProjectV2SingleSelectFieldOption(input: { id: $optionId, name: null, color: $color }) { singleSelectFieldOption { id name } } }' -F optionId="$option_id" -F color="$color" >/dev/null
    else
      echo "(Warning) Could not determine option id for $field_name:$label; color assignment skipped."
    fi
  done
}

# Helper: create number/date/text field
# Arguments:
#   $1: Field name
#   $2: Field type (number, date, text)
create_field() {
  local field_name="$1"
  local field_type="$2"
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    echo "Creating $field_type field '$field_name'"
    gh project field-create "$PROJECT_NUM" --name "$field_name" --data-type "$field_type" >/dev/null
  else
    echo "Field '$field_name' already exists"
  fi
}

# Helper: create numeric field for estimates (hours)
create_estimate_field() {
  create_field "Estimate" number
}



# --- Field definitions (from spec) ---

# Theme (strategic lens)
create_single_select_field "Theme" \
  "Design System|Content Management|Commerce (WooCommerce)|Editorial UX (Authoring)|Performance|Accessibility (A11y)|Security & Privacy|Integrations & APIs|Internationalisation (i18n)|Analytics & Measurement|SEO|Release & Deployment" \
  "Tokens, components, patterns|Modelling, imports, migration|Storefront, checkout, orders|Writing flows, editor UI|CWV, speed, scalability|WCAG, semantics|Hardening, policies|Third-party, webhooks|Locales, formats|Tracking, reporting|Technical SEO|Rollouts, flags, rollback" \
  "#AB7DF8|#C5DEF5|#D4C5F9|#4393F8|#D29922|#DB61A2|#9F3734|#8D4821|#C5DEF5|#C2E0C6|#C2E0C6|#006B75"

# Area (who/where executes)
create_single_select_field "Area" \
  "Frontend|Backend|Build & CI|Deployment/DevOps|Design System|Content|Analytics|A11y" \
  "Blocks, UI, theme layer|PHP, data, services|Pipelines, tests, tooling|Infra, hosting, releases|Tokens/components work|Modelling, copy, imports|GA4/GTM, dashboards|Accessibility fixes/reviews" \
  "#BFD4F2|#BFD4F2|#BFD4F2|#006B75|#C5DEF5|#C5DEF5|#C2E0C6|#DB61A2"

# Priority (scheduling urgency)
create_single_select_field "Priority" \
  "High|Medium|Low" \
  "Deadline/regulatory/live impact|Planned/standard work|Nice-to-have/backlog" \
  "#D93F0B|#0052CC|#C2E0C6"

# Severity (impact for bugs)
create_single_select_field "Severity" \
  "S0 – Blocker|S1 – Critical|S2 – Major|S3 – Minor|S4 – Trivial" \
  "Outage/data loss/security|Core flow broken/hotfix likely|Common path degraded|Limited impact/workaround|Cosmetic/typo" \
  "#B60205|#D93F0B|#FBCA04|#BFD4F2|#E1E4E8"

# Size (effort bucket)
create_single_select_field "Size" \
  "0 – Unknown|1 – XS|2 – S|3 – M|4 – L|5 – XL|6 – XXL" \
  "Not yet sized|Trivial (≤2h)|Small (≤0.5d)|Medium (1–2d)|Large (2–3d)|Very large (≈1 week)|Huge (≈1–2 weeks)" \
  "#E1E4E8|#BFD4F2|#C5DEF5|#58A6FF|#4393F8|#D4C5F9|#AB7DF8"

# Phase (pre/post-launch flow)
create_single_select_field "Phase" \
  "Pre-launch|Staging/UAT|Launch|Post-launch|Maintenance" \
  "Prep/build-up|Client testing|Go-live activities|Follow-ups, polish|Warranty/BAU fixes" \
  "#C5DEF5|#BFD4F2|#0E8A16|#C2E0C6|#9198A1"

# Release type (classify drops)
create_single_select_field "Release type" \
  "Major|Minor|Patch|Hotfix" \
  "Large scope/breaking|Enhancements|Small fixes|Urgent live correction" \
  "#D29922|#58A6FF|#C2E0C6|#F85149"

# Environment (target/tested)
create_single_select_field "Environment" \
  "Prototype|Staging|Live" \
  "Spike/sandboxes|QA/UAT|Production" \
  "#E1E4E8|#BFD4F2|#0E8A16"

# Status (workflow state)
create_single_select_field "Status" \
  "Backlog|To-do|In progress|In review|In QA|Done" \
  "Not yet planned|Ready to start|Being worked on|PR open/reviewing|Testing/validation|Complete/merged" \
  "#BFD4F2|#0E8A16|#1D76DB|#BFD4F2|#FBCA04|#E1E4E8"

# Issue Type (nature of work)
create_single_select_field "Issue Type" \
  "Epic|Story|Task|Bug|Chore|Design|Research" \
  "Cross-cutting body of work|User-facing value slice|Execution work item|Defect/incorrect behaviour|Ops/cleanup|UI/UX design output|Investigation/spike" \
  "#AB7DF8|#4393F8|#4393F8|#9F3734|#9198A1|#AB7DF8|#9198A1"

# Milestone (iteration, placeholder)
create_single_select_field "Milestone" \
  "Go-Live|UAT-1" \
  "Launch window|2-week UAT cycle" \
  "#58A6FF|#58A6FF"

# Numeric/date/text fields
create_field "Story Points" number
create_field "Estimate" number
create_field "Due Date" date
create_field "Start Date" date
create_field "Deadline" date
create_field "Assignee" text

echo "Project #$PROJECT_NUM for ${CLIENT_NAME} prepared."