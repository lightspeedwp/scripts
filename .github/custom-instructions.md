# GitHub Copilot Instructions for LightSpeed WP Scripts

This file provides workspace-specific instructions for GitHub Copilot and CodeRabbit automation in the LightSpeed WP scripts repository. It references all relevant instruction files, prompt templates, and chat modes, and documents how Copilot and CodeRabbit interact for automation, review, and governance.

## Instruction File Index

### Core Instructions

- [Custom Instructions](./custom-instructions.md): Main Copilot configuration and role-based guidance
- [Contributor Types](./instructions/contributor-types.instructions.md): Role-specific standards and prompts
- [Shell Script Standards](./instructions/shell-script-copilot.instructions.md): Bash automation best practices
- [Markdown Standards](./instructions/markdown-copilot.instructions.md): Technical writing and documentation
- [JS/Node Standards](./instructions/js-copilot.instructions.md): JavaScript/Node.js workflow guidance
- [Python Standards](./instructions/python-copilot.instructions.md): Python scripting standards

### All Instruction Files (.github/instructions/)

- [AI Prompt Engineering Safety](./instructions/ai-prompt-engineering-safety-best-practices.instructions.md): AI prompt engineering and safety best practices
- [Bats Tests and Runner Scripts](./instructions/bats-tests-and-runner-scripts.instructions.md): Shell script and Bats test standards
- [Coding Standards](./instructions/coding-standards.instructions.md): Universal coding standards for all languages
- [Contributor Types](./instructions/contributor-types.instructions.md): Role-specific contributor standards and prompts
- [Copilot Thought Logging](./instructions/copilot-thought-logging.instructions.md): Copilot thought logging and debugging
- [Create or Update Copilot Instructions](./instructions/create-or-update-copilot.instructions.md): Standards for instruction authoring
- [Documentation Standards](./instructions/documentation-standards.instructions.md): Documentation and README requirements
- [GitHub Actions CI/CD Best Practices](./instructions/github-actions-ci-cd-best-practices.instructions.md): Comprehensive CI/CD guidance
- [JavaScript/Node.js Standards](./instructions/js-copilot.instructions.md): JavaScript and Node.js workflow standards
- [Localization](./instructions/localization.instructions.md): Guidance for document localization
- [Markdown Content](./instructions/markdown.instructions.md): Markdown content rules and validation
- [Markdown Copilot](./instructions/markdown-copilot.instructions.md): Markdown standards for Copilot
- [Memory Bank](./instructions/memory-bank.instructions.md): Memory bank for session persistence
- [Performance Optimization](./instructions/performance-optimization.instructions.md): Universal performance optimization practices
- [Playwright Copilot](./instructions/playwright-copilot.instructions.md): Playwright automation and MCP server standards
- [Playwright TypeScript](./instructions/playwright-typescript.instructions.md): Playwright test generation instructions
- [Python Copilot](./instructions/python-copilot.instructions.md): Python scripting and automation standards
- [Self-Explanatory Code Commenting](./instructions/self-explanatory-code-commenting.instructions.md): Code commenting guidelines
- [Shell Script Copilot](./instructions/shell-script-copilot.instructions.md): Shell script development standards
- [Shell Script Header and Docs](./instructions/shell-script-header-and-docs.instructions.md): Script header and documentation standards
- [Spec-Driven Workflow v1](./instructions/spec-driven-workflow-v1.instructions.md): Specification-driven development workflow
- [Taming Copilot](./instructions/taming-copilot.instructions.md): Copilot control and guidance instructions
- [Task Implementation](./instructions/task-implementation.instructions.md): Task plan implementation instructions
- [TaskSync](./instructions/tasksync.instructions.md): TaskSync V4 protocol for continuous task management
- [WordPress Development](./instructions/wordpress.instructions.md): WordPress coding standards and security patterns

### Chat Modes (.github/chatmodes/)

