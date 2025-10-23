# Standardize Logging Script

This utility script adds standardized logging to bash scripts in the repository, ensuring consistency across all automation scripts.

## Overview

The `standardize-logging.sh` script scans shell scripts in the repository and adds or updates them with standardized logging functions that write to both console (with colors) and log files. This ensures consistent error handling and logging patterns across all scripts.

## Features

- Automatically adds standardized logging to shell scripts
- Creates backup files before modifying scripts
- Supports dry-run mode to preview changes
- Verbose mode for detailed debug information
- Skip scripts that already have logging setup
- Colorized console output and timestamped log files

## Usage

```bash
./standardize-logging.sh [OPTIONS] [SCRIPT_FILE]
```

### Options

- `--dry-run` - Preview changes without applying them
- `--verbose` - Show detailed debug information
- `--help` - Show help message

### Examples

Process a specific script:

```bash
./standardize-logging.sh ../project/update-projects.sh
```

Preview changes without applying them:

```bash
./standardize-logging.sh --dry-run ../project/update-projects.sh
```

Process all scripts in the repository:

```bash
./standardize-logging.sh
```

## Logging Implementation

The script adds the following logging functions to each script:

- `log_info()` - Standard information messages (green in console)
- `log_warn()` - Warning messages (yellow in console)
- `log_error()` - Error messages (red in console)
- `log_debug()` - Debug messages, only shown when VERBOSE=true (blue in console)

All log messages are written to both:

1. Console (with color formatting)
2. A log file in the `logs` directory, with timestamps

## File Structure

```text
logs/                      # Log files directory
  standardize-logging.log  # Log file for this script
  script-name.log          # Log file for each processed script
scripts/
  utility/
    standardize-logging.sh # This script
```

## Testing

The script is tested using Bats:

```bash
bats tests/test-standardize-logging.bats
```

See [test-standardize-logging.bats](/tests/test-standardize-logging.bats) for test cases.

## Troubleshooting

- If the script fails, check the log file at `logs/standardize-logging.log`
- Backup files are created before modifications with `.bak` extension
- Use `--verbose` for detailed debugging information
- For non-standard script structures, you may need to manually add logging

## Related Scripts

- [update-projects.sh](/scripts/project/update-projects.sh) - Uses standardized logging
- [client-delivery-project.sh](/scripts/project/client-delivery-project.sh) - Uses standardized logging
- [product-dev-project.sh](/scripts/project/product-dev-project.sh) - Uses standardized logging
