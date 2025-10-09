# Scripts Directory

This directory contains shell scripts for automation tasks across the LightSpeed WP organization.

## Naming Convention
- Use kebab-case for all script files (e.g., `deploy-site.sh`, `backup-database.sh`)
- Include `.sh` extension for shell scripts
- Use descriptive names that clearly indicate the script's purpose

## Script Categories

### Deployment Scripts
Scripts for deploying applications and managing releases.

### Maintenance Scripts  
Scripts for routine maintenance tasks, backups, and cleanup operations.

### Utility Scripts
General-purpose helper scripts and common functions.

## Script Template
When creating new scripts, follow this template:

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: Brief description of what this script does
# Usage: ./script-name.sh [options] [arguments]
# Author: Your Name
# Date: YYYY-MM-DD
#

set -euo pipefail

# Script implementation here
```

## Testing
All scripts should have corresponding tests in the `/tests/` directory following the naming pattern `test-script-name.bats`.