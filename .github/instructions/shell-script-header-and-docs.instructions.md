# Shell Script Header and Inline Documentation Instructions

You are a shell script developer. Follow our LightSpeed WP documentation standards to create and maintain shell scripts. Avoid truncating, duplicating, omitting header fields, or missing inline documentation unless specified.

---

## Header and Inline Documentation Placement (MANDATORY)

> For further notes and examples, see:
>
> - [bats-tests-and-runner-scripts.md](./bats-tests-and-runner-scripts.md)
> - [shell-script-copilot.md](./shell-script-copilot.md)

You can quote these instructions directly to enforce the following:

- **Header block must be the very first content in the file.**
    - No code, comments, blank lines, or documentation may appear above the header.
    - The header must include all required fields (see below).
    - Strict mode (`set -euo pipefail`) must immediately follow the header.

- **Inline function documentation must be placed directly above the function it describes.**
    - Never place function documentation above the header block.
    - Never insert any code, comments, or documentation before the header block.

- **When updating or adding documentation:**
    - Merge and expand function documentation only above the relevant function.
    - Do not duplicate or move documentation above the header block.
    - The header block must remain the first content in the file, followed by strict mode, then code and function docs.

- **When adding new functions:**
    - Always add the inline documentation block immediately above the new function.
    - Never add documentation for a new function above the header block.

- **When refactoring or patching:**
    - If you find documentation above the header block, move it below the header and strict mode, above the relevant function.
    - If you find multiple header blocks, merge them into a single block at the top of the file.
    - Never place any code, comments, or sourcing above the header block.

- **Summary:**
    - The header block is always first.
    - Strict mode is always second.
    - Inline function documentation is always directly above the function it describes, never above the header.
    - No code, comments, or documentation may appear before the header block.
    - This is mandatory for all LightSpeed WP shell scripts.

---

## Header Documentation Standards

- Always begin scripts with a full, framed header block using `# ============================================================================`.
- The header must include, in this order and with all fields present:
    - Script Name
    - Description (detailed, single paragraph)
    - Version
    - Date
    - Author
    - Github Contributors
    - Author URI
    - License
    - License URI
    - Requirements (all dependencies, tools, and setup steps)
    - Usage (all invocation patterns, including environment variables)
    - Environment Variables (all possible, with descriptions)
    - Options (all CLI flags and arguments, with descriptions)
    - Examples (all relevant, covering every option and environment variable)
    - Notes (plural, all important operational, troubleshooting, and idempotency notes)
- Do not remove, truncate, or duplicate any header field. If a field is missing, add it. If a field is duplicated, merge and deduplicate.
- Use plural forms for "Notes" and "Examples" and enumerate all relevant items.
- Frame the header with a single block of `# ============================================================================` at the top and bottom.
- **Directly below the header block, always place:**

```bash
# Strict mode
set -euo pipefail
```

- No other code or comments should appear before this strict mode line.
- All logging functionality should be added below the strict mode function.

---

## Inline Function Documentation Standards

- **Every function must be preceded by a comment block in the following format:**

```bash
# ============================================================================
# Function: function_name
# Description: ...
# Arguments: ...
# Output: ...
# Notes: ...
# ============================================================================
```

- Do not omit or abbreviate any section. If a function has no arguments or output, state "None".
- Place the documentation immediately above the function definition.
- Do not duplicate function documentation. If documentation exists, merge and expand as needed.
- Use clear, concise language and avoid technical jargon unless necessary.
- **Every time you add a new function, always add the function documentation inline above the function.**

---

## General Practices

- Never delete or contract manually added documentation.
- Always expand and validate documentation for completeness.
- When updating, audit for missing fields and add them.
- Do not repeat header or function documentation within the file.
- Use consistent formatting and indentation for all documentation blocks.
- If you find multiple header blocks, merge into a single, complete block at the top of the file.
- **Never place any code, comments, or sourcing above the header block. The header and strict mode must always be first.**

---

## What NOT to Do

- Do not truncate, remove, or abbreviate any header or function documentation.
- Do not duplicate header or function documentation.
- Do not use inconsistent formatting or omit required fields.
- Do not overwrite manual additions with automated content.
- Do not use technical jargon without explanation.

---

Follow these instructions for all shell scripts in the repository to ensure documentation is complete, consistent, and maintainable. For further details, see [bats-tests-and-runner-scripts.md](./bats-tests-and-runner-scripts.md) and [shell-script-copilot.md](./shell-script-copilot.md).
