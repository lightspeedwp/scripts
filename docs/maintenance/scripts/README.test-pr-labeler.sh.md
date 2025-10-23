# Script Name: `test-pr-labeler.sh`

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

This script is a simple test utility designed to verify the functionality of the Pull Request (PR) labeler workflow. It ensures that the automated labeling process is working as expected.

## Requirements

- `bats-core`

## Usage

```bash
./test-pr-labeler.sh [options]
```

## Options

| Option   | Description            |
| :------- | :--------------------- |
| `--help` | Show this help message |

## Examples

### Run the test script

```bash
./test-pr-labeler.sh
```

### Show Help

```bash
./test-pr-labeler.sh --help
```

## Notes

- This script is intended to be used as part of the CI/CD pipeline to validate the PR labeling workflow.
- It automatically verifies that the 'scripts' label is added to relevant PRs.

---

## Function Reference

### `show_help()`

- **Description:** Displays the help message for the script.
- **Arguments:** None
- **Output:** Prints the help text to standard output.

### `main()`

- **Description:** The main function that runs the PR labeler test. It handles argument parsing and prints verification messages.
- **Arguments:**
    - `$@`: Command-line arguments passed to the script.
- **Output:** Prints verification messages for the PR labeler workflow to standard output.
