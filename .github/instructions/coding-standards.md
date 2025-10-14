# Coding Standards Instruction

## Shell Script Coding Standards

- Use `#!/bin/bash` or `#!/usr/bin/env bash` as the shebang.
- Always set `set -euo pipefail` for robust error handling.
- Use kebab-case for filenames and functions.
- Quote all variable expansions: `"$var"`.
- Prefer functions for modularity and reuse.
- Use meaningful, descriptive variable names.
- Add header comments: name, description, usage, author, date.
- Document all functions and complex logic with inline comments.
- Avoid `eval` and unsafe practices.
- Test scripts with Bats (Bash Automated Testing System).
- Lint scripts with ShellCheck and fix all warnings.
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) and [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki).

## WordPress Coding Standards

- For PHP, JavaScript, CSS, and HTML, follow the official [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/).
- Use [PHP_CodeSniffer](https://github.com/WordPress/WordPress-Coding-Standards) for PHP linting.
- Use [eslint-config-wordpress](https://www.npmjs.com/package/eslint-config-wordpress) for JS linting.
- Use [stylelint-config-wordpress](https://github.com/WordPress/stylelint-config-wordpress) for CSS linting.
- Add header comments and inline documentation for all functions, classes, and complex logic.
- Reference WordPress documentation for best practices and examples.

## Enforcement

- Coding standards are enforced via CodeRabbit, ShellCheck, markdownlint, ESLint, and PHP_CodeSniffer status checks.
- All PRs must pass linting and review for coding standards compliance.
- Reviewers should verify adherence to standards before approving changes.

## References

- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki)
- [PHP_CodeSniffer for WordPress](https://github.com/WordPress/WordPress-Coding-Standards)
- [eslint-config-wordpress](https://www.npmjs.com/package/eslint-config-wordpress)
- [stylelint-config-wordpress](https://github.com/WordPress/stylelint-config-wordpress)
