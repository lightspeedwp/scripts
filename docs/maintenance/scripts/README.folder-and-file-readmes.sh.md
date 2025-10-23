# Script Name: `folder-and-file-readmes.sh`

## Table of Contents

- [Description](#description)
- [Requirements](#requirements)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [Options](#options)
- [Examples](#examples)
- [Notes](#notes)

---

## Description

This script generates comprehensive documentation for a repository by creating `README.md` files for folders and `README.<filename>.md` files for individual scripts. It extracts metadata from script headers to produce rich, structured documentation. The script supports various modes, including backup, merge, overwrite, linting, table of contents generation, and profile-style READMEs, making it a versatile tool for maintaining compliance and automating documentation workflows.

## Requirements

- `bash`
- `file`
- `grep`
- `sed`
- `xargs`

## Usage

To generate READMEs for a target folder:

```bash
./folder-and-file-readmes.sh [options] <target-folder>
```

To generate a README for a specific file with merge or overwrite options:

```bash
./folder-and-file-readmes.sh --file <file> [--merge|--overwrite]
```

To preview changes without writing files:

```bash
DRY_RUN=true ./folder-and-file-readmes.sh <target-folder>
```

## Environment Variables

| Variable         | Description                                        |
| :--------------- | :------------------------------------------------- |
| `DRY_RUN`        | If `true`, previews changes without writing files. |
| `MERGE_MODE`     | If `true`, merges new content with existing files. |
| `OVERWRITE_MODE` | If `true`, overwrites existing files.              |
| `LOG_FILE`       | Path to an optional log file.                      |

## Options

| Option          | Description                                  |
| :-------------- | :------------------------------------------- |
| `--help`        | Show the help message.                       |
| `--lint`        | Lint the generated markdown files.           |
| `--toc`         | Add a table of contents to `README.md`.      |
| `--dry-run`     | Preview changes without writing files.       |
| `--profile`     | Generate a GitHub profile-style `README.md`. |
| `--file <file>` | Generate a README for a specific file.       |
| `--merge`       | Merge new content with an existing README.   |
| `--overwrite`   | Overwrite an existing README.                |

## Examples

### Generate READMEs for a Folder

This command generates documentation for all files in the `scripts/maintenance` directory.

```bash
./folder-and-file-readmes.sh scripts/maintenance
```

### Generate and Merge a README for a Single File

This command generates a README for `update-projects.sh` and merges it with any existing documentation.

```bash
./folder-and-file-readmes.sh --file scripts/project/update-projects.sh --merge
```

### Preview README Generation with Dry Run

This command shows a preview of the documentation that would be generated for the `scripts/utility` folder without actually creating or modifying any files.

```bash
DRY_RUN=true ./folder-and-file-readmes.sh scripts/utility
```

## Notes

- Before overwriting any files, the script automatically creates a backup to prevent data loss.
- This script is a key part of the repository's documentation automation and compliance strategy.
