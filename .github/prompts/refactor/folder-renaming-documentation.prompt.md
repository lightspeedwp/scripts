---
applyTo: '**'
description: 'Prompt for folder renaming documentation and process.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['folder', 'renaming', 'documentation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Folder Renaming Documentation Prompt

## Role

You are a workflow documentation specialist. Create a prompt to guide the renaming of project and test folders for improved clarity and consistency in the LightSpeed WP scripts repository.

## Purpose

Ensure the folder structure is clear, consistent, and aligned with project naming conventions. Document the process for renaming `/scripts/update-projects/` to `/scripts/projects/` and `/tests/project/` to `/tests/projects/`.

Ensure the folder structure is clear, consistent, and aligned with project naming conventions. Document the process for renaming `/scripts/project/` to `/scripts/projects/` and `/tests/project-scripts/` to `/tests/projects/`. All related documentation, scripts, tests, and log files must be updated to reflect these changes.

## Critical Review & Impact Assessment

Renaming these folders will break all existing script and test references, including imports, path resolutions, documentation links, log file paths, and helper function usage. A comprehensive, step-by-step update is required to restore functionality and maintain consistency.

### Impacted Areas

- Script files in `/scripts/project/` → `/scripts/projects/`
- Test files in `/tests/project-scripts/` → `/tests/projects/`
- Documentation in `/docs/projects/`
- Log file creation and references
- Helper functions for path resolution
- Test setup and teardown blocks
- Loader lines for test helpers
- CI/CD configuration and scripts
- Any hardcoded paths in scripts, tests, or documentation

## Exhaustive Update Instructions

### 1. Inventory and Planning

- List all files in `/scripts/project/` and `/tests/project-scripts/`.
- Identify all references to these folders in scripts, tests, documentation, and CI/CD configs.
- Create a migration checklist for each file and reference.

### 2. Folder Renaming

- Rename `/scripts/project/` to `/scripts/projects/`.
- Rename `/tests/project-scripts/` to `/tests/projects/`.
- Validate that all files and subfolders are moved correctly.

#### Actionable Prompt for Automation Agents

You are an automation agent. Follow these instructions to rename project folders and update all references:

**Folders to Rename:**

- Rename `/scripts/update-projects/` to `/scripts/projects/`
- Rename `/tests/project/` to `/tests/projects/`

**Requirements:**

- Move all files and subfolders to the new locations.
- Update all references in scripts, documentation, tests, and workflows to use the new folder names.
- Ensure no broken paths or import errors remain.
- Update any README or documentation files that mention the old folder names.
- Validate that all scripts and tests run successfully after the change.
- Commit the changes with a clear message, e.g., `refactor: rename update-projects and project folders for consistency`.

**Example Commit Message:**

```text
refactor: rename update-projects and project folders for consistency

- Renamed /scripts/update-projects/ to /scripts/projects/
- Renamed /tests/project/ to /tests/projects/
- Updated all references in code, docs, and workflows
```

**Notes:**

- Double-check for case sensitivity on all platforms.
- If using Git, use `git mv` to preserve history.
- Run all tests and linting after renaming to ensure nothing is broken.

---

Use this prompt as a template for future folder renaming or refactoring tasks.

### 3. Update Script Files

- Update all internal path references (e.g., sourcing, imports, file reads/writes) to use `/scripts/projects/`.
- Update any log file paths to reflect the new folder name (e.g., `logs/project-*.log` → `logs/projects-*.log`).
- Update helper functions that resolve script or log paths.
- Update documentation links in script headers and inline comments.
- Update any script-generated output or artifacts to use the new folder name.

### 4. Update Test Files

- Update all loader lines for test helpers to use the new path:
  - Example: `load "$(dirname \"$BATS_TEST_FILENAME\")/../test-helper.bash"`
- Update all references to scripts under test to use `/scripts/projects/`.
- Update setup and teardown blocks to resolve new script and log paths.
- Update log file creation and cleanup logic to use the new folder name.
- Update any test output normalization functions to handle new paths.
- Update documentation links in test headers and inline comments.
- Update test coverage summary and README files to reflect new test folder and file names.

