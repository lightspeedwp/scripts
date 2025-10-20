# Product Development Project Creator

## Overview

This script creates and configures GitHub Projects V2 for product development workflows according to LightSpeed WP standards. It sets up standardized fields with appropriate options, colors, and descriptions for managing product development work.

## Usage

```bash
./product-dev-project.sh <product-name> [project-number]
# or
./product-dev-project.sh <org> <product-name> [project-number]
```

### Options

- `--settings-file <csv>`: CSV file with project settings (see fixtures/)
- `--access-file <csv>`: CSV file with access management settings (see fixtures/)
- `--manage-access`: Enable access management (Base Role, Invite Collaborators)
- `--help`: Show help message

### Examples

```bash
# Create a new project with default settings
./product-dev-project.sh my-product

# Update an existing project with ID 42
./product-dev-project.sh myorg my-product 42

# Create a project with custom settings from CSV
./product-dev-project.sh my-product --settings-file fixtures/product-development-settings.csv

# Update project with access management
./product-dev-project.sh my-product 42 --access-file fixtures/product-development-manage-access.csv --manage-access
```

## Features

- Creates or updates GitHub Projects V2 for product development
- Sets up standard fields with options, colors, and descriptions
- Configures project access management with team/user roles
- Supports CSV-driven configuration
- Includes dry-run mode for testing (when `DRY_RUN=true` and `GH_CLI_MOCK=1`)
- Handles authentication via GitHub CLI or GitHub App

## CSV Configuration

### Settings CSV Format

Firstline is header, subsequent lines are values:

```csv
Project Name,Short Description,README,Visibility
Product Development,Plan and ship versioned releases with a lean Scrumban flow,<markdown content>,Organization
```

### Access CSV Format

First line is header, empty team with role defines base role:

```csv
Team/User,Role
,Admin
developers-team,Write
product-team,Write
user1,Admin
```

## Testing

Tests for this script are located in `tests/project-scripts/`:

```bash
# Run all project script tests
./scripts/project/run-tests.sh

# Run specific test
bats tests/project-scripts/test-product-dev-project-csv.bats
bats tests/project-scripts/test-product-dev-project-auth.bats
bats tests/project-scripts/test-product_dev_project.bats
```

## Related Files

- `scripts/project/fixtures/product-development-settings.csv`: Example settings
- `scripts/project/fixtures/product-development-manage-access.csv`: Example access configuration
- `docs/update-projects/product-development-field-specs-v1-1.md`: Field specifications
