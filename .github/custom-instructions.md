# GitHub Copilot Custom Instructions

This file serves as the main configuration for GitHub Copilot instructions across the LightSpeed WP scripts repository. It follows the LightSpeed role-based framework to provide context-aware assistance for contributors.

## Repository Overview

This is the central automation scripts repository for LightSpeed WP organization, containing shell scripts, GitHub workflows, and organizational governance files aligned with our development standards.

## Instruction Files Structure

### Core Instructions
- [/.github/instructions/contributor-types.md](./instructions/contributor-types.md) - Role-specific guidance for different contributor types
- [/.github/instructions/shell-script-copilot.md](./instructions/shell-script-copilot.md) - Shell scripting standards and patterns
- [/.github/instructions/markdown-copilot.md](./instructions/markdown-copilot.md) - Documentation and markdown standards

### Language-Specific Instructions
- [/.github/instructions/js-copilot.md](./instructions/js-copilot.md) - JavaScript/Node.js workflow guidance
- [/.github/instructions/python-copilot.md](./instructions/python-copilot.md) - Python scripting standards

### Reusable Prompts
- [/.github/prompts/prompts.md](./prompts/prompts.md) - Template prompts for Copilot Chat and CLI

### Chat Modes
- [/.github/chatmodes/chatmodes.md](./chatmodes/chatmodes.md) - Scenario-based chatmodes for different development contexts

## LightSpeed Framework Integration

All instructions follow the pattern: "You are a [role]. Follow our [framework/patterns] to [type of task]. Avoid [practices or tools] unless specified."

### Key Principles
1. **Kebab-case naming**: All scripts and files use kebab-case convention
2. **Test-driven development**: Every script requires corresponding Bats tests
3. **Reusable workflows**: GitHub Actions should use `workflow_call` trigger
4. **Documentation standards**: Comprehensive README files and inline comments
5. **Security first**: No secrets in code, proper error handling

### Repository Structure Compliance
```
├── scripts/           # Shell scripts (kebab-case naming)
├── workflows/         # GitHub Actions workflows  
├── tests/            # Bats tests and dry-run scripts
├── .github/          # GitHub templates, Copilot instructions, and configuration
└── github-workflow/  # Organization-wide documentation
```

## Usage Guidelines

1. **For Contributors**: Reference the appropriate instruction file based on your role and task
2. **For Reviewers**: Use prompts to generate consistent code review feedback
3. **For Maintainers**: Leverage chatmodes for different development scenarios

## Integration with Development Workflow

These instructions integrate with:
- GitHub Actions CI/CD pipelines
- Branch protection rules and PR templates
- Code review processes using CodeRabbit
- Release management and changelog automation

All instructions are aligned with our org-wide branching strategy, labeling conventions, and project management practices as documented in the `/github-workflow/` directory.