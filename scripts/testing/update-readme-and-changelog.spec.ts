import { test, expect } from '@playwright/test';
import { execSync } from 'child_process';
import fs from 'fs';

const scriptPath = '../maintenance/update-readme-and-changelog.sh';
const readmePath = '../../README.md';

// Utility to read README badges block
function getBadgesBlock(content: string) {
    const start = content.indexOf('<!-- BADGES-START -->');
    const end = content.indexOf('<!-- BADGES-END -->');
    return content.slice(start, end + '<!-- BADGES-END -->'.length);
}

// Utility to read Copilot/Agent Instructions Table block
function getInstructionsTableBlock(content: string) {
    const start = content.indexOf('<!-- INSTRUCTIONS-TABLE-START -->');
    const end = content.indexOf('<!-- INSTRUCTIONS-TABLE-END -->');
    return content.slice(start, end + '<!-- INSTRUCTIONS-TABLE-END -->'.length);
}

test.describe('update-readme-and-changelog.sh', () => {
    test('updates README badges block', async () => {
        // Backup README
        const originalReadme = fs.readFileSync(readmePath, 'utf8');

        // Run the script
        execSync(`bash ${scriptPath}`);

        // Read updated README
        const updatedReadme = fs.readFileSync(readmePath, 'utf8');
        const badgesBlock = getBadgesBlock(updatedReadme);

        // Check that badges block exists and contains workflow badge URLs
        expect(badgesBlock).toContain('https://github.com/lightspeedwp/scripts/actions/workflows/');
        expect(badgesBlock).toContain('badge.svg');

        // Restore README
        fs.writeFileSync(readmePath, originalReadme);
    });

    test('generates Copilot/Agent Instructions Table in README', async () => {
        // Backup README
        const originalReadme = fs.readFileSync(readmePath, 'utf8');

        // Run the script
        execSync(`bash ${scriptPath}`);

        // Read updated README
        const updatedReadme = fs.readFileSync(readmePath, 'utf8');
        const instructionsTableBlock = getInstructionsTableBlock(updatedReadme);

        // Check that instructions table block exists and contains expected files and descriptions
        expect(instructionsTableBlock).toContain('.github/copilot-instructions.md');
        expect(instructionsTableBlock).toContain('Main Copilot & CodeRabbit integration');
        expect(instructionsTableBlock).toContain('.github/prompts/prompts.md');
        expect(instructionsTableBlock).toContain('Reusable prompt templates');
        expect(instructionsTableBlock).toContain('.github/chatmodes/chatmodes.md');
        expect(instructionsTableBlock).toContain('Scenario-based chat modes');

        // Restore README
        fs.writeFileSync(readmePath, originalReadme);
    });

    test('script runs without error', async () => {
        expect(() => execSync(`bash ${scriptPath}`)).not.toThrow();
    });
});