- [Chat Modes Overview](./chatmodes/chatmodes.md): Scenario-based development contexts
- [4.1-Beast Mode](./chatmodes/4.1-Beast.chatmode.md): Advanced beast mode for complex tasks
- [Critical Thinking](./chatmodes/critical-thinking.chatmode.md): Critical thinking and analysis mode
- [Debug Mode](./chatmodes/debug.chatmode.md): Debugging and troubleshooting mode
- [Implementation Plan](./chatmodes/implementation-plan.chatmode.md): Implementation planning mode
- [Plan Mode](./chatmodes/plan.chatmode.md): General planning mode
- [Planner Mode](./chatmodes/planner.chatmode.md): Strategic planning mode
- [Prompt Builder](./chatmodes/prompt-builder.chatmode.md): Prompt building and engineering mode
- [Prompt Engineer](./chatmodes/prompt-engineer.chatmode.md): Advanced prompt engineering mode
- [Task Planner](./chatmodes/task-planner.chatmode.md): Task planning and management mode

### Prompts (.github/prompts/)

- [Prompts Overview](./prompts/prompts.md): Template prompt patterns for Copilot Chat and CLI
- [AI Prompt Engineering Safety Review](./prompts/ai-prompt-engineering-safety-review.prompt.md): AI prompt safety review patterns
- [Conventional Commit](./prompts/conventional-commit.prompt.md): Conventional commit message patterns
- [Copilot Instructions Blueprint Generator](./prompts/copilot-instructions-blueprint-generator.prompt.md): Instructions blueprint generation
- [Create AGENTS.md](./prompts/create-agentsmd.prompt.md): AGENTS.md file creation prompt
- [Generate Custom Instructions from Codebase](./prompts/generate-custom-instructions-from-codebase.prompt.md): Codebase analysis for instructions
- [GitHub Copilot Starter](./prompts/github-copilot-starter.prompt.md): Copilot initialization prompts
- [Prompt Builder](./prompts/prompt-builder.prompt.md): Meta-prompt for building prompts

### Agents (.github/agents/)

- [Agents Overview](./agents/agent.md): Agent registry and management
- [Agent Template](./agents/agent-template.md): Template for creating new agents
- [Bats Tests Runner Agent](./agents/bats-tests-runner.agent.js): Automated test execution and validation
- [Issue Type Agent](./agents/issue-type.agent.js): Automatic issue type classification
- [Label Standardization Agent](./agents/label-standardization.agent.js): Label standardization and cleanup
- [Labeling Agent](./agents/labeling.agent.js): Automated labeling for issues and PRs
- [Linting Workflow Agent](./agents/linting-workflow.agent.js): Code quality and linting enforcement
- [Release Agent](./agents/release.agent.js): Release management and automation
- [Script Header Docs Agent](./agents/script-header-docs.agent.js): Script documentation validation

