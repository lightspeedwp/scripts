
---
applyTo: '**'
description: 'Prompt for example directory structure for modular shell script components.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['directory', 'structure', 'modular', 'shell']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Example Directory Structure for Modular Scripts

## Role

You are a filesystem architecture specialist. Follow our LightSpeed WP organizational standards to design optimal directory structures for modular shell script components and their supporting files.

## Purpose

Comprehensive directory structure organization ensures modular shell script components are organized systematically for optimal maintainability, scalability, and developer experience while supporting enterprise automation requirements.

## Checklist


## Current Repository State & Action Items

- Current folder structure uses `/scripts/project/` and `/tests/project-scripts/`. Planned renaming to `/scripts/projects/` and `/tests/projects/` for consistency and clarity.
- Modular includes are in `scripts/includes/` (currently `common-functions.sh`, `git-functions.sh`). Additional includes recommended.
- README files exist in some folders; expand to all major folders and subfolders.
- CI/CD workflows are in `.github/workflows/`.

**Action:** Rename folders for consistency, expand includes, add README files, and document directory structure in onboarding guides.

## Instructions

### Current State Analysis

#### Existing Directory Structure

```
/Users/ash/Studio/scripts/
├── AGENTS.md
├── CHANGELOG.md
├── README.md
├── VERSION
├── package.json
├── docs/
│   ├── script-functions-breakdown-spec.md
│   └── maintenance/
├── logs/
├── scripts/
│   ├── README.md
│   ├── deployment/
│   ├── includes/          # Currently empty - target for modular functions
│   ├── maintenance/
│   ├── project/
│   └── utility/
└── tests/
    ├── README.md
    ├── TEST_COVERAGE_SUMMARY.md
    ├── test-helper.bash
    ├── deployment/
    ├── maintenance/
    ├── project-scripts/
    ├── pytests/
    └── utility/
```

### Recommended Modular Structure

#### Complete Modular Architecture

```
scripts/                           # Root scripts directory
├── README.md                      # Scripts overview and usage guide
├── includes/                      # Shared function libraries
│   ├── README.md                  # Includes usage documentation
│   ├── core/                      # Essential system functions
│   │   ├── logging.sh             # Standardized logging functions
│   │   ├── validation.sh          # Input and system validation
│   │   ├── error-handling.sh      # Common error handling patterns
│   │   └── path-utils.sh          # Path resolution and validation
│   ├── cli/                       # Command-line interface utilities
│   │   ├── argument-parsing.sh    # Standardized CLI argument handling
│   │   ├── help-display.sh        # Consistent help message formatting
│   │   ├── interactive.sh         # User interaction and prompts
│   │   └── output-formatting.sh   # Consistent output formatting
│   ├── filesystem/                # File and directory operations
│   │   ├── file-operations.sh     # Safe file manipulation functions
│   │   ├── backup-management.sh   # Automated backup creation
│   │   ├── directory-utils.sh     # Directory management utilities
│   │   └── permissions.sh         # File permission management
│   ├── network/                   # Network and API utilities
│   │   ├── http-client.sh         # HTTP request handling
│   │   ├── github-api.sh          # GitHub API interaction functions
│   │   ├── download-utils.sh      # File download and verification
│   │   └── connectivity.sh        # Network connectivity checks
│   ├── security/                  # Security and authentication
│   │   ├── authentication.sh      # Authentication helper functions
│   │   ├── secrets-management.sh  # Secure handling of sensitive data
│   │   ├── input-sanitization.sh  # Input validation and sanitization
│   │   └── encryption.sh          # Encryption and hashing utilities
│   └── testing/                   # Testing support functions
│       ├── test-fixtures.sh       # Test data and fixture management
│       ├── mock-services.sh       # Mock external service calls
│       ├── assertions.sh          # Custom assertion functions
│       └── test-reporting.sh      # Test result formatting and reporting
│
├── deployment/                    # Deployment automation scripts
│   ├── README.md
│   ├── example-deployment.sh
│   ├── environments/              # Environment-specific configurations
│   │   ├── development.env
│   │   ├── staging.env
│   │   └── production.env
│   └── hooks/                     # Deployment lifecycle hooks
│       ├── pre-deploy.sh
│       ├── post-deploy.sh
│       └── rollback.sh
│
├── maintenance/                   # System maintenance scripts
│   ├── README.md
│   ├── cleanup/                   # Cleanup and optimization scripts
│   │   ├── log-rotation.sh
│   │   ├── cache-cleanup.sh
│   │   └── temp-file-cleanup.sh
│   ├── monitoring/                # System monitoring scripts
│   │   ├── health-check.sh
│   │   ├── performance-monitor.sh
│   │   └── resource-usage.sh
│   └── updates/                   # System update scripts
│       ├── dependency-updates.sh
│       ├── security-patches.sh
│       └── configuration-sync.sh
│
├── project/                       # Project-specific automation
│   ├── README.md
│   ├── setup/                     # Project initialization scripts
│   │   ├── environment-setup.sh
│   │   ├── dependency-install.sh
│   │   └── configuration-init.sh
│   ├── build/                     # Build automation scripts
│   │   ├── compile.sh
│   │   ├── package.sh
│   │   └── optimize.sh
│   └── release/                   # Release management scripts
│       ├── version-bump.sh
│       ├── changelog-generate.sh
│       └── release-publish.sh
│
└── utility/                       # General-purpose utility scripts
    ├── README.md
    ├── data-processing/           # Data manipulation utilities
    │   ├── csv-processor.sh
    │   ├── json-parser.sh
    │   └── text-formatter.sh
    ├── system-info/               # System information scripts
    │   ├── environment-info.sh
    │   ├── dependency-check.sh
    │   └── system-diagnostics.sh
    └── development/               # Development helper scripts
        ├── code-formatter.sh
        ├── lint-runner.sh
        └── test-runner.sh
```

