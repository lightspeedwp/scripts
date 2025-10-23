# README for utility-functions.sh

This document provides a detailed explanation of the `utility-functions.sh` script, its purpose, and how to use the functions it provides.

---

## Table of Contents

- [Script Overview](#script-overview)
- [Version Information](#version-information)
- [Requirements](#requirements)
- [Usage](#usage)
- [Function Reference](#function-reference)
- [License](#license)

---

## Script Overview

The `utility-functions.sh` script is a library of common, reusable shell functions intended to be sourced by other scripts in this repository. It provides a standardized toolkit for common operations, promoting code reuse and consistency across the entire automation suite.

The functions cover:

- **Logging:** A set of functions (`log_info`, `log_error`, etc.) for consistent, color-coded console output, controlled by a `LOG_LEVEL`.
- **Validation:** Helpers to check for command existence (`command_exists`), validate dependencies (`check_dependencies`), and verify URL formats (`validate_url`).
- **User Interaction:** A `confirm` function for interactive yes/no prompts.
- **File Operations:** A `backup_file` function to create timestamped backups.
- **Execution Control:** A `retry` function to re-execute a command with exponential backoff.

## Version Information

- **Version:** v0.1.0
- **Date:** 2025-10-14
- **Author:** LightSpeedWP
- **Contributors:** @lightspeedwp / @ashleyshaw

## Requirements

- **Bash:** Version 4.0 or later.

## Usage

This script is designed to be **sourced**, not executed directly. After sourcing it, all the utility functions become available in the calling script's environment.

```bash
# Source the utility functions at the beginning of your script
source /path/to/utility-functions.sh
```

You can control the verbosity of the logging functions by setting the `LOG_LEVEL` environment variable before sourcing the script.

**Log Levels:**

- `0`: ERROR
- `1`: WARN
- `2`: INFO (Default)
- `3`: DEBUG

```bash
# Enable debug logging
LOG_LEVEL=3 source ./utility-functions.sh

# Or use the --verbose flag
source ./utility-functions.sh --verbose
```

## Function Reference

| Function               | Description                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------------- |
| `log_error()`          | Logs a message at the ERROR level (red).                                                    |
| `log_warn()`           | Logs a message at the WARN level (yellow).                                                  |
| `log_info()`           | Logs a message at the INFO level (blue).                                                    |
| `log_success()`        | Logs a success message at the INFO level (green).                                           |
| `log_debug()`          | Logs a message at the DEBUG level (no color). Only prints if `LOG_LEVEL` is 3.              |
| `command_exists()`     | Checks if a given command is available in the system's `PATH`.                              |
| `check_dependencies()` | Takes a list of commands and checks if they all exist, logging an error if any are missing. |
| `confirm()`            | Prompts the user with a "yes/no" question and returns an appropriate exit code.             |
| `backup_file()`        | Creates a timestamped `.bak` file for a given file.                                         |
| `retry()`              | Attempts to run a command up to a specified number of times with exponential backoff.       |
| `get_script_dir()`     | Returns the absolute path to the directory of the script where it is called.                |
| `validate_url()`       | Checks if a string is a valid `http` or `https` URL.                                        |
| `is_root()`            | Checks if the script is being run by the root user.                                         |
| `timestamp()`          | Returns the current date and time in `YYYY-MM-DD HH:MM:SS` format.                          |

## License

This script is licensed under the [GPL v3 or later](https://www.gnu.org/licenses/gpl-3.0.html).
