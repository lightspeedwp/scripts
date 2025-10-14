# Shell Script Header and Inline Documentation Instructions

You are a shell script developer. Follow our LightSpeed WP documentation standards to create and maintain shell scripts. Avoid truncating, duplicating, or omitting header fields and inline documentation unless explicitly instructed.

## Header Documentation Standards

- Always begin scripts with a full, framed header block using `###############################################################################`.
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
- Frame the header with a single block of `###############################################################################` at the top and bottom.

## Inline Function Documentation Standards




Every function must be preceded by a comment block in the following format:

```bash
# Function: function_name
# Description: ...
# Arguments: ...
# Output: ...
# Notes: ...
```

Do not omit or abbreviate any section. If a function has no arguments or output, state "None".
Place the documentation immediately above the function definition.
Do not duplicate function documentation. If documentation exists, merge and expand as needed.
Use clear, concise language and avoid technical jargon unless necessary.

## General Practices

- Never delete or contract manually added documentation.
- Always expand and validate documentation for completeness.
- When updating, audit for missing fields and add them.
- Do not repeat header or function documentation within the file.
- Use consistent formatting and indentation for all documentation blocks.
- If you find multiple header blocks, merge into a single, complete block at the top of the file.

## What NOT to Do

- Do not truncate, remove, or abbreviate any header or function documentation.
- Do not duplicate header or function documentation.
- Do not use inconsistent formatting or omit required fields.
- Do not overwrite manual additions with automated content.
- Do not use technical jargon without explanation.

---

Follow these instructions for all shell scripts in the repository to ensure documentation is complete, consistent, and maintainable.
