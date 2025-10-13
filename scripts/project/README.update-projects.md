

# update-projects.sh

This script automates the creation, update, and deletion of GitHub Project fields for LightSpeed WP projects using the GitHub CLI (`gh`). It supports both interactive and non-interactive usage, CSV-driven field management, dry-run mode, and advanced authentication options.

## How It Works

1.**Setup & Error Handling**

- Enables strict error handling (`set -euo pipefail`).
- Defines colorized logging functions for clear output.

2.**Argument Parsing**

- Parses command-line options to determine project owner, project number, field CSV file, dry-run mode, and other behaviors.
- Example: `--fields-file <path>` specifies a CSV of fields to create or delete.

3.**Authentication & Scopes**

- Checks for the GitHub CLI and verifies authentication.
- Supports GitHub App authentication via environment variables.
- Validates required scopes (`repo`, `project`, `read:org`, `read:user`) and can auto-refresh them interactively if needed.

4.**Project Detection**

- Auto-detects project owner and number from environment variables, git remote, or authenticated user.
- Can parse these from `LS_PROJECT_URL` if set.

5.**Field Management**

- Reads field definitions from a CSV file (see format below).
- For each field, either creates or deletes (archives) it using the GitHub CLI.
- Supports single-select, number, date, and text field types.
- In dry-run mode, prints the commands instead of executing them.

6.**Execution Flow**

- Runs all checks and processes fields as specified.
- If no CSV is provided, creates example fields for demonstration.
- Logs all actions with colorized output for clarity.

## Security Warning: Hardcoded Credentials

**Never embed credentials, tokens, or private keys directly in source code.**

- Always use environment variables for sensitive information (e.g., `LS_APP_ID`, `LS_APP_PRIVATE_KEY`, `GH_TOKEN`).
- Do not commit secrets to version control.
- Rotate credentials regularly and restrict their scope.
- If you suspect credentials have been exposed, revoke and replace them immediately.

**Best Practice:**

Set credentials in your CI/CD environment or local shell, not in the script or repository files.

## Features

- Create, update, and delete project fields (single-select, number, date, text)
- Read field definitions from a CSV file for bulk operations
- Preview all operations with `--dry-run` (no changes made)
- Auto-detect project owner and number from environment or repo
- Refresh GitHub CLI scopes interactively with `--auto-refresh`
- Robust error handling and colorized logging
- Supports GitHub App authentication via environment variables

## Required Scopes

The following GitHub CLI scopes are required:

- `repo`
- `project`
- `read:org`
- `read:user`

If your token is missing scopes, the script will print a message like:

```
error: your authentication token is missing required scopes [repo project read:org read:user]
To request it, run:
gh auth refresh -s repo,project,read:org,read:user
```

## Flags & Options

| Option                | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `--project-owner <org>`   | Override project owner (default: auto-detect from repo or LS_PROJECT_URL)   |
| `--project-number <num>`  | Override project number (default: auto-detect from LS_PROJECT_URL)          |
| `--fields-file <path>`    | CSV file of fields to create (see format below)                             |
| `--delete-fields`         | Delete (archive) fields listed in CSV instead of creating them              |
| `--auto-refresh`          | Interactively refresh GitHub CLI scopes if needed                           |
| `--dry-run`               | Print commands instead of executing them                                    |
| `--help`                  | Show this help message                                                      |

## CSV Format for Field Creation

The script supports bulk field creation via a CSV file. Format:

```csv
name,type,options(optional)
Priority,single_select,High,Medium,Low
Status,single_select,Todo,In Progress,Done
Severity,single_select,Blocker,Critical,Major,Minor,Trivial
Assignee,text,
Due Date,date,
Story Points,number,
```

- Lines starting with `#` are ignored.
- For single-select fields, list options separated by commas after the type.
- For number, date, or text fields, leave the options column empty.

## Usage Examples

Run the script from the `scripts/project/` directory or provide the path:

```bash
./update-projects.sh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1
```

Preview all operations (dry-run):

```bash
./update-projects.sh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1 --dry-run
```

Delete (archive) fields listed in a CSV:

```bash
./update-projects.sh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1 --delete-fields
```

Auto-refresh scopes interactively:

```bash
./update-projects.sh --auto-refresh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1
```

## Environment Variables

- `LS_APP_ID`: GitHub App ID (for App authentication)
- `LS_APP_PRIVATE_KEY`: GitHub App private key (PEM format)
- `LS_PROJECT_URL`: GitHub project URL (for auto-detection of owner/number)
- `GH_TOKEN`: GitHub token (alternative to standard gh auth)

## Project Owner/Number Auto-Detection

- If `LS_PROJECT_URL` is set, the script will parse the owner and project number from the URL.
- If not set, it will attempt to detect the owner from the git remote or authenticated user.
- You can always override with `--project-owner` and `--project-number`.

## Testing & Validation

- Shell script tests use Bats (see `tests/project-scripts/test-update-projects.bats`).
- Playwright browser tests are available in `tests/` (see `tests/example.spec.ts`).
- Dry-run validation:

