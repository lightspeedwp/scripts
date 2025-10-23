# Scripts Directory

[![License: GPL v3 or later](https://img.shields.io/badge/License-GPL%20v3%20or%20later-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

This directory contains all automation scripts for LightSpeed WP, organized by function for clarity and maintainability.

## Subfolder Organization

Scripts are grouped as follows:

| Subfolder      | Purpose                                       |
| -------------- | --------------------------------------------- |
| `deployment/`  | Deployment automation scripts.                |
| `project/`     | Project management and update scripts.        |
| `maintenance/` | Maintenance and label management scripts.     |
| `utility/`     | Utility functions and server startup scripts. |

Refer to each subfolder for specific scripts and usage instructions.

## Naming Convention

- Use kebab-case for all script files (e.g., `deploy-site.sh`).
- Include `.sh` extension for shell scripts.
- Use descriptive names that clearly indicate the script's purpose.

## Script Header

All scripts must start with a header comment block:

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: Brief description of what this script does.
# Usage: ./script-name.sh [options] [arguments]
# Author: Your Name
# Date: YYYY-MM-DD
#
```

## Contributing

Please see [CONTRIBUTING.md](../CONTRIBUTING.md) for details.
