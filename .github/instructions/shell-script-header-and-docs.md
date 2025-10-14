# Shell Script Header & Documentation Standards - LightSpeed WP

You are a documentation specialist. Follow our LightSpeed WP script documentation patterns to ensure comprehensive and maintainable shell script documentation. Avoid abbreviated documentation unless specified for internal utility functions.

## Overview

This guide establishes mandatory standards for shell script headers, inline documentation, and code comments within the LightSpeed WP automation ecosystem. Consistent documentation ensures maintainability, onboarding efficiency, and operational reliability.

## Mandatory Script Header Format

### Complete Header Template

Every shell script must begin with this exact header structure:

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: [2-3 sentence description of script purpose and main functionality]
# Usage: ./script-name.sh [options] [arguments]
# Author: [Your Name or Team Name]
# Date: YYYY-MM-DD
# Version: [Semantic version if applicable]
# Dependencies: [Required tools, scripts, or environment variables]
# Exit Codes: [Document non-zero exit codes and their meanings]
#
# Examples:
#   ./script-name.sh --dry-run --config=prod.conf
#   ./script-name.sh --help
#   ./script-name.sh --environment=staging --verbose
#
# Notes:
#   - [Important operational notes]
#   - [Security considerations]
#   - [Performance implications]
#

set -euo pipefail  # Required error handling
```

### Header Component Requirements

#### 1. Shebang Line
```bash
#!/bin/bash
```
- **Required**: Must be the first line
- **Standard**: Use `/bin/bash` for LightSpeed scripts
- **Rationale**: Ensures consistent shell behavior across environments

#### 2. Script Identification
```bash
# Script Name: deploy-wordpress-site.sh
# Description: Automates WordPress site deployment with database migration, 
#              file synchronization, and configuration management. Supports 
#              both staging and production environments with rollback capability.
```
- **Script Name**: Exact filename including extension
- **Description**: 2-3 sentences covering main purpose, key features, and scope
- **Avoid**: Generic descriptions like "This script does deployment"

#### 3. Usage Documentation
```bash
# Usage: ./deploy-wordpress-site.sh [OPTIONS] ENVIRONMENT
#
# Arguments:
#   ENVIRONMENT    Target environment (staging|production|development)
#
# Options:
#   -c, --config FILE      Configuration file path (required)
#   -b, --backup           Create backup before deployment
#   -r, --rollback         Rollback to previous deployment
#   -d, --dry-run          Preview changes without executing
#   -v, --verbose          Enable detailed output
#   -h, --help             Display this help message
#
# Environment Variables:
#   DEPLOY_KEY            SSH key for remote access (required)
#   BACKUP_RETENTION      Days to keep backups (default: 30)
#   DEBUG                 Enable debug mode (default: false)
```

#### 4. Metadata and Dependencies
```bash
# Author: DevOps Team <devops@lightspeedwp.com>
# Date: 2024-01-15
# Version: 2.1.0
# Dependencies: rsync, mysql, wp-cli, aws-cli
# Requires: Ubuntu 20.04+, Bash 4.4+
```

#### 5. Exit Codes Documentation
```bash
# Exit Codes:
#   0    Success - deployment completed without errors
#   1    General error - check logs for details
#   2    Configuration error - invalid or missing config file
#   3    Network error - unable to connect to remote server
#   4    Backup failed - deployment aborted for safety
#   5    Rollback required - deployment failed, manual intervention needed
```

#### 6. Usage Examples
```bash
# Examples:
#   # Deploy to staging with backup
#   ./deploy-wordpress-site.sh --config=staging.conf --backup staging
#
#   # Production deployment with verbose output
#   ./deploy-wordpress-site.sh --config=prod.conf --verbose production
#
#   # Dry-run to preview production changes
#   ./deploy-wordpress-site.sh --config=prod.conf --dry-run production
#
#   # Rollback production deployment
#   ./deploy-wordpress-site.sh --config=prod.conf --rollback production
```

#### 7. Important Notes and Warnings
```bash
# Notes:
#   - Always test deployments in staging environment first
#   - Ensure database backup completion before production deployment
#   - Monitor application logs for 10 minutes after deployment
#   - Contact on-call engineer for production deployment issues
#
# Security:
#   - Script handles sensitive data - ensure secure file permissions (600)
#   - Never commit configuration files containing credentials
#   - Rotate deployment keys monthly
```

## Required Error Handling

### Mandatory Safety Configuration

```bash
set -euo pipefail
```

This must appear immediately after the header comments and provides:
- `set -e`: Exit on any command failure
- `set -u`: Exit on undefined variable usage  
- `set -o pipefail`: Exit on pipe command failures

### Error Handling Documentation

```bash
# Error handling strategy
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly LOG_FILE="/var/log/lightspeed/${SCRIPT_NAME%.sh}.log"

