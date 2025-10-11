#!/usr/bin/env bash
# LightSpeed product-development project bootstrapper
#
# Provisions a GitHub ProjectV2 for internal product development and supports all automatable ProjectV2 actions:
# - Create or update a project
# - Add standard fields and options
# - Add draft issues
# - Link repositories and teams
# - Update project item fields (label, issue type, status)
# Usage examples:
#   ./product_dev_project.sh <org> <product-name> [project-number]
#   ./product_dev_project.sh add-draft-issue <project-number> <org> <title> <body>
#   ./product_dev_project.sh link-repo <project-number> <org> <repo-owner> <repo-name>
#   ./product_dev_project.sh link-team <org> <team-slug> [project-number]
#   ./product_dev_project.sh update-label <item-id> <label-id>
#   ./product_dev_project.sh update-issue-type <item-id> <type-id>
#
# Requires: gh CLI, jq
set -euo pipefail
# Logging helpers
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $*" >&2
}
log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" >&2
}
# Dry-run support
DRY_RUN="${DRY_RUN:-false}"
run_cmd() {
  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "DRY RUN: $*"
  else
    eval "$*"
  fi
}

# Helper: link a team to the project
link_team() {
  local org="$1"
  local team_slug="$2"
  local project_num="${3:-$PROJECT_NUM}"
  if [[ -z "$org" || -z "$team_slug" ]]; then
    log_error "Usage: link_team <org> <team_slug> [project_num]"
    return 1
  fi
  log_info "Linking team $org/$team_slug to project #$project_num"
  local project_id team_id
  project_id=$(gh api graphql -F owner="$org" -F number="$project_num" -f query='{ organization(login: $owner) { projectV2(number: $number) { id } } }' | jq -r '.data.organization.projectV2.id')
  team_id=$(gh api graphql -F org="$org" -F slug="$team_slug" -f query='{ organization(login: $org) { team(slug: $slug) { id } } }' | jq -r '.data.organization.team.id')
  run_cmd "gh api graphql -F projectId=\"$project_id\" -F teamId=\"$team_id\" -f query='mutation($projectId:ID!, $teamId:ID!) { linkProjectV2ToTeam(input: {projectId: $projectId, teamId: $teamId}) { team { id name } } }'"
}

# Helper: link a repository to a ProjectV2
link_repository() {
  local project_num="$1"
  local org="$2"
  local repo_owner="$3"
  local repo_name="$4"
  if [[ -z "$project_num" || -z "$org" || -z "$repo_owner" || -z "$repo_name" ]]; then
    log_error "Usage: link_repository <project_num> <org> <repo_owner> <repo_name>"
    return 1
  fi
  local project_id repo_id
  project_id=$(gh api graphql -F owner="$org" -F number="$project_num" -f query='{ organization(login: $owner) { projectV2(number: $number) { id } } }' | jq -r '.data.organization.projectV2.id')
  repo_id=$(gh api graphql -F owner="$repo_owner" -F name="$repo_name" -f query='{ repository(owner: $owner, name: $name) { id } }' | jq -r '.data.repository.id')
  log_info "Linking repository $repo_owner/$repo_name to project #$project_num ($org)"
  run_cmd "gh api graphql -F projectId=\"$project_id\" -F repositoryId=\"$repo_id\" -f query='mutation($projectId:ID!, $repositoryId:ID!) { linkProjectV2ToRepository(input: {projectId: $projectId, repositoryId: $repositoryId}) { repository { id name } } }'"
}

# Helper: update a label on a project item
update_label() {
  local item_id="$1"
  local label_id="$2"
  if [[ -z "$item_id" || -z "$label_id" ]]; then
    log_error "Usage: update_label <item_id> <label_id>"
    return 1
  fi
  log_info "Updating label for item $item_id to $label_id"
  run_cmd "gh api graphql -F itemId=\"$item_id\" -F labelId=\"$label_id\" -f query='mutation($itemId:ID!, $labelId:ID!) { updateProjectV2ItemFieldValue(input: {projectV2ItemId: $item_id, fieldId: $label_id, value: { text: \"true\" }}) { projectV2Item { id } } }'"
}

