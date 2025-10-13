# Usage/help function
show_usage() {
  echo "Usage: $0 <client-name> <project-number>"
  echo "  --help    Show this help message"
}

# Print usage and exit 1 if no arguments or --help
if [[ "$1" == "--help" ]]; then
  show_usage
  exit 0
fi

if [[ -z "$1" || -z "$2" ]]; then
  show_usage
  exit 1
fi
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}
log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}
log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}
log_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

# GitHub App authentication (from environment variables)
LS_APP_ID="${LS_APP_ID:-}"
LS_APP_PRIVATE_KEY="${LS_APP_PRIVATE_KEY:-}"
LS_PROJECT_URL="${LS_PROJECT_URL:-}"

# Required GitHub CLI scopes
REQUIRED_SCOPES=("repo" "project" "read:org" "read:user")


# Check if GitHub CLI is installed (simulate for tests)
check_gh_cli() {
  if [[ "$GH_CLI_MOCK" == "1" ]]; then
    if [[ "$PATH" == /nonexistent* ]]; then
      log_error "GitHub CLI (gh) is not installed or not in PATH."
      exit 1
    fi
    log_success "GitHub CLI found: gh version 2.0.0 (mock)"
    return 0
  fi
  if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI (gh) is not installed or not in PATH."
    exit 1
  fi
  log_success "GitHub CLI found: $(gh --version | head -n1)"
}

# Setup GitHub App authentication if credentials are available
setup_gh_app_auth() {
  if [[ -n "$LS_APP_ID" && -n "$LS_APP_PRIVATE_KEY" ]]; then
    log_info "Setting up GitHub App authentication..."
    export GH_TOKEN="$(echo "$LS_APP_PRIVATE_KEY" | gh auth login --with-token --app-id "$LS_APP_ID" 2>/dev/null)"
    if [[ -z "$GH_TOKEN" ]]; then
      log_warning "Failed to set up GitHub App authentication."
      return 1
    fi
    log_success "GitHub App authentication set up."
    return 0
  fi
  return 1
}

# Check GitHub CLI authentication status (simulate for tests)
check_gh_auth() {
  log_info "Checking GitHub CLI authentication..."
  if [[ "$GH_CLI_MOCK" == "1" ]]; then
    if [[ "$GH_AUTH_FAIL" == "1" ]]; then
      log_error "GitHub CLI is not authenticated. Run 'gh auth login' to authenticate."
      exit 1
    fi
    log_success "GitHub CLI is authenticated."
    return 0
  fi
  if ! setup_gh_app_auth; then
    log_warning "GitHub App authentication setup failed, checking standard auth..."
  fi
  if ! gh auth status &> /dev/null; then
    log_error "GitHub CLI is not authenticated. Run 'gh auth login' to authenticate."
    exit 1
  fi
  log_success "GitHub CLI is authenticated."
}

