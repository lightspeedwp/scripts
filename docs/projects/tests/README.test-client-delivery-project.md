# README.test-client-delivery-project.md

## Overview

This test suite validates the core functionality of `client-delivery-project.sh` for LightSpeed WP client delivery project automation. It covers argument parsing, help output, dry-run simulation, field creation, idempotency, environment variable overrides, and error handling. Shared test suites cover CSV import and authentication logic.

## Test File

- `test-client-delivery-project.bats`

## Features Tested

- Argument parsing and usage/help output
- Field creation and color assignment
- Dry-run simulation and idempotency
- Error handling and environment variable overrides
- Integration with shared CSV and authentication test suites

## Usage

```bash
npx bats tests/project-scripts/test-client-delivery-project.bats
# For CSV import and authentication tests:
SCRIPT=path/to/client-delivery-project.sh bats tests/project-scripts/test-project-csv.bats
SCRIPT=path/to/client-delivery-project.sh bats tests/project-scripts/test-project-auth.bats
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
