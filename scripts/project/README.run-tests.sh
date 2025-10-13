
# run-tests.sh

Batch runner for all Bats test files in `tests/project-scripts/`.

---

## Overview

This script runs all Bats tests for project automation scripts, logging results to a timestamped log file. It ensures all scripts are tested for compliance, authentication, dry-run, and field spec logic.

---

## Usage

```bash
./run-tests.sh
```

---

## Features

- Runs all `*.bats` files in `tests/project-scripts/`
- Logs results to `logs/bats-project-scripts-YYYYMMDD-HHMMSS.log`
- Colorized output for info, success, and error
- Checks for Bats installation before running
- Exits with error if Bats is not installed

---

## Example Output

```bash
$ ./run-tests.sh
[INFO] Running all Bats tests in /path/to/tests/project-scripts/...
[INFO] Running /path/to/tests/project-scripts/test-client-delivery-project.bats...
✓ script exists and is executable
✓ script shows help with --help flag
...
[SUCCESS] All test results are logged in logs/bats-project-scripts-20251013-120000.log
```

---

## Troubleshooting

- If you see `[ERROR] bats is not installed`, install [bats-core](https://github.com/bats-core/bats-core) and ensure it is in your PATH.
- Ensure all scripts under test are executable (`chmod +x script.sh`).
- Check the log file for detailed test output and failures.

---

## Integration

- Used in CI/CD to validate all project automation scripts
- Ensures compliance with LightSpeed WP standards and field specs

---

## See Also

- [Bats documentation](https://bats-core.readthedocs.io/en/stable/)
- [test-helper.bash](../../tests/test-helper.bash) for shared test logic
