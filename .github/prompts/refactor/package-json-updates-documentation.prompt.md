# package.json Updates Documentation Prompt

## Role

You are a dependency and configuration management specialist. Create a prompt to guide updates to `package.json` and `package-lock.json` for improved automation, linting, and workflow integration in the LightSpeed WP scripts repository.

## Purpose

Ensure `package.json` and `package-lock.json` are updated to include Husky, linting scripts, formatting tools, and any required dependencies for automation and quality checks.

## Checklist

- [ ] Audit current `package.json` and `package-lock.json` for outdated or missing dependencies
- [ ] Add Husky as a dev dependency
- [ ] Add or update scripts for linting (e.g., `lint:js`, `lint:md`, `lint:sh`, `lint:json`)
- [ ] Add formatting scripts (Prettier, Black, etc.)
- [ ] Add test scripts for Jest, Bats, Pytest
- [ ] Add a script to install Husky hooks (e.g., `prepare`)
- [ ] Update scripts section for automation workflows
- [ ] Validate all scripts and dependencies
- [ ] Ensure all scripts are documented in the README
- [ ] Update `package-lock.json` accordingly
- [ ] Document changes in README files
- [ ] Commit changes with a clear message, e.g., `chore: update package.json for Husky and linting`

## package.json Update Prompt Template

### Context

`package.json` and `package-lock.json` must be updated to:

- Include Husky for git hooks
- Add scripts for linting, formatting, and testing
- Ensure all dependencies are current and required for automation
- Document setup and usage for contributors

### Actionable Prompt for Automation Agents

You are an automation agent. Follow these instructions to update `package.json` and `package-lock.json`:

**Requirements:**

- Add Husky as a dev dependency.
- Add or update scripts for linting (e.g., `lint:js`, `lint:md`, `lint:sh`, `lint:json`).
- Add a script to install Husky hooks (e.g., `prepare`).
- Ensure all scripts are documented in the README.
- Update `package-lock.json` accordingly.
- Commit changes with a message like `chore: update package.json for Husky and linting`.

**Example Scripts Section:**

```json
"scripts": {
  "lint:sh": "shellcheck scripts/**/*.sh",
  "lint:js": "eslint .",
  "lint:md": "markdownlint '**/*.md'",
  "lint:json": "jsonlint '**/*.json'",
  "format": "prettier --write .",
  "prepare": "husky install"
}
```

**Example Commit Message:**

```sh
git commit -am "chore: update package.json for Husky and linting"
```

### Steps

1. Audit current dependencies and scripts in `package.json` and `package-lock.json`.
2. Add Husky as a dev dependency:

    ```sh
    npm install --save-dev husky
    ```

3. Add or update linting, formatting, and test scripts as shown above.
4. Add a script to install Husky hooks (e.g., `prepare`).
5. Update automation and workflow scripts as needed.
6. Validate all scripts and dependencies.
7. Document changes in README files.
8. Commit changes with a clear message.

### Validation Steps

- Run all linting, formatting, and test scripts to confirm correct setup.
- Review documentation for updated instructions.
- Validate Husky integration and hook execution.
- Validate all scripts and hooks after updating.

---

Use this prompt to guide and document all `package.json` and `package-lock.json` update operations, ensuring robust automation, linting, and workflow integration across the repository.
