# lightspeedwp-automation

Centralized repository for LightSpeed WP organization automation scripts and CI/CD workflows.

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
GitHub-specific templates and configuration files.

**Contents**:
- Issue templates
- Pull request templates  
- MCP (Model Context Protocol) configuration for VSCode
- GitHub Actions configuration
- Organization-level GitHub settings

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

## LightSpeed Automation & Governance

For comprehensive documentation on org-wide automation, workflows, branching strategy, label governance, and project templates, see:

📖 **[LightSpeed Automation & Governance Handbook](LIGHTSPEED_AUTOMATION_HANDBOOK.md)**

This handbook consolidates all automation documentation and serves as the central reference for:
- Branching strategies for client & product development
- Changelog & release automation workflows  
- Label automation and issue type standards
- Project templates and GitHub Actions governance
- Implementation rollout plans and quality gates

## Reference
This repository structure follows the specifications outlined in: https://github.com/copilot/spaces/lightspeedwp/48
