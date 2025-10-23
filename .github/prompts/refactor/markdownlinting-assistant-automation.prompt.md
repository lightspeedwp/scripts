# Agent Task: Implement Markdown Linting Workflow

## Objective

Add a consistent Markdown linting workflow to this repository using:

- **markdownlint** (engine)
- **markdownlint-cli2** (CLI)
- **@github/markdownlint-github** (opinionated rules)
- **VS Code** config for local parity
- **GitHub Actions** for CI
- **Pre-commit** via Husky + lint-staged (optional but recommended)
- **Chatmode + prompts** for an in-repo LLM assistant

The agent must create/update files, scripts, and CI so contributors get the same results locally and in CI. Keep changes minimal and idempotent.

---

## Inputs & Conventions

- Repo root: current working directory.
- Package manager:
    - If `pnpm-lock.yaml` exists → `pnpm`
    - Else if `yarn.lock` exists → `yarn`
    - Else → `npm`
- Node: use existing `.nvmrc` or `engines` if present; otherwise assume Node ≥ 18.
- Do not overwrite existing files; **merge** where noted.

---

## Plan (high level)

1. **Dependencies:** add dev deps and convenient scripts.
2. **Configs:** add `.markdownlint-cli2.mjs` (primary), optional `.markdownlint.jsonc`.
3. **VS Code:** add `.vscode/settings.json` for editor parity.
4. **CI:** add `.github/workflows/markdownlint.yml`.
5. **Hooks (optional):** set up Husky + lint-staged for pre-commit.
6. **Docs:** add contributor doc and the chatmode prompt.
7. **Sanity check:** run lint, fix sample violations, re-run.
8. **Open PR:** include summary, test steps, and rollback note.

## Current Repository State & Action Items

- `.github/workflows/markdownlint.yml` exists, but `.markdownlint-cli2.mjs`, `.markdownlint.jsonc`, and `.vscode/settings.json` are missing.
- Husky and lint-staged are not yet installed or configured.
- Documentation for markdownlint setup and usage is incomplete; expand in README and CONTRIBUTING.md.

**Action:** Add missing config files, install Husky/lint-staged, update documentation, and validate local/CI parity for markdownlint.

---

## File Operations

### 1) `package.json` (merge)

Add/merge the following:

```jsonc
{
    "devDependencies": {
        "markdownlint-cli2": "^0.15.0",
        "@github/markdownlint-github": "^0.8.0",
        "markdownlint-cli2-formatter-pretty": "^0.0.6",
        "lint-staged": "^15.0.0",
        "husky": "^9.0.0",
    },
    "scripts": {
        "lint:md": "markdownlint-cli2 \"**/*.{md,mdx}\" \"!node_modules\"",
        "lint:md:fix": "markdownlint-cli2 --fix \"**/*.{md,mdx}\" \"!node_modules\"",
        "prepare": "husky install",
    },
    "lint-staged": {
        "*.{md,mdx}": "markdownlint-cli2",
    },
}
```

### 2) `.markdownlint-cli2.mjs` (new)

```js
import markdownIt from 'markdown-it';
import configOptions, { init } from '@github/markdownlint-github';

const markdownItFactory = () => markdownIt({ html: true });

const options = {
    config: init({
        // Safe defaults; adjust per repo
        MD013: { line_length: 120, code_blocks: false, tables: false },
        MD024: { siblings_only: true },
    }),
    customRules: ['@github/markdownlint-github'],
    markdownItFactory,
    outputFormatters: [
        ['markdownlint-cli2-formatter-pretty', { appendLink: true }],
    ],
};

export default options;
```

### 3) `.markdownlint.jsonc` (optional override; new if needed)

```json
{
    // Example: enforce ATX headings; rely on MD013 configured in cli2.mjs
    "MD003": { "style": "atx" }
}
```

### 4) `.github/workflows/markdownlint.yml` (new)

```yaml
name: markdownlint
on:
    pull_request:
        branches: [main, master]
    push:
        branches: [main, master]

jobs:
    lint:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v4
            - name: markdownlint-cli2
              uses: DavidAnson/markdownlint-cli2-action@v16
              with:
                  globs: '**/*.{md,mdx}'
```

### 5) `.vscode/settings.json` (merge or new)

```jsonc
{
    // Use VS Code + markdownlint for local parity
    "editor.rulers": [120],
    "markdownlint.config": {
        "MD003": { "style": "atx" },
        "MD013": { "line_length": 120, "code_blocks": false, "tables": false },
    },
    "files.eol": "\n",
    "editor.insertSpaces": true,
    "editor.tabSize": 2,
}
```

### 6) Husky hook (optional but preferred)

Run once after deps install:

```sh
npx husky add .husky/pre-commit "npx lint-staged"
```

Create `.husky/pre-commit` with:

```sh
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"
npx lint-staged
```

(Make executable.)

### 7) `docs/linting/markdown.md` (new)