# Helper: update issue type on a project item
update_issue_type() {
  local item_id="$1"
  local type_id="$2"
  if [[ -z "$item_id" || -z "$type_id" ]]; then
    log_error "Usage: update_issue_type <item_id> <type_id>"
    return 1
  fi
  log_info "Updating issue type for item $item_id to $type_id"
  run_cmd "gh api graphql -F itemId=\"$item_id\" -F typeId=\"$type_id\" -f query='mutation($itemId:ID!, $typeId:ID!) { updateProjectV2ItemFieldValue(input: {projectV2ItemId: $item_id, fieldId: $type_id, value: { text: \"true\" }}) { projectV2Item { id } } }'"
}

# Helper: add a draft issue to a ProjectV2
add_draft_issue() {
  local project_num="$1"
  local org="$2"
  local issue_title="$3"
  local issue_body="$4"
  if [[ -z "$project_num" || -z "$org" || -z "$issue_title" || -z "$issue_body" ]]; then
    log_error "Usage: add_draft_issue <project_num> <org> <title> <body>"
    return 1
  fi
  local project_id
  project_id=$(gh api graphql -F owner="$org" -F number="$project_num" -f query='{ organization(login: $owner) { projectV2(number: $number) { id } } }' | jq -r '.data.organization.projectV2.id')
  log_info "Adding draft issue to project #$project_num ($org): $issue_title"
  run_cmd "gh api graphql -F projectId=\"$project_id\" -F title=\"$issue_title\" -F body=\"$issue_body\" -f query='mutation($projectId:ID!, $title:String!, $body:String!) { addProjectV2DraftIssue(input: {projectId: $projectId, title: $title, body: $body}) { projectItem { id } } }'"
}

# Helper: ensure a single-select field exists and create options if missing.
ensure_single_select_field() {
  local field_name="$1"
  shift
  local options=("$@")
  local field_id
  field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  if [[ -z "$field_id" ]]; then
    local names
    names=$(printf "%s\n" "${options[@]}" | sed 's/:.*//;t')
    IFS="," read -r -a arr <<< "$names"
    log_info "Creating field '$field_name' with options: ${arr[*]}"
    run_cmd "gh project field-create $PROJECT_NUM --name \"$field_name\" --data-type single_select --options \"$names\" >/dev/null"
    field_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg name "$field_name" '.[] | select(.name==$name) | .id')
  else
    log_info "Field '$field_name' already exists"
  fi
  for opt in "${options[@]}"; do
    local label="${opt%%:*}"
    local color="${opt##*:}"
    local option_id
    option_id=$(gh project field-list "$PROJECT_NUM" --format json | jq -r --arg fld "$field_id" --arg lbl "$label" '.[] | select(.id==$fld) | .configuration.options[]? | select(.name==$lbl) | .id' 2>/dev/null || true)
    if [[ -z "$option_id" ]]; then
      local project_node_id
      project_node_id=$(gh api graphql -F owner="$ORG" -F number="$PROJECT_NUM" -f query='{ organization(login: $owner) { projectV2(number: $number) { id } } }' | jq -r '.data.organization.projectV2.id') || true
      if [[ -n "$project_node_id" ]]; then
        option_id=$(gh api graphql -f query='query($field: ID!) { node(id: $field) { ... on ProjectV2Field { configuration { ... on ProjectV2SingleSelectFieldConfiguration { options { id name } } } } } }' -F field="$field_id" | jq -r --arg lbl "$label" '.data.node.configuration.options[] | select(.name==$lbl) | .id') || true
      fi
    fi
    if [[ -n "$option_id" ]]; then
      log_info "Setting colour for $field_name:$label → $color"
      run_cmd "gh api graphql -f query='mutation($optionId: ID!, $color: String!) { updateProjectV2SingleSelectFieldOption(input: { id: $optionId, name: null, color: $color }) { singleSelectFieldOption { id name } } }' -F optionId=\"$option_id\" -F color=\"$color\" >/dev/null"
    else
      log_error "Could not determine option id for $field_name:$label; colour assignment skipped."
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
    log_info "Creating $data_type field '$field_name'"
    run_cmd "gh project field-create $PROJECT_NUM --name \"$field_name\" --data-type \"$data_type\" >/dev/null"
  else
    log_info "Field '$field_name' already exists"
  fi
}