#### Tests Directory Structure

```
tests/                             # Root tests directory
├── README.md                      # Testing overview and conventions
├── TEST_COVERAGE_SUMMARY.md       # Coverage tracking and requirements
├── includes/                      # Tests for shared includes
│   ├── README.md                  # Include testing documentation
│   ├── core/                      # Tests for core includes
│   │   ├── test-logging.bats      # Logging function tests
│   │   ├── test-validation.bats   # Validation function tests
│   │   ├── test-error-handling.bats
│   │   └── test-path-utils.bats
│   ├── cli/                       # CLI utility tests
│   │   ├── test-argument-parsing.bats
│   │   ├── test-help-display.bats
│   │   ├── test-interactive.bats
│   │   └── test-output-formatting.bats
│   ├── filesystem/                # Filesystem operation tests
│   │   ├── test-file-operations.bats
│   │   ├── test-backup-management.bats
│   │   ├── test-directory-utils.bats
│   │   └── test-permissions.bats
│   ├── network/                   # Network utility tests
│   │   ├── test-http-client.bats
│   │   ├── test-github-api.bats
│   │   ├── test-download-utils.bats
│   │   └── test-connectivity.bats
│   ├── security/                  # Security function tests
│   │   ├── test-authentication.bats
│   │   ├── test-secrets-management.bats
│   │   ├── test-input-sanitization.bats
│   │   └── test-encryption.bats
│   └── integration/               # Integration tests for includes
│       ├── test-include-interactions.bats
│       ├── test-dependency-resolution.bats
│       └── test-performance.bats
│
├── deployment/                    # Deployment script tests
│   ├── test-example-deployment.bats
│   ├── environments/              # Environment-specific tests
│   │   ├── test-development.bats
│   │   ├── test-staging.bats
│   │   └── test-production.bats
│   └── integration/               # End-to-end deployment tests
│       ├── test-deployment-workflow.bats
│       └── test-rollback-procedures.bats
│
├── maintenance/                   # Maintenance script tests
│   ├── cleanup/
│   │   ├── test-log-rotation.bats
│   │   ├── test-cache-cleanup.bats
│   │   └── test-temp-file-cleanup.bats
│   ├── monitoring/
│   │   ├── test-health-check.bats
│   │   ├── test-performance-monitor.bats
│   │   └── test-resource-usage.bats
│   └── updates/
│       ├── test-dependency-updates.bats
│       ├── test-security-patches.bats
│       └── test-configuration-sync.bats
│
├── project/                       # Project script tests
│   ├── setup/
│   │   ├── test-environment-setup.bats
│   │   ├── test-dependency-install.bats
│   │   └── test-configuration-init.bats
│   ├── build/
│   │   ├── test-compile.bats
│   │   ├── test-package.bats
│   │   └── test-optimize.bats
│   └── release/
│       ├── test-version-bump.bats
│       ├── test-changelog-generate.bats
│       └── test-release-publish.bats
│
├── utility/                       # Utility script tests
│   ├── data-processing/
│   │   ├── test-csv-processor.bats
│   │   ├── test-json-parser.bats
│   │   └── test-text-formatter.bats
│   ├── system-info/
│   │   ├── test-environment-info.bats
│   │   ├── test-dependency-check.bats
│   │   └── test-system-diagnostics.bats
│   └── development/
│       ├── test-code-formatter.bats
│       ├── test-lint-runner.bats
│       └── test-test-runner.bats
│
├── fixtures/                      # Test data and fixtures
│   ├── sample-configs/            # Sample configuration files
│   ├── test-data/                 # Test input data
│   ├── mock-responses/            # Mock API responses
│   └── expected-outputs/          # Expected test outputs
│
├── helpers/                       # Test helper functions and utilities
│   ├── test-helper.bash           # Main test helper functions
│   ├── assertion-helpers.bash     # Custom assertion functions
│   ├── mock-helpers.bash          # Mock service helpers
│   └── fixture-helpers.bash       # Test fixture management
│
└── reports/                       # Test reports and coverage data
    ├── coverage/                  # Coverage reports
    ├── performance/               # Performance test results
    └── integration/               # Integration test reports
```

