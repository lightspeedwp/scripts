# lightspeedwp-automation

Centralized repository for LightSpeed WP organization automation scripts and CI/CD workflows.

## GitHub Copilot Integration

This repository includes comprehensive GitHub Copilot instructions to assist with automation development:

- **[Custom Instructions](/.github/custom-instructions.md)**: Main Copilot configuration with role-based guidance
- **[Contributor Guidelines](/.github/instructions/contributor-types.md)**: Role-specific development patterns
- **[Shell Script Standards](/.github/instructions/shell-script-copilot.md)**: Bash automation best practices
- **[Documentation Guidelines](/.github/instructions/markdown-copilot.md)**: Technical writing standards
- **[Reusable Prompts](/.github/prompts/prompts.md)**: Template prompts for Copilot Chat and CLI
- **[Chat Modes](/.github/chatmodes/chatmodes.md)**: Scenario-based development contexts

## Repository Structure

### 📁 `/scripts/`
Shell scripts for automation tasks across the organization. All scripts follow kebab-case naming conventions.

**Naming Convention**: Use kebab-case for all script files (e.g., `deploy-site.sh`, `backup-database.sh`)

**Usage**: 
- General automation scripts
- Deployment helpers
- Maintenance tasks
- Utility functions

### 📁 `/workflows/`
Reusable GitHub Actions workflows that can be shared across repositories in the organization.

**Usage**:
- CI/CD pipeline templates
- Deployment workflows
- Testing automation
- Release management

### 📁 `/tests/`
Test harnesses using Bats (Bash Automated Testing System) and dry-run scripts for validation.

**Usage**:
- Bats test files for shell scripts
- Dry-run validation scripts
- Integration tests
- Mock environments for testing

### 📁 `/.github/`
GitHub-specific templates, Copilot instructions, and configuration files.

**Contents**:
- **Copilot Instructions**: Role-based AI assistance configuration
- **Issue & PR Templates**: Standardized contribution templates
- **MCP Configuration**: Model Context Protocol for VSCode integration
- **Prompts & Chat Modes**: Reusable AI interaction patterns
- **GitHub Actions**: Organization-level workflow configurations

## Getting Started

### Prerequisites
- Bash 4.0+
- Bats (for running tests)
- GitHub CLI (optional, for workflow management)

### Installation
```bash
git clone https://github.com/lightspeedwp/lightspeedwp-automation.git
cd lightspeedwp-automation
```

### Running Tests
```bash
# Run all tests
bats tests/

# Run specific test file
bats tests/test-script-name.bats
```

## Contributing

1. Follow kebab-case naming conventions for all files
2. Add corresponding tests for any new scripts in `/tests/`
3. Document script usage in comments at the top of each file
4. Use meaningful commit messages
5. Update this README when adding new directories or changing structure

## Directory Usage Guidelines

- **Scripts**: Keep scripts focused and single-purpose
- **Workflows**: Make workflows reusable with proper input parameters
- **Tests**: Write comprehensive tests for all scripts
- **Templates**: Keep GitHub templates up-to-date with organization standards

## Development Workflow Integration

All automation follows LightSpeed WP organizational standards:

- **Branch Strategy**: GitHub Flow with feature branches and protected main
- **Testing Requirements**: Bats framework for shell scripts, comprehensive test coverage
- **Code Review**: Automated Copilot reviews + human validation
- **Release Management**: Automated changelog generation and versioning
- **Security**: Secrets scanning, dependency updates, and compliance checks

## Reference
This repository structure follows the specifications outlined in: https://github.com/copilot/spaces/lightspeedwp/48

For detailed governance and workflow documentation, see the `/github-workflow/` directory containing org-wide standards.