```bash
./update-projects.sh --dry-run --fields-file fixtures/fields.csv --project-owner myorg --project-number 1
```

- Simple shell test harness:

```bash
./scripts/test-dry-run.sh
```

## Linting & Formatting

Linting and formatting are automated using npm scripts and GitHub Actions:

- Shell scripts: ShellCheck
- JS/TS: ESLint
- Formatting: Prettier

Run locally:

```bash
npm run lint:js
npm run lint:sh
npm run format
```

CI checks run automatically on push/PR via `.github/workflows/lint.yml`.

## Notes

- The script uses `gh api -I /` to inspect the `x-oauth-scopes` header and avoid directly reading the token into curl. Ensure you have network access to `api.github.com` when running.
- If you prefer not to use `--auto-refresh`, manually run the recommended `gh auth refresh -s ...` command printed by the script.
- All field operations are logged with colorized output for clarity.
- For advanced usage, see the script source and comments for details on authentication, error handling, and extensibility.

## Features

- Create, update, and delete project fields (single-select, number, date, text)
- Read field definitions from a CSV file for bulk operations
- Preview all operations with `--dry-run` (no changes made)
- Auto-detect project owner and number from environment or repo
- Refresh GitHub CLI scopes interactively with `--auto-refresh`
- Robust error handling and colorized logging
- Supports GitHub App authentication via environment variables

## Required Scopes

The following GitHub CLI scopes are required:

- `repo`
- `project`
- `read:org`
- `read:user`

If your token is missing scopes, the script will print a message like:

```
error: your authentication token is missing required scopes [repo project read:org read:user]
To request it, run:
gh auth refresh -s repo,project,read:org,read:user
```

## Flags & Options

| Option                | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `--project-owner <org>`   | Override project owner (default: auto-detect from repo or LS_PROJECT_URL)   |
| `--project-number <num>`  | Override project number (default: auto-detect from LS_PROJECT_URL)          |
| `--fields-file <path>`    | CSV file of fields to create (see format below)                             |
| `--delete-fields`         | Delete (archive) fields listed in CSV instead of creating them              |
| `--auto-refresh`          | Interactively refresh GitHub CLI scopes if needed                           |
| `--dry-run`               | Print commands instead of executing them                                    |
| `--help`                  | Show this help message                                                      |

## CSV Format for Field Creation

The script supports bulk field creation via a CSV file. Format:

```
name,type,options(optional)
Priority,single_select,High,Medium,Low
Status,single_select,Todo,In Progress,Done
Severity,single_select,Blocker,Critical,Major,Minor,Trivial
Assignee,text,
Due Date,date,
Story Points,number,
```
- Lines starting with `#` are ignored.
- For single-select fields, list options separated by commas after the type.
- For number, date, or text fields, leave the options column empty.

## Usage Examples

Run the script from the `scripts/project/` directory or provide the path:

```bash
./update-projects.sh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1
```

Preview all operations (dry-run):

```bash
./update-projects.sh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1 --dry-run
```

Delete (archive) fields listed in a CSV:

```bash
./update-projects.sh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1 --delete-fields
```

Auto-refresh scopes interactively:

```bash
./update-projects.sh --auto-refresh --fields-file fixtures/fields.csv --project-owner myorg --project-number 1
```

## Environment Variables

- `LS_APP_ID`: GitHub App ID (for App authentication)
- `LS_APP_PRIVATE_KEY`: GitHub App private key (PEM format)
- `LS_PROJECT_URL`: GitHub project URL (for auto-detection of owner/number)
- `GH_TOKEN`: GitHub token (alternative to standard gh auth)

## Project Owner/Number Auto-Detection

- If `LS_PROJECT_URL` is set, the script will parse the owner and project number from the URL.
- If not set, it will attempt to detect the owner from the git remote or authenticated user.
- You can always override with `--project-owner` and `--project-number`.

## Testing & Validation

- Shell script tests use Bats (see `tests/project-scripts/test-update-projects.bats`).
- Playwright browser tests are available in `tests/` (see `tests/example.spec.ts`).
- Dry-run validation:

```bash
./update-projects.sh --dry-run --fields-file fixtures/fields.csv --project-owner myorg --project-number 1
```

- Simple shell test harness:

```bash
./scripts/test-dry-run.sh
```

## Linting & Formatting

Linting and formatting are automated using npm scripts and GitHub Actions:

- Shell scripts: ShellCheck
- JS/TS: ESLint
- Formatting: Prettier

Run locally:

```bash
npm run lint:js
npm run lint:sh
npm run format
```

CI checks run automatically on push/PR via `.github/workflows/lint.yml`.

## Notes

- The script uses `gh api -I /` to inspect the `x-oauth-scopes` header and avoid directly reading the token into curl. Ensure you have network access to `api.github.com` when running.
- If you prefer not to use `--auto-refresh`, manually run the recommended `gh auth refresh -s ...` command printed by the script.
- All field operations are logged with colorized output for clarity.
- For advanced usage, see the script source and comments for details on authentication, error handling, and extensibility.
