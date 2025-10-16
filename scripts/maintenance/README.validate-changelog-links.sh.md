# Script Name: `validate-changelog-links.sh`

**Version:** v0.1.0
**Author:** LightSpeedWP
**License:** [GPL v3 or later](https://www.gnu.org/licenses/gpl-3.0.html)

## Table of Contents

- [Description](#description)
- [Requirements](#requirements)
- [Usage](#usage)
- [Options](#options)
- [Examples](#examples)
- [Notes](#notes)
- [Function Reference](#function-reference)

---

## Description

This script validates that all changelog entries under the `[Unreleased]` section of `CHANGELOG.md` include a linked Pull Request, Issue, or Commit. This ensures that all changes are traceable and properly documented before a new release.

## Requirements

- A `CHANGELOG.md` file in the root of the repository.
- `awk`
- `grep`

## Usage

```bash
./validate-changelog-links.sh [options]
```

## Options

| Option   | Description            |
| :------- | :--------------------- |
| `--help` | Show this help message |

## Examples

### Validate Changelog Links

```bash
./validate-changelog-links.sh
```

## Notes

- This script focuses exclusively on the `[Unreleased]` section for validation.
- It checks for PR references (e.g., `[#123]`), issue links, and commit references.
- The script will exit with a success status only if all entries have proper links.

---

## Function Reference

### `log_error()`

- **Description:** Logs error messages to standard error with an `[ERROR]` prefix.
- **Arguments:**
  - `$*`: The error message to log.
- **Output:** Prints the formatted error message to standard error.