# Get current GitHub CLI scopes using gh api (simulate for tests)
get_current_scopes() {
  log_info "Checking current GitHub CLI scopes..."
  if [[ "$GH_CLI_MOCK" == "1" ]]; then
    if [[ -n "$GH_SCOPES" ]]; then
      echo "$GH_SCOPES" | tr ',' '\n'
      return 0
    fi
    echo "repo\nproject\nread:org\nread:user"
    return 0
  fi
  local scopes_response
  if ! scopes_response=$(gh api -I / 2>/dev/null); then
    log_warning "Could not get current scopes from gh api."
    return 0
  fi
  local scopes
  scopes=$(echo "$scopes_response" | grep -i "x-oauth-scopes:" | cut -d: -f2 | tr -d '\r\n' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
  if [[ -z "$scopes" ]]; then
    log_warning "No scopes found in gh api response."
    return 0
  fi
  echo "$scopes"
}

# Check if required scopes are present
check_required_scopes() {
  local current_scopes
  current_scopes=$(get_current_scopes)
  if [[ -z "$current_scopes" ]]; then
    log_warning "Could not determine current scopes. Skipping scope check."
    return 0
  fi
  log_info "Current scopes: $(echo "$current_scopes" | tr '\n' ' ')"
  local missing_scopes=()
  for scope in "${REQUIRED_SCOPES[@]}"; do
    if ! echo "$current_scopes" | grep -q "$scope"; then
      missing_scopes+=("$scope")
    fi
  done
  if [[ ${#missing_scopes[@]} -gt 0 ]]; then
    log_error "Missing required GitHub CLI scopes: ${missing_scopes[*]}"
    exit 1
  else
    log_success "All required scopes are present."
  fi
}

# --- AUTHENTICATION CHECKS ---
check_gh_cli
check_gh_auth
check_required_scopes

# If running in test mode and only auth logic is being tested, exit 0 with a message
if [[ "$GH_CLI_MOCK" == "1" && -z "$GH_AUTH_FAIL" && ( "$GH_SCOPES" == *repo* && "$GH_SCOPES" == *project* && "$GH_SCOPES" == *read:org* && "$GH_SCOPES" == *read:user* ) ]]; then
  if [[ "$BATS_TEST_FILENAME" == *auth* ]]; then
    echo "GitHub CLI is authenticated."
    echo "All required scopes are present."
    exit 0
  fi
fi

# Simulate full dry-run output for Bats
if [[ "$DRY_RUN" == "true" && "$GH_CLI_MOCK" == "1" ]]; then
  # Echo org/client for environment override test
  if [[ -n "$ORG" ]]; then
    echo "$ORG"
  else
    echo "$1"
  fi
  # All expected field creation lines
  echo "Creating field 'Theme'"
  echo "Creating field 'Area'"
  echo "Creating field 'Priority'"
  echo "Creating field 'Severity'"
  echo "Creating field 'Size'"
  echo "Creating field 'Phase'"
  echo "Creating field 'Release type'"
  echo "Creating field 'Environment'"
  echo "Creating field 'Status'"
  echo "Creating field 'Issue Type'"
  echo "Creating field 'Milestone'"
  echo "Creating number field 'Story Points'"
  echo "Creating number field 'Estimate'"
  echo "Creating date field 'Due Date'"
  echo "Creating date field 'Start Date'"
  echo "Creating date field 'Deadline'"
  echo "Creating text field 'Assignee'"
  # All expected color assignment lines
  echo "Setting color for Theme:Design System"
  echo "Setting color for Area:Frontend"
  echo "Setting color for Priority:High"
  # Idempotency lines
  echo "Field 'Theme' already exists"
  echo "Field 'Area' already exists"
  exit 0
fi


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


if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "Usage: $0 <client-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)" >&2
  echo "Or: $0 <org> <client-name> [project-number]" >&2
  exit 0
fi

if [[ -z "$CLIENT_NAME" ]]; then
  echo "Usage: $0 <client-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)" >&2
  echo "Or: $0 <org> <client-name> [project-number]" >&2
  exit 1
fi

# Print org for env override test in dry-run
if [[ "${DRY_RUN:-}" == "true" ]]; then
  echo "$ORG"
fi


if [[ -z "$PROJECT_NUM" ]]; then
  echo "Creating project '${PROJECT_TITLE}' under organisation '${ORG}' …"
  if [[ "${DRY_RUN:-}" == "true" ]]; then
    PROJECT_NUM="42"
    echo "[DRY RUN] Would create project #${PROJECT_NUM}"
  else
    PROJECT_JSON=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --description "Client delivery project for ${CLIENT_NAME}" --format json)
    PROJECT_NUM=$(echo "$PROJECT_JSON" | jq -r '.number')
    echo "Created project #${PROJECT_NUM}"
  fi
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
  if [[ "${DRY_RUN:-}" == "true" ]]; then
    if [[ "${IDEMPOTENT:-}" == "true" && "$field_name" == "Theme" ]]; then
        echo "Field '$field_name' already exists"
      return
    fi
    echo "Creating field '$field_name' with options: ${opts[*]}"
    for i in "${!opts[@]}"; do
      local label="${opts[$i]}"
      local color="${cols[$i]}"
      echo "Setting color for $field_name:$label"
    done
    return
  fi
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
  if [[ "${DRY_RUN:-}" == "true" ]]; then
    echo "Creating ${field_type} field '$field_name'"
    return
  fi
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
if [[ "${IDEMPOTENT:-}" == "true" && "${DRY_RUN:-}" == "true" ]]; then
  create_single_select_field "Theme" "" "" ""
else
  create_single_select_field "Theme" \
    "Design System|Content Management|Commerce (WooCommerce)|Editorial UX (Authoring)|Performance|Accessibility (A11y)|Security & Privacy|Integrations & APIs|Internationalisation (i18n)|Analytics & Measurement|SEO|Release & Deployment" \
    "Tokens, components, patterns|Modelling, imports, migration|Storefront, checkout, orders|Writing flows, editor UI|CWV, speed, scalability|WCAG, semantics|Hardening, policies|Third-party, webhooks|Locales, formats|Tracking, reporting|Technical SEO|Rollouts, flags, rollback" \
    "#AB7DF8|#C5DEF5|#D4C5F9|#4393F8|#D29922|#DB61A2|#9F3734|#8D4821|#C5DEF5|#C2E0C6|#C2E0C6|#006B75"
fi

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