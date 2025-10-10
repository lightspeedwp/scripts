# GitHub Configuration Directory [![Copilot](https://github.com/lightspeedwp/scripts/actions/workflows/copilot-swe-agent/copilot/badge.svg)](https://github.com/lightspeedwp/scripts/actions/workflows/copilot-swe-agent/copilot)

This directory contains GitHub-specific templates and configuration files for the LightSpeed WP organization.

## Contents

### Templates
- **Issue Templates**: Standardized issue templates for bug reports, feature requests, etc.
- **Pull Request Template**: Consistent PR template for code reviews
- **Discussion Templates**: Templates for GitHub Discussions

### Configuration Files
- **MCP Configuration**: Model Context Protocol configuration for VSCode
- **GitHub Actions**: Organization-level workflow configurations
- **Repository Settings**: Default settings and policies

## MCP Configuration for VSCode

The MCP (Model Context Protocol) configuration enables enhanced AI assistance in VSCode by providing context about our automation scripts and workflows.

### Setup
1. Install the MCP extension in VSCode
2. The configuration will be automatically detected from `.github/mcp-config.json`
3. Restart VSCode to apply the configuration

### Features
- Context-aware code completion for scripts
- Workflow template suggestions
- Automated test generation for Bats files
- Documentation assistance

## Usage Guidelines

### Issue Templates
Use appropriate issue templates when creating new issues:
- **Bug Report**: For reporting bugs in scripts or workflows
- **Feature Request**: For requesting new automation features
- **Documentation**: For documentation improvements

### Pull Request Template
Follow the PR template checklist to ensure quality contributions:
- Tests added/updated
- Documentation updated
- Scripts follow naming conventions
- Workflows are reusable and well-documented

## Customization

Templates can be customized for specific needs while maintaining consistency across the organization. Update templates in the `templates/` subdirectory.
