
# client-delivery-project.sh

Provision and manage a GitHub ProjectV2 for client delivery engagements using Scrumban-style statuses and standardized fields.

---

## Overview

This script automates the creation and update of a GitHub Project for client delivery, ensuring all required fields exist with correct options, descriptions, and colors. It is idempotent (safe to run multiple times), supports dry-run mode, and includes robust authentication and error handling.

### Features

- **Comprehensive logging**: Logs all operations to both console and a timestamped log file in the `logs/` directory for troubleshooting and auditing.
- **CSV-driven settings import**: Use `--settings-file <csv>` to import project name, description, README, visibility, base role, and collaborators from a CSV file.
- **Access management**: Use `--access-file <csv>` to set base role and invite collaborators/teams with specific roles (No Access, Read, Write, Admin) from a separate CSV file.
- **Authentication logic**: Robust checks for GitHub CLI presence, authentication, and required scopes. Supports GitHub App tokens via environment variables.
- **Helper functions**: Includes output assertion helpers for Bats tests (`contains`, `not_contains`).
- **Standardized project fields**: Creates all required fields according to the client delivery field specifications document.

### Test Coverage

- Comprehensive Bats tests for argument parsing, dry-run simulation, field creation, idempotency, authentication, CSV import, and access management.
- Tests are organized into three files:
  - `tests/project-scripts/test-client-delivery-project.bats`: Core functionality tests
  - `tests/project-scripts/test-client-delivery-project-auth.bats`: Authentication validation tests
  - `tests/project-scripts/test-client-delivery-project-csv.bats`: CSV import and settings tests
- All test output is logged to a central log file via `run-tests.sh`

### Logging

- All operations are logged to the console with color-coded status indicators
- Log files are created in `scripts/project/logs/` directory with format `client-delivery-project-YYYYMMDD-HHMMSS.log`
- Log entries include timestamps and severity level (INFO, SUCCESS, WARNING, ERROR)
- Console and file logging are synchronized to ensure complete audit trail

### Troubleshooting

- If dry-run output does not match test expectations, check the script's dry-run simulation logic.
- If the log directory cannot be created, check permissions on the parent directory.
- For authentication failures, review the log file for detailed error information.
- For authentication failures, verify error messages match Bats test assertions.
- For CSV import issues, confirm the CSV format and script parsing logic are consistent.

---

## Usage

```bash
./client-delivery-project.sh <client-name> [project-number]
./client-delivery-project.sh <org> <client-name> [project-number]
```

- If `project-number` is omitted, a new project is created.
- If `org` is omitted, defaults to `lightspeedwp`.

### Arguments

- `<org>`: GitHub organization (default: `lightspeedwp`)
- `<client-name>`: Name of the client (required)
- `[project-number]`: Existing project number to update (optional)

### Options

- `--help` or `-h`: Show usage and exit
- `--settings-file <csv>`: Import project settings from a CSV file
- `--access-file <csv>`: Import access permissions from a CSV file
- `--manage-access`: Enable access management (base role, invite collaborators)

---

## Capabilities

- **Creates or updates** a ProjectV2 for a client
- **Adds standard fields** (see below) with correct options, descriptions, and colors
- **Idempotent**: Reuses existing fields/options to avoid duplication
- **Dry-run mode**: Set `DRY_RUN=true` to preview all actions without making changes
- **Authentication**: Uses GitHub CLI authentication, supports GitHub App tokens via env vars
- **Field spec compliance**: Follows authoritative field specs ([see field spec doc](../docs/update-projects/client-delivery-field-specs-v1-1.md))
- **Colorized output** and robust error handling

---

## Standard Fields Created

| Field Name      | Type         | Options/Notes                                   |
|-----------------|--------------|------------------------------------------------|
| Theme           | Single-select| Design System, Platform, ...                    |
| Area            | Single-select| Frontend, Backend, ...                          |
| Priority        | Single-select| High, Medium, Low                              |
| Severity        | Single-select| Blocker, Critical, Major, Minor, Trivial        |
| Size            | Single-select| XS, S, M, L, XL                                 |
| Phase           | Single-select| Discovery, Build, QA, Launch, ...               |
| Release type    | Single-select| Major, Minor, Patch                             |
| Environment     | Single-select| Production, Staging, QA, ...                    |
| Status          | Single-select| Todo, In Progress, Done, Blocked, ...           |
| Issue Type      | Single-select| Bug, Feature, Chore, ...                        |
| Milestone       | Single-select| (custom per project)                            |
| Story Points    | Number       | (for estimation)                                |
| Estimate        | Number       | (for time/cost)                                 |
| Due Date        | Date         | (deadline)                                      |
| Start Date      | Date         | (kickoff)                                       |
| Deadline        | Date         | (final deadline)                                |
| Assignee        | Text         | (person responsible)                            |

See [field spec doc](../docs/update-projects/client-delivery-field-specs-v1-1.md) for authoritative options, descriptions, and colors.

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
# Create a new client project in the default org
./client-delivery-project.sh acme-corp

# Update an existing project in a custom org
./client-delivery-project.sh myorg acme-corp 42

# Dry-run mode (no changes made)
DRY_RUN=true ./client-delivery-project.sh acme-corp

# Create with CSV settings and access management
./client-delivery-project.sh acme-corp --settings-file fixtures/client-delivery-settings.csv --access-file fixtures/client-delivery-manage-access.csv --manage-access
```

## CSV File Formats

### Settings CSV

The settings CSV should include these columns:

```csv
Project Name,Short Description,README,Visibility,Base Role,Invite Collaborators
Client Delivery Project,Project for managing client delivery engagements,See docs/update-projects/client-delivery-project-template-v1-6.md,Public,Write,"Interns;Developers;ashleyshaw"
```

### Access Management CSV

The access CSV uses the format `Team/User,Role` with a blank Team/User for the base role:

```csv
Team/User,Role
Interns,Write
Developers,Write
ashleyshaw,Admin
```

Supported roles:

- No Access
- Read (default if not specified)
- Write
- Admin

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
- For CSV-related issues, verify your CSV follows the format examples above

---

## See Also

- [Field spec doc](../docs/update-projects/client-delivery-field-specs-v1-1.md)
- [update-projects.sh](./update-projects.sh) for advanced field management