# Trap function for cleanup on exit
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo "ERROR: Script failed with exit code $exit_code" >&2
        echo "Check log file: $LOG_FILE" >&2
    fi
    
    # Cleanup temporary files
    rm -f "${TEMP_FILES[@]:-}" 2>/dev/null || true
}
trap cleanup EXIT
```

## Function Documentation Standards

### Function Header Template

```bash
#######################################
# Brief description of function purpose and behavior
#
# Detailed description covering:
# - What the function does
# - When it should be used  
# - Any side effects or state changes
#
# Arguments:
#   $1 - Description of first parameter with type and constraints
#   $2 - Description of second parameter (optional, default: value)
#   ... - Additional parameters as needed
#
# Globals:
#   VARIABLE_NAME - Description of global variables read or modified
#   
# Returns:
#   0 if success, non-zero on error
#   
# Outputs:
#   Writes description of stdout/stderr content to stdout/stderr
#   
# Examples:
#   function_name "arg1" "arg2"
#   function_name --option "value"
#######################################
function_name() {
    local param1="$1"
    local param2="${2:-default_value}"
    
    # Function implementation...
}
```

### Complete Function Example

```bash
#######################################
# Creates a timestamped backup of a file or directory
#
# This function creates a compressed backup with timestamp suffix,
# maintaining original permissions and ownership. Supports both
# files and directories with automatic compression format selection.
#
# Arguments:
#   $1 - Source path to backup (file or directory)
#   $2 - Backup directory (optional, default: ./backups)
#   $3 - Compression type (optional: gzip|bzip2|xz, default: gzip)
#
# Globals:
#   BACKUP_RETENTION_DAYS - Used to clean old backups if set
#   BACKUP_PREFIX - Prepended to backup filename if set
#   
# Returns:
#   0 if backup created successfully
#   1 if source path does not exist
#   2 if backup directory cannot be created
#   3 if compression fails
#   
# Outputs:
#   Backup file path to stdout on success
#   Error messages to stderr on failure
#   
# Examples:
#   backup_file "/etc/nginx/nginx.conf"
#   backup_file "/var/www/html" "/backups/web" "bzip2"
#   BACKUP_PREFIX="pre-deploy-" backup_file "./config"
#######################################
backup_file() {
    local source_path="$1"
    local backup_dir="${2:-./backups}"
    local compression="${3:-gzip}"
    
    # Validation
    if [[ ! -e "$source_path" ]]; then
        echo "Error: Source path does not exist: $source_path" >&2
        return 1
    fi
    
    # Create backup directory if needed
    if ! mkdir -p "$backup_dir"; then
        echo "Error: Cannot create backup directory: $backup_dir" >&2
        return 2
    fi
    
    # Generate timestamped backup name
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local basename="$(basename "$source_path")"
    local backup_name="${BACKUP_PREFIX:-}${basename}_${timestamp}"
    
    # Determine compression extension and command
    local extension
    local compress_cmd
    case "$compression" in
        gzip)   extension=".tar.gz"; compress_cmd="tar -czf" ;;
        bzip2)  extension=".tar.bz2"; compress_cmd="tar -cjf" ;;
        xz)     extension=".tar.xz"; compress_cmd="tar -cJf" ;;
        *)      
            echo "Error: Unsupported compression type: $compression" >&2
            return 3
            ;;
    esac
    
    local backup_path="${backup_dir}/${backup_name}${extension}"
    
    # Create compressed backup
    if $compress_cmd "$backup_path" -C "$(dirname "$source_path")" "$(basename "$source_path")"; then
        echo "$backup_path"
        
        # Clean old backups if retention is set
        if [[ -n "${BACKUP_RETENTION_DAYS:-}" ]]; then
            find "$backup_dir" -name "${BACKUP_PREFIX:-}${basename}_*" \
                -mtime "+${BACKUP_RETENTION_DAYS}" -delete 2>/dev/null || true
        fi
        
        return 0
    else
        echo "Error: Failed to create backup: $backup_path" >&2
        rm -f "$backup_path" 2>/dev/null || true
        return 3
    fi
}
```

## Variable Documentation Standards

### Global Variables

```bash
#######################################
# Global Configuration Variables
#######################################

