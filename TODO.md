# Lightspeed Automation TODO List

## 🚨 Project Scripts & Field Automation — EXTREME DETAIL ROADMAP

This section documents, step-by-step, the actions required to fully update, refactor, and test the GitHub Project automation scripts and field CSVs for both client delivery and product development projects.

1. **Field Specification Extraction**

- Review `client-delivery-field-specs-v1-1.md` and `product-development-field-specs-v1-1.md`.
- Create a master list of all required fields for each project type, including:
    - Field name
    - Field type (single_select, number, date, text, etc.)
    - Options (for single_select fields)
    - Color codes (for options, if specified)
    - Applicability (client, product, or both)
    - Any default values or required logic

2. **CSV File Creation/Extension**

- Update `fields.csv` to include all fields for both project types, using the format: `name,type,options(optional)`
- If needed, create separate CSVs for client and product fields, or add a column for project type.
- Ensure all single-select options and colors are included and sorted as per documentation (e.g., numeric prefixes for Size).
- Update `additional-fields.csv` with any extra fields not present in the main CSV.

3. **Script Refactoring**

- **A. update-projects.sh**
    - Validate that the script reads all fields from the CSV(s).
    - Ensure it can create, update, and delete all field types and options.
    - Add logic to handle color codes for single-select options.
    - Add support for new fields (from specs) if not already present.
    - Ensure dry-run and live modes work for all field operations.
- **B. client-delivery-project.sh**
    - Refactor to read field definitions from the CSV, or extend hardcoded logic to support all required fields.
    - Ensure all fields from the client delivery spec are created with correct options and colors.
    - Add error handling for missing or invalid field definitions.
    - Document any limitations or manual steps required.
- **C. product-dev-project.sh**
    - Refactor to read field definitions from the CSV, or extend hardcoded logic to support all required fields.
    - Ensure all fields from the product development spec are created with correct options and colors.
    - Add error handling for missing or invalid field definitions.
    - Document any limitations or manual steps required.

4. **Test Suite Expansion**

- Review all Bats tests in project-scripts.
- Add tests to validate creation of every required field for both project types.
- Add tests for CSV-driven field creation, including edge cases (missing options, invalid types).
- Add tests for dry-run and live modes.
- Add tests for error handling and help output.
- Ensure tests cover both field creation and update logic.

5. **Documentation Updates**

- Update `README.md` to document:
    - All new fields and options
    - CSV format and usage
    - Script CLI usage and examples
    - Error handling and limitations
    - Test coverage and how to run tests
- Update any related automation or workflow documentation.

6. **Validation & QA**

- Run all scripts in dry-run mode to verify output and field creation logic.
- Run all scripts in live mode (on a test project) to verify actual field creation and updates.
- Validate that all fields appear in GitHub Projects as expected, with correct options and colors.
- Review logs and error messages for clarity and completeness.

7. **Governance & Integration**

- Ensure all changes align with org-wide automation, branching, and labeling standards.
- Update Copilot and CodeRabbit instructions to reflect new field automation logic.
- Document integration points with other automation scripts and workflows.

**This section must be kept up-to-date as work progresses. Each step should be checked off only when fully complete and validated.**

---

### Credential Management & Security Best Practices

The script does not embed any hardcoded credentials directly in its source code. Instead, it reads sensitive values (such as `LS_APP_ID`, `LS_APP_PRIVATE_KEY`, `GH_TOKEN`, and `LS_PROJECT_URL`) from environment variables, which is the recommended best practice for security.

**Key points:**

- No secrets, tokens, or private keys are present in the script itself.
- The script warns users to set credentials via environment variables, not in the code.
- The README now includes a security warning about hardcoded credentials and instructs users to avoid embedding secrets in source code.

**Summary:**
The script follows best practices for credential management and does not risk unauthorized access by embedding credentials in the source code. Always ensure environment variables are set securely and never commit secrets to version control.

---

### Script Consolidation & Workflow Recommendations

Here’s a concise analysis of your situation:

- `client-delivery-project.sh` and `product-dev-project.sh` are both specialized bootstrap scripts for creating and configuring GitHub Projects, but each is tailored for a specific use case (client delivery vs. internal product development). They hardcode field sets, options, and some workflow logic for their respective scenarios.
- `update-projects.sh` is a general-purpose, extensible script. It supports CSV-driven field management, dry-run, authentication, and can be adapted for any project type. It’s designed for maintainability and future extensibility.

**Do you need all three scripts?**

- If your workflow requires distinct field sets, naming conventions, or automation logic for client delivery vs. product development, keeping the specialized scripts may help onboarding and clarity for non-technical users.
- If you want a single, flexible automation tool, `update-projects.sh` is sufficient. It can be configured via CSVs to handle both use cases and more, reducing duplication and maintenance overhead.

**Recommendation:**

- Use `update-projects.sh` as your main automation tool.
- Archive or refactor the specialized scripts to be thin wrappers or documentation examples, unless you have strong reasons to keep them (e.g., non-technical users, legacy automation, or frequent one-off bootstrapping).

Let me know if you want a migration plan, wrapper script examples, or help updating your CSVs and documentation for a unified workflow.

# Lightspeed Automation TODO List

Welcome! This file is your master roadmap for automating, refactoring, and documenting the scripts repository. It starts with a high-level plan of action, followed by a detailed, themed checklist. Use this to coordinate work, prioritize improvements, and ensure best practices across the organization.

## Table of Contents

