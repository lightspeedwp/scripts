#!/usr/bin/env bash
#
# update-projects.sh
#
# This script sets up GitHub Projects for the Tour Operator plugin (product
# development) and the ASNZ Tour Operator client (client delivery). It uses
# the GitHub CLI (`gh`) to create the custom fields necessary for each
# project according to the drop‑in specifications. Run this script after
# authenticating with `gh auth login` and ensure you have `project` scope.
#
# Usage: ./update-projects.sh

set -euo pipefail

# If running in CI, a GitHub App's credentials may be provided via environment
# variables. Prefer using an existing GH_TOKEN, otherwise, if LS_APP_ID and
# LS_APP_PRIVATE_KEY are provided (from repository secrets or variables), use
# them to create a GitHub App JWT and exchange it for an installation token.

generate_jwt() {
  # Args: app_id, private_key_file
  local app_id="$1"
  local keyfile="$2"

  # header
  local header
  header='{"alg":"RS256","typ":"JWT"}'

  # payload: iat now, exp now+600 seconds
  local iat
  iat=$(date +%s)
  local exp=$(( iat + 600 ))
  local payload
  payload=$(printf '{"iat":%d,"exp":%d,"iss":%s}' "$iat" "$exp" "$app_id")

  # base64url encoding helper
  b64url() {
    # usage: b64url "string"
    printf '%s' "$1" | openssl base64 -A | tr -d '\n' | tr -d '=' | tr '/+' '_-' | tr -d '\n'
  }

  local header_b64
  header_b64=$(b64url "$header")
  local payload_b64
  payload_b64=$(b64url "$payload")

  local signing_input
  signing_input="${header_b64}.${payload_b64}"

  # Sign the input with the private key (RS256)
  local signature_b64
  signature_b64=$(printf '%s' "$signing_input" | openssl dgst -sha256 -sign "$keyfile" | openssl base64 -A | tr -d '=' | tr '/+' '_-' | tr -d '\n')

  printf '%s.%s.%s' "$header_b64" "$payload_b64" "$signature_b64"
}

create_installation_token_from_app() {
  # Expects LS_APP_ID and LS_APP_PRIVATE_KEY in env. Sets GH_TOKEN on success.
  if [ -z "${LS_APP_ID-}" ] || [ -z "${LS_APP_PRIVATE_KEY-}" ]; then
    return 1
  fi

  local tmpkey
  tmpkey=$(mktemp)
  # Write the private key preserving newlines
  printf '%s' "$LS_APP_PRIVATE_KEY" > "$tmpkey"
  chmod 600 "$tmpkey"

  # Generate JWT
  local jwt
  jwt=$(generate_jwt "$LS_APP_ID" "$tmpkey") || {
    echo "Failed to generate JWT" >&2
    rm -f "$tmpkey"
    return 2
  }

  # Use JWT to list installations and pick the installation id for the requested ORG
  local installations_api
  installations_api="https://api.github.com/app/installations"
  local installation_id
  # Filter installations by account.login == ORG if ORG is provided in the environment
  if [ -n "${ORG-}" ]; then
    installation_id=$(curl -sS -H "Authorization: Bearer $jwt" -H "Accept: application/vnd.github+json" "$installations_api" | jq -r --arg org "$ORG" '.[] | select(.account.login==$org) | .id' | head -n1) || true
  else
    installation_id=$(curl -sS -H "Authorization: Bearer $jwt" -H "Accept: application/vnd.github+json" "$installations_api" | jq -r '.[0].id // empty') || true
  fi

  if [ -z "$installation_id" ]; then
    echo "Could not find an installation id for the app. Ensure the app is installed in the target org." >&2
    rm -f "$tmpkey"
    return 3
  fi

  # Create an installation access token
  local token_api
  token_api="https://api.github.com/app/installations/${installation_id}/access_tokens"
  local token
  token=$(curl -sS -X POST -H "Authorization: Bearer $jwt" -H "Accept: application/vnd.github+json" "$token_api" | jq -r '.token // empty') || true

  rm -f "$tmpkey"

  if [ -z "$token" ]; then
    echo "Failed to obtain installation token" >&2
    return 4
  fi

  export GH_TOKEN="$token"
  echo "Obtained GH_TOKEN from GitHub App installation"
  return 0
}

