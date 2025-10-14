import { test, expect } from '@playwright/test';
import { execSync } from 'child_process';

const CLIENT_SCRIPT = './client-delivery-project.sh';
const PRODUCT_SCRIPT = './product-dev-project.sh';
const UPDATE_SCRIPT = './update-projects.sh';
const PROJECT_DIR = __dirname;

function runScript(script: string, args: string[] = [], env: Record<string, string> = {}) {
    const cmd = `${script} ${args.join(' ')}`;
    return execSync(cmd, {
        cwd: PROJECT_DIR,
        env: { ...process.env, ...env },
        encoding: 'utf-8',
    });
}

test.describe('Client Delivery Project Script', () => {
    test('shows usage with no arguments', async () => {
        const output = runScript(CLIENT_SCRIPT, []);
        expect(output).toMatch(/Usage:/);
    });

    test('creates project and all fields (dry-run)', async () => {
        const output = runScript(CLIENT_SCRIPT, ['TestClient', '123'], { DRY_RUN: 'true' });
        expect(output).toMatch(/Creating project/);
        expect(output).toMatch(/Creating field 'Theme'/);
        expect(output).toMatch(/Creating field 'Area'/);
        expect(output).toMatch(/Creating field 'Priority'/);
        expect(output).toMatch(/Creating field 'Severity'/);
        expect(output).toMatch(/Creating field 'Size'/);
        expect(output).toMatch(/Creating field 'Phase'/);
        expect(output).toMatch(/Creating field 'Release type'/);
        expect(output).toMatch(/Creating field 'Environment'/);
        expect(output).toMatch(/Creating field 'Status'/);
        expect(output).toMatch(/Creating number field 'Story Points'/);
        expect(output).toMatch(/Creating date field 'Due Date'/);
        expect(output).toMatch(/Creating text field 'Assignee'/);
        // Check color assignment and option descriptions
        expect(output).toMatch(/Setting color for Theme:Design System/);
        expect(output).toMatch(/Tokens, components, patterns/);
    });

    test('idempotency: does not recreate existing fields', async () => {
        // Simulate running twice, second run should say 'already exists'
        runScript(CLIENT_SCRIPT, ['TestClient', '123'], { DRY_RUN: 'true' });
        const output = runScript(CLIENT_SCRIPT, ['TestClient', '123'], { DRY_RUN: 'true' });
        expect(output).toMatch(/Field 'Theme' already exists/);
        expect(output).toMatch(/Field 'Area' already exists/);
    });

    test('supports environment variable overrides', async () => {
        const output = runScript(CLIENT_SCRIPT, ['TestClient', '123'], {
            ORG: 'customorg',
            DRY_RUN: 'true',
        });
        expect(output).toMatch(/under organisation 'customorg'/);
    });

    test('errors on missing client name', async () => {
        let error = '';
        try {
            runScript(CLIENT_SCRIPT, []);
        } catch (e) {
            error = String(e);
        }
        expect(error).toMatch(/Usage:/);
    });

    test('handles edge case: invalid color assignment', async () => {
        // Simulate color assignment failure (option id not found)
        // This is a stub: in real test, mock gh api to fail
        const output = runScript(CLIENT_SCRIPT, ['TestClient', '123'], {
            DRY_RUN: 'true',
            MOCK_COLOR_FAIL: 'true',
        });
        expect(output).toMatch(/color assignment skipped/);
    });

    test('helper function coverage: create_field', async () => {
        // Should create number, date, text fields
        const output = runScript(CLIENT_SCRIPT, ['TestClient', '123'], { DRY_RUN: 'true' });
        expect(output).toMatch(/Creating number field 'Story Points'/);
        expect(output).toMatch(/Creating date field 'Due Date'/);
        expect(output).toMatch(/Creating text field 'Assignee'/);
    });
});

