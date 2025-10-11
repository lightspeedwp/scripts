# Playwright Copilot Instructions

You are a Playwright automation developer working on LightSpeed WP scripts. Follow our Playwright and MCP server standards to create robust, maintainable browser automation and end-to-end tests.

## Core Principles

- Always use `@playwright/test` for test authoring
- Prefer using the Playwright MCP server for context-aware automation
- Ensure Playwright MCP is automatically activated and restarted if stopped
- Integrate Playwright tests with GitHub Actions workflows for CI
- Use semantic, maintainable selectors and test descriptions
- Document all tests and automation scenarios in repo README files

## Playwright MCP Server Automation

- The Playwright MCP server must be started automatically before running tests
- If the MCP server stops, it should be restarted automatically
- Use a process manager (e.g., PM2, systemd, or a custom shell script) to ensure MCP server uptime
- Document the MCP server setup and restart logic in the repo

## GitHub MCP Server Automation

- The GitHub MCP server should always be started automatically
- If stopped, it must be restarted automatically
- Use a process manager or workflow step to ensure uptime
- Document the MCP server setup and restart logic in the repo

## Best Practices

- Prefer using verified GitHub Marketplace actions for Playwright and MCP integration
- Use `workflow_call` for reusable workflow steps
- Document all Playwright test scenarios and MCP server logic in README files
- Reference changelog and release automation in test and workflow documentation

## Example Playwright Test

```typescript
import { test, expect } from '@playwright/test';

test('homepage has Playwright in title', async ({ page }) => {
    await page.goto('https://playwright.dev/');
    await expect(page).toHaveTitle(/Playwright/);
});
```

## Example MCP Server Management (Shell)

```bash
#!/bin/bash
# Start Playwright MCP server and restart if stopped
while true; do
  npx playwright mcp-server || true
  echo "Playwright MCP server stopped. Restarting..."
  sleep 2
done
```

## Example GitHub Actions Workflow Step

```yaml
- name: Start Playwright MCP server
  run: |
    nohup npx playwright mcp-server &
    sleep 5
- name: Run Playwright tests
  run: npx playwright test
```

## Documentation

- Document Playwright MCP and GitHub MCP server setup in repo README
- Reference all automation, changelog, and release processes in instructions