1. [High-Level Plan of Action](#high-level-plan-of-action)
2. [Priority Order](#priority-order)
3. [Project Automation](#project-automation)
4. [Documentation--instructions](#documentation--instructions)
5. [Automation Reliability](#automation-reliability)
6. [Automation--testing](#automation--testing)
7. [Additional Automation--refactoring-ideas](#additional-automation--refactoring-ideas)

---

## High-Level Plan of Action

1. **Automate MCP/Playwright and GitHub MCP servers**: Ensure these servers are always running and integrated with repo workflows for reliable automation.
2. **Refactor Copilot & CodeRabbit instructions**: Update and align instructions for smarter automation, review, and governance.
3. **Refactor GitHub project scripts**: Modularize and extend scripts for ProjectV2 automation, including all major actions and helpers.
4. **Resume automation and documentation improvements**: Continue with reliability, documentation, and feature enhancements.
5. **Expand and maintain test coverage**: Add and improve tests for all new and refactored features.

---

## Priority Order

- [ ] Playwright Copilot & MCP server automation
    - Write Playwright-specific Copilot instructions for this repo, including MCP server auto-activation and restart logic. Ensure Playwright MCP and GitHub MCP servers are always running via workflow steps or process manager. Document setup, restart logic, and integration in README and instruction files.

- [ ] Refactor Copilot & CodeRabbit instructions
    - Update Copilot custom instructions and CodeRabbit .yml to specifically understand this repo's scripts, add future-proof prompt examples, and define chat modes relevant to this repo. Cross-reference instruction sets and document how they interact for automation, review, and governance.

- [ ] GitHub project script refactor
    - Refactor and extend product_dev_project.sh to support all automatable ProjectV2 actions: create project, add fields, add items/issues, link repositories/teams, update project/fields/items/status. Plan helper functions for each mutation and CLI/GraphQL integration.

- [ ] Resume automation tasks
    - Continue with automation, documentation, and reliability improvements as listed below.

- [ ] Add tests for new features
    - Add and expand Bats/Playwright tests for any new or refactored scripts and features.

---

## Project Automation

- [ ] Project Automation Complete

- [ ] Automate repo linking to project
    - Implement and test a helper function in product_dev_project.sh to link repositories to a GitHub ProjectV2 using the linkProjectV2ToRepository GraphQL mutation. Ensure CLI entry point is documented and error handling/logging is robust. Add Bats tests for this functionality.

- [ ] Automate team linking to project
    - Implement and test a helper function in product_dev_project.sh to link teams to a GitHub ProjectV2 using the linkProjectV2ToTeam GraphQL mutation. Standardize CLI entry point, document usage, and add Bats tests. Validate error handling and logging.

- [ ] Automate project/field/item/status updates
    - Create update helpers for project, fields, items, and status in product_dev_project.sh using GraphQL mutations (updateProjectV2, updateProjectV2Field, updateProjectV2ItemFieldValue, updateProjectV2StatusUpdate). Ensure modularity, CLI entry points, and comprehensive Bats test coverage.

## Documentation & Instructions

- [ ] Documentation & Instructions Complete

- [ ] Document automation features
    - Update scripts/README.md to document all new script capabilities, CLI usage, helper functions, and automation scenarios. Include examples, error handling notes, and test coverage details. Ensure markdownlint compliance.

- [ ] Release & changelog instructions integration
    - Expand Copilot and CodeRabbit instructions to include release and changelog automation, customer-facing changelog guidance, and best practices for using verified Marketplace actions and workflow_call. Reference changelog and release workflows in documentation and instructions.

## Automation Reliability

- [ ] Automation Reliability Complete

- [ ] Resolve remaining linting and test coverage issues
    - Review all shell scripts, markdown, and workflow files for unresolved linting errors (ShellCheck, markdownlint, ESLint, Prettier). Fix any outstanding issues, update CI workflows, and ensure all scripts and docs pass linting and tests. Document linting process and status checks in README.

## Automation & Testing

- [ ] Automation & Testing Complete

- [ ] Automate changelog and README updates
    - Write a script to automate changelog and README updates after each round of changes. Ensure changelog entries are generated, committed, and pushed, and README files are updated with new features, usage, and automation details.

- [ ] Extend Playwright test coverage
    - Write additional Playwright tests to extend coverage for this repository. Start by testing CLI entry points, error handling, automation scenarios, and integration with MCP server. Document test plan and coverage goals in README.

- [ ] Chain CodeRabbit and Copilot PR reviews
    - Implement a workflow to chain CodeRabbit AI PR review and a Copilot review (using a free model). First invoke CodeRabbit for audit, then run Copilot review after CodeRabbit completes. Pass PR context/results between jobs if needed.

## Additional Automation & Refactoring Ideas

- [ ] Additional Automation & Refactoring Ideas Complete

- [ ] Package reusable scripts and helpers
    - Refactor common shell functions and automation logic into a toolkit or shared package for use across other org repos. Document usage and distribution strategy (e.g., submodule, release, npm, GitHub Action).

- [ ] Create persistent task tracking
    - Migrate session-based JSON task lists to a persistent file (e.g., tasks.json or tasks.md) for long-term tracking and team collaboration. Sync with todo.md as needed.

- [ ] Improve test coverage depth
    - Expand Bats and Playwright tests to cover edge cases, error handling, and integration scenarios. Add scenario-based tests for scripts with complex logic.

- [ ] Enhance documentation for packaging and distribution
    - Add a section to the README explaining how to package, version, and distribute scripts, helpers, and automation workflows for other repos.

- [ ] Standardize script interfaces and error handling
    - Ensure all scripts have consistent CLI interfaces, help output, and robust error handling/logging. Add usage examples to documentation.

- [ ] Automate badge and contributor updates across multiple files
    - Extend badge/contributor automation to update all relevant README files, not just the root README.

- [ ] Document and automate changelog best practices
    - Create a guide for changelog entry standards and automate changelog generation for releases and major changes.

- [ ] Integrate automation with org-wide governance
    - Align automation scripts and workflows with organization-wide branching, labeling, and project management strategies. Document integration points.