test.describe('Product Dev Project Script', () => {
    test('shows usage with no arguments', async () => {
        const output = runScript(PRODUCT_SCRIPT, []);
        expect(output).toMatch(/Usage:/);
    });

    test('creates project and all fields (dry-run)', async () => {
        const output = runScript(PRODUCT_SCRIPT, ['TestProduct', '456'], { DRY_RUN: 'true' });
        expect(output).toMatch(/Creating project/);
        expect(output).toMatch(/Creating field 'Theme'/);
        expect(output).toMatch(/Creating field 'Area'/);
        expect(output).toMatch(/Creating field 'Priority'/);
        expect(output).toMatch(/Creating field 'Severity'/);
        expect(output).toMatch(/Creating field 'Size'/);
        expect(output).toMatch(/Creating field 'Phase'/);
        expect(output).toMatch(/Creating field 'Release type'/);
        expect(output).toMatch(/Creating field 'Environment'/);
        expect(output).toMatch(/Creating field 'Status'/);
        expect(output).toMatch(/Creating number field 'Story Points'/);
        expect(output).toMatch(/Creating date field 'Due Date'/);
        expect(output).toMatch(/Creating text field 'Assignee'/);
        // Check color assignment and option descriptions
        expect(output).toMatch(/Setting color for Theme:Design System/);
        expect(output).toMatch(/Tokens, components, patterns/);
    });

    test('idempotency: does not recreate existing fields', async () => {
        runScript(PRODUCT_SCRIPT, ['TestProduct', '456'], { DRY_RUN: 'true' });
        const output = runScript(PRODUCT_SCRIPT, ['TestProduct', '456'], { DRY_RUN: 'true' });
        expect(output).toMatch(/Field 'Theme' already exists/);
        expect(output).toMatch(/Field 'Area' already exists/);
    });

    test('supports environment variable overrides', async () => {
        const output = runScript(PRODUCT_SCRIPT, ['TestProduct', '456'], {
            ORG: 'customorg',
            DRY_RUN: 'true',
        });
        expect(output).toMatch(/under organisation 'customorg'/);
    });

    test('errors on missing product name', async () => {
        let error = '';
        try {
            runScript(PRODUCT_SCRIPT, []);
        } catch (e) {
            error = String(e);
        }
        expect(error).toMatch(/Usage:/);
    });

    test('handles edge case: invalid color assignment', async () => {
        // Simulate color assignment failure (option id not found)
        // This is a stub: in real test, mock gh api to fail
        const output = runScript(PRODUCT_SCRIPT, ['TestProduct', '456'], {
            DRY_RUN: 'true',
            MOCK_COLOR_FAIL: 'true',
        });
        expect(output).toMatch(/color assignment skipped/);
    });

    test('helper function coverage: create_field', async () => {
        const output = runScript(PRODUCT_SCRIPT, ['TestProduct', '456'], { DRY_RUN: 'true' });
        expect(output).toMatch(/Creating number field 'Story Points'/);
        expect(output).toMatch(/Creating date field 'Due Date'/);
        expect(output).toMatch(/Creating text field 'Assignee'/);
    });
});

test.describe('Update Projects Script', () => {
    test('shows help with --help', async () => {
        const output = runScript(UPDATE_SCRIPT, ['--help']);
        expect(output).toMatch(/Usage:/);
    });

    test('creates fields from CSV (dry-run)', async () => {
        const output = runScript(UPDATE_SCRIPT, [
            '--fields-file',
            'fixtures/client-delivery-fields.csv',
            '--dry-run',
        ]);
        expect(output).toMatch(/Processing fields from/);
        expect(output).toMatch(/Creating project field:/);
    });

    test('idempotency: does not recreate existing fields from CSV', async () => {
        runScript(UPDATE_SCRIPT, [
            '--fields-file',
            'fixtures/client-delivery-fields.csv',
            '--dry-run',
        ]);
        const output = runScript(UPDATE_SCRIPT, [
            '--fields-file',
            'fixtures/client-delivery-fields.csv',
            '--dry-run',
        ]);
        expect(output).toMatch(/already exists/);
    });

    test('supports environment variable overrides', async () => {
        const output = runScript(
            UPDATE_SCRIPT,
            ['--fields-file', 'fixtures/client-delivery-fields.csv', '--dry-run'],
            { PROJECT_OWNER: 'customorg' }
        );
        expect(output).toMatch(/customorg/);
    });

    test('errors on missing CSV', async () => {
        let error = '';
        try {
            runScript(UPDATE_SCRIPT, ['--fields-file', 'fixtures/nonexistent.csv', '--dry-run']);
        } catch (e) {
            error = String(e);
        }
        expect(error).toMatch(/not found/);
    });

    test('handles edge case: invalid field type', async () => {
        // Simulate invalid field type in CSV
        // This is a stub: in real test, mock CSV with bad type
        const output = runScript(
            UPDATE_SCRIPT,
            ['--fields-file', 'fixtures/additional-fields.csv', '--dry-run'],
            { MOCK_INVALID_TYPE: 'true' }
        );
        expect(output).toMatch(/Invalid field type/);
    });

    test('helper function coverage: create_project_field', async () => {
        const output = runScript(UPDATE_SCRIPT, [
            '--fields-file',
            'fixtures/client-delivery-fields.csv',
            '--dry-run',
        ]);
        expect(output).toMatch(/Creating project field:/);
    });
});
