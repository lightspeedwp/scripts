
# lightspeedwp-automation

<div align="center">
  <h3>Workflow Status</h3>
  
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/run-tests.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/run-tests.yml/badge.svg?branch=develop" alt="Shell Script Tests" />
  </a>
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/playwright.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/playwright.yml/badge.svg?branch=develop" alt="Playwright Tests" />
  </a>
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml/badge.svg?branch=develop" alt="Lint Status (JS/TS/Prettier)" />
  </a>
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/markdownlint.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/markdownlint.yml/badge.svg?branch=develop" alt="Markdown Lint" />
  </a>
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/shellcheck.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/shellcheck.yml/badge.svg?branch=develop" alt="ShellCheck Lint" />
  </a>
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/release.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/release.yml/badge.svg?branch=main" alt="Release Automation" />
  </a>
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/changelog.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/changelog.yml/badge.svg?branch=main" alt="Changelog Automation" />
  </a>
</div>



## Contributor Recognition Automation

This repository uses the [all-contributors](https://allcontributors.org/) tool to automate contributor recognition in the README.

### Setup

- Install the CLI:
  ```bash
  npm install --save-dev all-contributors-cli
  ```
- Add contributors:
  ```bash
  npx all-contributors add <username> <contribution-type>
  ```
- Generate the contributors table:
  ```bash
  npx all-contributors generate
  ```
- Contributor info is managed in `.all-contributorsrc` and explained in the documentation file below.

#### Contributor Configuration & Types

See [.all-contributorsrc-docs.md](.all-contributorsrc-docs.md) for:
- Configuration options for contributor automation
- Contribution types used in this project
- How to keep `.all-contributorsrc` up to date
- Guidance for manual and CLI-based updates

Reference this file in your README or CONTRIBUTING.md to explain how contributor recognition works and which contribution types are supported.

## CodeRabbit Review Automation

This repository uses [CodeRabbit](https://coderabbit.ai/) for automated code review and governance enforcement. Key features:

- Required status checks for linting (markdownlint) and tests before merging
- Minimum 2 review approvals for all PRs
- Auto-labeling and auto-assign for shell, docs, CI, and test files
- Path-specific review instructions for scripts, workflows, tests, and documentation
- Enhanced merge protection and governance alignment

See [.coderabbit.yml](.coderabbit.yml) for full configuration and review rules.
\n## Advanced Project Automation Scripts

Scripts like `product_dev_project.sh` automate GitHub ProjectV2 provisioning, field management, item/issue linking, and governance. Features include:

- Create/update projects, fields, items, and status
- Add draft issues, link repositories/teams, update labels and issue types
- Modular helper functions for GraphQL and CLI integration
- Full alignment with org-wide meta/template files and governance standards
- Bats test coverage and error handling

See [scripts/scripts/README.md](scripts/scripts/README.md) for usage and extension details.

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


- Node.js 18+ (for Playwright and linting)
- npm (for installing JS dependencies)
**Usage**:

- Bats test files for shell scripts
- Dry-run validation scripts
- Integration tests
- Mock environments for testing
npm install # Installs Playwright, Prettier, and other dev dependencies

### 📁 `/.github/`

GitHub-specific templates, Copilot instructions, and configuration files.

**Contents**:

- **Copilot Instructions**: Role-based AI assistance configuration
- **Issue & PR Templates**: Standardized contribution templates
- **MCP Configuration**: Model Context Protocol for VSCode integration

npx playwright test
npx playwright test
- **Prompts & Chat Modes**: Reusable AI interaction patterns
- **GitHub Actions**: Organization-level workflow configurations

## Getting Started

### Prerequisites

- Bash 4.0+
- Bats (for running tests)

## Playwright Browser Testing

This repository uses [Playwright](https://playwright.dev/) for browser-based automation and testing.

- Test files are located in `tests/` and use the `.spec.ts` extension.
- To run all browser tests:

```bash
npx playwright test
```

- To run a specific test file:

```bash
npx playwright test tests/example.spec.ts
```

- Playwright configuration and output are ignored via `.gitignore`.

See [Playwright documentation](https://playwright.dev/docs/intro) for more details.

\n## Linting & Formatting Automation
\n## Stricter Linting & Test Enforcement

Linting and test coverage are strictly enforced via CodeRabbit and CI workflows:

- All markdown files must pass linting (markdownlint)
- All scripts must have corresponding Bats tests
- Status checks are required for merges
- Auto-labels and auto-assign streamline review and governance

See [tests/README.md](tests/README.md) and [.coderabbit.yml](.coderabbit.yml) for details.

Linting and formatting are automated using npm scripts and GitHub Actions:

- **Shell scripts:** Linted with [ShellCheck](https://www.shellcheck.net/)
- **JavaScript/TypeScript:** Linted with [ESLint](https://eslint.org/)
- **Formatting:** Enforced with [Prettier](https://prettier.io/)

### Local Usage

Run all linters and formatters:

```bash
npm run lint:js    # Lint JS/TS files
npm run lint:sh    # Lint shell scripts
npm run format     # Format code with Prettier
```

### Continuous Integration

Linting and formatting are checked automatically in CI via GitHub Actions (`.github/workflows/lint.yml`).

On every push or pull request, the following checks run:

- ESLint for JS/TS
- ShellCheck for shell scripts
- Prettier formatting check

See `.github/workflows/lint.yml` for details.

## Editor & Code Style

- `.editorconfig` enforces consistent indentation and line endings
- `.prettierrc` and `.prettierignore` configure Prettier formatting
- `.shellcheckrc` configures ShellCheck rules
- ESLint config is in `eslint.config.js` (flat config for v9+)

## Troubleshooting

- If Playwright tests do not run, ensure Node.js and dependencies are installed (`npm install`).
- For ShellCheck errors, install via Homebrew (`brew install shellcheck`) or your package manager.
- For ESLint v9+ migration, use `eslint.config.js` instead of `.eslintrc.json`.


## Reference

- GitHub CLI (optional, for workflow management)

### Installation

```bash
git clone https://github.com/lightspeedwp/lightspeedwp-automation.git
cd lightspeedwp-automation
```

### Running Tests

```bash
# Run all tests

### Automated Release Process

Releases are automated when changes are merged from `develop` to `main`:

- On push to `main`, the release workflow:
  - Generates/updates `CHANGELOG.md` from commit history
  - Bumps version and tags the release
  - Publishes a GitHub Release with changelog details
  - All PRs must include a changelog entry in the required format (see PR template)

See `.github/workflows/release.yml` for details.

### Changelog Management Strategy

- All notable changes are documented in `CHANGELOG.md` using [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
- PRs must include a changelog entry in the following format:

```md
### Added
- Short description of new features or scripts

### Changed
- Short description of changes or improvements

### Fixed
- Short description of bug fixes

### Security
- Short description of security updates
```

- Changelog entries are required for all PRs and are included in the automated release process
- The PR template enforces changelog entry format and references automation

### Manual Release Fallback

If automation fails, releases can be created manually:

1. Update `CHANGELOG.md` with the latest changes
2. Bump the version in relevant files
3. Commit and tag the release:

```bash
git add CHANGELOG.md
git commit -m "chore(release): vX.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin main --tags
```

1. Create a GitHub Release and paste the changelog entry


See [CHANGELOG.md](CHANGELOG.md) and [release workflow](.github/workflows/release.yml) for implementation details.

```bash
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


## 📚 Major Documentation & Meta Files

All automation, workflow, and governance in this repository is aligned with the following documentation and meta files. Use this table as your central reference for standards, templates, and automation strategies:

| File | Purpose |
|------|---------|
| [LIGHTSPEED_AUTOMATION_HANDBOOK.md](LIGHTSPEED_AUTOMATION_HANDBOOK.md) | Org-wide automation, governance, branching, and workflow standards |
| [scripts/README.md](scripts/scripts/README.md) | Script usage, automation features, and GitHub Project automation details |
| [scripts/update-projects/README.update-projects.md](scripts/update-projects/README.update-projects.md) | update-projects.sh usage, flags, testing, and validation |
| [workflows/README.md](scripts/workflows/README.md) | Workflow usage, CI/CD pipeline templates, and deployment automation |
| [tests/README.md](scripts/tests/README.md) | Test harnesses, Bats usage, and validation strategies |
| [.github/README.md](scripts/.github/README.md) | GitHub templates, Copilot instructions, and configuration files |
| [.github/PROJECT_META.md](scripts/.github/PROJECT_META.md) | Core project automation, field sync, and workflow logic |
| [.github/PROJECT_META.product-development.md](scripts/.github/PROJECT_META.product-development.md) | Product development project template, fields, automations, and views |
| [.github/PROJECT_META.client-delivery.md](scripts/.github/PROJECT_META.client-delivery.md) | Client delivery project template, fields, automations, and views |
| [.github/ISSUE_LABELS.md](scripts/.github/ISSUE_LABELS.md) | Issue labeling strategy, status/priority/area conventions |
| [.github/PR_LABELS.md](scripts/.github/PR_LABELS.md) | PR labeling strategy, branch/status mapping, changelog hygiene |

All scripts, workflows, and automations in this repository are verified to follow the standards and strategies described in these files. Project provisioning, field sync, label/PR automation, and governance are fully aligned.

For detailed governance and workflow documentation, see the [LightSpeed Automation & Governance Handbook](LIGHTSPEED_AUTOMATION_HANDBOOK.md).