```markdown
# Markdown Linting

This repo uses **markdownlint-cli2** with **@github/markdownlint-github**.

## Commands

- `pnpm lint:md` / `yarn lint:md` / `npm run lint:md`
- `pnpm lint:md:fix` / `yarn lint:md:fix` / `npm run lint:md:fix`

## Config precedence

1. `.markdownlint-cli2.mjs` (primary)
2. `.markdownlint.jsonc` (optional overrides)
3. VS Code settings for local parity

## CI

GitHub Actions runs on push/PR. PRs must pass lint.

## Pre-commit

If enabled, Husky + lint-staged lints changed Markdown before commit.
```

### 8) `prompts/chatmode-markdown-linting.md` (new)

> This file powers an in-repo chatmode for assistants.

```markdown
# Chatmode: Markdown Linting Assistant

## Role

You are a Markdown linting assistant. When any Markdown is provided, you check, explain, and (if asked) apply fixes according to **markdownlint** and GitHub’s **markdownlint-github** rules. Use neutral UK English; be concise.

## Process

1. Respect project config (if present): `.markdownlint-cli2.mjs`, `.markdownlint.jsonc/.json/.yml`.
2. Otherwise use the GitHub rules with these defaults:
    - Headings: MD001, MD003: atx, MD041, MD024 (siblings_only)
    - Whitespace/blocks: MD009, MD010, MD012, MD022, MD031, MD032
    - Lists: MD004, MD005, MD007, MD029
    - Code & emphasis: MD038, MD040 (require language), MD037
    - Links: MD011, MD034
    - Line length: MD013: 120 (ignore code blocks & tables)
3. Report violations grouped by rule ID → short message → line numbers (top 10 unique issues by default).
4. Propose fixes via a minimal **unified diff** (≤200 lines); no semantic rewrites; preserve YAML front matter.
5. On “apply”, return the full cleaned file.

## Outputs

- **Lint Summary** (bullets)
- **Patch** (unified diff)
- **(Optional) Clean File**

## Constraints

- Keep summary to one screen, diff to one block.
- Do not modify semantics, names, or code beyond lint fixes.
```

### 9) `prompts/agent-task-markdown-linting.md` (new)

> A copy of this very task prompt for repeatable runs.

Paste the entire content of this Agent Task into `prompts/agent-task-markdown-linting.md`.

### 10) Optional helper script `scripts/setup-markdownlint.sh` (new)

```sh
#!/usr/bin/env bash
set -euo pipefail

PM="npm"
[ -f pnpm-lock.yaml ] && PM="pnpm"
[ -f yarn.lock ] && PM="yarn"

if [ "$PM" = "pnpm" ]; then
  pnpm add -D markdownlint-cli2 @github/markdownlint-github markdownlint-cli2-formatter-pretty lint-staged husky
elif [ "$PM" = "yarn" ]; then
  yarn add -D markdownlint-cli2 @github/markdownlint-github markdownlint-cli2-formatter-pretty lint-staged husky
else
  npm i -D markdownlint-cli2 @github/markdownlint-github markdownlint-cli2-formatter-pretty lint-staged husky
fi

npm run prepare || pnpm run prepare || yarn run prepare || true
npx husky add .husky/pre-commit "npx lint-staged" || true

echo "Setup complete. Run '${PM} run lint:md' to test."
```

---

## Verification

### Local

1. Run: `npm run lint:md` (or `pnpm` / `yarn`).
2. Introduce a small violation (e.g., trailing spaces), confirm it’s reported.
3. Run: `npm run lint:md:fix` and confirm it’s corrected.
4. Open a `.md` file in VS Code and verify inline warnings match CLI.

### CI

- Push a branch; ensure the **markdownlint** workflow runs and passes.
- Open a PR with a known violation; confirm the check blocks merging.

---

## Acceptance Criteria

- Scripts `lint:md` and `lint:md:fix` work with the detected package manager.
- CI job exists and fails on violations, passes when fixed.
- VS Code shows consistent diagnostics with CLI.
- (If enabled) Pre-commit prevents committing violating Markdown.
- Docs and prompts exist and are discoverable:
    - `docs/linting/markdown.md`
    - `prompts/chatmode-markdown-linting.md`
    - `prompts/agent-task-markdown-linting.md`

---

## Git Hygiene

- Create branch: `chore/markdownlint-setup`
- Suggested commits:
    - `chore(markdown): add markdownlint config and scripts`
    - `ci(markdown): add markdownlint GitHub Action`
    - `docs(markdown): contributor guide + chatmode prompt`
    - `chore(git): optional husky + lint-staged`

- PR title: **Add Markdown Linting (markdownlint-cli2 + GitHub rules)**
- PR body: include “Verification” steps and screenshots of passing CI.

---

## Rollback

- Revert the PR; delete `.github/workflows/markdownlint.yml`.
- Remove devDeps and scripts; delete lint config files.
- Remove Husky hook if created; `git rm -r .husky` if unwanted.