<!-- INSTRUCTIONS-TABLE-START -->
| File | Purpose |
|------|---------|
| [.github/custom-instructions.md](.github/custom-instructions.md) | Main Copilot & CodeRabbit integration, file index, and standards cross-reference |
| [.github/prompts/prompts.md](.github/prompts/prompts.md) | Reusable prompt templates for Copilot Chat/CLI |
| [.github/chatmodes/chatmodes.md](.github/chatmodes/chatmodes.md) | Scenario-based chat modes for development contexts |
| [.github/agents/agent.md](.github/agents/agent.md) | Agent registry and automation tools |
| [.github/instructions/ai-prompt-engineering-safety-best-practices.instructions.md](.github/instructions/ai-prompt-engineering-safety-best-practices.instructions.md) | AI prompt engineering and safety best practices |
| [.github/instructions/bats-tests-and-runner-scripts.instructions.md](.github/instructions/bats-tests-and-runner-scripts.instructions.md) | Shell script and Bats test standards |
| [.github/instructions/coding-standards.instructions.md](.github/instructions/coding-standards.instructions.md) | Universal coding standards for all languages |
| [.github/instructions/contributor-types.instructions.md](.github/instructions/contributor-types.instructions.md) | Role-specific contributor standards and prompts |
| [.github/instructions/copilot-thought-logging.instructions.md](.github/instructions/copilot-thought-logging.instructions.md) | Copilot thought logging and debugging |
| [.github/instructions/create-or-update-copilot.instructions.md](.github/instructions/create-or-update-copilot.instructions.md) | Standards for instruction authoring |
| [.github/instructions/documentation-standards.instructions.md](.github/instructions/documentation-standards.instructions.md) | Documentation and README requirements |
| [.github/instructions/github-actions-ci-cd-best-practices.instructions.md](.github/instructions/github-actions-ci-cd-best-practices.instructions.md) | Comprehensive CI/CD guidance |
| [.github/instructions/js-copilot.instructions.md](.github/instructions/js-copilot.instructions.md) | JavaScript/Node.js workflow standards |
| [.github/instructions/localization.instructions.md](.github/instructions/localization.instructions.md) | Guidance for document localization |
| [.github/instructions/markdown.instructions.md](.github/instructions/markdown.instructions.md) | Markdown content rules and validation |
| [.github/instructions/markdown-copilot.instructions.md](.github/instructions/markdown-copilot.instructions.md) | Markdown standards for Copilot |
| [.github/instructions/memory-bank.instructions.md](.github/instructions/memory-bank.instructions.md) | Memory bank for session persistence |
| [.github/instructions/performance-optimization.instructions.md](.github/instructions/performance-optimization.instructions.md) | Universal performance optimization practices |
| [.github/instructions/playwright-copilot.instructions.md](.github/instructions/playwright-copilot.instructions.md) | Playwright automation and MCP server standards |
| [.github/instructions/playwright-typescript.instructions.md](.github/instructions/playwright-typescript.instructions.md) | Playwright test generation instructions |
| [.github/instructions/python-copilot.instructions.md](.github/instructions/python-copilot.instructions.md) | Python scripting and automation standards |
| [.github/instructions/self-explanatory-code-commenting.instructions.md](.github/instructions/self-explanatory-code-commenting.instructions.md) | Code commenting guidelines |
| [.github/instructions/shell-script-copilot.instructions.md](.github/instructions/shell-script-copilot.instructions.md) | Shell script development standards |
| [.github/instructions/shell-script-header-and-docs.instructions.md](.github/instructions/shell-script-header-and-docs.instructions.md) | Script header and documentation standards |
| [.github/instructions/spec-driven-workflow-v1.instructions.md](.github/instructions/spec-driven-workflow-v1.instructions.md) | Specification-driven development workflow |
| [.github/instructions/taming-copilot.instructions.md](.github/instructions/taming-copilot.instructions.md) | Copilot control and guidance instructions |
| [.github/instructions/task-implementation.instructions.md](.github/instructions/task-implementation.instructions.md) | Task plan implementation instructions |
| [.github/instructions/tasksync.instructions.md](.github/instructions/tasksync.instructions.md) | TaskSync V4 protocol for continuous task management |
| [.github/instructions/wordpress.instructions.md](.github/instructions/wordpress.instructions.md) | WordPress coding standards and security patterns |
<!-- INSTRUCTIONS-TABLE-END -->

## Repository Overview

This is the central automation scripts repository for LightSpeed WP organization, containing shell scripts, GitHub workflows, and organizational governance files aligned with our development standards.

## Instruction Files Structure

### Organized Instructions

#### Core Development Instructions

- [/.github/instructions/contributor-types.instructions.md](./instructions/contributor-types.instructions.md) - Role-specific guidance for different contributor types
- [/.github/instructions/shell-script-copilot.instructions.md](./instructions/shell-script-copilot.instructions.md) - Shell scripting standards and patterns
- [/.github/instructions/markdown-copilot.instructions.md](./instructions/markdown-copilot.instructions.md) - Documentation and markdown standards
- [/.github/instructions/coding-standards.instructions.md](./instructions/coding-standards.instructions.md) - Universal coding standards for all languages
- [/.github/instructions/documentation-standards.instructions.md](./instructions/documentation-standards.instructions.md) - Documentation and README requirements

#### Language-Specific Instructions

