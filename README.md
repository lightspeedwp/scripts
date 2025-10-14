# LightSpeed WP Automation

[![License: GPL v3 or later](https://img.shields.io/badge/License-GPL%20v3%20or%20later-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
[![Lint Status (JS/TS/Prettier)](https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml)
[![Markdown Lint](https://github.com/lightspeedwp/scripts/actions/workflows/markdownlint.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/markdownlint.yml)
[![Development Status](https://github.com/lightspeedwp/scripts/actions/workflows/release.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/release.yml)

Centralized repository for LightSpeed WP organization automation scripts and CI/CD workflows.

This repository includes comprehensive GitHub Copilot instructions to assist with automation development:

- **[Custom Instructions](/.github/custom-instructions.md)**: Main Copilot configuration with role-based guidance
- **[Contributor Guidelines](/.github/instructions/contributor-types.md)**: Role-specific development patterns
- **[Shell Script Standards](/.github/instructions/shell-script-copilot.md)**: Bash automation best practices
- **[Documentation Guidelines](/.github/instructions/markdown-copilot.md)**: Technical writing standards
- **[Reusable Prompts](/.github/prompts/prompts.md)**: Template prompts for Copilot Chat and CLI
- **[Chat Modes](/.github/chatmodes/chatmodes.md)**: Scenario-based development contexts

## Repository Structure

- `scripts/`: Shell scripts for automation tasks.
- `workflows/`: GitHub Actions workflows.
- `tests/`: Bats tests and dry-run scripts.
- `.github/`: GitHub templates, Copilot instructions, and configuration.
- `LIGHTSPEED_AUTOMATION_HANDBOOK.md`: Organization-wide documentation.

## Key Automation Features

- GitHub ProjectV2 automation (create, update, link, field/item/status management)
- Automatic issue type assignment for GitHub Projects
- Contributor recognition automation
- Badge and changelog update automation
- Stricter linting and test enforcement via CodeRabbit and CI

## Automation Agents

The repository includes specialized automation agents that help with various tasks. For more information on available agents, see [AGENTS.md](AGENTS.md).

## Getting Started

### Prerequisites

- [Bats-core](https://github.com/bats-core/bats-core) for running tests
- [ShellCheck](https://www.shellcheck.net/) for linting shell scripts
- [Node.js](https://nodejs.org/) and npm for Prettier
- GitHub CLI (optional, for workflow management)

### Installation

```bash
git clone https://github.com/lightspeedwp/lightspeedwp-automation.git
cd lightspeedwp-automation
npm install # Installs Prettier and other dev dependencies
```

### Usage

#### Run All Tests

```bash
bats tests/
```

#### Find all README files

```bash
chmod +x scripts/maintenance/find-readmes.sh
./scripts/maintenance/find-readmes.sh
```

## Development

### Linting & Formatting

Linting and formatting are automated using npm scripts and GitHub Actions:

- **Shell scripts:** Linted with [ShellCheck](httpss://www.shellcheck.net/)
- **JavaScript/TypeScript:** Linted with [ESLint](httpss://eslint.org/)
- **Formatting:** Enforced with [Prettier](httpss://prettier.io/)

Run all linters and formatters:

```bash
npm run lint:js    # Lint JS/TS files
npm run lint:sh    # Lint shell scripts
npm run format     # Format code with Prettier
```

### Error Handling Patterns

- All scripts use `set -euo pipefail` for robust error handling.
- CLI scripts validate required parameters and provide usage/help output.
- Errors are logged with timestamps and context for easier troubleshooting.
- Automated workflows enforce status checks and fail on lint/test errors.



## Release & Changelog

Releases are automated when changes are merged from `develop` to `main`. The release workflow generates/updates `CHANGELOG.md`, bumps the version, tags the release, and publishes a GitHub Release.

See [CHANGELOG.md](CHANGELOG.md) and the [release workflow](.github/workflows/release.yml) for implementation details.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Documentation

All automation, workflow, and governance in this repository is aligned with the documentation and meta files in the `.github` directory and the `LIGHTSPEED_AUTOMATION_HANDBOOK.md`.

## License

This project is licensed under the GPL v3 or later. See the [LICENSE](LICENSE) file for details.
