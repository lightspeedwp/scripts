# test-create-project-field.sh

Test helper for verifying project field command construction and dry-run output in project automation scripts.

---

## Overview

This script is used to test the helper functions for building project field creation commands and to verify dry-run output for field creation logic. It is primarily used in Bats tests to ensure that field command construction is correct and portable.

### New Features

- **Helper functions**: Loads command construction helpers from `update-projects.sh` for field creation.
- **Dry-run output**: Verifies dry-run output for field creation logic, ensuring correct command structure.
- **Bats test coverage**: Used by `test-create-project-field.bats` to validate helper logic and output.

### Troubleshooting

- If expected tokens are missing in output, check the helper function logic in `update-projects.sh`.
- Ensure the script is executable (`chmod +x test-create-project-field.sh`).

---

## Usage

```bash
./test-create-project-field.sh [--help]
```

### Options

- `--help`: Show usage and exit

---

## Features

- Prints help/usage when `--help` is passed
- Loads and tests helper functions from `update-projects.sh` without running the main script
- Verifies that command parts for field creation include all required tokens (e.g., `gh`, `project`, `field-create`, `--name`, `--data-type`)
- Runs the script in dry-run mode to show printed commands for inspection

---

## Example Output

```bash
$ ./test-create-project-field.sh --help
test-create-project-field.sh: Test for project field command helpers.
Usage: ./test-create-project-field.sh [--help]
 --help    Show this help message.

$ ./test-create-project-field.sh
Command parts:
gh
project
field-create
--name
--data-type
has gh
has project
has field-create
has --name
has --data-type

Running script in dry-run to show printed commands:
... (dry-run output) ...
Test complete.
```

---

## Test Coverage

- Used by Bats tests to validate field command construction and dry-run output
- Ensures helper logic is portable and correct for all field types

---

## Troubleshooting

- If you see errors about missing tokens, check the helper function logic in `update-projects.sh`
- Ensure the script is executable (`chmod +x test-create-project-field.sh`)

---

## See Also

- [update-projects.sh](./update-projects.sh) for main field management logic
- [Bats documentation](https://bats-core.readthedocs.io/en/stable/)
