
---
applyTo: '**'
description: 'Prompt for modular includes recommendations for shell script automation.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['includes', 'modular', 'shell', 'automation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Modular Includes Recommendations

## Role

You are a shell script developer and automation architect. Create modular, reusable shell script includes following LightSpeed WP standards.

## Purpose

Centralize common shell script functionality into testable, documented modules that eliminate code duplication and ensure consistency across all automation scripts.

## Checklist

- [ ] Create modular include files for shared functionality
- [ ] Add comprehensive headers and inline documentation
- [ ] Write corresponding Bats tests for each include
- [ ] Source includes properly in existing scripts
- [ ] Validate all functions are testable and documented
- [ ] Remove duplicated code from existing scripts

## Recommended Include Files

| Include File         | Purpose                                      | Key Functions/Variables                | Usage Example                      | Dependencies         | Testing Requirements |
|---------------------|----------------------------------------------|----------------------------------------|------------------------------------|----------------------|----------------------|
| logging.sh          | Centralize all logging functionality         | log_msg, log_info, log_success, log_warning, log_error, log_debug | source "$(dirname "$0")/../includes/logging.sh" | colors.sh            | Log file creation, color output |
| colors.sh           | Standardize color codes and formatting       | RED, GREEN, YELLOW, BLUE, NC, BOLD, DIM, UNDERLINE | source "$(dirname "$0")/../includes/colors.sh" | None                 | Color variable validation |
| validation.sh       | Input and system validation                  | command_exists, check_dependencies, validate_file_exists, validate_directory, validate_version_format, validate_email | source "$(dirname "$0")/../includes/validation.sh" | None                 | Function output, error handling |
| cli-utils.sh        | CLI argument parsing and help                | parse_common_args, show_standard_help, validate_required_args | source "$(dirname "$0")/../includes/cli-utils.sh" | None                 | Argument parsing, help output |
| file-utils.sh       | Safe file operations, backup, timestamp      | create_backup, safe_write_file, timestamp, cleanup_temp_files | source "$(dirname "$0")/../includes/file-utils.sh" | None                 | File creation, backup validation |
| env-utils.sh        | Environment variable management              | load_env_file, validate_required_env, export_env_vars, clear_env_vars | source "$(dirname "$0")/../includes/env-utils.sh" | None                 | Env loading, validation |
| github-auth.sh      | GitHub CLI authentication and API helpers    | gh_authenticate, validate_gh_token, check_gh_scopes, gh_api_call | source "$(dirname "$0")/../includes/github-auth.sh" | gh CLI               | Auth, token, API call validation |
| json-utils.sh       | JSON parsing and manipulation with jq        | parse_json, validate_json, extract_json_field, update_json_field | source "$(dirname "$0")/../includes/json-utils.sh" | jq                    | JSON parsing, field extraction |

## Sourcing and Usage Patterns

- Always source includes at the top of scripts using relative paths.
- Document usage examples in each include file header.
- Remove duplicated functions from scripts after migration.

## Migration and Refactoring Notes

- Refactor existing scripts to use new includes.
- Validate all functions with Bats tests.
- Update documentation and usage examples after migration.
