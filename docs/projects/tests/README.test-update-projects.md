# README.test-update-projects.md

## Overview

This test suite validates the main functionality of `update-projects.sh` for managing GitHub Project fields. It covers argument parsing, help output, field creation, deletion, authentication, CSV import, dry-run simulation, and error handling. Shared test suites cover CSV import and authentication logic.

## Test File

- `test-update-projects.bats`

## Features Tested

- Argument parsing and usage/help output
- Field creation and deletion
- CSV-driven field management
- Authentication logic and error handling
- Dry-run simulation and idempotency
- Integration with shared CSV and authentication test suites

## Usage

```bash
npx bats tests/project-scripts/test-update-projects.bats
# For CSV import and authentication tests:
SCRIPT=path/to/update-projects.sh bats tests/project-scripts/test-project-csv.bats
SCRIPT=path/to/update-projects.sh bats tests/project-scripts/test-project-auth.bats
```

## Requirements

- bats-core
- bats-support
- bats-assert
- test-helper.bash

## Notes

- For shared CSV and authentication tests, set the `SCRIPT` environment variable to the path of the script under test.
- All tests are idempotent and safe to run repeatedly.
- See [bats-tests-and-runner-scripts.instructions.md](../../.github/instructions/bats-tests-and-runner-scripts.instructions.md) for documentation standards.
