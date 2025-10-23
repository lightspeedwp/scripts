# Script Name: `prune-labels.sh`

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

This script provides a conservative, REST-only approach to synchronizing and pruning labels in GitHub repositories. It aligns repository labels with a canonical `labels.yml` file from a central `.github` repository, maps non-standard labels to their standard equivalents, and optionally removes any labels that do not conform to the organization's standards after migration.

## Requirements

- GitHub CLI (`gh`) installed and authenticated.
- A GitHub organization with a `.github` repository containing a `labels.yml` file.
- `yq` (YAML processor) installed.
- `jq` (JSON processor) installed.

## Usage

The script is executed with environment variables to control its behavior.

```bash
[Environment Variables] ./prune-labels.sh [options]
```

## Environment Variables

| Variable        | Description                                                                                           |
| :-------------- | :---------------------------------------------------------------------------------------------------- |
| `ORG`           | The GitHub organization. Default: `lightspeedwp`.                                                     |
| `DRY_RUN`       | If `true` (default), shows what would happen without making changes. Set to `false` to apply changes. |
| `STRICT_PRUNE`  | If `true`, deletes non-canonical labels. Default: `false`.                                            |
| `CANON_REPO`    | The repository containing the canonical `labels.yml` file. Default: `.github`.                        |
| `LABELS_PATH`   | The path to the `labels.yml` file in the canonical repository. Default: `.github/labels.yml`.         |
| `PROTECT_REGEX` | An optional regex to protect certain labels from being deleted (e.g., `"^lang: + ^area:"`).           |
| `ONLY`          | A space-separated list of repositories to process exclusively.                                        |

## Options

| Option   | Description            |
| :------- | :--------------------- |
| `--help` | Show this help message |

## Examples

This command shows which labels would be pruned without actually deleting them.

```bash
DRY_RUN=true ./prune-labels.sh
```

### Prune Labels with Protection

This command deletes non-canonical labels but protects any labels matching the specified regex.

```bash
DRY_RUN=false STRICT_PRUNE=true PROTECT_REGEX="^lang:|^area:" ./prune-labels.sh
```

### Process Specific Repositories

This command processes only the specified repositories (`repo1` and `repo2`).

```bash
ONLY="repo1 repo2" ./prune-labels.sh
```

## Notes

- This script is designed for safe and predictable label management across an entire GitHub organization.
- By default, it operates in a non-destructive `DRY_RUN` mode to prevent accidental data loss.
- The `STRICT_PRUNE` variable must be explicitly set to `true` to enable the deletion of labels.