# If GH_TOKEN isn't provided, attempt to derive one from the provided app creds.
if [ -z "${GH_TOKEN-}" ]; then
  if [ -n "${LS_APP_ID-}" ] && [ -n "${LS_APP_PRIVATE_KEY-}" ]; then
    echo "No GH_TOKEN set — attempting to create installation token from LS_APP_ID/LS_APP_PRIVATE_KEY"
    if ! create_installation_token_from_app; then
      echo "Warning: unable to create GH_TOKEN from LS_APP_ID/LS_APP_PRIVATE_KEY; continuing and relying on existing gh auth or interactive login" >&2
    fi
  fi
fi

# Required scopes for creating/updating GitHub Projects via the gh CLI
REQUIRED_PROJECT_SCOPES=("read:project" "write:project")

# By default do not attempt an interactive refresh unless the flag is passed
AUTO_REFRESH=false
# Default to dry-run to avoid accidental destructive changes
DRY_RUN=true
CONFIRM=false

# Defaults (can be overridden via CLI)
ORG="lightspeedwp"
TO_PROJECT_NUMBER=13   # Tour Operator plugin project number
ASNZ_PROJECT_NUMBER=32 # ASNZ client project number

show_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --auto-refresh           If scopes are missing, run 'gh auth refresh -s ...' interactively
  --dry-run                Print the gh commands that would be executed and exit
  --project-owner <org>    Override the project owner/organisation (default: ${ORG})
  --to-project <number>    Override the Tour Operator project number (default: ${TO_PROJECT_NUMBER})
  --asnz-project <number>  Override the ASNZ project number (default: ${ASNZ_PROJECT_NUMBER})
  -h, --help               Show this help
EOF
}

# Parse CLI args
while [ "$#" -gt 0 ]; do
  case "$1" in
    --auto-refresh)
      AUTO_REFRESH=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --confirm|--yes|-y)
      DRY_RUN=false
      CONFIRM=true
      shift
      ;;
    --project-owner)
      if [ -n "${2-}" ]; then
        ORG="$2"
        shift 2
      else
        echo "--project-owner requires an argument" >&2
        exit 2
      fi
      ;;
    --to-project)
      if [ -n "${2-}" ]; then
        TO_PROJECT_NUMBER="$2"
        shift 2
      else
        echo "--to-project requires an argument" >&2
        exit 2
      fi
      ;;
    --asnz-project)
      if [ -n "${2-}" ]; then
        ASNZ_PROJECT_NUMBER="$2"
        shift 2
      else
        echo "--asnz-project requires an argument" >&2
        exit 2
      fi
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      show_help
      exit 2
      ;;
  esac
done

