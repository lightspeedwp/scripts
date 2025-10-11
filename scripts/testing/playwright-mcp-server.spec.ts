import { test, expect } from '@playwright/test';

test.describe('MCP Server Automation', () => {
    test('MCP server health endpoint returns healthy', async ({ request }) => {
        const response = await request.get('http://localhost:3000/health');
        expect(response.ok()).toBeTruthy();
        const body = await response.text();
        expect(body).toContain('healthy');
    });
});