#### Documentation Directory Structure

```
docs/                              # Project documentation
├── README.md                      # Documentation overview
├── api/                           # API documentation
│   ├── functions/                 # Function reference documentation
│   │   ├── logging-functions.md
│   │   ├── validation-functions.md
│   │   └── utility-functions.md
│   └── includes/                  # Include file documentation
│       ├── core-includes.md
│       ├── cli-includes.md
│       └── filesystem-includes.md
├── guides/                        # User and developer guides
│   ├── getting-started.md         # Quick start guide
│   ├── migration-guide.md         # Migration from legacy scripts
│   ├── best-practices.md          # Development best practices
│   └── troubleshooting.md         # Common issues and solutions
├── examples/                      # Usage examples and tutorials
│   ├── basic-scripts/             # Simple script examples
│   ├── advanced-patterns/         # Complex usage patterns
│   └── integration-examples/      # Integration with external tools
├── specifications/                # Technical specifications
│   ├── architecture-overview.md   # System architecture
│   ├── coding-standards.md        # Coding standards and conventions
│   ├── testing-requirements.md    # Testing standards and requirements
│   └── security-guidelines.md     # Security best practices
└── maintenance/                   # Maintenance and operational docs
    ├── deployment-procedures.md   # Deployment processes
    ├── monitoring-setup.md        # Monitoring and alerting setup
    └── backup-procedures.md       # Backup and recovery procedures
```

#### Configuration Directory Structure

```
config/                            # Configuration management
├── README.md                      # Configuration overview
├── environments/                  # Environment-specific configurations
│   ├── development/
│   │   ├── logging.conf
│   │   ├── database.conf
│   │   └── api-endpoints.conf
│   ├── staging/
│   │   ├── logging.conf
│   │   ├── database.conf
│   │   └── api-endpoints.conf
│   └── production/
│       ├── logging.conf
│       ├── database.conf
│       └── api-endpoints.conf
├── templates/                     # Configuration templates
│   ├── script-template.sh         # Template for new scripts
│   ├── test-template.bats         # Template for new tests
│   └── documentation-template.md  # Template for documentation
└── defaults/                      # Default configurations
    ├── global-defaults.conf       # System-wide defaults
    ├── script-defaults.conf       # Default script configurations
    └── test-defaults.conf          # Default test configurations
```

### Naming Conventions

#### File Naming Standards

**Shell Scripts**
- Format: `kebab-case.sh`
- Examples: `validate-release.sh`, `backup-database.sh`, `sync-repositories.sh`

