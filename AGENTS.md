# Agents Directory & Registry

This repository contains AI and automation agents to assist with GitHub project management and issue workflow automation.

## Purpose

This file serves as a registry for agent implementations in the repository, including:
- Custom GitHub Copilot agents
- Issue management automation agents
- Workflow automation agents
- MCP server agents
- Any other AI or automation agents

## Current Agents

### issue-type-agent

- **Purpose:** Automatically analyzes GitHub issues and assigns appropriate issue types in GitHub Projects
- **Location:** .github/agents/issue-type-agent.js
- **Integration:** GitHub Actions (.github/workflows/auto-issue-type.yml)
- **Usage:** Automatically runs when issues are opened or reopened
- **Functionality:**
  - Analyzes issue content, title, and labels
  - Determines appropriate issue type (Bug, Feature, Task, etc.)
  - Updates GitHub ProjectsV2 issue type field
  - Adds issues to relevant projects if not already added

## Additional Automation Logic

Additional agent-related logic is managed via:

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
