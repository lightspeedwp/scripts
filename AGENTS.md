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
- **Standards:** Aligned with org-wide-issue-types-v1-9.md and project templates
- **Functionality:**
    - Analyzes issue template metadata, content, title, and labels
    - Determines appropriate issue type using the standardized types (Bug, Feature, Task, Epic, Story, etc.)
    - Updates GitHub ProjectsV2 issue type field
    - Adds issues to relevant projects if not already added
- **Definition of Done:**
    - Correctly identifies all standard issue types per org-wide standards
    - Prioritizes template metadata over content analysis
    - Documents behavior in .github/docs/auto-issue-type.md
    - Integrates with PR and issue templates
    - Follows the standard branch naming conventions when modified

### label-standardization-agent

- **Purpose:** Enforces standardized labels across repositories, preventing redundant labels
- **Location:** .github/agents/label-standardization-agent.js
- **Integration:** GitHub Actions (.github/workflows/label-standardization.yml)
- **Usage:** Runs weekly and can be triggered manually via workflow_dispatch
- **Standards:** Aligned with org-wide-labels-v1-11.md and standard prefixes
- **Functionality:**
    - Detects non-standard labels with standard equivalents (e.g., "php" vs "lang:php")
    - Migrates issues/PRs from non-standard to standard labels
    - Removes redundant non-standard labels after migration
    - Supports dry-run mode for testing before applying changes
- **Definition of Done:**
    - Successfully standardizes all labels according to organization conventions
    - Properly migrates issues/PRs to use standard labels
    - Provides clear logging and summary reports
    - Integrates with existing label workflows
    - Documents behavior in .github/docs/label-standardization.md

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
