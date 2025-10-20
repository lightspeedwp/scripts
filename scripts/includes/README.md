# Scripts Includes

This directory contains reusable shell functions and utilities for LightSpeed WP automation scripts.

## Structure

```
scripts/includes/
├── README.md                 # This file
├── common-functions.sh       # Common utility functions
└── git-functions.sh         # Git-related operations
```

## Usage

Source the appropriate include files in your scripts:

```bash
#!/bin/bash
set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/includes/common-functions.sh"
source "${SCRIPT_DIR}/includes/git-functions.sh"

# Now use the functions
log_info "Starting script execution"
validate_required_tools "git" "curl"

if is_git_repo; then
    current_branch=$(get_current_branch)
    log_info "Working on branch: $current_branch"
fi
```

## Available Functions

### common-functions.sh

- **Logging Functions:**
  - `log_info()` - Log informational messages
  - `log_error()` - Log error messages to stderr
  - `log_warn()` - Log warning messages
  - `log_success()` - Log success messages
  - `setup_logging()` - Initialize logging with file

- **Validation Functions:**
  - `validate_required_tools()` - Check for required commands
  - `validate_file_exists()` - Check if file exists and is readable
  - `validate_directory_exists()` - Check if directory exists and is accessible

- **Utility Functions:**
  - `check_dry_run()` - Check if in dry-run mode
  - `execute_with_dry_run()` - Execute command respecting dry-run mode
  - `get_script_dir()` - Get directory containing current script
  - `confirm_action()` - Prompt user for confirmation
  - `cleanup_temp_files()` - Clean up temporary files
  - `create_backup()` - Create timestamped backup of file

### git-functions.sh

- **Repository Functions:**
  - `is_git_repo()` - Check if in git repository
  - `get_current_branch()` - Get current branch name
  - `get_repo_root()` - Get repository root directory
  - `get_commit_hash()` - Get current commit hash

- **Status Functions:**
  - `has_uncommitted_changes()` - Check for uncommitted changes
  - `validate_clean_working_tree()` - Ensure clean working tree

## Standards

All include files follow LightSpeed WP standards:

- Complete header documentation with all required fields
- Proper function documentation with description, arguments, output, and notes
- Error handling with `set -euo pipefail`
- Idempotent operations where applicable
- Consistent naming conventions

## Testing

Include files are tested through:

- Unit tests in corresponding test files
- Integration tests with actual scripts
- ShellCheck validation for syntax and best practices

See `tests/includes/` for test helpers and validation functions.

## Contributing

When adding new include files:

1. Follow the established naming convention (kebab-case)
2. Include complete header documentation
3. Document all functions with proper format
4. Add corresponding tests
5. Update this README with new functions
6. Ensure ShellCheck compliance

## Examples

### Simple Script Using Includes

```bash
#!/bin/bash
set -euo pipefail

# Source includes
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/includes/common-functions.sh"

# Setup logging
setup_logging "/tmp/my-script.log"

# Validate environment
validate_required_tools "git" "curl"

# Main logic
log_info "Starting main process"
if confirm_action "This will perform changes"; then
    execute_with_dry_run some_command --flag
    log_success "Process completed successfully"
else
    log_info "Process cancelled by user"
fi
```

### Git Operations Script

```bash
#!/bin/bash
set -euo pipefail

# Source includes
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/includes/common-functions.sh"
source "${SCRIPT_DIR}/includes/git-functions.sh"

# Validate git repository
if ! is_git_repo; then
    log_error "Not in a git repository"
    exit 1
fi

# Check for clean working tree
validate_clean_working_tree || exit 1

# Get current state
current_branch=$(get_current_branch)
commit_hash=$(get_commit_hash --short)

log_info "Current branch: $current_branch"
log_info "Current commit: $commit_hash"
```