# GitHub Copilot Custom Instructions

This file serves as the main configuration for GitHub Copilot instructions across the LightSpeed WP scripts repository. It follows the LightSpeed role-based framework to provide context-aware assistance for contributors.

## Repository Overview

This is the central automation scripts repository for LightSpeed WP organization, containing shell scripts, GitHub workflows, and organizational governance files aligned with our development standards.

## Instruction Files Structure

### Core Instructions

The `.github/instructions/` directory contains specialized guidance files that provide context-aware assistance for different aspects of the LightSpeed WP automation workflow. Each file follows the standard format: "You are a [role]. Follow our [framework/patterns] to [type of task]. Avoid [practices or tools] unless specified."

#### Foundation Files

- **[contributor-types.md](./instructions/contributor-types.md)** - Defines role-specific guidance for different contributor types (developers, maintainers, reviewers, documentation writers). Provides context switching for Copilot based on contributor expertise level and responsibilities.

- **[coding-standards.md](./instructions/coding-standards.md)** - Establishes organization-wide coding standards that apply across all languages and frameworks. Covers general principles like naming conventions, error handling, security practices, and code review requirements.

- **[documentation-standards.md](./instructions/documentation-standards.md)** - Comprehensive documentation guidelines covering technical writing, API documentation, README structures, and accessibility requirements. Aligns with markdown standards but extends to broader documentation practices.

#### Language-Specific Instructions

- **[shell-script-copilot.md](./instructions/shell-script-copilot.md)** - Comprehensive shell scripting standards and patterns including Bash best practices, error handling with `set -euo pipefail`, script header requirements, and integration with LightSpeed automation workflows.

- **[js-copilot.md](./instructions/js-copilot.md)** - JavaScript and Node.js development standards covering ES6+ practices, npm workflow integration, testing with Jest, linting with ESLint, and GitHub Actions workflow automation.

- **[python-copilot.md](./instructions/python-copilot.md)** - Python scripting standards for automation tasks including type hints, pytest testing, virtual environments, dependency management, and integration with organizational workflows.

- **[markdown-copilot.md](./instructions/markdown-copilot.md)** - Markdown and documentation standards focusing on accessibility, consistent formatting, cross-referencing, and integration with automated documentation workflows.

- **[playwright-copilot.md](./instructions/playwright-copilot.md)** - Playwright-specific testing standards and MCP server automation guidance for browser testing, test organization, and CI/CD integration.

#### Testing & Quality Assurance

- **[bats-tests-and-runner-scripts.md](./instructions/bats-tests-and-runner-scripts.md)** - Comprehensive Bats testing framework guidance covering test structure, runner script patterns, coverage requirements, and CI/CD integration for shell script testing.

- **[shell-script-header-and-docs.md](./instructions/shell-script-header-and-docs.md)** - Detailed requirements for shell script documentation including mandatory header components, inline documentation patterns, function documentation, and usage examples.

### Chat Modes & Prompts

- **[chatmodes.md](./chatmodes/chatmodes.md)** - Scenario-based chat modes for different development contexts including shell script development, GitHub Actions workflows, documentation contribution, code review, and problem diagnosis.

- **[prompts.md](./prompts/prompts.md)** - Reusable prompt templates for Copilot Chat and CLI covering code generation, review, documentation, testing, automation, and learning scenarios.

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
└── LIGHTSPEED_AUTOMATION_HANDBOOK.md  # Organization-wide documentation
```



## Usage Guidelines

1. **For Contributors**: Reference the appropriate instruction file based on your role and task. Use chat modes from [chatmodes/chatmodes.md](../chatmodes/chatmodes.md) for context-specific guidance. Scripts must follow repo standards: kebab-case naming, header comments, error handling (`set -euo pipefail`), and Bats test coverage.
2. **For Reviewers**: Use prompt templates from [prompts/prompts.md](../prompts/prompts.md) and CodeRabbit review instructions (see .coderabbit.yml) for consistent, standards-based feedback. Reviewers should check for script header, error handling, test coverage, and documentation alignment.
3. **For Maintainers**: Leverage chatmodes and prompt patterns for automation, governance, and onboarding. Ensure all new scripts and workflows are documented and tested.

## Copilot & CodeRabbit Integration

This repository uses both GitHub Copilot and CodeRabbit for automation, review, and governance:

- **Copilot** provides context-aware code suggestions, automation, and documentation support, following the standards in this file and referenced instructions. Chat modes and prompt templates are used for manual and automated review.
- **CodeRabbit** enforces review standards, status checks, and auto-labeling as configured in [.coderabbit.yml](../../.coderabbit.yml). It uses path-based instructions to ensure scripts, workflows, and documentation meet repo requirements. All scripts, markdown, and workflows are checked for linting, test coverage, and governance alignment.
- **Interaction**: Copilot-generated code and documentation are automatically reviewed by CodeRabbit, which applies the relevant instructions and prompts. Chat modes and prompt templates are referenced for both manual and automated review. Release and changelog automation are also integrated and referenced in documentation.

## Future-Proof Prompt Examples

See [prompts/prompts.md](../prompts/prompts.md) for reusable prompt patterns. Example:

```text
Review this {script_or_workflow} for compliance with LightSpeed WP standards:
- Naming conventions
- Documentation completeness
- Test coverage
- Error handling
- Integration with workflow automation
- Accessibility guidelines
```

## Chat Modes Reference

Refer to [chatmodes/chatmodes.md](../chatmodes/chatmodes.md) for scenario-based chat modes. Example activations:

- "I'm working on shell script automation for LightSpeed WP"
- "I'm reviewing code for LightSpeed WP standards compliance"
- "I need help diagnosing issues with LightSpeed automation"
- "I'm managing releases and changelog automation"

## Integration with Development Workflow

These instructions integrate with:

- GitHub Actions CI/CD pipelines
- Branch protection rules and PR templates
- CodeRabbit review automation ([.coderabbit.yml](../../.coderabbit.yml))
- Release management and changelog automation

All instructions are aligned with our org-wide branching strategy, labeling conventions, and project management practices as documented in the LightSpeed Automation & Governance Handbook. Release and changelog workflows are referenced in documentation and instructions for full automation coverage.
