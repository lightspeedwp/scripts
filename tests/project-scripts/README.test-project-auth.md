# README.test-project-auth.md

## Overview

This shared test suite validates authentication and scope logic for all project automation scripts. It covers GitHub CLI authentication, required scopes, error handling, and integration with multiple scripts via the `SCRIPT` environment variable.

## Test File

- `test-project-auth.bats`

## Features Tested

- GitHub CLI authentication checks
- Required scope validation
- Error handling for missing CLI, authentication, or scopes
- Success path for valid authentication and scopes

## Usage

```bash
SCRIPT=path/to/script.sh bats tests/project-scripts/test-project-auth.bats
```

## Requirements

- bats-core
- bats-support
- bats-assert
- test-helper.bash

## Notes

- Set the `SCRIPT` environment variable to the path of the script under test.
- All tests are idempotent and safe to run repeatedly.
- See [bats-tests-and-runner-scripts.instructions.md](../../.github/instructions/bats-tests-and-runner-scripts.instructions.md) for documentation standards.
