# product-dev-project.sh

Provision and manage a GitHub ProjectV2 for internal product development, supporting all automatable ProjectV2 actions and standardized fields.

---

## Overview

This script automates the creation and update of a GitHub Project for product development, ensuring all required fields exist with correct options, descriptions, and colors. It is idempotent (safe to run multiple times), supports dry-run mode, and includes robust authentication and error handling. It also provides helpers for common project automation tasks.

---

## Usage

```bash
./product-dev-project.sh <product-name> [project-number]
./product-dev-project.sh <org> <product-name> [project-number]
```

- If `project-number` is omitted, a new project is created.
- If `org` is omitted, defaults to `lightspeedwp`.

### Arguments

- `<org>`: GitHub organization (default: `lightspeedwp`)
- `<product-name>`: Name of the product (required)
- `[project-number]`: Existing project number to update (optional)

### Options

- `--help` or `-h`: Show usage and exit

---

## Features

- **Creates or updates** a ProjectV2 for a product
- **Adds standard fields** (see below) with correct options, descriptions, and colors
- **Idempotent**: Reuses existing fields/options to avoid duplication
- **Dry-run mode**: Set `DRY_RUN=true` to preview all actions without making changes
- **Authentication**: Uses GitHub CLI authentication, supports GitHub App tokens via env vars
- **Field spec compliance**: Follows authoritative field specs ([see field spec doc](../docs/update-projects/product-development-field-specs-v1-1.md))
- **Colorized output** and robust error handling

---

## Standard Fields Created

| Field Name   | Type          | Options/Notes                            |
| ------------ | ------------- | ---------------------------------------- |
| Theme        | Single-select | Design System, Platform, ...             |
| Area         | Single-select | Frontend, Backend, ...                   |
| Priority     | Single-select | High, Medium, Low                        |
| Severity     | Single-select | Blocker, Critical, Major, Minor, Trivial |
| Size         | Single-select | XS, S, M, L, XL                          |
| Phase        | Single-select | Discovery, Build, QA, Launch, ...        |
| Release type | Single-select | Major, Minor, Patch                      |
| Environment  | Single-select | Production, Staging, QA, ...             |
| Status       | Single-select | Todo, In Progress, Done, Blocked, ...    |
| Issue Type   | Single-select | Bug, Feature, Chore, ...                 |
| Milestone    | Single-select | (custom per project)                     |
| Story Points | Number        | (for estimation)                         |
| Estimate     | Number        | (for time/cost)                          |
| Due Date     | Date          | (deadline)                               |
| Start Date   | Date          | (kickoff)                                |
| Deadline     | Date          | (final deadline)                         |
| Assignee     | Text          | (person responsible)                     |

See [field spec doc](../docs/update-projects/product-development-field-specs-v1-1.md) for authoritative options, descriptions, and colors.

---

## Dry-Run & Idempotency

- Set `DRY_RUN=true` to preview all actions (no changes made)
- Script prints all field creation and color assignment actions
- If fields already exist, script prints "Field '<name>' already exists"
- Safe to run multiple times: will not duplicate fields or options

---

## Authentication & Security

- Requires [gh CLI](https://cli.github.com/) authenticated with appropriate scopes: `repo`, `project`, `read:org`, `read:user`
- Supports GitHub App authentication via `LS_APP_ID` and `LS_APP_PRIVATE_KEY` env vars
- Never hardcode credentials; use environment variables

---

## Dependencies

- [gh CLI](https://cli.github.com/)
- [jq](https://stedolan.github.io/jq/)

---

## Example

```bash
# Create a new product project in the default org
./product-dev-project.sh my-product

# Update an existing project in a custom org
./product-dev-project.sh myorg my-product 42

# Dry-run mode (no changes made)
DRY_RUN=true ./product-dev-project.sh my-product
```

---

## Exit Codes

- `0`: Success
- `1`: Invalid arguments or error

---

## Troubleshooting

- Ensure `gh` CLI is authenticated and has access to the organization
- Check for correct permissions to create/update projects
- If you see scope errors, run: `gh auth refresh -s repo,project,read:org,read:user`
- For GitHub App auth, set `LS_APP_ID` and `LS_APP_PRIVATE_KEY` in your environment

---

## See Also

- [Field spec doc](../docs/update-projects/product-development-field-specs-v1-1.md)
- [update-projects.sh](./update-projects.sh) for advanced field management
