
# Project Script Test Suite

This folder contains comprehensive [Bats](https://github.com/bats-core/bats-core) test suites for all GitHub Project automation scripts in `scripts/project/`. These tests ensure robust, spec-compliant automation for both client delivery and product development workflows, covering argument parsing, field creation, authentication, dry-run, idempotency, and error handling.

---

## Test Files Overview

| Test File                                 | Purpose                                                                                       |
|-------------------------------------------|-----------------------------------------------------------------------------------------------|
| `test-client-delivery-project.bats`       | Tests `client-delivery-project.sh` for argument handling, help output, dry-run, field creation, idempotency, env overrides, and error handling |
| `test-client-delivery-project-auth.bats`  | Tests authentication logic for `client-delivery-project.sh` (gh CLI presence, auth, scopes)    |
| `test-product_dev_project.bats`           | Tests `product-dev-project.sh` for CLI commands, dry-run, field creation, idempotency, env overrides, and error handling |
| `test-product-dev-project-auth.bats`      | Tests authentication logic for `product-dev-project.sh` (gh CLI presence, auth, scopes)        |
| `test-create-project-field.bats`          | Tests helper logic for field command construction and dry-run output in project scripts        |
| `test-update-projects.bats`               | Tests `update-projects.sh` for field management, CSV-driven creation, options, dry-run, deletion, and error handling |

---

## How the Tests Work

- **Bats Framework**: All tests are written in Bats, a Bash-based testing framework. Each test runs the target script with various arguments and environment variables, then asserts on exit codes and output.
- **Mocking**: Many tests set `GH_CLI_MOCK=1` to simulate GitHub CLI presence and authentication, ensuring tests are safe and do not require real API calls.
- **Dry-Run Mode**: Tests use `DRY_RUN=true` to verify that scripts print the correct actions without making changes.
- **Helper Functions**: Shared logic is loaded from `../../tests/test-helper.bash`.
- **Edge Cases**: Tests cover missing arguments, invalid field specs, duplicate fields, missing dependencies, and credential leakage prevention.
- **CSV-Driven Tests**: `test-update-projects.bats` uses CSV fixtures to test bulk field creation and deletion.
- **Idempotency**: Tests ensure scripts can be run repeatedly without duplicating fields or options.
- **Colorized Output**: Tests validate that scripts print colorized info, success, and error messages.

---

## Running the Tests

### With run-tests.sh (Recommended)

Use the batch runner to execute all Bats tests and log results:

```bash
cd scripts/project
./run-tests.sh
```

- All results are logged to `logs/bats-project-scripts-YYYYMMDD-HHMMSS.log` in the repo root.
- The script prints colorized info, success, and error messages for each test file.

### Directly with Bats

To run all tests in this folder:

```bash
bats .
```

To run a specific test file:

```bash
bats test-client-delivery-project.bats
```

---

## What the Tests Cover

- Script help output and argument parsing
- Field creation for all required types (single-select, number, date, text)
- Dry-run and live modes for field creation, update, and deletion
- Option, description, and color assignment for single-select fields
- Idempotency (re-running with existing fields)
- Environment variable overrides (ORG, CLIENT_NAME, PRODUCT_NAME)
- Error handling for missing/invalid arguments and field specs
- Authentication logic (gh CLI presence, auth, required scopes)
- Output validation for colorized logs and info/success/error messages
- Credential leakage prevention (ensures secrets are not printed)
- CSV-driven field creation and deletion
- Helper function correctness (via SKIP_MAIN=1 sourcing)
- Edge cases: duplicate fields, missing dependencies, invalid CSV

---

## Log Files

- All test runs via `run-tests.sh` are logged to `logs/bats-project-scripts-YYYYMMDD-HHMMSS.log` in the repository root.
- Review these logs for detailed output, failures, and troubleshooting.

---

## Adding or Modifying Tests

- Add new `.bats` files for additional scripts or features
- Use descriptive test names and comments
- Mock external dependencies (e.g., GitHub CLI) for safe testing
- Validate both positive and negative scenarios
- Source scripts with `SKIP_MAIN=1` to test helper functions in isolation

---

## Troubleshooting

- Ensure Bats is installed and available in your PATH ([bats-core install guide](https://github.com/bats-core/bats-core))
- Run tests in a clean environment to avoid side effects
- Use the `--verbose` flag for detailed output
- If a test fails, check the log file for details and rerun the test with debugging enabled

---

## Related Documentation

- [scripts/project/README.client-delivery-project.md](../../scripts/project/README.client-delivery-project.md)
- [scripts/project/README.product-dev-project.md](../../scripts/project/README.product-dev-project.md)
- [scripts/project/README.update-projects.md](../../scripts/project/README.update-projects.md)
- [test-helper.bash](../../tests/test-helper.bash)
- [Field spec docs](../../scripts/docs/update-projects/)

---

**All project automation scripts must have corresponding, up-to-date tests in this folder.**
