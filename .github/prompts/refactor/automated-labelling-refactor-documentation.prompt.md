---
applyTo: '**'
description: 'Prompt for refactoring automated labelling based on project specs.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['automation', 'labelling', 'workflow']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Automated Labelling Refactor Documentation Prompt

## Role

You are a workflow automation and labeling specialist. Create a prompt to guide the refactor and improvement of automated labeling based on specifications in `/docs/projects/spec/` for the LightSpeed WP scripts repository.

## Purpose

Ensure automated labeling scripts and workflows are updated to match project specifications, improve accuracy, and maintain consistency across issues, pull requests, and project boards.

## Checklist

- [ ] Audit current automated labeling scripts and workflows
- [ ] Review specifications in `/docs/projects/spec/`
- [ ] Identify gaps, errors, or outdated logic in labeling automation
- [ ] Update scripts to match label categories, naming conventions, and rules
- [ ] Add or update tests for labeling logic
- [ ] Document changes and usage in README files
- [ ] Validate labeling accuracy and error handling
- [ ] Commit changes with a clear message
- [ ] Add front matter to all prompt files for metadata and compliance

## Automated Labelling Refactor Prompt Template

### Context

Automated labeling must be refactored to:

- Match label categories and rules in `/docs/projects/spec/`
- Improve accuracy and consistency for issues, PRs, and project boards
- Document setup, usage, and troubleshooting for contributors

### Steps

1. Audit current automated labeling scripts and workflows
2. Review label specifications and rules in `/docs/projects/spec/`
3. Identify and document gaps or errors in current automation
4. Update scripts to match required label categories, naming conventions, and rules
5. Add or update tests for labeling logic and edge cases
6. Document changes and usage in README files
7. Validate labeling accuracy and error handling
8. Commit changes with a message such as:

   ```sh
   git commit -am "Refactor automated labeling to match project specs and improve accuracy"
   ```

### Validation Steps

- Test automated labeling on issues, PRs, and project boards
- Review labeling accuracy and error handling
- Validate documentation and onboarding instructions

---

Use this prompt to guide and document all automated labeling refactor operations, ensuring accuracy, consistency, and alignment with project specifications.
