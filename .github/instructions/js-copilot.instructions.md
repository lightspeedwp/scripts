# JavaScript/Node.js Copilot Instructions

You are a JavaScript developer. Follow our LightSpeed WP Node.js and GitHub Actions workflow standards to create and maintain automation scripts. Avoid heavy dependencies, hardcoded values, or undocumented options unless specified.

## Core Principles

### Script Structure

```javascript
#!/usr/bin/env node

/**
 * Script Name: script-name.js
 * Description: Brief description of functionality
 * Usage: node script-name.js [options] [arguments]
 * Dependencies: List required packages
 * Author: LightSpeed WP Team
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration
const config = {
    dryRun: process.env.DRY_RUN === 'true',
    verbose: process.env.VERBOSE === 'true',
};

async function main() {
    try {
        // Main logic here
        await processWorkflow();
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
}

// Execute if called directly
if (require.main === module) {
    main();
}

module.exports = { main };
```

### Error Handling

```javascript
class WorkflowError extends Error {
    constructor(message, code = 1) {
        super(message);
        this.name = 'WorkflowError';
        this.code = code;
    }
}

function handleError(error) {
    if (error instanceof WorkflowError) {
        console.error(`Workflow Error: ${error.message}`);
        process.exit(error.code);
    } else {
        console.error(`Unexpected Error: ${error.message}`);
        console.error(error.stack);
        process.exit(1);
    }
}
```

## GitHub Actions Integration

### Action Script Template

```javascript
const core = require('@actions/core');
const github = require('@actions/github');

async function run() {
    try {
        // Get inputs
        const token = core.getInput('github-token', { required: true });
        const repoName = core.getInput('repository');

        // Initialize Octokit
        const octokit = github.getOctokit(token);

        // Main logic
        const result = await processRepository(octokit, repoName);

        // Set outputs
        core.setOutput('result', JSON.stringify(result));
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
```

### Common GitHub API Patterns

```javascript
async function createPullRequest(octokit, owner, repo, data) {
    try {
        const response = await octokit.rest.pulls.create({
            owner,
            repo,
            title: data.title,
            body: data.body,
            head: data.head,
            base: data.base,
        });

        return response.data;
    } catch (error) {
        throw new WorkflowError(`Failed to create PR: ${error.message}`);
    }
}

async function updateLabels(octokit, owner, repo, labels) {
    const results = [];

    for (const label of labels) {
        try {
            await octokit.rest.issues.createLabel({
                owner,
                repo,
                name: label.name,
                color: label.color,
                description: label.description,
            });
            results.push({ name: label.name, status: 'created' });
        } catch (error) {
            if (error.status === 422) {
                // Label exists, update it
                await octokit.rest.issues.updateLabel({
                    owner,
                    repo,
                    name: label.name,
                    color: label.color,
                    description: label.description,
                });
                results.push({ name: label.name, status: 'updated' });
            } else {
                results.push({ name: label.name, status: 'failed', error: error.message });
            }
        }
    }

    return results;
}
```

## Configuration Management

### Environment Variables

```javascript
const config = {
    githubToken: process.env.GITHUB_TOKEN,
    orgName: process.env.ORG_NAME || 'lightspeedwp',
    dryRun: process.env.DRY_RUN === 'true',
    verbose: process.env.VERBOSE === 'true',
};

function validateConfig() {
    const required = ['githubToken'];

    for (const key of required) {
        if (!config[key]) {
            throw new WorkflowError(`Missing required environment variable: ${key.toUpperCase()}`);
        }
    }
}
```

### Command Line Arguments

```javascript
const { program } = require('commander');

program
    .name('workflow-script')
    .description('LightSpeed WP workflow automation')
    .version('1.0.0')
    .option('-d, --dry-run', 'preview changes without executing')
    .option('-v, --verbose', 'show detailed output')
    .option('-c, --config <path>', 'configuration file path')
    .parse();

const options = program.opts();
```

## File Operations

### Safe File Handling

```javascript
const fs = require('fs').promises;
const path = require('path');

async function readJsonFile(filePath) {
    try {
        const content = await fs.readFile(filePath, 'utf8');
        return JSON.parse(content);
    } catch (error) {
        if (error.code === 'ENOENT') {
            throw new WorkflowError(`File not found: ${filePath}`);
        }
        throw new WorkflowError(`Failed to read ${filePath}: ${error.message}`);
    }
}

async function writeJsonFile(filePath, data) {
    try {
        const dir = path.dirname(filePath);
        await fs.mkdir(dir, { recursive: true });

        const content = JSON.stringify(data, null, 2);
        await fs.writeFile(filePath, content, 'utf8');

        console.log(`Written: ${filePath}`);
    } catch (error) {
        throw new WorkflowError(`Failed to write ${filePath}: ${error.message}`);
    }
}
```

