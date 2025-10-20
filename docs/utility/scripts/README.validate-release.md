# README for validate-release.sh

This document provides a detailed explanation of the `validate-release.sh` script, its purpose, and usage instructions.

---

## Table of Contents

- [Script Overview](#script-overview)
- [Version Information](#version-information)
- [Requirements](#requirements)
- [Usage](#usage)
- [Validation Checks](#validation-checks)
- [Function Reference](#function-reference)
- [License](#license)

---

## Script Overview


The `validate-release.sh` script is a pre-release checklist tool. It runs a series of checks to ensure that the repository is in a consistent and valid state before a new version is released. This helps prevent common release issues, such as version mismatches, broken workflows, or incomplete documentation.

## Changelog and Release Automation

The release process is fully automated using GitHub Actions and supporting scripts. Every PR must include a changelog entry under the `[Unreleased]` section of `CHANGELOG.md` (unless `[skip changelog]` is present). On release, the changelog is compiled, the version is bumped, and a GitHub Release is created with notes from the changelog. The `validate-release.sh` script validates that the changelog, version, and documentation are consistent and complete before a release can proceed. See also: `validate-changelog-links.sh` for changelog entry validation.

The script is designed to be run from the root of the repository, either manually by a developer or as part of an automated CI/CD pipeline.

## Version Information

- **Version:** v0.1.0
- **Date:** 2025-10-14
- **Author:** LightSpeedWP
- **Contributors:** @lightspeedwp / @ashleyshaw

## Requirements

- **Bash:** Version 4.0 or later.
- **`jq`:** For parsing `package.json`.
- **`yq` or `python3` with `PyYAML`:** For validating the syntax of YAML workflow files.
- **`bats-core`:** For validating that tests can be run.

## Usage

Execute the script from the root of the repository. You can specify the version you expect the repository to be at.

```bash
./scripts/utility/validate-release.sh [--version VERSION] [--verbose]
```

**Options:**

| Option | Description |
| --- | --- |
| `--version VERSION` | The version string to check for (e.g., `0.2.0`). Defaults to `0.1.0`. |
| `--verbose`, `-v` | Enable verbose output, which provides more detail on the checks being performed. |
| `--help`, `-h` | Display the help message. |

## Validation Checks

The script performs the following checks:

1. **Version Consistency:**
    - Reads the `VERSION` file.
    - Reads the `version` field from `package.json`.
    - Compares both against the expected version and ensures they match.

2. **Workflow Validity:**
    - Checks for the existence of essential workflow files (`release.yml`, `test.yml`, `lint.yml`) in `.github/workflows/`.
    - Validates the YAML syntax of all workflow files to catch parsing errors.

3. **Test Coverage:**
    - Ensures the `tests/` directory exists.
    - Counts the number of `.bats` test files.
    - If `bats` is installed, it confirms that the test suite can be executed.

4. **Documentation Completeness:**
    - Verifies that `README.md`, `CHANGELOG.md`, and `CONTRIBUTING.md` exist.
    - Checks if the `CHANGELOG.md` contains an entry for the expected version.

If all checks pass, the script exits with a status code of `0`. If any check fails, it logs an error and exits with a status code of `1`.

## Function Reference

| Function | Description |
| --- | --- |
| `main()` | The main entry point that parses arguments and calls the validation functions. |
| `check_version_files()` | Performs the version consistency checks. |
| `check_workflows()` | Validates the GitHub Actions workflow files. |
| `check_tests()` | Checks for the existence and executability of the test suite. |
| `check_documentation()` | Ensures essential documentation files are present and correctly formatted. |
| `log_info()`, `log_success()`, `log_warning()`, `log_error()` | Internal logging functions for formatted console output. |

## License

This script is licensed under the [GPL v3 or later](https://www.gnu.org/licenses/gpl-3.0.html).
