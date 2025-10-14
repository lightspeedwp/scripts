# Script Name: `sync-org-labels.sh`

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

This script synchronizes GitHub organization labels across all repositories to ensure they conform to a centralized standard. It is designed to maintain consistency and order in label management, which is crucial for effective project tracking and workflow automation.

## Requirements

- GitHub CLI (`gh`) installed and authenticated.
- A GitHub token with the necessary scopes (`repo`, `project`, `read:org`, `read:user`).
- `jq` for JSON processing.
- `yq` for YAML processing.
- `curl` for making API requests.
- `bats-core` for running tests.

## Usage

The script can be run with various environment variables to control its behavior.

```bash
./sync-org-labels.sh [options]
```

## Environment Variables

| Variable  | Description                                                                 |
| :-------- | :-------------------------------------------------------------------------- |
| `DRY_RUN` | Set to `true` to preview changes without applying them (default).           |
| `PRUNE`   | Set to `true` to delete non-canonical labels from repositories.             |
| `ONLY`    | A space-separated list of repository names to process exclusively.          |

## Options

| Option      | Description                         |
| :---------- | :---------------------------------- |
| `--dry-run` | Preview changes without applying them. |
| `--verbose` | Show detailed debug information.    |
| `--help`    | Show this help message.             |

## Examples

### Preview Label Synchronization
This command shows the changes that would be made without actually applying them.
```bash
DRY_RUN=true ./sync-org-labels.sh
```

### Synchronize and Prune Labels
This command applies the label synchronization and deletes any non-canonical labels.
```bash
PRUNE=true ./sync-org-labels.sh
```

### Synchronize Labels for Specific Repositories
This command synchronizes labels for `repo1` and `repo2` only.
```bash
ONLY="repo1 repo2" ./sync-org-labels.sh
```

### Combined Dry Run and Prune for Specific Repositories
This command previews the pruning of labels for `repo1` and `repo2`.
```bash
DRY_RUN=true PRUNE=true ONLY="repo1 repo2" ./sync-org-labels.sh
```

## Notes

- This script is intended to be executed directly from the command line.
- By default, it operates in a safe, non-destructive `DRY_RUN` mode.
- To apply changes, `DRY_RUN` must be unset or set to `false`, and `PRUNE` can be set to `true` to remove extra labels.
