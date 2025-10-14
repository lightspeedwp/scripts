# Script Name: `find-readmes.sh`

## Table of Contents

- [Description](#description)
- [Requirements](#requirements)
- [Usage](#usage)
- [Options](#options)
- [Examples](#examples)
- [Notes](#notes)

---

## Description

This script finds all README files within the repository. It performs a case-insensitive search to locate files with names such as `README.md`, `readme.md`, and other variations.

## Requirements

- `bash`

## Usage

```bash
./find-readmes.sh [options]
```

## Options

| Option   | Description            |
| :------- | :--------------------- |
| `--help` | Show this help message |

## Examples

### Find all README files
This command will list all README files in the current directory and its subdirectories.
```bash
./find-readmes.sh
```

### Show Help
Displays the help message, providing information on usage and available options.
```bash
./find-readmes.sh --help
```

## Notes

- This script is designed to be executed from the root of the repository.
- It recursively searches through all subdirectories to find matching README files.