- [/.github/instructions/js-copilot.instructions.md](./instructions/js-copilot.instructions.md) - JavaScript/Node.js workflow standards
- [/.github/instructions/python-copilot.instructions.md](./instructions/python-copilot.instructions.md) - Python scripting and automation standards
- [/.github/instructions/wordpress.instructions.md](./instructions/wordpress.instructions.md) - WordPress coding standards and security patterns

#### Testing and Quality Instructions

- [/.github/instructions/bats-tests-and-runner-scripts.instructions.md](./instructions/bats-tests-and-runner-scripts.instructions.md) - Shell script and Bats test standards
- [/.github/instructions/playwright-copilot.instructions.md](./instructions/playwright-copilot.instructions.md) - Playwright automation and MCP server standards
- [/.github/instructions/playwright-typescript.instructions.md](./instructions/playwright-typescript.instructions.md) - Playwright test generation instructions
- [/.github/instructions/performance-optimization.instructions.md](./instructions/performance-optimization.instructions.md) - Universal performance optimization practices

#### AI and Automation Instructions

- [/.github/instructions/ai-prompt-engineering-safety-best-practices.instructions.md](./instructions/ai-prompt-engineering-safety-best-practices.instructions.md) - AI prompt engineering and safety best practices
- [/.github/instructions/create-or-update-copilot.instructions.md](./instructions/create-or-update-copilot.instructions.md) - Standards for instruction authoring
- [/.github/instructions/copilot-thought-logging.instructions.md](./instructions/copilot-thought-logging.instructions.md) - Copilot thought logging and debugging
- [/.github/instructions/memory-bank.instructions.md](./instructions/memory-bank.instructions.md) - Memory bank for session persistence
- [/.github/instructions/task-implementation.instructions.md](./instructions/task-implementation.instructions.md) - Task plan implementation instructions
- [/.github/instructions/tasksync.instructions.md](./instructions/tasksync.instructions.md) - TaskSync V4 protocol for continuous task management
- [/.github/instructions/taming-copilot.instructions.md](./instructions/taming-copilot.instructions.md) - Copilot control and guidance instructions

#### Development Workflow Instructions

- [/.github/instructions/github-actions-ci-cd-best-practices.instructions.md](./instructions/github-actions-ci-cd-best-practices.instructions.md) - Comprehensive CI/CD guidance
- [/.github/instructions/spec-driven-workflow-v1.instructions.md](./instructions/spec-driven-workflow-v1.instructions.md) - Specification-driven development workflow
- [/.github/instructions/self-explanatory-code-commenting.instructions.md](./instructions/self-explanatory-code-commenting.instructions.md) - Code commenting guidelines
- [/.github/instructions/shell-script-header-and-docs.instructions.md](./instructions/shell-script-header-and-docs.instructions.md) - Script header and documentation standards
- [/.github/instructions/localization.instructions.md](./instructions/localization.instructions.md) - Guidance for document localization
- [/.github/instructions/markdown.instructions.md](./instructions/markdown.instructions.md) - Markdown content rules and validation

### Chat Modes

- [/.github/chatmodes/chatmodes.md](./chatmodes/chatmodes.md) - Scenario-based chatmodes for different development contexts

### Prompts

- [/.github/prompts/prompts.md](./prompts/prompts.md) - Template prompt patterns for Copilot Chat and CLI

### Agents

- [/.github/agents/agent.md](./agents/agent.md) - Agent registry and automation tools
- [/AGENTS.md](../AGENTS.md) - Root agents directory and registry

## LightSpeed Framework Integration

All instructions follow the pattern: "You are a [role]. Follow our [framework/patterns] to [type of task]. Avoid [practices or tools] unless specified."

### Key Principles

1. **Kebab-case naming**: All scripts and files use kebab-case convention
2. **Test-driven development**: Every script requires corresponding Bats tests
3. **Reusable workflows**: GitHub Actions should use `workflow_call` trigger
4. **Documentation standards**: Comprehensive README files and inline comments
5. **Security first**: No secrets in code, proper error handling

### Repository Structure Compliance

```md
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
