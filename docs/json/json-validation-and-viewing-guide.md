# JSON Validation & Viewing — Practical Guide (v1.1)

> Lightweight, reliable ways to **view, lint, prettify, and validate** JSON in Chrome & VS Code, plus a Copilot agent prompt and CI-friendly workflows. UK English, minimal stack, repeatable steps.
> _Regenerated: 2025-10-17 13:41 _

---

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [View JSON in Chrome (JSONVue / JSONView)](#view-json-in-chrome-jsonvue--jsonview)
4. [Lint & Pretty-print JSON in VS Code (no extensions)](#lint--prettyprint-json-in-vs-code-no-extensions)
5. [VS Code “Viewer” Extensions (optional)](#vs-code-viewer-extensions-optional)
6. [JSON Schema: generate & wire up](#json-schema-generate--wire-up)
7. [Validate JSON against a schema (VS Code & CLI)](#validate-json-against-a-schema-vs-code--cli)
8. [Batch format/validate & log errors (repeatable workflow)](#batch-formatvalidate--log-errors-repeatable-workflow)
9. [Copilot “JSON Linter” Agent — Prompt](#copilot-json-linter-agent--prompt)
10. [Extra handy JSON utilities](#extra-handy-json-utilities)
11. [Recommended VS Code settings](#recommended-vs-code-settings)
12. [Appendix: References](#appendix-references)

---

## Overview

This guide helps you:
- **View** JSON quickly in the browser or VS Code.
- **Prettify** JSON with built-in VS Code tools (no extensions required).
- **Validate** JSON structure using **JSON Schema** (Ajv CLI).
- **Automate** formatting/validation across many files with simple scripts and CI.
- **Prompt** a Copilot-style agent to lint/validate and output minimal diffs.

---

## Quick Start

```bash
# 1) Format every JSON file in place (non-destructive)
npm i -D prettier
npx prettier --write "**/*.json"

# 2) Validate your data against a JSON Schema (Ajv CLI)
npm i -D ajv ajv-cli
npx ajv validate -s schema/my-doc.schema.json -d "data/**/*.json" --errors=text

# 3) Log validation errors for review
mkdir -p reports
npx ajv validate -s schema/my-doc.schema.json -d "data/**/*.json" --errors=text \
  2>&1 | tee reports/ajv-errors.log
```

---

## View JSON in Chrome (JSONVue / JSONView)

- **Chrome/Chromium**: [JSONVue (Web Store)](https://chromewebstore.google.com/detail/jsonvue/chklaanhfefbnpoihckbnefhakgolnmc) — a port of the original JSONView; pretty-print with collapsible nodes and common viewer features.
- **Firefox & Chrome alt**: [JSONView (benhollis)](http://benhollis.net/software/jsonview/) / [JSONView (Chrome listing)](https://chromewebstore.google.com/detail/jsonview/gmegofmjomhknnokphhckolhcffdaihd).
- Typical features across this lineage:
  - Client-side validation (historically via JSON parsing/JSONLint-style logic).
  - **JSONP** support for viewing `callback({...})` payloads.
  - **Customisable stylesheet** for the rendered tree.
  - Legacy spec references may cite **RFC 4627**; modern JSON is specified in **RFC 8259** / ECMA-404.

> Tip: Viewer extensions are great for **read-only inspection** of API responses. For editing, prefer VS Code’s built-in JSON tools below.

---

## Lint & Pretty-print JSON in VS Code (no extensions)

**Built-in tools (maintained by Microsoft):**

- **Format Document**
  - macOS: **⇧⌥F**
  - Windows: **Shift+Alt+F**
  - Linux: **Ctrl+Shift+I**
- **Format Selection**
  - macOS: **⌘K ⌘F**
  - Windows/Linux: **Ctrl+K Ctrl+F**
- **Format on Save**: enable in Settings (JSON).

### Multi-file “prettify” trick (touch-to-format)

> Works when **Format on Save** is enabled. Useful to force pretty-printing across many files without extensions.

1) Open **Settings (JSON)** and ensure:
```json
{
  "editor.formatOnSave": true,
  "[json]": {
    "editor.defaultFormatter": null,
    "editor.wordWrap": "on",
    "editor.formatOnPaste": false,
    "editor.formatOnType": false
  }
}
```
2) Drag the folder into VS Code.
3) Open the **Search** view (⌘⇧F) and search for a single comma `,`.
4) **Replace All** with `,` across files. This touches each file; VS Code saves & formats each JSON on save.
5) Spot-check a few files — they should now be prettified.

> Prefer CI automation for repeatability — see the workflows below.

---

## VS Code “Viewer” Extensions (optional)

If you want a **tree viewer** panel (read/edit) on top of the built-ins:

- **JSON Viewer (Mr.Che)** — preview JSON as a tree; open via “Open in JSON viewer.”
  Marketplace: https://marketplace.visualstudio.com/items?itemName=ccimage.jsonviewer
- **Json Editor (Nick DeMayo)** — interactive tree editor synced with file (alternative).

> Marketplace ratings & maintenance vary. For reliability and longevity, favour **VS Code’s built-in JSON language features** and add a viewer extension only if you truly need tree editing.

---

## JSON Schema: generate & wire up

Start with a small, explicit schema and grow it. Wire schemas via `$schema` (per file) or `json.schemas` (workspace mapping).

**Minimal starting schema** (`schema/my-doc.schema.json`):
```json
{
  "$id": "https://example.com/my-doc.schema.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "MyDoc",
  "type": "object",
  "required": ["name", "version"],
  "properties": {
    "name":   { "type": "string", "minLength": 1 },
    "version":{ "type": "integer", "minimum": 1 },
    "tags":   { "type": "array", "items": { "type": "string" }, "uniqueItems": true },
    "meta":   { "type": "object", "additionalProperties": true }
  },
  "additionalProperties": false
}
```

**Per-file attachment (at the top of your JSON files):**
```json
{
  "$schema": "./schema/my-doc.schema.json",
  "name": "Example",
  "version": 1
}
```

**Workspace mapping (`.vscode/settings.json`):**
```json
{
  "json.schemas": [
    {
      "fileMatch": ["data/**/*.json"],
      "url": "./schema/my-doc.schema.json"
    }
  ]
}
```

---

## Validate JSON against a schema (VS Code & CLI)

### VS Code (schema-aware diagnostics)

Attach a schema (above). VS Code surfaces validation errors inline and offers IntelliSense, hovers, and suggestions.

### CLI (Ajv — fast and CI-friendly)

```bash
npm i -D ajv ajv-cli

# Validate every JSON under data/ against a schema
npx ajv validate -s schema/my-doc.schema.json -d "data/**/*.json" --errors=text

# Produce a machine-readable JSON report
npx ajv validate -s schema/my-doc.schema.json -d "data/**/*.json" --errors=json \
  > reports/ajv-errors.json
```

---

## Batch format/validate & log errors (repeatable workflow)

**Option A — Prettier for formatting; Ajv for validation**

```bash
npm i -D prettier ajv ajv-cli

# 1) Format all JSON (non-destructive)
npx prettier --write "**/*.json"

# 2) Validate and tee errors to a log
mkdir -p reports
npx ajv validate -s schema/my-doc.schema.json -d "data/**/*.json" --errors=text \
  2>&1 | tee reports/ajv-errors.log

# 3) Non-zero exit on validation errors is built in (Ajv), so your CI fails correctly.
```

**Option B — JSONLint for strict syntax checks (no schema)**

```bash
npm i -D jsonlint
npx jsonlint -cq data/**/*.json 2>&1 | tee reports/jsonlint.log
```

> Use **Ajv** for data-shape guarantees; **JSONLint** for pure syntax checks. Running both is common.

**Optional: GitHub Actions (CI)** — `.github/workflows/json-validate.yml`
```yaml
name: JSON format & validate
on:
  pull_request:
    paths: ["**/*.json", "schema/**/*.json", ".prettierrc*"]
jobs:
  check-json:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci || npm i -D prettier ajv ajv-cli
      - run: npx prettier --check "**/*.json"
      - run: |
          mkdir -p reports
          npx ajv validate -s schema/my-doc.schema.json -d "data/**/*.json" --errors=text \
            2>&1 | tee reports/ajv-errors.log
```

---

## Copilot “JSON Linter” Agent — Prompt

Use this as a **system prompt** for a Copilot/agent. Keep it under ~4k chars if your platform requires.

**Role**
You are a **JSON Linter & Validator**. You pretty-print JSON, validate syntax and **JSON Schemas**, and propose **minimal diffs**. You output ready-to-run VS Code/CLI steps.

**Purpose**
Keep JSON collections **valid, readable, and schema-compliant** with a minimal toolchain.

**Process**
- If input is raw JSON: check syntax; if invalid, return the exact error location and a **3-line fix**.
- If a `$schema` is present or a schema path is supplied: validate with Ajv; summarise errors and propose minimal object/array edits.
- For multi-file tasks: output a **bash block** using `prettier`, `ajv-cli`, optionally `jsonlint`.
- Never rename or drop keys unless the schema requires it; call out any **breaking** changes.

**Constraints**
- UK English; concise. Prefer VS Code built-ins and Ajv; justify extra dependencies.
- Outputs always include: 1) a succinct diagnosis, 2) a minimal patch (JSON or JSON Patch), 3) a runnable command.

**Example first user message**
“Validate all files in `data/` against `schema/my-doc.schema.json`, pretty-print in place, and write a log of validation errors.”

---

## Extra handy JSON utilities

- **Diff JSON**: `npx json-diff a.json b.json` (or `git diff --word-diff a.json b.json`)
- **Sort keys (stable order)**: `jq -S . input.json > output.json`
- **Find duplicate keys**: `npx jsonlint -c file.json`

---

## Recommended VS Code settings

Place in **User** or **Workspace** settings for sane JSON defaults:

```json
{
  "editor.formatOnSave": true,

  "[json]": {
    "editor.defaultFormatter": null, // VS Code built-in
    "editor.wordWrap": "on",
    "editor.formatOnPaste": false,
    "editor.formatOnType": false
  },

  "json.validate.enable": true,
  "json.schemaDownload.enable": true,

  // Map schemas to file globs
  "json.schemas": [
    { "fileMatch": ["data/**/*.json"], "url": "./schema/my-doc.schema.json" }
  ],

  // General quality-of-life
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true
}
```

---

## Appendix: References

- **VS Code — JSON language features** (validation, schemas, formatting):
  https://code.visualstudio.com/Docs/languages/json

- **Stack Overflow — Format code in VS Code** (shortcuts & commands):
  https://stackoverflow.com/questions/29973357/how-do-you-format-code-in-visual-studio-code-vscode

- **Stack Overflow — Auto-pretty JSON view in VS Code** (discussion & options):
  https://stackoverflow.com/questions/66781071/is-there-a-way-to-view-json-files-automatically-prettyfied-in-visual-studio-code

- **Chromium JSON viewer**:
  JSONVue (port of JSONView): https://chromewebstore.google.com/detail/jsonvue/chklaanhfefbnpoihckbnefhakgolnmc

- **Firefox/Chrome alternative JSON viewer**:
  JSONView: http://benhollis.net/software/jsonview/ and https://chromewebstore.google.com/detail/jsonview/gmegofmjomhknnokphhckolhcffdaihd

- **JSONLint**:
  https://github.com/zaach/jsonlint

- **RFC 8259 (modern JSON spec)**:
  https://www.rfc-editor.org/info/rfc8259

- **Ajv CLI**:
  https://ajv.js.org/packages/ajv-cli.html

- **Prettier CLI**:
  https://prettier.io/docs/cli
