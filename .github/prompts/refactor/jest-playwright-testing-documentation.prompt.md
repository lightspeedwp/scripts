---
applyTo: '**'
description: 'Prompt for Jest and Playwright testing workflow setup and documentation.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['jest', 'playwright', 'testing', 'automation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Jest/Playwright Testing Documentation Prompt

## Role

You are a prompt engineering specialist for automated testing workflows. Create a prompt to guide the comprehensive setup of Jest and Playwright for testing in the LightSpeed WP scripts repository.

## Purpose

Ensure Jest and Playwright are configured for robust unit, integration, and end-to-end testing, supporting high code quality and reliable automation workflows.

### Requirements

- Install Jest and Playwright as dev dependencies.
- Set up configuration files for both (jest.config.js, playwright.config.js).
- Add scripts to `package.json` for running tests.
- Create example test files for both frameworks.
- Document test setup and usage in the README.
- Integrate tests into CI workflows.
- Commit changes with a message like `test: add Jest and Playwright testing setup`.

## Notes

- Validate that tests run locally and in CI.
- Use this prompt as a template for future test workflow integrations.

## Checklist

## Current Repository State & Action Items

- Jest and Playwright are not yet installed or configured in this branch.
- No `jest.config.js` or `playwright.config.js` files exist.
- No example test files for Jest or Playwright are present.
- CI workflows for testing exist, but do not include Jest/Playwright integration.

**Action:** Install Jest and Playwright, add configuration files, create example tests, update CI workflows, and document setup/usage in README files.

- [x] Add Jest, Playwright, and related packages to package.json
- [x] Install all required devDependencies
- [x] Create `tests/jest` and `tests/playwright` folders for test organization
- [ ] Configure Jest for unit and integration tests
- [ ] Configure Playwright for end-to-end browser tests
- [ ] Add example test files and suites in the new folders
- [ ] Document test setup, execution, and reporting
- [ ] Integrate tests with CI/CD pipeline
- [ ] Provide troubleshooting and validation steps
- [ ] Update documentation and onboarding guides
- [ ] Write and store agent tests in the correct folder
- [ ] Create instructions for testing workflows and agent integration
- [ ] Create chatmodes for agent testing, debugging, and workflow automation
- [ ] Create prompts for test writing, validation, and reporting

## Jest/Playwright Setup Prompt Template

### Context

We need to implement Jest and Playwright for:

- Unit and integration testing of scripts and modules
- End-to-end browser testing for automation workflows
- CI/CD integration for automated test execution
- Documentation of test setup and usage
- Creation of instructions, chatmodes, and prompts to support agent testing and workflow automation

### Playwright Setup Instructions

1. Install Playwright and its dependencies:

    ```sh
    npm install --save-dev @playwright/test
    npx playwright install
    ```

2. Create Playwright configuration file (`playwright.config.ts` or `.js`) in the project root.
3. Store Playwright tests in the `tests/playwright/` folder.
4. Add example Playwright test files (e.g., `agent-e2e.spec.ts`).
5. Document Playwright test setup and execution in `/docs/`.
6. Integrate Playwright test scripts into CI/CD pipeline.
7. Validate setup by running all Playwright tests locally and in CI.

### Recommended Agent Test Types

- Unit tests for agent core logic (e.g., input validation, output formatting)
- Integration tests for agent interactions with scripts and workflows
- End-to-end tests for agent-driven automation scenarios
- Error handling and edge case tests
- Performance and reliability tests

### Example Agent Test Files

- `tests/agents/agent-core.test.js`
- `tests/agents/agent-integration.test.js`
- `tests/agents/agent-e2e.test.js`
- `tests/agents/agent-error.test.js`
- `tests/agents/agent-performance.test.js`

### How to Write and Store Agent Tests

1. Create test files in the `tests/agents/` folder using Jest or Playwright as appropriate.
2. Use descriptive test names and group related tests in suites.
3. Mock dependencies and external services for unit tests.
4. Use Playwright for browser-based or end-to-end automation tests.
5. Document each test with purpose, expected outcome, and setup steps.
6. Validate tests by running locally and in CI.
7. Update documentation and onboarding guides to reference agent test folder and conventions.
8. Create instructions files for agent testing workflows and integration.
9. Develop chatmodes for agent debugging, test validation, and workflow automation.
10. Author prompts for writing, validating, and reporting agent tests.

### Setup Steps

1. Configure Jest by creating a `jest.config.js` in the project root
2. Configure Playwright by creating a `playwright.config.ts` or `.js` in the project root
3. Add example test files to `tests/jest/` and `tests/playwright/`
4. Document test setup and execution in `/docs/`
5. Integrate test scripts into CI/CD pipeline
6. Validate setup by running all tests
7. Troubleshoot common issues (dependencies, environment)
8. Commit changes with a clear message (e.g., "Add Jest and Playwright testing setup")

### Validation Steps

- Run all Jest and Playwright tests locally and in CI
- Review test coverage and reporting
- Ensure documentation is clear and up to date

---

Use this prompt to guide and document all Jest and Playwright testing setup operations, including instructions for package installation, folder creation, configuration, and initial test setup.
