# Agents Registry

This file serves as a registry for all automation agents available in the LightSpeed WP repository.

## Available Agents

### Active Automation Agents

#### Bats Tests Runner Agent

- **Purpose:** Automates test execution and validation for Bats test suites
- **Location:** `.github/agents/bats-tests-runner.agent.js`
- **Integration:** GitHub Actions CI/CD pipelines, manual test execution
- **Usage:** Automatically triggered on script or test file changes during PR reviews
- **Standards:** Aligned with LightSpeed WP Bats testing requirements and coverage thresholds

#### Issue Type Agent

- **Purpose:** Automatically analyzes GitHub issues and assigns appropriate issue types
- **Location:** `.github/agents/issue-type.agent.js`
- **Integration:** GitHub Actions (`.github/workflows/auto-issue-type.yml`)
- **Usage:** Automatically runs when issues are opened or reopened
- **Standards:** Aligned with org-wide issue types and project templates

#### Label Standardization Agent

- **Purpose:** Enforces standardized labels across repositories, preventing redundant labels
- **Location:** `.github/agents/label-standardization.agent.js`
- **Integration:** GitHub Actions (`.github/workflows/label-standardization.yml`)
- **Usage:** Runs weekly and can be triggered manually via workflow_dispatch
- **Standards:** Aligned with org-wide labels and standard prefixes

#### Labeling Agent

- **Purpose:** Automatically applies labels based on content, files changed, and context
- **Location:** `.github/agents/labeling.agent.js`
- **Integration:** GitHub Actions on issue/PR creation and updates, label management workflows
- **Usage:** Automatically triggered on issue/PR creation, updates, and periodic label synchronization
- **Standards:** Aligned with LightSpeed WP label categories and naming conventions

#### Linting Workflow Agent

- **Purpose:** Enforces code quality standards across multiple languages and file types
- **Location:** `.github/agents/linting-workflow.agent.js`
- **Integration:** GitHub Actions on code changes, CI/CD quality gates
- **Usage:** Automatically triggered on code changes via pull requests and repository validation
- **Standards:** Aligned with multi-language linting standards (ShellCheck, markdownlint, ESLint, Prettier, yamllint)

#### Release Agent

- **Purpose:** Automates version management, changelog generation, and release processes
- **Location:** `.github/agents/release.agent.js`
- **Integration:** GitHub Actions on release branch creation, tag events, and release workflows
- **Usage:** Automatically triggered on release branch creation, tag creation, and release publication
- **Standards:** Aligned with semantic versioning and changelog standards

#### Script Header Docs Agent

- **Purpose:** Validates script headers and ensures comprehensive inline documentation
- **Location:** `.github/agents/script-header-docs.agent.js`
- **Integration:** GitHub Actions on script file changes, manual documentation reviews
- **Usage:** Automatically triggered on shell script changes via pull requests
- **Standards:** Aligned with LightSpeed WP shell script documentation standards and header requirements

### Development Templates

#### Agent Template

- **Purpose:** Template for creating new automation agents
- **Location:** `.github/agents/agent-template.md`
- **Usage:** Use as a starting point when creating new agents
- **Standards:** Includes all required documentation sections and integration patterns

## Agent Integration Points

All agents integrate with:

- GitHub Actions workflows (`.github/workflows/`)
- Repository automation and CI/CD pipelines
- Issue and PR management workflows
- Code quality and documentation standards
- LightSpeed WP organizational standards

## Adding New Agents

1. Create agent implementation in `.github/agents/`
2. Add workflow integration in `.github/workflows/`
3. Document the agent in this registry
4. Update the root `AGENTS.md` file
5. Test integration and provide usage examples

## Related Documentation

- [Root AGENTS.md](../../AGENTS.md) - Main agents directory and registry
- [Custom Instructions](./../custom-instructions.md) - Integration with Copilot instructions
- [Workflows Documentation](./../workflows/README.md) - GitHub Actions integration
- [Agent Template](./agent-template.md) - Template for creating new agents

---

See the root [AGENTS.md](../../AGENTS.md) for the complete organizational agent registry and detailed functionality descriptions.
