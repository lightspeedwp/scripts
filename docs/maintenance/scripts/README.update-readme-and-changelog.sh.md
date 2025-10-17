# Script Name: `update-readme-and-changelog.sh`

**Version:** v0.2.0
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

This script updates all `README.md` files in the repository to ensure they contain a license badge and a link to the `CONTRIBUTING.md` file. It also includes a stub for future enhancements related to `CHANGELOG.md` updates.

## Requirements

- `find`
- `grep`
- `sed`

## Usage

```bash
./update-readme-and-changelog.sh [options]
```

## Options

| Option   | Description            |
| :------- | :--------------------- |
| `--help` | Show this help message |

## Examples

### Update all README files

```bash
./update-readme-and-changelog.sh
```

## Notes

- This script is intended to be executed directly from the root of the repository.
- It will recursively find and update all `README.md` files.

---

## Function Reference

### `show_help()`

- **Description:** Displays the help message for the script.
- **Arguments:** None
- **Output:** Prints the help message to standard output.

### `update_readme_files()`

- **Description:** Finds all `README.md` files and adds a license badge and a contributing link if they are missing.
- **Arguments:** None
- **Output:** Modifies `README.md` files in place.
