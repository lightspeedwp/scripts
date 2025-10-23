# Agent Template

Use this template to document and implement new agents in the `.github/agents/` directory.

---

## Agent Name

- **Purpose:** Briefly describe what this agent does and its role in the automation ecosystem.
- **Location:** `.github/agents/agent-name.js` (or `.py`, `.sh`, etc.)
- **Integration Points:** List workflows, scripts, or systems this agent interacts with (e.g., Copilot, CodeRabbit, GitHub Actions).
- **Usage Instructions:**
    - How to invoke or configure the agent
    - Required environment variables or secrets
    - Example usage or workflow snippet
- **Maintenance Notes:**
    - How to update, test, or extend the agent
    - Known limitations or troubleshooting tips

---

## Example Entry

### copilot-swe-agent

- **Purpose:** Automates code suggestions and review for SWE tasks
- **Location:** `.github/agents/copilot-swe-agent.js`
- **Integration:** GitHub Actions, Copilot Chat, CodeRabbit
- **Usage:** See README and workflow documentation

---

## Implementation Checklist

- [ ] Document agent purpose and integration points
- [ ] Add usage instructions and configuration details
- [ ] Provide example invocation or workflow
- [ ] Note maintenance and troubleshooting steps
- [ ] Link to related documentation or standards
