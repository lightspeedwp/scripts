# README for folder-and-file-readmes.sh

This document provides a comprehensive overview of the `folder-and-file-readmes.sh` script, its features, usage, and integration in LightSpeed WP automation workflows.

---

## Table of Contents

- [Script Overview](#script-overview)
- [Version Information](#version-information)
- [Requirements](#requirements)
- [Usage](#usage)
- [Options](#options)
- [Examples](#examples)
- [Features](#features)
- [Function Reference](#function-reference)
- [Integration](#integration)
- [Customization](#customization)
- [License](#license)

---

## Script Overview

`folder-and-file-readmes.sh` automates the generation of documentation for repository folders and files. It creates a main `README.md` for a folder and a `README.<filename>.md` for each file, extracting header metadata and composing rich, standards-compliant documentation. The script supports backup, merge, overwrite, linting, table of contents, and profile options for robust automation and compliance.

## Version Information

- **Version:** v1.0.0
- **Date:** 2025-10-15
- **Author:** LightSpeed WP Team
- **Contributors:** @lightspeedwp / @ashleyshaw

## Requirements

- **bash**
- **file**
- **grep**
- **sed**
- **xargs**

## Usage

```bash
./folder-and-file-readmes.sh [options] <target-folder>
./folder-and-file-readmes.sh --file <file> [--merge|--overwrite]
DRY_RUN=true ./folder-and-file-readmes.sh <target-folder>
```

## Options

| Option | Description |
| --- | --- |
| `--help` | Show help message |
| `--lint` | Lint generated markdown files |
| `--toc` | Add table of contents to README.md or specified file |
| `--dry-run` | Preview changes without writing files |
| `--profile` | Generate GitHub profile-style README.md |
| `--file <file>` | Generate README for a specific file |
| `--merge` | Merge new content with existing README |
| `--overwrite` | Overwrite existing README |
| `--create <folders...>` | Create docs for one or more folders |
| `--list` | List all markdown files that would be generated |
| `--backup` | Backup existing README files before overwrite |
| `--check` | Check for missing documentation blocks |
| `--update` | Update existing README files with new content |
| `--force` | Force overwrite even if backup exists |
| `--exclude <pat>` | Exclude files/folders matching pattern |
| `--include <pat>` | Include only files/folders matching pattern |
| `--summary` | Show summary of generated docs |
| `--version` | Show script version |
| `--log-file <file>` | Specify log file for output |
| `--color` | Enable colored output |
| `--no-color` | Disable colored output |
| `--config <file>` | Specify config file for doc generation |
| `--env <key=val>` | Set environment variable for script |
| `--list-env` | List environment variables |
| `--clear-env` | Clear environment variables |
| `--help-all` | Show help for all options |

## Examples

- Generate documentation for a folder:

  ```bash
  ./folder-and-file-readmes.sh scripts/maintenance
  ```

- Generate README for a specific file:

  ```bash
  ./folder-and-file-readmes.sh --file scripts/project/update-projects.sh --merge
  ```

- Preview changes (dry run):

  ```bash
  DRY_RUN=true ./folder-and-file-readmes.sh scripts/utility
  ```

- Add table of contents and lint:

  ```bash
  ./folder-and-file-readmes.sh --lint --toc scripts/maintenance
  ```

- Multi-folder support:

  ```bash
  ./folder-and-file-readmes.sh --create scripts/maintenance scripts/project scripts/utility
  ```

## Features

- Generates rich, standards-compliant documentation for folders and files
- Extracts header metadata and composes documentation sections
- Supports backup, merge, overwrite, lint, and dry-run modes
- Validates header completeness and documentation blocks
- Adds table of contents and profile-style README options
- Integrates with CI/CD pipelines for automated documentation
- Logs actions and supports exclusion/inclusion patterns

## Function Reference

| Function | Description |
| --- | --- |
| `generate_file_readme()` | Generates `README.<filename>.md` for a file, extracting header metadata and composing documentation sections. |
| `parse_arguments()` | Parses command line arguments and sets script options. |
| `main()` | Main execution function, coordinates argument parsing, README generation, and option handling. |
| `create_docs_for_folders()` | Generates documentation for all valid files in specified folders. |

## Integration

This script is designed for use in automation pipelines and can be integrated with related scripts in the repository. It supports LightSpeed WP shell script and documentation standards and is suitable for CI/CD workflows.

## Customization

You can extend this script by editing its header, options, or integrating with other tools. Configuration files and environment variables allow for flexible customization.

## License

This script is licensed under the [GPL v3 or later](https://www.gnu.org/licenses/gpl-3.0.html).
