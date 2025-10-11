

# Scripts Directory Structure


This directory contains all automation scripts for LightSpeed WP, organized by function for clarity and maintainability. **All scripts are now located in their respective subfolders; no executable scripts remain in the root.**

## Subfolder Organization

Scripts are grouped as follows:

| Subfolder      | Purpose                                                      |
|---------------|--------------------------------------------------------------|
| `deployment/`  | Deployment automation scripts (e.g., client delivery, dry-run validation, example deployment) |
| `project/`     | Project management and update scripts (e.g., product/project setup, field updates) |
| `maintenance/` | Maintenance and label management scripts (e.g., prune/update/sync labels) |
| `testing/`     | Test harnesses, validation scripts, Playwright/Bats tests, test runners |
| `utility/`     | Utility functions and server startup scripts (shared helpers, MCP server) |
| `dry-run/`     | Dry-run scripts for safe validation of deployment/configuration |
| `packages/`    | Package management and related resources                     |

Refer to each subfolder for specific scripts and usage instructions. The root README provides an overview and links to documentation, standards, and contribution guidelines.

## Subfolders Overview

| Subfolder      | Purpose                                                      |
|---------------|--------------------------------------------------------------|
| `deployment/`  | Deployment automation scripts (e.g., client delivery, dry-run validation) |
| `project/`     | Project management and update scripts (e.g., project setup, field updates) |
| `maintenance/` | Maintenance and label management scripts (e.g., prune/update labels) |
| `testing/`     | Test harnesses, validation scripts, and Playwright/Bats tests |
| `utility/`     | Utility functions and server startup scripts (shared helpers) |
| `dry-run/`     | Dry-run scripts for safe validation of deployment/configuration |
| `packages/`    | Package management and related resources                     |

## How to Use

- Place new scripts in the appropriate subfolder based on their function.
- Each subfolder may contain its own README for specific usage instructions.
- See the root README for overall repo usage, standards, and contribution guidelines.

## Quick Reference

- **Deployment**: Automated deployment, dry-run validation
- **Project**: Project setup, field updates, project automation
- **Maintenance**: Label management, repo maintenance
- **Testing**: Test scripts, Playwright/Bats harnesses
- **Utility**: Shared functions, server startup
- **Dry-run**: Safe validation scripts
- **Packages**: Package management


## Playwright MCP Server Automation

This repo includes automation to ensure Playwright MCP and GitHub MCP servers are always running for reliable testing and automation. Key features:

- **Copilot instructions** for Playwright and MCP server management in `.github/instructions/playwright-copilot.md`.
- **Server startup and health scripts** in `scripts/utility/`:
  - `start-mcp-server.sh`: Starts MCP server if not running
  - `check-mcp-server-health.sh`: Checks health and restarts MCP server if needed
- **GitHub Actions workflow** in `.github/workflows/playwright-mcp-server.yml`:
  - Starts MCP server, runs health check, and executes Playwright tests
  - Auto-restarts MCP server if stopped
- **Playwright tests** in `scripts/testing/playwright-mcp-server.spec.ts` validate MCP server health endpoint

### Setup & Integration

- Scripts are idempotent and log status for CI/CD reliability
- Workflow ensures MCP server is ready before running Playwright tests
- Troubleshooting and restart logic are documented in automation scripts and workflow README

See the automation workflow and utility scripts for usage details and integration points.

## Naming Convention

- Use kebab-case for all script files (e.g., `deploy-site.sh`, `backup-database.sh`)
- Include `.sh` extension for shell scripts
- Use descriptive names that clearly indicate the script's purpose

## Script Header & Comments

