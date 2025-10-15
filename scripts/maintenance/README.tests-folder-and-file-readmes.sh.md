# Test Suite: `tests-folder-and-file-readmes.sh`

**Version:** v0.1.0
**Author:** LightSpeedWP
**License:** [GPL v3 or later](https://www.gnu.org/licenses/gpl-3.0.html)

## Table of Contents

- [Description](#description)
- [Requirements](#requirements)
- [Usage](#usage)
- [Test Scope](#test-scope)
- [Notes](#notes)

---

## Description

This script is a comprehensive Bats test suite for the `folder-and-file-readmes.sh` maintenance script. It validates all command-line options, error handling, and core functionalities such as dry-run, linting, table of contents generation, and profile mode. The suite ensures that the documentation generation script complies with LightSpeed WP standards for shell script documentation and test coverage.

## Requirements

- `bats-core`
- `test-helper.bash`

## Usage

To run the test suite, execute the following command from the repository root:

```bash
bats scripts/maintenance/tests-folder-and-file-readmes.sh
```

## Test Scope

This test suite covers the following scenarios:

- **Script Existence:** Verifies that the `folder-and-file-readmes.sh` script exists and is executable.
- **Core Functionality:** Tests `dry-run`, `lint`, `toc`, and `profile` options.
- **Error Handling:** Ensures the script handles errors gracefully.
- **File Operations:** Validates `backup`, `merge`, and `overwrite` functionalities.

## Notes

- All CLI options and error conditions are tested.
- Dry-run mode is validated to ensure no files are written to disk.
- Paths are resolved relative to the test file location.
- This test suite should be expanded as new features are added to the `folder-and-file-readmes.sh` script.
