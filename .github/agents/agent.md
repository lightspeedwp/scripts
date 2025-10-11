# Example Agent: copilot-swe-agent

- **Purpose:** Automates code suggestions and review for SWE (Software Engineering) tasks, integrating Copilot and CodeRabbit review automation.
- **Location:** `.github/agents/copilot-swe-agent.js` (future implementation)
- **Integration Points:**
  - GitHub Copilot Chat
  - CodeRabbit review workflows
  - GitHub Actions (for CI/CD automation)
- **Usage Instructions:**
  - Invoked automatically via workflow or manually via Copilot Chat
  - Requires access to Copilot and CodeRabbit APIs
  - Example workflow integration:
    ```yaml
    - name: Run Copilot SWE Agent
      run: node .github/agents/copilot-swe-agent.js
    ```
- **Maintenance Notes:**
  - Update agent logic as Copilot/CodeRabbit APIs evolve
  - Test integration with CI workflows and review automation
  - Document any limitations or troubleshooting steps in AGENTS.md

---

## Implementation Checklist

- [x] Document agent purpose and integration points
- [x] Add usage instructions and configuration details
- [ ] Provide example invocation or workflow
- [ ] Note maintenance and troubleshooting steps
- [ ] Link to related documentation or standards