# Script configuration
readonly SCRIPT_VERSION="2.1.0"              # Script version for compatibility checks
readonly SCRIPT_CONFIG_DIR="/etc/lightspeed" # Default configuration directory
readonly SCRIPT_LOCK_FILE="/var/lock/$(basename "$0").lock" # Prevent concurrent execution

# Environment settings
readonly ENV="${ENVIRONMENT:-development}"    # Runtime environment (development|staging|production)
readonly DEBUG="${DEBUG:-false}"              # Enable debug output (true|false)
readonly DRY_RUN="${DRY_RUN:-false}"         # Preview mode without changes (true|false)

# External dependencies
readonly REQUIRED_COMMANDS=(               # Commands that must be available
    "git" 
    "curl" 
    "jq"
    "mysql"
)

# Timeout and retry settings
readonly NETWORK_TIMEOUT=30                 # Network operation timeout in seconds
readonly MAX_RETRIES=3                      # Maximum retry attempts for failed operations
readonly RETRY_DELAY=5                      # Delay between retry attempts in seconds

# File and directory paths
readonly LOG_DIR="/var/log/lightspeed"      # Log file directory
readonly TEMP_DIR="${TMPDIR:-/tmp}"         # Temporary file directory
readonly BACKUP_DIR="${BACKUP_DIR:-./backups}" # Backup storage directory
```

### Local Variables

```bash
# Function-level variable documentation
process_deployment() {
    local deployment_config="$1"           # Path to deployment configuration file
    local target_environment="$2"          # Target environment name
    local force_deploy="${3:-false}"       # Force deployment flag (default: false)
    
    local deployment_id                    # Unique identifier for this deployment
    local backup_path                      # Path to pre-deployment backup
    local rollback_available=false         # Whether rollback is possible
    
    # Process implementation...
}
```

## Inline Documentation Standards

### Code Block Documentation

```bash
# ============================================================================
# Configuration Loading and Validation
# ============================================================================

# Load configuration file with validation
if [[ -f "$CONFIG_FILE" ]]; then
    # Source configuration with error handling
    if ! source "$CONFIG_FILE"; then
        echo "Error: Failed to load configuration: $CONFIG_FILE" >&2
        exit 2
    fi
else
    echo "Error: Configuration file not found: $CONFIG_FILE" >&2
    echo "Use --help for usage information" >&2
    exit 2
fi

# Validate required configuration variables
readonly REQUIRED_CONFIG=(
    "DATABASE_HOST"
    "DATABASE_NAME" 
    "DEPLOY_TARGET"
    "SSH_KEY_PATH"
)

for var in "${REQUIRED_CONFIG[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        echo "Error: Required configuration variable not set: $var" >&2
        exit 2
    fi
done

# ============================================================================
# Pre-deployment Safety Checks  
# ============================================================================

# Verify target environment accessibility
echo "Verifying connection to $DEPLOY_TARGET..."
if ! ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 "$DEPLOY_TARGET" 'echo "Connection successful"'; then
    echo "Error: Cannot connect to deployment target: $DEPLOY_TARGET" >&2
    exit 3
fi

# Check available disk space (require at least 1GB free)
available_space=$(ssh -i "$SSH_KEY_PATH" "$DEPLOY_TARGET" 'df / | awk "NR==2 {print \$4}"')
if [[ $available_space -lt 1048576 ]]; then  # 1GB in KB
    echo "Error: Insufficient disk space on target (available: ${available_space}KB)" >&2
    exit 4
fi
```

### Complex Logic Documentation

```bash
# ============================================================================
# Deployment Execution with Rollback Capability
# ============================================================================