check_gh_scopes() {
  # Ensure gh is installed
  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI not found; please install GitHub CLI: https://cli.github.com/" >&2
    return 1
  fi

  # Use gh api to fetch headers which include x-oauth-scopes
  scopes_header=$(gh api -I / 2>/dev/null | tr -d '\r' | awk -F": " '/^x-oauth-scopes:/ {print $2}' || true)

  if [ -z "${scopes_header}" ]; then
    echo "You are not authenticated with gh. Run: gh auth login" >&2
    return 2
  fi

  scopes="${scopes_header}"

  missing=()
  for s in "${REQUIRED_PROJECT_SCOPES[@]}"; do
    if ! echo "${scopes}" | grep -qw "${s}"; then
      missing+=("${s}")
    fi
  done

  if [ ${#missing[@]} -ne 0 ]; then
    echo "error: your authentication token is missing required scopes [${missing[*]}]" >&2
    echo "To request it, run:" >&2
    echo "  gh auth refresh -s $(IFS=,; echo "${missing[*]}")" >&2

    if [ "${AUTO_REFRESH}" = "true" ]; then
      echo "\nAuto-refresh enabled: attempting interactive 'gh auth refresh' now..." >&2
      # Run interactive refresh with the missing scopes
      if gh auth refresh -s $(IFS=,; echo "${missing[*]}"); then
        # Re-fetch scopes after refresh
        scopes_header=$(gh api -I / 2>/dev/null | tr -d '\r' | awk -F": " '/^x-oauth-scopes:/ {print $2}' || true)
        scopes="${scopes_header}"
        # Recompute missing
        missing=()
        for s in "${REQUIRED_PROJECT_SCOPES[@]}"; do
          if ! echo "${scopes}" | grep -qw "${s}"; then
            missing+=("${s}")
          fi
        done
        if [ ${#missing[@]} -ne 0 ]; then
          echo "Scopes still missing after refresh: [${missing[*]}]" >&2
          return 3
        fi
        echo "Scopes refreshed successfully; proceeding..." >&2
        return 0
      else
        echo "Interactive gh auth refresh failed or was cancelled." >&2
        return 3
      fi
    fi

    return 3
  fi

  return 0
}

# (Defaults are set earlier and may be overridden via CLI)

create_field() {
  local project_number=$1
  local name=$2
  local data_type=$3
  local options=$4
  if [ "${DRY_RUN}" = "true" ]; then
    if [ "$data_type" = "SINGLE_SELECT" ]; then
      echo "DRY RUN: gh project field-create \"$project_number\" --owner \"$ORG\" --name \"$name\" --data-type SINGLE_SELECT --single-select-options \"$options\""
    else
      echo "DRY RUN: gh project field-create \"$project_number\" --owner \"$ORG\" --name \"$name\" --data-type \"$data_type\""
    fi
    return 0
  fi

  if [ "$data_type" = "SINGLE_SELECT" ]; then
    echo "Creating single-select field '$name' with options [$options] in project $project_number"
    gh project field-create "$project_number" --owner "$ORG" --name "$name" \
      --data-type SINGLE_SELECT --single-select-options "$options" || true
  else
    echo "Creating $data_type field '$name' in project $project_number"
    gh project field-create "$project_number" --owner "$ORG" --name "$name" --data-type "$data_type" || true
  fi
}

# Verify gh auth scopes before attempting to create project fields (skip in dry-run)
if [ "${DRY_RUN}" = "true" ]; then
  echo "Dry-run mode: skipping gh auth/scope checks"
else
  # If not in dry-run, require explicit confirmation for non-interactive runs
  if [ "${DRY_RUN}" != "true" ]; then
    if [ "${CONFIRM}" != "true" ]; then
      if [ -t 0 ]; then
        read -p "You are about to make changes to GitHub projects. Type 'yes' to continue: " yn
        if [ "$yn" != "yes" ]; then
          echo "Aborting." >&2
          exit 0
        fi
      else
        echo "Error: destructive actions require --confirm when running non-interactively" >&2
        exit 2
      fi
    fi
  fi

  if ! check_gh_scopes; then
    exit 1
  else
    echo "gh token has required project scopes; proceeding..."
  fi
fi

# -----------------------------------------------------------------------------
# Tour Operator plugin (Product Development) fields
#
echo "\nSetting up fields for Product – Tour Operator (project #$TO_PROJECT_NUMBER)"

# Status field (Backlog → Ready → In progress → In review → In QA → Done)
create_field "$TO_PROJECT_NUMBER" "Status" "SINGLE_SELECT" "Backlog,Ready,In progress,In review,In QA,Done"

# Issue Type field (Epic, Feature, Story, Task, Bug, Refactor, Design, Research, Chore)
create_field "$TO_PROJECT_NUMBER" "Issue Type" "SINGLE_SELECT" "Epic,Feature,Story,Task,Bug,Refactor,Design,Research,Chore"

# Priority field (P0–P3)
create_field "$TO_PROJECT_NUMBER" "Priority" "SINGLE_SELECT" "P0,P1,P2,P3"

# Area field (Frontend, Backend, Content, A11y, Analytics, Build & CI, DevOps)
create_field "$TO_PROJECT_NUMBER" "Area" "SINGLE_SELECT" "Frontend,Backend,Content,A11y,Analytics,Build & CI,DevOps"

# Theme field (Design System, Performance, Editor UX, Block Theme, Configuration)
create_field "$TO_PROJECT_NUMBER" "Theme" "SINGLE_SELECT" "Design System,Performance,Editor UX,Block Theme,Configuration"

# Size (number)
create_field "$TO_PROJECT_NUMBER" "Size" "NUMBER" ""

# Start Date (date)
create_field "$TO_PROJECT_NUMBER" "Start Date" "DATE" ""

# Deadline (date)
create_field "$TO_PROJECT_NUMBER" "Deadline" "DATE" ""

# Milestone (text)
create_field "$TO_PROJECT_NUMBER" "Milestone" "TEXT" ""

# Environment (Prototype, Staging, Live)
create_field "$TO_PROJECT_NUMBER" "Environment" "SINGLE_SELECT" "Prototype,Staging,Live"

# Time (hours) (number)
create_field "$TO_PROJECT_NUMBER" "Time (hours)" "NUMBER" ""

# -----------------------------------------------------------------------------
# ASNZ client project (Client Delivery) fields
#
echo "\nSetting up fields for Client – ASNZ (project #$ASNZ_PROJECT_NUMBER)"

# Status field (Backlog → Todo → In progress → In review → In QA → Done)
create_field "$ASNZ_PROJECT_NUMBER" "Status" "SINGLE_SELECT" "Backlog,Todo,In progress,In review,In QA,Done"

# Issue Type field (Epic, Story, Task, Bug, Chore, Design, Research)
create_field "$ASNZ_PROJECT_NUMBER" "Issue Type" "SINGLE_SELECT" "Epic,Story,Task,Bug,Chore,Design,Research"

# Priority field (P0–P3)
create_field "$ASNZ_PROJECT_NUMBER" "Priority" "SINGLE_SELECT" "P0,P1,P2,P3"

# Area field (Frontend, Backend, Content, A11y, Analytics, Build & CI, DevOps)
create_field "$ASNZ_PROJECT_NUMBER" "Area" "SINGLE_SELECT" "Frontend,Backend,Content,A11y,Analytics,Build & CI,DevOps"

# Theme field (Checkout, Performance, Editor UX, Migration, Configuration, SEO)
create_field "$ASNZ_PROJECT_NUMBER" "Theme" "SINGLE_SELECT" "Checkout,Performance,Editor UX,Migration,Configuration,SEO"

# Size (number)
create_field "$ASNZ_PROJECT_NUMBER" "Size" "NUMBER" ""

# Start Date (date)
create_field "$ASNZ_PROJECT_NUMBER" "Start Date" "DATE" ""

# Deadline (date)
create_field "$ASNZ_PROJECT_NUMBER" "Deadline" "DATE" ""

# Milestone (text)
create_field "$ASNZ_PROJECT_NUMBER" "Milestone" "TEXT" ""

# Environment (Localhost, Prototype, Staging, Live)
create_field "$ASNZ_PROJECT_NUMBER" "Environment" "SINGLE_SELECT" "Localhost,Prototype,Staging,Live"

# Time (hours) (number)
create_field "$ASNZ_PROJECT_NUMBER" "Time (hours)" "NUMBER" ""

echo "\nField setup complete. You may need to configure automations and views via the GitHub UI or API separately." 