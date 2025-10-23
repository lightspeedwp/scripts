---
applyTo: '**'
description: 'Prompt for refactoring issue types automation and GitHub auth scope.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['issue-types', 'automation', 'github']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Issue Types Refactor Documentation Prompt

## Role

You are an issue type automation specialist. Create a prompt to guide the refactor and improvement of issue types automation and GitHub authentication scope for the LightSpeed WP scripts repository.

## Purpose

Ensure issue types automation scripts and workflows are updated to match project specifications, improve accuracy, maintain consistency, and resolve GitHub authentication scope issues for issues, pull requests, and project boards.

## Checklist

## Current Repository State & Action Items

- Issue type automation scripts are present in `scripts/maintenance/` (e.g., `manage-issue-types.sh`).
- Folder structure: `/scripts/project/` and `/tests/project-scripts/` currently used; planned renaming for consistency.
- Spec files for issue types and rules are in `/docs/projects/spec/`.
- Automated issue type workflows exist in `.github/workflows/`.
- Tests for issue type scenarios are missing or incomplete.
- GitHub authentication scope issues may exist; audit and update as needed.

**Action:** Audit scripts against spec files, update naming and logic, resolve authentication issues, add/expand tests, and update documentation in README and changelog files.

## Issue Types Refactor Prompt Template

### Context

Issue types automation must be refactored to:

- Match issue type categories and rules in `/docs/projects/spec/`
- Resolve GitHub authentication scope issues
- Improve accuracy and error handling
- Document changes and update usage instructions

### Requirements

- Review current issue types automation logic and workflows.
- Identify and resolve any GitHub authentication scope issues.
- Update scripts, agents, and workflows to match new requirements.
- Add or update tests for all issue type scenarios.
- Document changes in the relevant README and changelog.
- Commit changes with a message like `refactor: update issue types automation and fix auth scopes`.

### Notes

- Validate all changes with tests and in CI.
- Use this prompt as a template for future issue type automation updates.
