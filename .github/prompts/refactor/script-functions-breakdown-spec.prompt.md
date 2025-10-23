---
applyTo: '**'
description: 'Prompt for detailed specifications for breaking out reusable shell script functions.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['functions', 'specification', 'modular', 'shell']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Script Functions to Break Out - Detailed Specifications

## Role

You are a shell script refactoring specialist. Analyze existing scripts to identify and extract reusable functions following LightSpeed WP modular architecture standards.

## Purpose

Document all shell script functions that should be extracted into includes with detailed specifications for inputs, outputs, behavior, and testing requirements.

## Checklist

- [ ] Analyze all existing shell scripts for common patterns
- [ ] Document function specifications with inputs/outputs
- [ ] Create extraction plan with dependencies
- [ ] Write Bats test specifications for each function
- [ ] Plan migration strategy from existing scripts

## Instructions

### Function Categories and Specifications

#### 1. Logging Functions

##### `log_msg(level, message)`

**Source Files**: Found in multiple scripts (validate-release.sh, standardize-logging.sh)
**Purpose**: Core logging function that writes to both stderr and log file

**Arguments**:

- `level`: Log level (INFO, SUCCESS, WARNING, ERROR, DEBUG)
- `message`: Message to log (string, supports multiple arguments)

**Output**:

- Stderr: Colored message with timestamp
- File: Timestamped message in `${LOG_FILE}`
  **Behavior**:
- Creates log directory if it doesn't exist
- Formats message with timestamp and level
- Uses colors based on log level
- Appends to log file atomically
  **Dependencies**: `colors.sh` for color variables
  **Test Requirements**:
- Verify log file creation
- Validate message format in file
- Check color output on stderr
- Test with multiple message arguments

##### `log_info(message)`

**Extracted From**: validate-release.sh, standardize-logging.sh, utility-functions.sh
**Purpose**: Log informational messages
**Arguments**: `message` - Information to log
**Output**: Green colored output to stderr, timestamped entry to log file
**Implementation**: Calls `log_msg "INFO" "$@"`

##### `log_success(message)`

**Extracted From**: validate-release.sh, utility-functions.sh
**Purpose**: Log success messages
**Arguments**: `message` - Success message to log
**Output**: Bright green colored output with checkmark, timestamped entry to log file
**Implementation**: Calls `log_msg "SUCCESS" "$@"`

##### `log_warning(message)` / `log_warn(message)`

**Extracted From**: Multiple scripts with inconsistent naming
**Purpose**: Log warning messages
**Arguments**: `message` - Warning to log
**Output**: Yellow colored output with warning icon, timestamped entry to log file
**Implementation**: Calls `log_msg "WARNING" "$@"`
**Note**: Standardize on `log_warning` name

##### `log_error(message)`

**Extracted From**: All scripts with error handling
**Purpose**: Log error messages
**Arguments**: `message` - Error to log
**Output**: Red colored output with error icon, timestamped entry to log file
**Implementation**: Calls `log_msg "ERROR" "$@"`

##### `log_debug(message)`

**Extracted From**: Scripts with verbose mode
**Purpose**: Log debug messages when verbose mode enabled
**Arguments**: `message` - Debug information to log
**Output**: Blue colored output (if VERBOSE=true), timestamped entry to log file
**Behavior**: Only outputs if `VERBOSE` environment variable is true
**Implementation**:

```bash
log_debug() {
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        log_msg "DEBUG" "$@"
    fi
}
```

#### 2. Validation Functions

##### `command_exists(command)`

**Extracted From**: utility-functions.sh
**Purpose**: Check if a command is available in PATH
**Arguments**: `command` - Command name to check
**Returns**: 0 if exists, 1 if not found
**Implementation**: Uses `command -v "$1" >/dev/null 2>&1`
**Test Requirements**:

- Test with existing commands (bash, ls)
- Test with non-existent commands
- Verify return codes

##### `check_dependencies(commands_array)`

**Extracted From**: Multiple scripts with dependency validation
**Purpose**: Validate that all required commands are available
**Arguments**: Array of command names
**Returns**: 0 if all found, 1 if any missing
**Output**: Error messages for missing commands
**Implementation**:

```bash
check_dependencies() {
    local missing_commands=()
    for cmd in "$@"; do
        if ! command_exists "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_error "Missing required commands: ${missing_commands[*]}"
        return 1
    fi
    return 0
}
```

##### `validate_file_exists(filepath, description)`

**Extracted From**: Scripts with file validation
**Purpose**: Validate file exists with descriptive error
**Arguments**:

- `filepath` - Path to file to check
- `description` - Human-readable description for errors
  **Returns**: 0 if exists, 1 if not found
  **Output**: Error message if file not found

##### `validate_version_format(version)`

