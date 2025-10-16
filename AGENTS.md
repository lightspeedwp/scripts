# AGENTS.md

## Project Overview

This repository contains automation scripts and GitHub Actions workflows for the LightSpeed WP organization. It includes shell scripts, CI/CD workflows, and AI automation agents for project management, code quality enforcement, and development workflow optimization. The project uses Node.js for JavaScript components, Bash for shell scripts, and various GitHub Actions for CI/CD automation.

## Setup Commands

- Install dependencies: `npm install`
- Start linting: `npm run lint`
- Run tests: `npm test`
- Run dry-run tests: `npm run test:dry-run`
- Format code: `npm run format`
- Validate all: `npm run validate`

## Development Workflow

- The repository uses GitHub Actions for automation
- All scripts follow kebab-case naming convention
- Shell scripts require corresponding Bats tests
- Markdown files must pass markdownlint validation
- JavaScript files must pass ESLint validation

## Testing Instructions

- Run all tests: `npm test`
- Run shell script tests: `bats tests/test-*.bats`
- Run markdown linting: `npm run lint:md`
- Run shell script linting: `npm run lint:sh`
- Run JavaScript linting: `npm run lint:js`
- Test coverage summary available in `/tests/TEST_COVERAGE_SUMMARY.md`

## Code Style

- Shell scripts: Follow LightSpeed WP Bash standards with `set -euo pipefail`
- JavaScript: Use ESLint configuration with Prettier formatting
- Markdown: Follow markdownlint rules for consistency
- All files: Use kebab-case naming convention

## Automation Agents

This repository contains AI and automation agents to assist with GitHub project management and workflow automation.

## Current Agents

### issue-type-agent

- **Purpose:** Automatically analyzes GitHub issues and assigns appropriate issue types in GitHub Projects
- **Location:** `.github/agents/issue-type.agent.js`
- **Integration:** GitHub Actions (`.github/workflows/auto-issue-type.yml`)
- **Usage:** Automatically runs when issues are opened or reopened
- **Standards:** Aligned with org-wide issue types and project templates
- **Functionality:**
  - Analyzes issue template metadata, content, title, and labels
  - Determines appropriate issue type using standardized types (Bug, Feature, Task, Epic, Story, etc.)
  - Updates GitHub ProjectsV2 issue type field
  - Adds issues to relevant projects if not already added
- **Testing:** Run `bats tests/test-issue-type-agent.bats` (if available)
- **Definition of Done:**
  - Correctly identifies all standard issue types per org-wide standards
  - Prioritizes template metadata over content analysis
  - Integrates with PR and issue templates
  - Follows standard branch naming conventions when modified

### label-standardization-agent

- **Purpose:** Enforces standardized labels across repositories, preventing redundant labels
- **Location:** `.github/agents/label-standardization.agent.js`
- **Integration:** GitHub Actions (`.github/workflows/label-standardization.yml`)
- **Usage:** Runs weekly and can be triggered manually via `workflow_dispatch`
- **Commands:**
  - Manual trigger: Go to Actions → Label Standardization → Run workflow
  - Test mode: Set dry-run parameter to true in workflow
- **Standards:** Aligned with org-wide labels and standard prefixes
- **Functionality:**
  - Detects non-standard labels with standard equivalents (e.g., "php" vs "lang:php")
  - Migrates issues/PRs from non-standard to standard labels
  - Removes redundant non-standard labels after migration
  - Supports dry-run mode for testing before applying changes
- **Testing:** Run with dry-run mode enabled to preview changes
- **Definition of Done:**
  - Successfully standardizes all labels according to organization conventions
  - Properly migrates issues/PRs to use standard labels
  - Provides clear logging and summary reports
  - Integrates with existing label workflows

### script-header-docs-agent

- **Purpose:** Documentation specialist that ensures comprehensive script headers and inline documentation following LightSpeed WP standards
- **Location:** `.github/agents/script-header-docs.agent.js`
- **Integration:** GitHub Actions on script file changes, manual documentation reviews
- **Usage:** Automatically triggered on shell script changes via pull requests
- **Commands:**
  - Check script documentation: Review shell scripts in PRs automatically
  - Manual validation: Use `.github/instructions/shell-script-header-and-docs.instructions.md` guidelines