### Backup Operations

```javascript
async function createBackup(filePath) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupPath = `${filePath}.backup.${timestamp}`;

    try {
        await fs.copyFile(filePath, backupPath);
        console.log(`Backup created: ${backupPath}`);
        return backupPath;
    } catch (error) {
        throw new WorkflowError(`Failed to create backup: ${error.message}`);
    }
}
```

## Testing Patterns

### Unit Tests (Jest)

```javascript
// tests/workflow-script.test.js
const { main } = require('../workflow-script');

describe('Workflow Script', () => {
    beforeEach(() => {
        // Setup test environment
        process.env.DRY_RUN = 'true';
    });

    afterEach(() => {
        // Cleanup
        delete process.env.DRY_RUN;
    });

    test('handles missing configuration gracefully', async () => {
        delete process.env.GITHUB_TOKEN;

        await expect(main()).rejects.toThrow('Missing required environment variable');
    });

    test('processes valid input correctly', async () => {
        process.env.GITHUB_TOKEN = 'fake-token';

        const result = await main();
        expect(result).toBeDefined();
    });
});
```

### GitHub Actions Testing

```javascript
// Mock GitHub API responses
const mockOctokit = {
    rest: {
        repos: {
            get: jest.fn().mockResolvedValue({
                data: { name: 'test-repo' },
            }),
        },
    },
};

test('creates pull request successfully', async () => {
    const result = await createPullRequest(mockOctokit, 'owner', 'repo', {
        title: 'Test PR',
        body: 'Test description',
        head: 'feature-branch',
        base: 'main',
    });

    expect(result).toBeDefined();
});
```

## Logging and Monitoring

### Structured Logging

```javascript
class Logger {
    static info(message, data = {}) {
        console.log(
            JSON.stringify({
                level: 'info',
                message,
                timestamp: new Date().toISOString(),
                ...data,
            })
        );
    }

    static error(message, error = null) {
        console.error(
            JSON.stringify({
                level: 'error',
                message,
                timestamp: new Date().toISOString(),
                error: error ? error.message : null,
                stack: error ? error.stack : null,
            })
        );
    }
}
```

### Progress Reporting

```javascript
function createProgressBar(total, label = 'Processing') {
    let current = 0;

    return {
        increment() {
            current++;
            const percentage = Math.round((current / total) * 100);
            process.stdout.write(`\r${label}: ${current}/${total} (${percentage}%)`);

            if (current === total) {
                process.stdout.write('\n');
            }
        },
    };
}
```

## Performance Considerations

### Batch Operations

```javascript
async function processBatch(items, batchSize = 10, processor) {
    const results = [];

    for (let i = 0; i < items.length; i += batchSize) {
        const batch = items.slice(i, i + batchSize);
        const batchResults = await Promise.all(batch.map((item) => processor(item)));
        results.push(...batchResults);

        // Rate limiting pause
        if (i + batchSize < items.length) {
            await new Promise((resolve) => setTimeout(resolve, 1000));
        }
    }

    return results;
}
```

### Caching

```javascript
class SimpleCache {
    constructor(ttlMs = 300000) {
        // 5 minutes default
        this.cache = new Map();
        this.ttl = ttlMs;
    }

    set(key, value) {
        this.cache.set(key, {
            value,
            expires: Date.now() + this.ttl,
        });
    }

    get(key) {
        const item = this.cache.get(key);

        if (!item || Date.now() > item.expires) {
            this.cache.delete(key);
            return null;
        }

        return item.value;
    }
}
```

## Integration with LightSpeed Workflow

### Package.json Template

```json
{
    "name": "lightspeed-automation-script",
    "version": "1.0.0",
    "description": "LightSpeed WP automation script",
    "main": "index.js",
    "scripts": {
        "test": "jest",
        "lint": "eslint .",
        "start": "node index.js"
    },
    "dependencies": {
        "@actions/core": "^1.10.0",
        "@actions/github": "^5.1.1"
    },
    "devDependencies": {
        "jest": "^29.0.0",
        "eslint": "^8.0.0"
    }
}
```
