# lightspeedwp-automation






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
  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/release.yml">
    <img src="https://github.com/lightspeedwp/scripts/actions/workflows/release.yml/badge.svg?branch=develop" alt="Development Status" />
  </a>


  <a href="https://github.com/lightspeedwp/scripts/actions/workflows/changelog.yml">



    <a href="https://github.com/lightspeedwp/scripts">



    </a>

<!-- Recommended additional badges: -->

<!-- Coverage: <img src="https://img.shields.io/codecov/c/github/lightspeedwp/scripts?style=flat-square" alt="Coverage" /> -->

<!-- Version: <img src="https://img.shields.io/github/package-json/v/lightspeedwp/scripts?style=flat-square" alt="Version" /> -->

<!-- Code Quality: <img src="https://img.shields.io/codacy/grade/PROJECT_ID?style=flat-square" alt="Code Quality" /> -->


  npm install --save-dev all-contributors-cli



  ```
- Add contributors:
  ```bash
  npx all-contributors add <username> <contribution-type>
  ```
- Generate the contributors table:

#### Contributor Configuration & Types



See [.all-contributorsrc-docs.md](.all-contributorsrc-docs.md) for:
- Configuration options for contributor automation
Reference this file in your README or CONTRIBUTING.md to explain how contributor recognition works and which contribution types are supported.


## CodeRabbit Review Automation

- Required status checks for linting (markdownlint) and tests before merging
- Minimum 2 review approvals for all PRs
- Auto-labeling and auto-assign for shell, docs, CI, and test files
\n## Advanced Project Automation Scripts


Scripts like `product_dev_project.sh` automate GitHub ProjectV2 provisioning, field management, item/issue linking, and governance. Features include:

- Create/update projects, fields, items, and status
- Add draft issues, link repositories/teams, update labels and issue types

Centralized repository for LightSpeed WP organization automation scripts and CI/CD workflows.



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
## New Features & CLI Usage

### Key Automation Features
- MCP/Playwright server auto-activation and restart
- GitHub ProjectV2 automation (create, update, link, field/item/status management)
- Automatic issue type assignment for GitHub Projects
- Contributor recognition automation
- Badge and changelog update automation
- Stricter linting and test enforcement via CodeRabbit and CI

### Automation Agents

The repository includes specialized automation agents that help with various tasks:

- **Issue Type Agent**: Automatically categorizes GitHub issues in Projects based on template metadata and content analysis
  - Location: `.github/agents/issue-type-agent.js` and `.github/workflows/auto-issue-type.yml`
  - Triggered by: Issues being opened or reopened
  - Functionality: Analyzes issue template metadata, content, and sets appropriate issue type in GitHub Projects
  - Standards: Follows org-wide-issue-types-v1-9.md specifications

For more information on available agents, see [AGENTS.md](AGENTS.md).

### CLI Usage Examples

#### Start MCP Server
```bash
chmod +x scripts/start-mcp-server.sh
./scripts/start-mcp-server.sh
```

#### Run Project Automation Script
```bash
chmod +x scripts/project/product_dev_project.sh
./scripts/project/product_dev_project.sh --create --name "My Project" --owner "lightspeedwp"
```

#### Update Badges and Changelog
```bash
chmod +x scripts/maintenance/update-readme-and-changelog.sh
./scripts/maintenance/update-readme-and-changelog.sh
```

#### Run All Tests
```bash
bats tests/
```

#### Find all README files
```bash
chmod +x scripts/maintenance/find-readmes.sh
./scripts/maintenance/find-readmes.sh
```

### Error Handling Patterns
- All scripts use `set -euo pipefail` for robust error handling.
- CLI scripts validate required parameters and provide usage/help output.
- Errors are logged with timestamps and context for easier troubleshooting.
- Automated workflows enforce status checks and fail on lint/test errors.

### Markdownlint Compliance
- All documentation files are checked with markdownlint in CI.
- Use blank lines around code fences and lists.
- Avoid duplicate headings and ensure consistent heading structure.
- See [markdownlint documentation](https://github.com/DavidAnson/markdownlint) for rules and best practices.

## Release & Changelog Instructions

### Automated Release Process
- On push to `main`, the release workflow:
  - Generates/updates `CHANGELOG.md` from commit history
  - Bumps version and tags the release
  - Publishes a GitHub Release with changelog details
  - All PRs must include a changelog entry in the required format (see PR template)

### Changelog Entry Format
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
4. Create a GitHub Release and paste the changelog entry

See [CHANGELOG.md](CHANGELOG.md) and [release workflow](.github/workflows/release.yml) for implementation details.
## Playwright Browser Testing

This repository uses [Playwright](https://playwright.dev/) for browser-based automation and testing.


Test files are located in `tests/` and use the `.spec.ts` extension.

### Playwright MCP Server Automation

- The Playwright MCP server must be running before Playwright tests are executed.
- MCP server is auto-activated and restarted if stopped using [`scripts/start-mcp-server.sh`](scripts/start-mcp-server.sh).
- CI workflow [`playwright-mcp-server.yml`](.github/workflows/playwright-mcp-server.yml) ensures MCP server is started and logs are archived.
- For local development, run:

```bash
chmod +x scripts/start-mcp-server.sh
./scripts/start-mcp-server.sh
npx playwright test
```

#### Example GitHub Actions Workflow

```yaml
- name: Start Playwright MCP server
  run: |
    chmod +x scripts/start-mcp-server.sh
    ./scripts/start-mcp-server.sh
- name: Run Playwright tests
  run: npx playwright test
```

#### MCP Server Restart Logic

The MCP server is checked and started if not running. For production, use a process manager (e.g., PM2) for persistent uptime.

#### Troubleshooting

- If Playwright tests do not run, ensure Node.js and dependencies are installed (`npm install`).
- If MCP server fails to start, check `playwright-mcp-server.log` for errors.

Playwright configuration and output are ignored via `.gitignore`.

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
| [.github/instructions/playwright-copilot.md](.github/instructions/playwright-copilot.md) | Playwright-specific Copilot instructions and MCP server automation |
<!-- INSTRUCTIONS-TABLE-END -->