- **Standards:** Aligned with LightSpeed WP shell script documentation standards and header requirements
- **Functionality:**
  - Validates script headers follow LightSpeed WP standards (shebang, script name, description, usage, author, date)
  - Checks for proper inline documentation and comments
  - Ensures function documentation and usage examples
  - Validates parameter and variable documentation
  - Generates documentation quality scores and improvement suggestions
- **Testing:** Review shell scripts against documentation standards in `.github/instructions/`
- **Definition of Done:**
  - All shell scripts have compliant headers with required components
  - Functions and important variables are properly documented
  - Provides clear feedback on documentation gaps with actionable suggestions
  - Integrates with PR review process for automated documentation validation

### bats-tests-runner-agent

- **Purpose:** Test automation specialist that ensures comprehensive test coverage and quality following LightSpeed WP testing standards
- **Location:** `.github/agents/bats-tests-runner.agent.js`
- **Integration:** GitHub Actions on script or test file changes, CI/CD test validation
- **Usage:** Automatically triggered on script or test file changes during PR reviews
- **Commands:**
  - Run all tests: `npm test`
  - Run specific test: `bats tests/test-script-name.bats`
  - Run dry-run tests: `npm run test:dry-run`
- **Standards:** Aligned with LightSpeed WP Bats testing requirements and coverage thresholds
- **Functionality:**
  - Ensures every shell script has corresponding Bats tests
  - Validates test coverage and quality against script type requirements
  - Manages test runner scripts and CI integration
  - Checks for proper test structure and naming conventions
  - Analyzes test categories (basic functionality, error handling, dry-run, etc.)
- **Testing:** Use `.github/workflows/run-shell-tests.yml` and `.github/workflows/test-all.yml`
- **Definition of Done:**
  - All shell scripts have corresponding test files with minimum coverage threshold
  - Test files follow naming conventions and quality standards
  - Test runners are properly configured for CI/CD integration
  - Provides comprehensive testing reports with coverage metrics and suggestions

### release-agent

- **Purpose:** Release management specialist that automates version management and changelog generation following LightSpeed WP release processes
- **Location:** `.github/agents/release.agent.js`
- **Integration:** GitHub Actions on release branch creation, tag events, and release workflows
- **Usage:** Automatically triggered on release branch creation, tag creation, and release publication
- **Commands:**
  - Create release: Use `.github/workflows/release.yml` workflow
  - Update changelog: Modify `CHANGELOG.md` and `VERSION` files
  - Validate release: Run `npm run validate` before creating releases
- **Standards:** Aligned with LightSpeed WP semantic versioning and changelog standards
- **Functionality:**
  - Validates release readiness and quality gates
  - Manages semantic versioning and changelog automation
  - Coordinates release branches and tag creation
  - Handles release notes and documentation updates
  - Performs comprehensive pre-release validation (files, tests, documentation, dependencies)
- **Testing:** Use `.github/workflows/release.yml` for release automation testing
- **Definition of Done:**
  - All release criteria are validated before release creation
  - Version consistency is maintained across all files (VERSION, package.json, CHANGELOG.md)
  - Release process is fully automated with proper quality gates
  - Provides detailed release validation reports and blocks releases with critical issues

### linting-workflow-agent

- **Purpose:** Code quality specialist that ensures consistent code quality across all files following LightSpeed WP linting standards
- **Location:** `.github/agents/linting-workflow.agent.js`
- **Integration:** GitHub Actions on code changes, CI/CD quality gates
- **Usage:** Automatically triggered on code changes via pull requests and repository validation
- **Commands:**
  - Run all linting: `npm run lint`
  - Run markdown linting: `npm run lint:md`
  - Run shell linting: `npm run lint:sh`
  - Run JavaScript linting: `npm run lint:js`
  - Format code: `npm run format`
- **Standards:** Aligned with LightSpeed WP multi-language linting standards (ShellCheck, markdownlint, ESLint, Prettier, yamllint)
- **Functionality:**
  - Validates linting configuration consistency across multiple languages
  - Enforces code quality standards for shell, JavaScript, Markdown, YAML
  - Manages automated fixes and suggestions
  - Coordinates with CI/CD workflows for quality gates
  - Analyzes changed files for linting issues with detailed reporting
