# Development Guide

You are a developer. Follow our repo setup and testing patterns to develop, test, and validate automation scripts and workflows. Avoid manual releases and untested changes.

## Local Setup

- Clone repo, install dependencies (`npm install`, `pip install`, `pre-commit install`).
- Run tests (`./tests/run-tests.sh`, `bats ./tests/test-update-projects.bats`).
- Lint scripts (`shellcheck scripts/*.sh`, `pre-commit run --all-files`).

## Best Practices

- Scripts must support dry-run and explicit confirmation.
- Reference secrets via environment variables.
- Keep scripts idempotent.
- Use org-wide label, branching, and changelog conventions.

See [CONTRIBUTING.md](CONTRIBUTING.md) for contributor workflow.
