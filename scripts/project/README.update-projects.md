# update-projects.sh

This script sets up GitHub Projects fields used by the projects for the
Tour Operator plugin and the ASNZ client. It uses the GitHub CLI (`gh`) and
requires the authenticated token to include GitHub Projects scopes.

All scripts follow LightSpeed WP standards for header comments and inline documentation. See `scripts/README.md` for code comment requirements.

Required scopes

- read:project
- write:project

If your token is missing scopes the script will print a message like:

error: your authentication token is missing required scopes [read:project write:project]
To request it, run:
gh auth refresh -s read:project,write:project

Flags

- `--auto-refresh` — If passed, the script will attempt to run
  `gh auth refresh -s ...` interactively to request the missing scopes.

Usage

Run the script from the `scripts` directory or provide the path:

```bash
./update-projects.sh
./update-projects.sh --auto-refresh
```

## Testing & Validation

- Playwright browser tests are available in `tests/` (see `tests/example.spec.ts`).
- Shell script tests use Bats (see `tests/test-update-projects.bats`).
- Dry-run validation:

```bash
./update-projects.sh --dry-run --project-owner myorg --to-project 101 --asnz-project 202
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
```

Dry-run and testing

- To print the gh commands without executing them, use `--dry-run` and optionally override org/project ids:

```bash
./update-projects.sh --dry-run --project-owner myorg --to-project 101 --asnz-project 202
```

- A simple shell test harness is available at `scripts/test-dry-run.sh`. Run it from the repository root or the `scripts` directory:

```bash
./scripts/test-dry-run.sh
```

- If you use Bats for shell testing, there is a minimal test at
  `scripts/__tests__/update-projects.bats` (requires `bats` to be installed).

Notes

- The script uses `gh api -I /` to inspect the `x-oauth-scopes` header and
  avoid directly reading the token into curl. Ensure you have network access
  to `api.github.com` when running.
- If you prefer not to use `--auto-refresh`, manually run the recommended
  `gh auth refresh -s ...` command printed by the script.
