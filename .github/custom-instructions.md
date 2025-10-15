# GitHub Copilot Instructions for LightSpeed WP Scripts

This file provides workspace-specific instructions for GitHub Copilot and CodeRabbit automation in the LightSpeed WP scripts repository. It references all relevant instruction files, prompt templates, and chat modes, and documents how Copilot and CodeRabbit interact for automation, review, and governance.

## Instruction File Index

- [Custom Instructions](./custom-instructions.md): Main Copilot configuration and role-based guidance
- [Contributor Types](./instructions/contributor-types.md): Role-specific standards and prompts
- [Shell Script Standards](./instructions/shell-script-copilot.md): Bash automation best practices
- [Markdown Standards](./instructions/markdown-copilot.md): Technical writing and documentation
- [JS/Node Standards](./instructions/js-copilot.md): JavaScript/Node.js workflow guidance
- [Python Standards](./instructions/python-copilot.md): Python scripting standards
- [Prompts](./prompts/prompts.md): Template prompt patterns for Copilot Chat and CLI
- [Chat Modes](./chatmodes/chatmodes.md): Scenario-based development contexts

<!-- INSTRUCTIONS-TABLE-START -->
| File | Purpose |
|------|---------|
| [.github/copilot-instructions.md](.github/copilot-instructions.md) | Main Copilot & CodeRabbit integration, file index, and standards cross-reference |
| [.github/custom-instructions.md](.github/custom-instructions.md) | Copilot custom instructions, role-based configuration |
| [.github/prompts/prompts.md](.github/prompts/prompts.md) | Reusable prompt templates for Copilot Chat/CLI |
| [.github/chatmodes/chatmodes.md](.github/chatmodes/chatmodes.md) | Scenario-based chat modes for development contexts |
| [.github/instructions/contributor-types.md](.github/instructions/contributor-types.md) | Role-specific contributor standards and prompts |
| [.github/instructions/shell-script-copilot.md](.github/instructions/shell-script-copilot.md) | Shell script automation standards and patterns |
| [.github/instructions/markdown-copilot.md](.github/instructions/markdown-copilot.md) | Markdown/documentation standards and accessibility |
| [.github/instructions/js-copilot.md](.github/instructions/js-copilot.md) | JavaScript/Node.js workflow standards |
| [.github/instructions/python-copilot.md](.github/instructions/python-copilot.md) | Python scripting standards |
<!-- INSTRUCTIONS-TABLE-END -->


## Repository Overview

This is the central automation scripts repository for LightSpeed WP organization, containing shell scripts, GitHub workflows, and organizational governance files aligned with our development standards.

## Instruction Files Structure

### Core Instructions

- [/.github/instructions/contributor-types.md](./instructions/contributor-types.md) - Role-specific guidance for different contributor types
- [/.github/instructions/shell-script-copilot.md](./instructions/shell-script-copilot.md) - Shell scripting standards and patterns
- [/.github/instructions/markdown-copilot.md](./instructions/markdown-copilot.md) - Documentation and markdown standards

### Language-Specific Instructions



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