**Include Files**
- Format: `kebab-case.sh` (same as scripts, but in includes/ directory)
- Examples: `logging.sh`, `file-operations.sh`, `github-api.sh`

**Test Files**
- Format: `test-[script-name].bats` or `test-[include-name].bats`
- Examples: `test-validate-release.bats`, `test-logging.bats`

**Documentation Files**
- Format: `kebab-case.md`
- Examples: `getting-started.md`, `api-reference.md`, `migration-guide.md`

**Configuration Files**
- Format: `kebab-case.conf` or `kebab-case.env`
- Examples: `database-config.conf`, `api-settings.env`

#### Directory Naming Standards

**Functional Grouping**
- Use descriptive, purpose-based names
- Examples: `deployment/`, `maintenance/`, `monitoring/`

**Technical Grouping**
- Group by technology or component type
- Examples: `includes/`, `tests/`, `docs/`

**Environment Grouping**
- Group by deployment environment
- Examples: `environments/development/`, `environments/production/`

### Implementation Guidelines

#### Step-by-Step Directory Creation

**Phase 1: Core Infrastructure**

```bash
# Create essential directories
mkdir -p scripts/includes/{core,cli,filesystem,network,security,testing}
mkdir -p tests/includes/{core,cli,filesystem,network,security,integration}
mkdir -p docs/{api,guides,examples,specifications,maintenance}
mkdir -p config/{environments/{development,staging,production},templates,defaults}

# Create placeholder README files
touch scripts/includes/README.md
touch tests/includes/README.md
touch docs/README.md
touch config/README.md
```

**Phase 2: Function Migration**

```bash
# Migrate logging functions
./scripts/utility/extract-functions.sh \
  --source-pattern "scripts/**/*.sh" \
  --function-pattern "log_*" \
  --output "scripts/includes/core/logging.sh"

# Create corresponding tests
./scripts/utility/generate-tests.sh \
  --include "scripts/includes/core/logging.sh" \
  --output "tests/includes/core/test-logging.bats"
```

**Phase 3: Script Updates**

```bash
# Update scripts to use includes
./scripts/maintenance/migrate-to-includes.sh \
  --scripts-dir "scripts/" \
  --includes-map "config/includes-mapping.json" \
  --backup-dir "backups/"
```

#### Maintenance Procedures

**Regular Cleanup**

```bash
# Remove empty directories
find scripts/ tests/ docs/ config/ -type d -empty -delete

# Validate directory structure
./scripts/utility/validate-structure.sh \
  --config "config/directory-structure.json" \
  --fix-permissions true
```

**Structure Validation**

```bash
# Ensure all required directories exist
required_dirs=(
  "scripts/includes/core"
  "tests/includes/core"
  "docs/api/functions"
  "config/environments/production"
)

for dir in "${required_dirs[@]}"; do
  [[ -d "$dir" ]] || mkdir -p "$dir"
done
```

## System Constraints

- Directory structure must be consistent across all environments
- Naming conventions must follow organizational standards
- File placement must enable easy discovery and navigation
- Structure must support automated tooling and CI/CD processes
- Organization must scale with project growth

## Example First Message to Copilot

```text
Implement the recommended modular directory structure for LightSpeed WP scripts. Create the directory hierarchy, establish naming conventions, and set up the infrastructure for includes, tests, documentation, and configuration management.
```

## Verification Steps

- [ ] All recommended directories are created
- [ ] Naming conventions are consistently applied
- [ ] File organization supports easy navigation
- [ ] Structure enables automated tooling integration
- [ ] Documentation clearly explains organization principles
- [ ] Maintenance procedures are documented and tested

## References

- [Shell Script Copilot Instructions](../.github/instructions/shell-script-copilot.instructions.md)
- [Documentation Standards](../.github/instructions/documentation-standards.instructions.md)
- [Bats Tests and Runner Scripts Instructions](../.github/instructions/bats-tests-and-runner-scripts.instructions.md)

## Closing Statement

A well-organized directory structure provides the foundation for maintainable, scalable automation while supporting developer productivity and enabling effective tooling integration throughout the development lifecycle.