**Extracted From**: validate-release.sh
**Purpose**: Validate semantic version format
**Arguments**: `version` - Version string to validate
**Returns**: 0 if valid semver, 1 if invalid
**Test Requirements**:

- Valid versions: v1.0.0, 1.2.3, 1.0.0-alpha.1
- Invalid versions: 1, v1, 1.2, invalid

#### 3. File Operation Functions

##### `create_backup(filepath)`

**Extracted From**: folder-and-file-readmes.sh, update scripts
**Purpose**: Create timestamped backup of file before modification
**Arguments**: `filepath` - Path to file to backup
**Returns**: 0 on success, 1 on failure
**Output**: Backup file path on stdout, log messages
**Behavior**: Creates `${filepath}.backup.$(timestamp)`
**Implementation**:

```bash
create_backup() {
    local file="$1"
    local backup="${file}.backup.$(timestamp)"
    if cp "$file" "$backup"; then
        log_info "Backup created: $backup"
        echo "$backup"
        return 0
    else
        log_error "Failed to create backup of $file"
        return 1
    fi
}
```

##### `timestamp()`

**Extracted From**: utility-functions.sh
**Purpose**: Generate consistent timestamp for filenames
**Arguments**: None
**Returns**: Always 0
**Output**: Timestamp string in format YYYY-MM-DD-HHMMSS
**Implementation**: `date +"%Y-%m-%d-%H%M%S"`

##### `safe_write_file(filepath, content)`

**Purpose**: Write file with automatic backup
**Arguments**:

- `filepath` - Target file path
- `content` - Content to write (from stdin if not provided)
  **Returns**: 0 on success, 1 on failure
  **Behavior**: Creates backup if file exists, then writes new content

#### 4. CLI Utility Functions

##### `show_help(script_name, description, usage, options_array)`

**Extracted From**: All scripts with --help functionality
**Purpose**: Generate consistent help output
**Arguments**:

- `script_name` - Name of the script
- `description` - Brief description
- `usage` - Usage pattern
- `options_array` - Array of option descriptions
  **Output**: Formatted help message to stdout

##### `parse_common_args(args_array)`

**Extracted From**: Multiple scripts with similar argument patterns
**Purpose**: Parse standard arguments (--help, --verbose, --dry-run)
**Arguments**: Array of command line arguments
**Behavior**: Sets global variables (VERBOSE, DRY_RUN, HELP_REQUESTED)
**Returns**: 0 if parsing successful, 1 if unknown option

#### 5. Path Resolution Functions

##### `get_script_dir()`

**Extracted From**: All scripts with path resolution
**Purpose**: Get directory containing the current script
**Arguments**: None
**Returns**: Always 0
**Output**: Absolute path to script directory
**Implementation**: `cd "$(dirname "${BASH_SOURCE[1]}")" && pwd`

##### `get_repo_root()`

**Extracted From**: Scripts needing repository root
**Purpose**: Get repository root directory
**Arguments**: None
**Returns**: 0 if found, 1 if not in git repo
**Output**: Absolute path to repository root
**Implementation**: Uses git rev-parse or relative path calculation

##### `resolve_logs_dir()`

**Extracted From**: All scripts with logging
**Purpose**: Get standardized logs directory path
**Arguments**: None
**Returns**: Always 0
**Output**: Absolute path to logs directory
**Behavior**: Creates directory if it doesn't exist

#### 6. GitHub Utility Functions

##### `gh_authenticate()`

**Extracted From**: Scripts using GitHub CLI
**Purpose**: Ensure GitHub CLI is authenticated
**Arguments**: None
**Returns**: 0 if authenticated, 1 if not
**Output**: Error messages if authentication fails

##### `gh_check_scopes(required_scopes_array)`

**Purpose**: Validate GitHub token has required scopes
**Arguments**: Array of required scope names
**Returns**: 0 if all scopes present, 1 if missing scopes
**Output**: Error messages for missing scopes

## System Constraints

- All extracted functions must be backward compatible
- Original script behavior must be preserved
- Functions must handle all error cases gracefully
- All functions require comprehensive Bats tests
- Migration must be performed incrementally

## Example First Message to Copilot

> "Extract and modularize shell script functions into includes following the detailed specifications. Start with logging functions, then validation, file operations, CLI utilities, path resolution, and GitHub utilities. Create comprehensive Bats tests for each function and update existing scripts to use the includes."

## Verification Steps

- [ ] All specified functions extracted to appropriate include files
- [ ] Original script functionality preserved
- [ ] Comprehensive test coverage for each function
- [ ] No code duplication between scripts
- [ ] All include files properly documented
- [ ] Migration completed without breaking changes

## References

- Shell Script Copilot Instructions
- Self-Explanatory Code Commenting Instructions
- Bats Tests and Runner Scripts Instructions

## Closing Statement

Function extraction should be performed systematically with thorough testing at each stage to ensure no functionality is lost during the modularization process.
