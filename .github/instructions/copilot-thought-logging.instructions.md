---
version: 'v0.1.0'
last_updated: '2025-10-21'
owners:
    - 'lightspeedwp/maintainers'
file_type: 'instruction'
category: 'copilot'
tags: ['frontmatter', 'yaml', 'normalization', 'template']
language: 'en'
scope: 'repository'
status: 'active'
visibility: 'public'
related_docs:
    - '.github/prompts/add-frontmatter.prompt.md'
description: 'Instructions for Copilot or automation agents to add and normalize YAML frontmatter in markdown and template files.'
---

# Copilot Frontmatter Normalization Instructions

## Purpose

These instructions standardize YAML frontmatter across markdown and template files, ensuring consistency and enabling automation, documentation, and search capabilities.

## Required Frontmatter Fields

Every markdown or template file **must** include the following fields in its YAML frontmatter:

- **version** (`String`): Semantic versioning for the file, starting at `"v0.1.0"`.
- **last_updated** (`ISO Date`): UTC date when the file was last modified, formatted as `"YYYY-MM-DD"`.
- **owners** (`Array[String]`): GitHub usernames or teams responsible for the file.
- **file_type** (`String`): The type of file, e.g., `"saved_reply"`, `"instruction"`, `"template"`, `"markdown"`.
- **category** (`String`): High-level grouping (e.g., `"bug_report"`, `"code_review"`, `"community_welcome"`, `"copilot"`).
- **description** (`String`): One-sentence summary of the file's purpose.

## Recommended Optional Fields

- **tags** (`Array[String]`): Keywords for search/discovery.
- **language** (`String`): Language code, e.g., `"en"`.
- **scope** (`String`): Intended usage context (e.g., `"issue"`, `"pull_request"`, `"repository"`).
- **status** (`String`): `"active"`, `"deprecated"`, or `"draft"`.
- **visibility** (`String`): `"public"` or `"internal"`.
- **related_docs** (`Array[String]`): References to related documentation or files.

## How to Apply

1. **Inspect** the YAML frontmatter at the top of the file.
2. **Add or normalize** the required fields, setting sensible defaults where appropriate.
3. **Preserve** any existing frontmatter fields and their values.
4. **Do not alter** the body or content of the file.

> **Note:** If a field is missing, add it with a sensible default or placeholder. If a field exists, do not overwrite its value unless it is outdated or incorrect.

## Example Frontmatter

