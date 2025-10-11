# Documentation Standards Instruction

## README Requirements
- Every directory containing scripts, workflows, or tests must have a README.md.
- Each README must include:
  - Project or directory overview
  - Table of contents for long documents
  - Usage instructions for all scripts, workflows, or tests
  - Example commands and expected outputs
  - Description of automation features and integration points
  - Error handling and troubleshooting notes
  - Test coverage summary and status badge (if applicable)
  - Links to related documentation, governance, and instruction files
  - Changelog or release notes section (if relevant)
- All README files must pass markdownlint and be kept up to date with changes.

## In-line Documentation Requirements
- All scripts, workflows, and test files must include:
  - Header comments with name, description, usage, author, and date
  - Function/method comments describing purpose, parameters, and return values
  - Inline comments for complex logic, edge cases, and error handling
  - References to related documentation or instruction files where appropriate
- Use consistent comment style and formatting for each language (Bash, JS, Python, YAML)
- Update in-line documentation whenever code is changed or refactored

## Enforcement
- Documentation standards are enforced via CodeRabbit and markdownlint status checks
- PRs must update documentation and in-line comments for new features, changes, or fixes
- Reviewers should verify documentation compliance before approving changes

## Example README Section
```markdown
# Example Automation Script

## Overview
This script automates deployment for WordPress sites.

## Usage
```bash
./deploy-wordpress-site.sh --env staging
```

## Features
- Automated deployment
- Error handling and logging
- Integration with CI workflows

## Test Coverage
![Test Status](https://github.com/example/repo/actions/workflows/run-tests.yml/badge.svg)

## Changelog
- v1.0.0: Initial release
```

## Example In-line Documentation (Bash)
```bash
#!/bin/bash
# Script Name: deploy-wordpress-site.sh
# Description: Deploys WordPress site to specified environment
# Usage: ./deploy-wordpress-site.sh --env <environment>
# Author: LightSpeed WP Team
# Date: 2025-10-11

set -euo pipefail

# Deploy site to environment
function deploy_site() {
  # Validate environment argument
  # ...existing code...
}
```