deploy_application() {
    local deployment_strategy="$1"
    
    # Create deployment checkpoint for rollback
    local checkpoint_id=$(date '+%Y%m%d_%H%M%S')
    local checkpoint_file="/tmp/deployment_checkpoint_${checkpoint_id}"
    
    # Document current state before changes
    cat > "$checkpoint_file" << EOF
# Deployment Checkpoint: $checkpoint_id
# Created: $(date)
# Strategy: $deployment_strategy
PREVIOUS_VERSION=$(get_current_version)
PREVIOUS_COMMIT=$(git rev-parse HEAD)
PREVIOUS_CONFIG_HASH=$(md5sum "$CONFIG_FILE")
DATABASE_BACKUP_PATH=$backup_path
EOF

    # Multi-phase deployment with validation at each step
    local phases=(
        "backup_database:critical"      # Create database backup (critical - abort on failure)
        "backup_files:critical"         # Create file system backup (critical)
        "stop_services:normal"          # Stop application services (recoverable)
        "deploy_code:critical"          # Deploy new code (critical)  
        "migrate_database:critical"     # Run database migrations (critical)
        "update_config:normal"          # Update configuration files (recoverable)
        "start_services:critical"       # Start services (critical)
        "health_check:critical"         # Verify deployment health (critical)
    )
    
    # Execute deployment phases with error recovery
    for phase_spec in "${phases[@]}"; do
        local phase_name="${phase_spec%:*}"
        local phase_criticality="${phase_spec#*:}"
        
        echo "Executing deployment phase: $phase_name"
        
        if ! execute_deployment_phase "$phase_name"; then
            echo "Error: Deployment phase failed: $phase_name" >&2
            
            # Determine recovery strategy based on criticality
            if [[ "$phase_criticality" == "critical" ]]; then
                echo "Critical phase failed - initiating automatic rollback" >&2
                if restore_from_checkpoint "$checkpoint_file"; then
                    echo "Rollback completed successfully" >&2
                    exit 5
                else
                    echo "CRITICAL: Rollback failed - manual intervention required" >&2
                    exit 6
                fi
            else
                echo "Non-critical phase failed - continuing deployment with warning" >&2
            fi
        fi
    done
    
    # Cleanup checkpoint after successful deployment
    rm -f "$checkpoint_file"
    echo "Deployment completed successfully (ID: $checkpoint_id)"
}
```

## Documentation Quality Standards

### Clarity and Completeness

- **Purpose**: Every script, function, and complex section must have clear purpose documentation
- **Context**: Explain why something is done, not just what is done
- **Assumptions**: Document any assumptions about environment, data, or usage
- **Side Effects**: Document any state changes, file modifications, or external impacts

### Maintenance Information

```bash
# ============================================================================
# Maintenance Notes
# ============================================================================
#
# Last Updated: 2024-01-15 by DevOps Team
# Next Review: 2024-04-15 (quarterly review cycle)
#
# Known Issues:
#   - MySQL timeout handling needs improvement for large databases
#   - SSH connection pool exhaustion under high load
#   - Backup cleanup may fail with insufficient permissions
#
# Planned Improvements:
#   - Add support for blue-green deployments (Q2 2024)
#   - Implement deployment metrics collection (Q1 2024)  
#   - Add automated rollback testing (Q1 2024)
#
# Dependencies to Monitor:
#   - MySQL client version compatibility
#   - SSH key rotation schedule
#   - Disk space monitoring alerts
# ============================================================================
```

### Security Documentation

```bash
# ============================================================================
# Security Considerations
# ============================================================================
#
# Sensitive Data Handling:
#   - Database passwords are never logged or displayed
#   - SSH keys are loaded from secure locations with proper permissions
#   - Temporary files containing credentials are securely deleted
#   - All network communications use encrypted protocols
#
# Access Controls:
#   - Script requires deployment group membership
#   - Configuration files must have 600 permissions
#   - Log files are restricted to deployment user access
#
# Audit Trail:
#   - All deployment actions are logged with timestamps
#   - User identification is captured in deployment logs
#   - Database changes are tracked in migration logs
#   - File modifications are recorded with checksums
# ============================================================================
```

## Documentation Validation

### Automated Checks

The documentation quality is validated through:

1. **Header Completeness**: All required header components present
2. **Function Documentation**: Public functions have complete documentation blocks
3. **Error Handling**: All exit codes are documented
4. **Examples Validity**: Usage examples are syntactically correct
5. **Link Validation**: All referenced files and URLs are accessible

### Review Checklist

- [ ] Script header contains all mandatory components
- [ ] Usage examples are complete and accurate
- [ ] All exit codes are documented with meanings
- [ ] Functions have appropriate documentation blocks
- [ ] Complex logic sections have explanatory comments
- [ ] Security considerations are documented
- [ ] Maintenance information is current
- [ ] Dependencies are clearly identified
- [ ] Global variables are documented with purpose and type

## Integration with Development Workflow

### Pre-commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit - Documentation validation

# Check shell scripts for required documentation
for script in $(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$'); do
    if ! validate_script_documentation "$script"; then
        echo "Error: $script lacks required documentation" >&2
        exit 1
    fi
done
```

### CI/CD Integration

Documentation standards are enforced through:
- Automated header validation in pull requests
- Function documentation coverage reports
- Link validation in documentation updates
- Example script execution testing

This comprehensive documentation approach ensures that LightSpeed WP shell scripts remain maintainable, secure, and operationally reliable throughout their lifecycle.