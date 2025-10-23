---
applyTo: '**'
description: 'Prompt for recommended script files for modular includes in shell script automation.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['includes', 'modular', 'shell', 'recommendation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Recommended Script Files for `/scripts/includes/` Folder

## Role

You are a shell script modularization specialist. Follow our LightSpeed WP standards to create reusable shell script modules for shared functionality.

## Purpose

Centralize common shell script functions (logging, parsing, validation, authentication) into modular includes for reuse across all scripts in the repository.

## Checklist

- [ ] Create modular files for each functional area
- [ ] Add comprehensive headers and inline documentation to each include
- [ ] Write corresponding Bats tests for each include file
- [ ] Source includes consistently across all scripts
- [ ] Validate no function duplication exists after refactoring
- [ ] Update existing scripts to use new includes
- [ ] Document include usage patterns and examples

## Instructions

### Core Include Files to Create

#### 1. `logging.sh` - Centralized Logging System

**Purpose**: Standardized logging functions with file output and colored terminal display
**Functions**: `log_info()`, `log_success()`, `log_warning()`, `log_error()`, `log_debug()`
**Dependencies**: Colors from `colors.sh`
**Usage**: `source "$(dirname "$0")/../includes/logging.sh"`

#### 2. `colors.sh` - Terminal Color Definitions

**Purpose**: Consistent color variable definitions for all scripts
**Variables**: `RED`, `GREEN`, `YELLOW`, `BLUE`, `NC` (No Color)
**Usage**: Sourced by `logging.sh` and other scripts needing colored output

#### 3. `validation.sh` - Input and Dependency Validation

**Purpose**: Common validation functions for arguments, files, and system requirements
**Functions**: `validate_file()`, `validate_directory()`, `command_exists()`, `check_dependencies()`
**Usage**: Source for any script requiring input validation

#### 4. `cli-utils.sh` - Command Line Interface Utilities

**Purpose**: Standardized argument parsing and help message generation
**Functions**: `parse_arguments()`, `show_help()`, `show_usage()`, `show_version()`
**Usage**: Common CLI patterns and option handling

#### 5. `file-utils.sh` - File Operation Utilities

**Purpose**: Safe file operations, backup creation, and timestamp handling
**Functions**: `create_backup()`, `safe_write()`, `generate_timestamp()`, `cleanup_temp_files()`
**Usage**: Any script manipulating files

#### 6. `env-utils.sh` - Environment Variable Management

**Purpose**: Environment variable loading, validation, and management
**Functions**: `load_env_file()`, `validate_required_env()`, `export_env_vars()`, `clear_env_vars()`
**Usage**: Scripts requiring environment configuration

#### 7. `github-auth.sh` - GitHub Authentication and API

**Purpose**: GitHub CLI authentication, token validation, and API helpers
**Functions**: `gh_authenticate()`, `validate_gh_token()`, `check_gh_scopes()`, `gh_api_call()`
**Dependencies**: GitHub CLI (`gh`)
**Usage**: Scripts interacting with GitHub API

#### 8. `json-utils.sh` - JSON Processing with jq

**Purpose**: JSON parsing, validation, and manipulation using jq
**Functions**: `parse_json()`, `validate_json()`, `extract_json_field()`, `update_json_field()`
**Dependencies**: `jq`
**Usage**: Scripts processing JSON data

#### 9. `yaml-utils.sh` - YAML Processing with yq

**Purpose**: YAML parsing, validation, and manipulation using yq
**Functions**: `parse_yaml()`, `validate_yaml()`, `extract_yaml_field()`, `update_yaml_field()`
**Dependencies**: `yq`
**Usage**: Scripts processing YAML files (workflows, configs)

#### 10. `path-utils.sh` - Path Resolution and Navigation

**Purpose**: Consistent path resolution relative to scripts and repository root
**Functions**: `resolve_script_dir()`, `resolve_repo_root()`, `resolve_relative_path()`
**Usage**: All scripts requiring path resolution

#### 11. `test-utils.sh` - Testing and Dry-Run Utilities

**Purpose**: Common testing patterns, dry-run functionality, and test helpers
**Functions**: `is_dry_run()`, `dry_run_execute()`, `setup_test_env()`, `cleanup_test_env()`
**Usage**: Scripts supporting dry-run and testing modes

#### 12. `markdown-utils.sh` - Markdown Processing

**Purpose**: Markdown parsing, TOC generation, and content manipulation
**Functions**: `generate_toc()`, `validate_markdown()`, `extract_headings()`, `update_readme_section()`
**Dependencies**: `markdownlint`
**Usage**: Scripts generating or updating markdown documentation

## System Constraints

- All includes must be POSIX-compliant and testable
- Each include must have comprehensive Bats test coverage
- Functions must not conflict with existing script logic
- No destructive changes without explicit dry-run confirmation
- All includes must follow LightSpeed WP header and documentation standards

## Example First Message to Copilot

```
Create modular shell script includes for /scripts/includes/ covering logging, validation, CLI utilities, file operations, GitHub auth, JSON/YAML processing, and path resolution. Each include needs comprehensive headers, inline documentation, and corresponding Bats tests. Update existing scripts to source these includes and eliminate code duplication.
```

## Verification Steps

- [ ] All includes are created with proper headers and documentation
- [ ] Bats tests exist for every include with >80% coverage
- [ ] No function duplication exists across the codebase
- [ ] All existing scripts successfully source and use includes
- [ ] Include dependencies are clearly documented and validated
- [ ] Path resolution works correctly from any script location

## References

- [Shell Script Copilot Instructions](../.github/instructions/shell-script-copilot.instructions.md)
- [Bats Tests and Runner Scripts Instructions](../.github/instructions/bats-tests-and-runner-scripts.instructions.md)
- [Coding Standards Instructions](../.github/instructions/coding-standards.instructions.md)

## Closing Statement

Modularizing shared shell script logic into `/scripts/includes/` eliminates code duplication, improves maintainability, centralizes testing, and ensures consistent behavior across all automation scripts.
