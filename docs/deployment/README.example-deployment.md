# README for example-deployment.sh

This document provides an overview of the `example-deployment.sh` script, its purpose, and how it can be used as a template.

---

## Table of Contents

- [Script Overview](#script-overview)
- [Version Information](#version-information)
- [Requirements](#requirements)
- [Usage](#usage)
- [As a Template](#as-a-template)
- [Function Reference](#function-reference)
- [License](#license)

---

## Script Overview

The `example-deployment.sh` script serves as a basic template for creating deployment scripts for LightSpeed WP projects. It provides a standard structure, including argument parsing, environment validation, logging, and a placeholder for the core deployment logic.

It is not a functional deployment script out-of-the-box but is intended to be copied and customized to meet the specific needs of a project's deployment process.

## Version Information

- **Version:** v0.1.0
- **Date:** 2025-10-14
- **Author:** LightSpeedWP
- **Contributors:** @lightspeedwp / @ashleyshaw

## Requirements

- **Bash:** A standard Bash environment.

## Usage

The script is executed with the target environment and version as arguments.

```bash
./example-deployment.sh [environment] [version]
```

**Arguments:**

| Argument        | Description                                                                                       |
| --------------- | ------------------------------------------------------------------------------------------------- |
| `[environment]` | The target environment for the deployment (e.g., `staging`, `production`). Defaults to `staging`. |
| `[version]`     | The version of the application to deploy. Defaults to `latest`.                                   |

## As a Template

To use this script as a template:

1. **Copy the file:** Create a new script for your specific deployment needs (e.g., `deploy-my-plugin.sh`).
2. **Customize the `deploy` function:** Replace the placeholder comment in the `deploy` function with your actual deployment commands. This could involve:
    - Building assets (`npm run build`).
    - Copying files to a server (`scp`, `rsync`).
    - Running database migrations.
    - Clearing caches.
    - Interacting with a cloud provider's CLI.
3. **Extend Validation:** Add any additional checks needed for your environment in the `validate_environment` function or create new validation functions.
4. **Update Header:** Modify the script's header block with the correct name, description, and usage instructions.

## Function Reference

| Function                 | Description                                                                            |
| ------------------------ | -------------------------------------------------------------------------------------- |
| `main()`                 | The main entry point that orchestrates the validation and deployment process.          |
| `deploy()`               | The core function where the main deployment logic should be placed.                    |
| `validate_environment()` | Checks if the specified environment is a valid target (e.g., `staging`, `production`). |
| `log()`                  | A simple logging function that prints messages to the console and a log file.          |
| `error_exit()`           | A function to log an error message and exit the script with a non-zero status code.    |

## License

This script is licensed under the [GPL v3 or later](https://www.gnu.org/licenses/gpl-3.0.html).