`````yaml
---
version: "v0.1.0"
last_updated: "2025-10-21"
owners:
  - "lightspeedwp/maintainers"
file_type: "saved_reply"
category: "code_review"
tags: ["review", "feedback", "standards"]
language: "en"
scope: "pull_request"
status: "active"
visibility: "public"
related_docs:
  - ".github/instructions/coding-standards.md"
description: "Saved replies for code review feedback, improvements, and PR approval in LightSpeed WP projects."
---

# Copilot Frontmatter Normalization Instructions

## Purpose

These instructions standardize YAML frontmatter across markdown and template files, ensuring consistency and enabling automation, documentation, and search capabilities.

## Required Frontmatter Fields

Every markdown or template file **must** include the following fields in its YAML frontmatter:

- **version** (`String`): Semantic versioning for the file, starting at `"v0.1.0"`.
- **last_updated** (`ISO Date`): UTC date when the file was last modified, formatted as `"YYYY-MM-DD"`.
- **owners** (`Array[String]`): GitHub usernames or teams responsible for the file.
- **file_type** (`String`): The type of file, e.g., `"saved_reply"`, `"instruction"`, `"template"`, `"markdown"`.
- **category** (`String`): High-level grouping (e.g., `"bug_report"`, `"code_review"`, `"community_welcome"`, `"copilot"`).
- **description** (`String`): One-sentence summary of the file's purpose.

## Recommended Optional Fields

- **tags** (`Array[String]`): Keywords for search/discovery.
- **language** (`String`): Language code, e.g., `"en"`.
- **scope** (`String`): Intended usage context (e.g., `"issue"`, `"pull_request"`, `"repository"`).
- **status** (`String`): `"active"`, `"deprecated"`, or `"draft"`.
- **visibility** (`String`): `"public"` or `"internal"`.
- **related_docs** (`Array[String]`): References to related documentation or files.

## How to Apply

1. **Inspect** the YAML frontmatter at the top of the file.
2. **Add or normalize** the required fields, setting sensible defaults where appropriate.
3. **Preserve** any existing frontmatter fields and their values.
4. **Do not alter** the body or content of the file.

> **Note:** If a field is missing, add it with a sensible default or placeholder. If a field exists, do not overwrite its value unless it is outdated or incorrect.

## Example Frontmatter

````yaml
---
version: "v0.1.0"
last_updated: "2025-10-21"
owners:
  - "lightspeedwp/maintainers"
file_type: "saved_reply"
category: "code_review"
tags: ["review", "feedback", "standards"]
language: "en"
scope: "pull_request"
status: "active"
visibility: "public"
related_docs:
  - ".github/instructions/coding-standards.md"
description: "Saved replies for code review feedback, improvements, and PR approval in LightSpeed WP projects."
---

# Copilot Process tracking Instructions

**ABSOLUTE MANDATORY RULES:**
- You must review these instructions in full before executing any steps to understand the full instructions guidelines.
- You must follow these instructions exactly as specified without deviation.
- Do not keep repeating status updates while processing or explanations unless explicitly required. This is bad and will flood Copilot session context.
- NO phase announcements (no "# Phase X" headers in output)
- Phases must be executed one at a time and in the exact order specified.
- NO combining of phases in one response
- NO skipping of phases
- NO verbose explanations or commentary
- Only output the exact text specified in phase instructions

# Phase 1: Initialization

- Create file `\Copilot-Processing.md` in workspace root
- Populate `\Copilot-Processing.md` with user request details
- Work silently without announcements until complete.
- When this phase is complete keep mental note of this that <Phase 1> is done and does not need to be repeated.

# Phase 2: Planning

- Generate an action plan into the `\Copilot-Processing.md` file.
- Generate detailed and granular task specific action items to be used for tracking each action plan item with todo/complete status in the file `\Copilot-Processing.md`.
- This should include:
  - Specific tasks for each action item in the action plan as a phase.
  - Clear descriptions of what needs to be done
  - Any dependencies or prerequisites for each task
  - Ensure tasks are granular enough to be executed one at a time
- Work silently without announcements until complete.
- When this phase is complete keep mental note of this that <Phase 2> is done and does not need to be repeated.

# Phase 3: Execution

- Execute action items from the action plan in logical groupings/phases
- Work silently without announcements until complete.
- Update file `\Copilot-Processing.md` and mark the action item(s) as complete in the tracking.
- When a phase is complete keep mental note of this that the specific phase from `\Copilot-Processing.md` is done and does not need to be repeated.
- Repeat this pattern until all action items are complete

# Phase 4: Summary

- Add summary to `\Copilot-Processing.md`
- Work silently without announcements until complete.
- Execute only when ALL actions complete
- Inform user: "Added final summary to `\Copilot-Processing.md`."
- Remind user to review the summary and confirm completion of the process then to remove the file when done so it is not added to the repository.

**ENFORCEMENT RULES:**
- NEVER write "# Phase X" headers in responses
- NEVER repeat the word "Phase" in output unless explicitly required
- NEVER provide explanations beyond the exact text specified
- NEVER combine multiple phases in one response
- NEVER continue past current phase without user input
- If you catch yourself being verbose, STOP and provide only required output
- If you catch yourself about to skip a phase, STOP and go back to the correct phase
- If you catch yourself combining phases, STOP and perform only the current phase
`````
