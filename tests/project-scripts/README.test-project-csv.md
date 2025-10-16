# README.test-project-csv.md

## Overview

This shared test suite validates CSV import and dry-run output logic for all project automation scripts. It covers importing settings, access, and fields from CSV files, dry-run simulation, and integration with multiple scripts via the `SCRIPT` environment variable.

## Test File

- `test-project-csv.bats`

## Features Tested

- Importing settings CSV and validating dry-run output
- Importing access CSV and validating dry-run output
- Importing fields CSV and validating dry-run output
- Access management logic

## Usage

```bash
SCRIPT=path/to/script.sh bats tests/project-scripts/test-project-csv.bats
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
