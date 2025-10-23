---
applyTo: '**'
description: 'Prompt for updating and restructuring the /docs/ folder.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['documentation', 'docs', 'workflow']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'

# Docs Folder Update Documentation Prompt

## Role

You are a documentation workflow specialist. Create a prompt to guide the update and restructuring of the `/docs/` folder for improved clarity, completeness, and maintainability in the LightSpeed WP scripts repository.

## Purpose

Ensure the `/docs/` folder structure is organized, all required documentation files are present, and references are consistent across scripts, tests, and onboarding guides.

## Checklist

- [ ] Audit the current `/docs/` folder structure and contents
- [ ] Identify missing documentation files for scripts, tests, and workflows
- [ ] Create or update README files for each major subfolder
- [ ] Ensure all scripts and tests reference the correct documentation files
- [ ] Update links and references in documentation, scripts, and tests
- [ ] Organize documentation by domain (deployment, maintenance, projects, utility, etc.)
- [ ] Add usage examples, diagrams, and onboarding instructions where needed
- [ ] Validate documentation for completeness and accuracy
- [ ] Commit changes with a clear message

## Docs Folder Update Prompt Template

### Context

The `/docs/` folder must be updated to:

- Include missing documentation files for all scripts and tests
- Organize content by domain and workflow
- Ensure all references and links are correct and up to date
- Provide onboarding and usage instructions for contributors

### Steps

1. Audit the `/docs/` folder and subfolders for missing or outdated files
2. Create or update README files for each domain and major workflow
3. Add missing documentation files for scripts, tests, and automation workflows
4. Update all links and references in scripts, tests, and documentation
5. Organize documentation by domain and workflow for clarity
6. Add usage examples, diagrams, and onboarding instructions
7. Validate documentation for completeness and accuracy
8. Commit changes with a message such as:

   ```sh
   git commit -am "Update docs folder structure and add missing documentation files"
   ```


### Validation Steps
- Review all documentation files for completeness and accuracy
- Ensure all scripts and tests reference the correct documentation
- Validate onboarding and usage instructions
- Validate all new docs with markdownlint
- Document any major changes in the changelog if user-facing

---

Use this prompt to guide and document all `/docs/` folder update operations, ensuring clarity, completeness, and maintainability across the repository. Use this as a template for future documentation structure updates.
