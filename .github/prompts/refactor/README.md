
# Refactor Prompts Overview & Usage Guide

This folder contains a comprehensive set of prompt engineering documents for modular shell script architecture, CI/CD integration, documentation, testing, security, and automation for the LightSpeed WP scripts repository.

## Objective

The goal is to use these prompt files as explicit, actionable specifications for a Copilot agent to refactor, audit, and fine-tune the entire repository. Each prompt describes a domain-specific refactor, migration, or best practice. Some work has already been completed; the remaining tasks require auditing and refinement based on these prompts.

## How to Use These Prompts

1. **Pass all prompt files in this folder to the Copilot agent in a single session.**
2. **Instruct the agent to refactor the repository according to each prompt's requirements.**
3. **Audit existing work and fine-tune scripts, tests, includes, documentation, and workflows as specified.**
4. **Validate that all changes meet the standards and checklists described in the prompts.**
5. **Commit and document all changes with clear messages referencing the relevant prompt(s).**



## Prompt Files & Their Purposes

- **advanced-deployment-strategies-for-modular-components.prompt.md**
	- Advanced deployment strategies for modular shell script components, including multi-environment, zero-downtime, validation, and rollback.
- **agent-integration-with-scripts.prompt.md**
	- Patterns for integrating AI agents with shell scripts for automation, review, and orchestration.
- **automated-labelling-refactor-documentation.prompt.md**
	- Refactor and improve automated labeling workflows to match project specs and ensure accuracy.
- **best-practices-for-shell-script-modularization.prompt.md**
	- Comprehensive best practices for modular shell script development, maintainability, and reliability.
- **ci-cd-pipeline-integration-for-modular-scripts.prompt.md**
	- CI/CD pipeline integration for modular scripts, including testing, security, and release management.
- **docs-folder-update-documentation.prompt.md**
	- Update and restructure the `/docs/` folder for clarity, completeness, and maintainability.
- **documentation-and-testing-integration-strategies.prompt.md**
	- Strategies for integrating documentation and testing for modular shell script includes.
- **example-directory-structure-for-modular-scripts.prompt.md**
	- Example directory structures for organizing modular shell script components and supporting files.
- **folder-renaming-documentation.prompt.md**
	- Document and guide the renaming of project and test folders, including script renames and impact analysis.
- **github-copilot-performance-and-optimization-guidelines.prompt.md**
	- Performance and optimization guidelines for Copilot-driven shell script automation.
- **husky-implementation-documentation.prompt.md**
	- Setup and integration of Husky for linting and quality checks on git hooks.
- **includes-test-methodology.prompt.md**
	- Bats test methodology for modular shell script includes, edge cases, and integration testing.
- **interactive-prompts-for-copilot-implementation.prompt.md**
	- Interactive prompt templates for Copilot implementation of modular shell script architecture.
- **issue-types-refactor-documentation.prompt.md**
	- Refactor issue types automation and GitHub authentication scope for project boards.
- **jest-playwright-testing-documentation.prompt.md**
	- Setup and documentation for Jest and Playwright testing workflows.
- **markdownlinting-assistant-automation.prompt.md**
	- Add and document markdown linting workflows for local and CI environments.
- **migration-guide-from-monolithic-to-modular-architecture.prompt.md**
	- Step-by-step migration guide from monolithic to modular shell script architecture.
- **modular-includes-recommendations.prompt.md**
	- Recommendations for modular includes and reusable shell script modules.
- **monitoring-and-alerting-for-shell-script-automation.prompt.md**
	- Monitoring and alerting strategies for shell script automation systems.
- **package-json-updates-documentation.prompt.md**
	- Guide for updating `package.json` and related scripts for automation and quality checks.
- **prompt-json-linting-validation.md**
	- JSON linting and validation workflow prompt for automation and CI.
- **prompt-templates-for-include-creation.prompt.md**
	- Structured templates for function extraction and modular include creation.
- **recommended-script-files-for-includes.prompt.md**
	- List of recommended script files for modular includes and their purposes.
- **script-functions-breakdown-spec.prompt.md**
	- Detailed specifications for breaking out reusable shell script functions.
- **security-considerations-for-modular-shell-scripts.prompt.md**
	- Security guidelines and threat modeling for modular shell script automation.
- **specific-implementation-examples-for-each-component.prompt.md**
	- Concrete implementation examples for each modular shell script component.
- **workflow-documentation-integration.prompt.md**
	- Integration of workflow documentation with automation and CI/CD processes.

## Next Steps

- Audit the repository against each prompt's checklist and requirements.
- Fine-tune scripts, tests, includes, and documentation as needed.
- Remove or consolidate duplicate prompt files as work progresses.
- Ensure all prompt files are markdownlint compliant and up to date.

---

For details, see individual prompt files and the consolidation plan above.