### 5. Update Documentation

- Update all documentation files in `/docs/projects/` to reference `/scripts/projects/` and `/tests/projects/`.
- Update any code samples, usage instructions, or diagrams to use the new folder names.
- Update README files in `/scripts/projects/` and `/tests/projects/`.
- Update any onboarding or setup guides.

### 6. Update Log Files and Logging Functions

- Update all log file creation logic to use the new folder name (e.g., `logs/projects-*.log`).
- Update logging functions to reference the correct script/test paths.
- Update log rotation, cleanup, and archival scripts if they use hardcoded paths.
- Validate that all log outputs are correctly generated and accessible after the change.

### 7. Update Helper Functions

- Update any shared helper functions (e.g., in `test-helper.bash`) that resolve script, test, or log paths.
- Update any path normalization logic to use the new folder names.
- Validate that all helper functions work correctly after the change.

### 8. Update CI/CD Configuration

- Update all CI/CD scripts and configuration files to use the new folder names for test discovery, script execution, and artifact collection.
- Update any workflow triggers or job paths.
- Validate that all CI/CD jobs run successfully after the change.

### 9. Update Hardcoded Paths

- Search the entire codebase for hardcoded references to `/scripts/project/` and `/tests/project-scripts/`.
- Update all such references to `/scripts/projects/` and `/tests/projects/`.
- Validate that all scripts, tests, and documentation are free of outdated paths.

### 10. Validation and Testing

- Run all scripts in `/scripts/projects/` to validate functionality.
- Run all tests in `/tests/projects/` to validate coverage and correctness.
- Validate log file creation and output.
- Validate documentation links and onboarding guides.
- Validate CI/CD pipeline runs and passes.
- Review test coverage summary and update as needed.

### 11. Commit and Documentation

- Commit all changes with a clear message:


## Checklist

- [ ] Identify all references to the old folder names in scripts, tests, and documentation
- [ ] Rename `/scripts/update-projects/` to `/scripts/projects/`
- [ ] Rename `/tests/project/` to `/tests/projects/`
- [ ] Update all import, require, and path references in scripts and tests
- [ ] Update documentation files to reflect new folder names
- [ ] Validate that all scripts and tests run successfully after renaming
- [ ] Commit changes with a clear message

## Folder Renaming Prompt Template

### Context

We need to rename the following folders for consistency:

- `/scripts/update-projects/` → `/scripts/projects/`
- `/tests/project/` → `/tests/projects/`

### Steps


```sh  git commit -am "Rename project folders, update all references, logs, and documentation"  ```- Update changelog and release notes to document the migration.- Notify team members of the breaking change and provide migration instructions.## Additional Concerns & Recommendations
- **Backup:** Create a backup of the repository before starting the migration.
- **Atomic Migration:** Perform all changes in a single commit or PR to avoid partial updates.
- **Review:** Have a second reviewer validate all changes before merging.- **Testing:** Run all tests and scripts in a clean environment to catch missed references.
- **Documentation:** Update all onboarding and setup guides to reflect the new structure.
- **Deprecation:** Mark old folder names as deprecated in documentation and comments.
- **Communication:** Announce the change to all contributors and stakeholders.

1. Search the codebase for all references to the old folder names
2. Rename the folders using `mv` or your file manager
3. Update all scripts, tests, and documentation to use the new folder names
4. Run all tests to ensure functionality is preserved
5. Update any CI/CD configuration or scripts that reference the old folder names
6. Commit the changes with a message such as:

   ```sh
   git commit -am "Rename project folders, update all references, logs, and documentation"
   ```

### Validation Steps

- Run all scripts and tests to confirm no broken references
- Review documentation for updated paths
- Ensure CI/CD pipeline passes

---

Use this expanded prompt to guide and document all folder renaming operations, including exhaustive updates to scripts, tests, documentation, log files, helper functions, and CI/CD configuration. Ensure all references are updated and validated for a smooth migration. Use this prompt to guide and document all folder renaming operations in the repository.