# Main CLI entry point
main() {
  local cmd="${1:-}"
  shift || true
  case "$cmd" in
    link-team)
      link_team "$@"
      ;;
    link-repo)
      link_repository "$@"
      ;;
    add-draft-issue)
      add_draft_issue "$@"
      ;;
    update-label)
      update_label "$@"
      ;;
    update-issue-type)
      update_issue_type "$@"
      ;;
    ""|create|provision)
      # Default: create or update project and fields
      ORG="${1:-lightspeedwp}"
      PRODUCT_NAME="${2:-}"
      PROJECT_TITLE="Product – ${PRODUCT_NAME}"
      PROJECT_NUM="${3:-}"
      if [[ -z "$PRODUCT_NAME" ]]; then
        log_error "Usage: $0 <product-name> [project-number] (org defaults to 'lightspeedwp' or pass as first arg)"
        log_error "Or: $0 <org> <product-name> [project-number]"
        exit 1
      fi
      if [[ -z "$PROJECT_NUM" ]]; then
        log_info "Creating project '${PROJECT_TITLE}' under organisation '${ORG}' …"
        PROJECT_JSON=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --description "Release train for ${PRODUCT_NAME}" --format json)
        PROJECT_NUM=$(echo "$PROJECT_JSON" | jq -r '.number')
        log_info "Created project #${PROJECT_NUM}"
      else
        log_info "Updating existing project #${PROJECT_NUM} ('${PROJECT_TITLE}') …"
      fi
      # Add all standard fields
      ensure_single_select_field "Status" \
        "Backlog:#6E7781" \
        "Ready:#58A6FF" \
        "In progress:#DB6D28" \
        "In review:#A371F7" \
        "In QA:#D29922" \
        "Done:#3FB950"
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
      ensure_single_select_field "Priority" \
        "P0 – Critical:#F85149" \
        "P1 – Important:#DB6D28" \
        "P2 – Normal:#58A6FF" \
        "P3 – Minor:#3FB950"
      ensure_single_select_field "Area" \
        "Frontend:#58A6FF" \
        "Backend:#3FB950" \
        "Build & CI:#D29922" \
        "DevOps:#6E7781" \
        "Design:#A371F7" \
        "Analytics:#DB61A2" \
        "A11y:#A371F7"
      ensure_single_select_field "Theme" \
        "Design System:#3FB950" \
        "Performance:#DB6D28" \
        "Editor UX:#A371F7" \
        "Block Theme:#58A6FF" \
        "Configuration:#6E7781"
      ensure_single_select_field "Milestone" "vNEXT:#58A6FF"
      ensure_numeric_field "Size" number
      ensure_numeric_field "Time" number
      ensure_numeric_field "Start Date" date
      ensure_numeric_field "Deadline" date
      ensure_single_select_field "Environment" \
        "Localhost:#6E7781" \
        "Prototype:#A371F7" \
        "Staging:#D29922" \
        "Live:#3FB950"
      log_info "Project #$PROJECT_NUM is prepared with fields."
      ;;
    *)
      log_error "Unknown command: $cmd"
      log_error "Usage: $0 [link-team|link-repo|add-draft-issue|update-label|update-issue-type|create|provision] ..."
      exit 1
      ;;
  esac
}

main "$@"