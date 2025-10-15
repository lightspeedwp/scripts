---
applyTo: '**'
description: 'Instruction Authoring Standards for LightSpeed WP Copilot, prompts, chatmodes, and agents. Includes frontmatter, structure, review, and integration requirements.'
version: '1.1'
author: 'LightSpeed WP Team'
audience: ['contributor', 'maintainer', 'reviewer', 'automation']
status: 'approved'
changelog: ['2025-10-15: Initial version', '2025-10-15: Added versioning, audience, status, changelog, deprecation, tags, validation, feedback, lifecycle, automation, security, localization, accessibility, conflict, impact fields']
tags: ['standards', 'automation', 'copilot', 'review', 'prompt', 'chatmode', 'agent']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
deprecated: false
related: ['custom-instructions.md', 'AGENTS.md', 'prompts.md', 'chatmodes.md']
updated: '2025-10-15'
created: '2025-10-15'
---
# Instruction Authoring Standards

You are an instruction author. Follow our LightSpeed WP instruction framework and best practices to create and maintain contributor guidance, standards, and automation instructions. Avoid ambiguity, duplication, missing context, or unsupported tools unless specified.

---

## Purpose

This document provides standards and patterns for writing effective instructions for contributors, automation agents, and documentation in the LightSpeed WP organization. It also defines the process for creating or updating Copilot instruction files, prompts, chatmodes, and agents, ensuring all new or updated instructions are properly referenced, documented, and integrated.

---

## Core Principles

- **Clarity**: Use concise, direct language. State the role, framework, task type, and anti-patterns in the opening paragraph.
- **Actionability**: Instructions must be immediately usable by contributors or automation agents.
- **Consistency**: Follow a standard structure and formatting for all instruction files.
- **Context**: Reference related standards, documentation, and examples.
- **Enforceability**: Instructions should be testable, reviewable, and enforceable via automation or code review.
- **Integration**: Always update `.github/custom-instructions.md` and cross-reference related files.
- **Extensibility**: Add agent, prompt, or chatmode files if required by the new instructions.
- **Traceability**: Document all changes and references for maintainability.

---

## Standard Structure for Instruction Files

1. **Frontmatter**
   - YAML block at the top of the file with metadata fields (see below)
2. **Opening Paragraph**
   - Format: `You are a [role]. Follow our [framework/patterns] to [type of task]. Avoid [practices or tools] unless specified.`
3. **Purpose and Scope**
   - Briefly describe what the instruction covers and who should use it.
4. **Core Principles**
   - List the key principles for effective instructions (clarity, actionability, etc.).
5. **Required Sections**
   - Role definition and context
   - Framework or standards to follow
   - Task types and scenarios
   - Anti-patterns and explicit exclusions
   - Examples and references
6. **Formatting Guidelines**
   - Use markdown headings and bullet lists for readability.
   - Include code blocks for templates and examples.
   - Reference related files using relative links.
7. **Integration References**
   - Reference `.github/custom-instructions.md` and any related agent, prompt, or chatmode files
8. **Review and Enforcement**
   - Checklist for clarity, completeness, and compliance

---

## Frontmatter Guidelines

All instruction, prompt, chatmode, and agent files must begin with a YAML frontmatter block containing relevant metadata. Example fields:

### Instruction Files
```yaml
---
applyTo: '**'
description: 'Brief summary of the instruction purpose and scope'
version: '1.0'
author: 'Instruction author name or team'
audience: ['contributor', 'maintainer', 'reviewer', 'automation']
status: 'approved|draft|deprecated'
changelog: ['YYYY-MM-DD: Initial version', 'YYYY-MM-DD: Updates']
tags: ['standards', 'automation']
feedback: 'How to suggest improvements or report issues.'
deprecated: false
related: ['custom-instructions.md', 'agent.md', 'prompts.md', 'chatmodes.md']
updated: 'YYYY-MM-DD'
created: 'YYYY-MM-DD'
---
```

### Prompt Files
```yaml
---
promptType: 'copilot|review|automation|custom'
description: 'Purpose and usage of the prompt'
version: '1.0'
author: 'Prompt author name or team'
audience: ['contributor', 'automation']
status: 'approved|draft|deprecated'
changelog: ['YYYY-MM-DD: Initial version']
tags: ['prompt', 'copilot']
feedback: 'How to suggest improvements or report issues.'
deprecated: false
related: ['custom-instructions.md', 'prompts.md']
updated: 'YYYY-MM-DD'
created: 'YYYY-MM-DD'
---
```