- All scripts must start with a header comment block:

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: Brief description of what this script does
# Usage: ./script-name.sh [options] [arguments]
# Author: Your Name
# Date: YYYY-MM-DD
#
```

- Add inline comments for complex logic or important functions.
- Use meaningful variable names and document any environment variables or dependencies.

For update-projects.sh usage, flags, testing, and code comment standards, see [update-projects/README.update-projects.md](../update-projects/README.update-projects.md).


## Advanced Project Automation Scripts
`product_dev_project.sh` and related scripts automate GitHub ProjectV2 provisioning, field management, item/issue linking, and governance. Features include:

- Create/update projects, fields, items, and status
- Add draft issues, link repositories/teams, update labels and issue types
- Modular helper functions for GraphQL and CLI integration
- Full alignment with org-wide meta/template files and governance standards
- Bats test coverage and error handling


See usage examples in this README and [LIGHTSPEED_AUTOMATION_HANDBOOK.md](../LIGHTSPEED_AUTOMATION_HANDBOOK.md).

This repository integrates advanced GitHub Project automation, issue/PR labeling, and workflow strategies. All automation scripts, workflows, and label conventions are aligned with the organization-wide standards described in:

- `.github/PROJECT_META.md` (core automation and field sync)
- `.github/PROJECT_META.product-development.md` (product dev template)
- `.github/ISSUE_LABELS.md` (issue labeling)
- `.github/PR_LABELS.md` (PR labeling)

### Key Principles

- **Project fields are the source of truth** for delivery state; labels are signals for automation and routing.
- **Automations** keep issues/PRs in sync with Project fields, using branch, label, and status conventions.
- **No `type:*` labels**—classification lives in the Project's Issue Type field.
- **Lean status values**—use labels like `needs-qa`, `needs-review`, `blocked` and let workflows sync status.

### GitHub Project Automation: product_dev_project.sh

`product_dev_project.sh` automates the provisioning and management of GitHub Projects (ProjectV2) for internal product development. It uses the GitHub CLI (`gh`) and GraphQL API for advanced operations.

#### Features

- Create or update a ProjectV2 for a product
- Add and update standard fields (Status, Issue Type, Priority, Area, Theme, Size, Start Date, Deadline, Milestone, Environment)
- Assign colors to single-select field options via GraphQL
- Add draft issues to the project
- Link repositories and teams to the project
- Update labels and issue types for project items
- Update project, fields, items, and status (extendable)

#### Usage

- Create/Update Project: `./product_dev_project.sh <org> <product-name> [project-number]`
- Add Draft Issue: `./product_dev_project.sh add-draft-issue "<title>" "<body>" [project-number] [org]`
- Link Repository: `./product_dev_project.sh link-repo <repo-owner> <repo-name> [project-number] [org]`
- Link Team: `./product_dev_project.sh link-team <org> <team-slug> [project-number]`
- Update Label: `./product_dev_project.sh update-label <item-id> <label-id>`
- Update Issue Type: `./product_dev_project.sh update-issue-type <item-id> <type-id>`

#### How It Works

- **Field Provisioning:** Ensures all standard fields exist, creates missing ones, and assigns colors using GraphQL mutations.
- **Draft Issues:** Uses the `addProjectV2DraftIssue` GraphQL mutation to add issues directly to the project.
- **Repository Linking:** Uses the `linkProjectV2ToRepository` mutation to associate a repo with the project.
- **Team Linking:** Uses the `linkProjectV2ToTeam` mutation to associate a team with the project.
- **Label/Type Updates:** Uses the `updateProjectV2ItemFieldValue` mutation to update labels and issue types for project items.

#### Extending Automation


You can extend the script to automate:

- Project updates (`updateProjectV2`)
- Field updates (`updateProjectV2Field`)
- Item field value updates (`updateProjectV2ItemFieldValue`)
- Status updates (`updateProjectV2StatusUpdate`)

Refer to the [GitHub GraphQL API documentation for mutation details](https://docs.github.com/en/graphql/reference/mutations).

#### Example Workflow

1. Create a new project:
  `./product_dev_project.sh lightspeedwp "Internal Automation & Docs"`
2. Add a draft issue:
  `./product_dev_project.sh add-draft-issue "Initial Planning" "Kickoff meeting and requirements gathering."`
3. Link a repository:
  `./product_dev_project.sh link-repo lightspeedwp scripts`
4. Link a team:
  `./product_dev_project.sh link-team lightspeedwp devops`
5. Update a label for a project item:
  `./product_dev_project.sh update-label <item-id> <label-id>`
6. Update issue type for a project item:
  `./product_dev_project.sh update-issue-type <item-id> <type-id>`

---

## Issue Labeling Strategy

- **Status labels:** `status:*` (one per issue, e.g. `needs-triage`, `ready`, `in-progress`, `needs-review`, `needs-qa`, `blocked`)
- **Priority labels:** `priority:*` (critical, important, normal, minor)
- **Area/Component labels:** `area:*` or `comp:*` (e.g. `area:theme`, `comp:block-templates`)
- **Routing labels:** `lang:*`, `env:*`, `compat:*`, `cpt:*`, `meta:*`
- **No `type:*` labels**—classification is managed in the Project's Issue Type field.

Automations enforce one status and one priority per issue, defaulting to `status:needs-triage` and `priority:normal` if missing. See `.github/ISSUE_LABELS.md` for full details.

## PR Labeling Strategy

- **Paths → labels:** via `.github/labeler.yml` (e.g. `area:ci`, `lang:php`)
- **Branch prefixes → status:** (`feat/`, `fix/`, `docs/`, `chore/`, `build/` → `status:needs-review`)
- **Changelog hygiene:** `meta:needs-changelog` if no changelog marker exists
- **Status rules:** exactly one `status:*` per PR
- **Optional branch→type mapping:** If Project Type field is present, map PR branch to Type (e.g. `feat/`→`Feature`)

See `.github/PR_LABELS.md` for full details.

## Project Meta Automation

Workflows in `.github/workflows/project-meta-sync.yml` and `.github/workflows/labels-issues-prs.yml`:

- Auto-add issues/PRs to the org Project
- Sync Project fields from labels and branch semantics
- Status, Priority, and Type are derived from labels and branch
- Guardrails: labels are signals, Project fields are the source of truth

## Product Development Project Template

See `.github/PROJECT_META.product-development.md` for recommended fields, automations, and views for product development projects. Key highlights:

- Status: Backlog → Ready → In progress → In review → In QA → Done
- Issue Type: Epic, Feature, Story, Task, Bug, Refactor, Design, Research, Chore
- Milestone/Release: vX.Y.Z
- Recommended views: Release Gate, Tech Debt, Roadmap, Backlog, Epics

## Client Delivery Project Template

See `.github/PROJECT_META.client-delivery.md` for recommended fields, automations, and views for client delivery projects. Key highlights:

- Status: Backlog → Todo → In progress → In review → In QA → Done
- Issue Type: Epic, Story, Task, Bug, Chore, Design, Research
- Recommended views: QA Gate, UAT (Client), Team Flow, Roadmap, Epics

---

## Files Powering Automation

- `.github/workflows/project-meta-sync.yml` — add to Project + update fields
- `.github/workflows/labels-issues-prs.yml` — issue/PR label rules
- `.github/labeler.yml` — path & branch rules for PRs
- `.github/repository.yml` — human-readable repo metadata
- `dependabot.yml` — dependency PRs that feed `area:dependencies`

---

## Script Template

When creating new scripts, follow this template:

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: Brief description of what this script does
# Usage: ./script-name.sh [options] [arguments]
# Author: Your Name
# Date: YYYY-MM-DD
#

set -euo pipefail

# Script implementation here
```

## Playwright Browser Testing

Some automation scripts are tested using Playwright browser tests. See `tests/example.spec.ts` for an example.

Run all browser tests:

```bash
npx playwright test
```

Run a specific test file:

```bash
npx playwright test tests/example.spec.ts
```

## Linting & Formatting

Linting and formatting are automated using npm scripts and GitHub Actions:

- Shell scripts: Linted with ShellCheck
- JS/TS: Linted with ESLint
- Formatting: Enforced with Prettier

Run all linters and formatters:

```bash
npm run lint:js    # Lint JS/TS files
npm run lint:sh    # Lint shell scripts
npm run format     # Format code with Prettier
```

Linting and formatting are checked automatically in CI via `.github/workflows/lint.yml`.

## Testing

All scripts should have corresponding tests in the `/tests/` directory following the naming pattern `test-script-name.bats`.
