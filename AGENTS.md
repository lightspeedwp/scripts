# Agents Directory & Registry

This repository currently does not include any dedicated agent implementations or an `./github/agents/` folder. All agent logic is handled via automation scripts, Copilot instructions, and workflow integrations documented elsewhere.

## Purpose

This file serves as a placeholder and registry for future agent implementations, including:
- Custom GitHub Copilot agents
- CodeRabbit review agents
- Workflow automation agents
- MCP server agents
- Any other AI or automation agents

## Current State

- **No agents are present in the root or `./github/agents/` directory.**
- All agent-related logic is managed via:
  - [Copilot instructions](.github/copilot-instructions.md)
  - [Custom instructions](.github/custom-instructions.md)
  - [Prompts](.github/prompts/prompts.md)
  - [Chat modes](.github/chatmodes/chatmodes.md)
  - [Automation scripts](scripts/)
  - [Workflows](.github/workflows/)

## How to Add Agents

1. Create a new folder: `./github/agents/`
2. Add agent implementation files (e.g., `copilot-agent.js`, `review-agent.py`)
3. Document each agent in this file:
   - Name
   - Purpose
   - Integration points
   - Usage instructions
   - Maintenance notes

## Example Entry (for future agents)

```markdown
### copilot-swe-agent
- **Purpose:** Automates code suggestions and review for SWE tasks
- **Location:** .github/agents/copilot-swe-agent.js
- **Integration:** GitHub Actions, Copilot Chat, CodeRabbit
- **Usage:** See README and workflow documentation
```

---

**Note:** Update this file whenever new agents are added or existing ones are modified.