### Chatmode Files
```yaml
---
chatmodeType: 'scenario|role|custom'
description: 'Purpose and usage of the chatmode'
version: '1.0'
author: 'Chatmode author name or team'
audience: ['contributor', 'reviewer']
status: 'approved|draft|deprecated'
changelog: ['YYYY-MM-DD: Initial version']
tags: ['chatmode', 'scenario']
feedback: 'How to suggest improvements or report issues.'
deprecated: false
related: ['custom-instructions.md', 'chatmodes.md']
updated: 'YYYY-MM-DD'
created: 'YYYY-MM-DD'
---
```

### Agent Files
```yaml
---
name: 'Agent Name'
description: 'Purpose and integration points for the agent'
agentType: 'automation|review|custom'
tools: ['tool1', 'tool2']
model: 'copilot|claude|gemini'
author: 'Agent author or team'
created: 'YYYY-MM-DD'
updated: 'YYYY-MM-DD'
version: '1.0'
status: 'approved|draft|deprecated'
changelog: ['YYYY-MM-DD: Initial version', 'YYYY-MM-DD: Updates']
tags: ['agent', 'automation']
audience: ['automation', 'reviewer']
feedback: 'How to suggest improvements or report issues.'
deprecated: false
related: ['AGENTS.md', 'agent.md', 'custom-instructions.md']
---
```

---

## When to Create a Custom Agent

Create a dedicated agent when:
- The new instructions require automation, validation, or review beyond existing agents
- There is a need for specialized logic, integration, or reporting
- The agent will be referenced by multiple instruction, prompt, or chatmode files

### Agent File Creation Checklist
- Add agent implementation to `.github/agents/agentname.js|py|sh`
- Add YAML frontmatter as above
- Update `AGENTS.md` in the repository root with agent details and purpose
- Update `.github/agents/agent.md` to document and link the agent
- Reference the agent in related instruction, prompt, or chatmode files

---

## Review Checklist
- [ ] Opening paragraph follows required format
- [ ] Purpose and scope are clear
- [ ] Core principles are listed
- [ ] Required sections are present
- [ ] Formatting is consistent
- [ ] Frontmatter is present and complete
- [ ] Examples and references included
- [ ] Anti-patterns and exclusions are explicit
- [ ] Integration references are included
- [ ] `.github/custom-instructions.md` updated
- [ ] AGENTS.md and agent.md updated if agent created
- [ ] Prompts.md and chatmodes.md updated if relevant
- [ ] Reviewed for clarity and enforceability

---

## Example Opening Paragraphs

- Shell script instructions:
  `You are a shell script developer. Follow our Bash standards to create and maintain automation scripts. Avoid complex dependencies, non-POSIX features, or undocumented options unless specified.`

- Documentation instructions:
  `You are a documentation contributor. Follow our markdown standards to create and maintain documentation for automation tools. Avoid technical jargon, missing headers, or outdated documentation unless specified.`

---

## Best Practices
- Always start with the required opening paragraph format.
- Be explicit about what is required, recommended, and prohibited.
- Use examples to illustrate correct and incorrect patterns.
- Reference related standards and instruction files.
- Update instructions when standards or workflows change.
- Place instruction files in `.github/instructions/` or a dedicated `instructions/` folder.
- Name prompt and chatmode files as `name.prompt.md` and `name.chatmode.md` respectively.
- Track changes and updates in the changelog field (for prompts, chatmodes, agents).
- Use the deprecated field and status to mark instructions as deprecated (where supported).
- Specify intended audience for each file (where supported).
- Include sample validation steps or test cases.
- Document rationale for major changes.
- Provide translation guidelines if needed.
- Ensure instructions are accessible and readable.
- Describe how to resolve instruction conflicts.
- Use the feedback field for improvement suggestions (where supported).
- Use status to indicate draft, approved, or deprecated (where supported).
- Document integration with CI/CD or review bots.
- Include security best practices and checks.
- Link to related standards and documentation.
- Provide ready-to-use templates for common types.
- Document impact of changes on workflows and automation.

---

Follow these instructions for all shell scripts, runner scripts, and Bats test files in the repository to ensure maintainability, coverage, and documentation quality. For further details, see [shell-script-header-and-docs.md](./shell-script-header-and-docs.md) and [shell-script-copilot.md](./shell-script-copilot.md).

Each instruction file should refer back to the main instructions [.github/custom-instructions.md](../custom-instructions.md).
