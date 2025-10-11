# Playwright Copilot & MCP Server Automation

This document describes the automation strategy for Playwright Copilot and MCP server integration in the LightSpeed WP scripts repository.

## Goals
- Ensure Playwright MCP and GitHub MCP servers are always running for reliable automation and testing.
- Automate server startup, restart, and health checks via workflow steps or process manager.
- Provide Copilot instructions for Playwright automation and MCP server management.
- Document setup, restart logic, and integration in README and instruction files.

## Implementation Overview

### 1. Playwright-Specific Copilot Instructions
- Add Copilot instructions for Playwright automation in `.github/instructions/playwright-copilot.md`.
- Include patterns for MCP server auto-activation, restart, and health checks.
- Document integration points with workflows and scripts.

### 2. MCP Server Automation Workflow
- Create a GitHub Actions workflow (`.github/workflows/playwright-mcp-server.yml`) to:
  - Start MCP server before Playwright tests.
  - Restart MCP server if not healthy.
  - Run Playwright tests against MCP endpoints.
  - Document workflow steps and error handling.

### 3. Server Startup & Health Scripts
- Add shell scripts to `scripts/utility/` for MCP server startup, restart, and health checks.
- Ensure scripts are idempotent and log status.
- Integrate with workflow and Copilot instructions.

### 4. Documentation
- Update `scripts/README.md` and workflow README to explain MCP server automation, setup, and integration.
- Include troubleshooting, restart logic, and workflow usage examples.

## Example Workflow Snippet
```yaml
jobs:
  mcp-server:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Start MCP server
        run: ./scripts/utility/start-mcp-server.sh
      - name: Health check MCP server
        run: ./scripts/utility/check-mcp-server-health.sh
      - name: Run Playwright tests
        run: npx playwright test
```

## Next Steps
- Implement and test automation scripts and workflow.
- Expand Copilot instructions for Playwright/MCP integration.
- Document all changes and update test coverage.