- **Testing:** Use `.github/workflows/lint.yml`, `.github/workflows/eslint.yml`, `.github/workflows/markdownlint.yml`
- **Definition of Done:**
  - All supported file types have proper linting configurations
  - Linting workflows are integrated into CI/CD with appropriate triggers
  - Code quality issues are detected and reported with auto-fix suggestions
  - Comprehensive linting reports provide actionable feedback for developers

### labeling-agent

- **Purpose:** Project organization specialist that ensures consistent issue and PR categorization following LightSpeed WP labeling standards
- **Location:** `.github/agents/labeling.agent.js`
- **Integration:** GitHub Actions on issue/PR creation and updates, label management workflows
- **Usage:** Automatically triggered on issue/PR creation, updates, and periodic label synchronization
- **Commands:**
  - Automatic labeling: Triggered by `.github/workflows/labeler.yml` on PR/issue events
  - Manual labeling: Use GitHub issue/PR interfaces with standardized labels
- **Standards:** Aligned with LightSpeed WP label categories and naming conventions (area:, lang:, priority:, status:, size:, type:)
- **Functionality:**
  - Automatically applies labels based on content, files changed, and context
  - Enforces label consistency and naming conventions
  - Manages label hierarchies and relationships
  - Integrates with project management and workflow automation
  - Validates repository labels against organizational standards
- **Testing:** Use `.github/workflows/labeler.yml` and `.github/workflows/issue-labeler.yml`
- **Definition of Done:**
  - All issues and PRs receive appropriate labels based on standardized categories
  - Repository labels conform to organizational naming conventions
  - Label application is consistent and automated across content and file patterns
  - Provides comprehensive labeling reports with suggestions for improvement

## Build and Deployment

- Validation pipeline command: `npm run lint && npm test`
- Output directories: `tests/` for test outputs, `logs/` for execution logs
- Environment configurations: Development uses local validation, production uses GitHub Actions
- Deployment commands: Deployment handled via GitHub Actions workflows in `.github/workflows/`
- CI/CD integration: All agents integrate with GitHub Actions for automated execution

## Pull Request Guidelines

- Title format: [component] Brief description (e.g., "agent: Update issue type classification logic")
- Required checks: `npm run lint`, `npm test`, markdown validation, shell script validation
- All agents must pass linting and testing before merge
- Documentation updates required for agent functionality changes
- Agent modifications require corresponding workflow testing

## Agent Management

### Adding New Agents

1. Create agent file in `.github/agents/` following naming convention `name.agent.js`
2. Add corresponding workflow in `.github/workflows/` if needed
3. Document agent in this file and `.github/agents/agent.md`
4. Add tests following Bats testing standards
5. Update documentation and cross-references

### Agent Integration Workflows

- **Issue Management:** `.github/workflows/auto-issue-type.yml`, `.github/workflows/issue-labeler.yml`
- **Label Management:** `.github/workflows/label-standardization.yml`, `.github/workflows/labeler.yml`
- **Code Quality:** `.github/workflows/lint.yml`, `.github/workflows/eslint.yml`, `.github/workflows/markdownlint.yml`
- **Testing:** `.github/workflows/run-shell-tests.yml`, `.github/workflows/test-all.yml`
- **Release:** `.github/workflows/release.yml`

## Additional Automation Logic

Additional agent-related logic is managed via:

- [Custom instructions](.github/custom-instructions.md) - Main Copilot integration and standards
- [Prompts](.github/prompts/prompts.md) - Template prompt patterns for agent interactions
- [Chat modes](.github/chatmodes/chatmodes.md) - Scenario-based development contexts
- [Instructions](.github/instructions/) - Detailed standards and guidelines for all automation
- [Automation scripts](scripts/) - Shell scripts for manual and automated operations
- [Workflows](.github/workflows/) - GitHub Actions automation pipelines

## How to Add Agents

1. Create a new folder: `./github/agents/`
2. Add agent implementation files (e.g., `copilot-agent.js`, `review-agent.py`)
3. Document each agent in this file:
   - Name
   - Purpose
   - Integration points
   - Usage instructions
   - Maintenance notes

## Example Entry (for future agents)

```markdown
### copilot-swe-agent
- **Purpose:** Automates code suggestions and review for SWE tasks
- **Location:** .github/agents/copilot-swe-agent.js
- **Integration:** GitHub Actions, Copilot Chat, CodeRabbit
- **Usage:** See README and workflow documentation
```

---

**Note:** Update this file whenever new agents are added or existing ones are modified.
