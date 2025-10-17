# Script Name: `update-badges.sh`

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

This script updates the workflow badges in the main `README.md` file of the repository. It dynamically generates badges for all workflows located in the `.github/workflows` directory, ensuring that the documentation always reflects the current CI/CD status.

## Requirements

- `bash`
- `awk`

## Usage

```bash
./update-badges.sh [options]
```

## Options

| Option   | Description            |
| :------- | :--------------------- |
| `--help` | Show this help message |

## Examples

### Update Workflow Badges

This command will find all workflows and update the badges in the `README.md` file.

```bash
./update-badges.sh
```

## Notes

- The script uses HTML comment tags (`<!-- BADGES-START -->` and `<!-- BADGES-END -->`) to identify the section in the `README.md` file where the badges should be placed.
- It is designed to be run from the root of the repository.

---

## Function Reference

### `generate_badges()`

- **Description:** Generates HTML badge links for all GitHub Actions workflows.
- **Arguments:** None
- **Output:** Populates a global `BADGES` array with HTML badge links.
- **Notes:** Dynamically discovers all workflow files in `.github/workflows/` and generates badges that link to the workflow runs on GitHub.

### `update_readme_badges()`

- **Description:** Updates the `README.md` file with the generated badges.
- **Arguments:** None
- **Output:** Modifies the `README.md` file in place.
- **Notes:** This function will replace the content between the `BADGES_START` and `BADGES_END` comments with the new badges.
