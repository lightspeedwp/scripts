#!/usr/bin/env node
/**
 * ============================================================================
 * Script Name: labeling.agent.js
 * Description: Labeling Agent. Automatically applies, enforces, and manages org-wide label standards for issues and PRs. Integrates with project management and workflow automation.
 * Version: v1.0.0
 * Author: LightSpeed WP Team
 * Github Contributors: See repo history
 * Author URI: https://lightspeedwp.agency/
 * License: GPL v3 or later
 * License URI: https://www.gnu.org/licenses/gpl-3.0.html
 * Requirements: Node.js, @octokit/rest, @actions/core, @actions/github, path
 * Usage: Used in workflows: pr-labeller.yml, issue-labeler.yml, pr-labels-project-sync.yml, issue-labels-project-sync.yml
 * Environment Variables:
 *   - GITHUB_TOKEN: Required for API access
 *   - DRY_RUN: Set to "true" to preview without making changes
 *   - VERBOSE: Set to "true" for detailed logs
 *   - LABEL_CONFIG_PATH: Path to label configuration file (default: .github/labels.yml)
 *   - AUTO_REMOVE_INVALID: Set to "true" to automatically remove non-standard labels
 * Options: None (all configuration via env vars and workflow inputs)
 * Examples:
 *   - node .github/agents/labeling.agent.js
 *   - Used via GitHub Actions workflow
 * Notes:
 *   - Aligns with org-wide-labels-v1-12.md, label-automation-strategy-v1-1.md
 *   - See related script: manage-labels.sh
 *   - See related tests: test-manage-labels.bats, labeling.agent.test.js
 * ============================================================================
 */
const LABEL_FAMILIES = {
  lang: {
    prefix: 'lang:',
    description: 'Programming language or technology',
    color: '5319E7',
    labels: ['bash', 'js', 'php', 'python', 'css', 'html', 'typescript', 'yaml', 'json'],
  },
  priority: {
    prefix: 'priority:',
    description: 'Issue or PR priority level',
    color: 'D73A4A',
    labels: ['low', 'medium', 'high', 'critical', 'urgent'],
  },
  status: {
    prefix: 'status:',
    description: 'Current status or state',
    color: '0E8A16',
    labels: ['blocked', 'needs-review', 'needs-testing', 'work-in-progress', 'ready', 'on-hold'],
  },
  size: {
    prefix: 'size:',
    description: 'Estimated effort or complexity',
    color: 'FBCA04',
    labels: ['xs', 's', 'm', 'l', 'xl', 'xxl'],
  },
  type: {
    prefix: 'type:',
    description: 'Type of change or issue',
    color: 'B60205',
    labels: ['bug', 'feature', 'enhancement', 'refactor', 'documentation', 'chore', 'question'],
  },
};

// File path patterns for automatic labeling
const FILE_PATTERNS = {
  'area:ci': ['.github/workflows/**', '.github/actions/**', 'scripts/ci/**'],
  'area:documentation': ['*.md', 'docs/**', '.github/docs/**', 'README*'],
  'area:testing': ['tests/**', '**/*.test.js', '**/*.spec.js', '**/*.bats', 'test-*'],
  'area:security': ['**/*security*', '**/*auth*', 'SECURITY.md'],
  'area:dependencies': ['package*.json', 'requirements*.txt', 'Gemfile*', 'composer.json'],
  'lang:bash': ['**/*.sh', '**/*.bash'],
  'lang:js': ['**/*.js', '**/*.mjs', '**/*.jsx'],
  'lang:typescript': ['**/*.ts', '**/*.tsx'],
  'lang:python': ['**/*.py'],
  'lang:php': ['**/*.php'],
  'lang:css': ['**/*.css', '**/*.scss', '**/*.sass'],
  'lang:html': ['**/*.html', '**/*.htm'],
  'lang:yaml': ['**/*.yml', '**/*.yaml'],
  'lang:json': ['**/*.json'],
};

// Content-based labeling patterns
const CONTENT_PATTERNS = {
  'type:bug': [
    /\b(?:bug|error|issue|problem|broken|fail|crash|exception)\b/i,
    /\b(?:not working|doesn't work|stops working)\b/i,
    /\b(?:fix|resolve|correct|repair)\b/i,
  ],
  'type:feature': [
    /\b(?:feature|enhancement|improvement|add|new)\b/i,
    /\b(?:implement|create|build|develop)\b/i,
    /\b(?:request|proposal|suggestion)\b/i,
  ],
  'type:documentation': [
    /\b(?:documentation|docs|readme|guide|tutorial)\b/i,
    /\b(?:document|explain|clarify|describe)\b/i,
  ],
  'type:refactor': [
    /\b(?:refactor|restructure|reorganize|cleanup|clean up)\b/i,
    /\b(?:optimize|improve|simplify|modernize)\b/i,
  ],
  'priority:high': [
    /\b(?:urgent|critical|high priority|asap|blocking)\b/i,
    /\b(?:production|live|customer|client)\b/i,
  ],
  'priority:low': [
    /\b(?:low priority|nice to have|when time permits)\b/i,
    /\b(?:minor|cosmetic|polish)\b/i,
  ],
  'area:security': [
    /\b(?:security|vulnerability|exploit|attack|auth|authentication)\b/i,
    /\b(?:permission|access|credential|token|password)\b/i,
  ],
  'area:performance': [
    /\b(?:performance|speed|slow|optimization|bottleneck)\b/i,
    /\b(?:memory|cpu|load time|latency)\b/i,
  ],
};

// Config
const config = {
  dryRun: process.env.DRY_RUN === 'true',
  verbose: process.env.VERBOSE === 'true',
  token: process.env.GITHUB_TOKEN,
  labelConfigPath: process.env.LABEL_CONFIG_PATH || '.github/labels.yml',
  autoRemoveInvalid: process.env.AUTO_REMOVE_INVALID === 'true',
};

/**
 * Main function
 */
async function run() {
  try {
    if (!config.token) {
      throw new Error('GITHUB_TOKEN is required');
    }

    const octokit = new Octokit({ auth: config.token });
    const context = github.context;

    log('Starting labeling automation...');

    const labelingAction = determineLabelingAction(context);
    log(`Detected labeling action: ${labelingAction}`);

    switch (labelingAction) {
      case 'label_issue':
        await labelIssue(octokit, context);
        break;
      case 'label_pull_request':
        await labelPullRequest(octokit, context);
        break;
      case 'validate_labels':
        await validateRepositoryLabels(octokit, context);
        break;
      case 'sync_labels':
        await syncLabelsWithStandard(octokit, context);
        break;
      default:
        log('No labeling action required for this event');
    }

    log('Labeling automation completed successfully');

  } catch (error) {
    core.setFailed(`Error: ${error.message}`);
  }
}

/**
 * Determine what labeling action to take
 */
function determineLabelingAction(context) {
  const { eventName, payload } = context;

  if (eventName === 'issues' && ['opened', 'edited'].includes(payload.action)) {
    return 'label_issue';
  }

  if (eventName === 'pull_request' && ['opened', 'edited', 'synchronize'].includes(payload.action)) {
    return 'label_pull_request';
  }

  if (eventName === 'schedule' || (eventName === 'workflow_dispatch')) {
    return 'sync_labels';
  }

  if (eventName === 'push' && payload.ref === 'refs/heads/main') {
    return 'validate_labels';
  }

  return 'none';
}

/**
 * Automatically label an issue based on content and context
 */
async function labelIssue(octokit, context) {
  const issue = context.payload.issue;
  log(`Analyzing issue #${issue.number}: ${issue.title}`);

  const suggestedLabels = await analyzeIssueForLabels(issue);
  const currentLabels = issue.labels.map(label => label.name);

  // Filter out labels that are already applied
  const newLabels = suggestedLabels.filter(label => !currentLabels.includes(label));

  if (newLabels.length > 0) {
    await applyLabelsToIssue(octokit, context, issue.number, newLabels, 'issue');
  } else {
    log('No new labels to apply to issue');
  }

  // Generate labeling report
  await generateIssueLabelingReport(octokit, context, issue, suggestedLabels, currentLabels);
}

/**
 * Automatically label a pull request based on changes and context
 */
async function labelPullRequest(octokit, context) {
  const pr = context.payload.pull_request;
  log(`Analyzing PR #${pr.number}: ${pr.title}`);

  // Get changed files
  const { data: files } = await octokit.pulls.listFiles({
    owner: context.repo.owner,
    repo: context.repo.repo,
    pull_number: pr.number,
  });

  const suggestedLabels = await analyzePullRequestForLabels(pr, files);
  const currentLabels = pr.labels.map(label => label.name);

  // Filter out labels that are already applied
  const newLabels = suggestedLabels.filter(label => !currentLabels.includes(label));

  if (newLabels.length > 0) {
    await applyLabelsToIssue(octokit, context, pr.number, newLabels, 'pull_request');
  } else {
    log('No new labels to apply to pull request');
  }

  // Generate labeling report
  await generatePRLabelingReport(octokit, context, pr, suggestedLabels, currentLabels, files);
}

/**
 * Analyze issue content for appropriate labels
 */
async function analyzeIssueForLabels(issue) {
  const labels = new Set();

  const content = `${issue.title} ${issue.body || ''}`.toLowerCase();

  // Check content patterns
  for (const [label, patterns] of Object.entries(CONTENT_PATTERNS)) {
    if (patterns.some(pattern => pattern.test(content))) {
      labels.add(label);
    }
  }

  // Check for template-based labels
  if (issue.body) {
    const templateLabelMatch = issue.body.match(/(?:labels?|type):\s*([^\r\n]+)/i);
    if (templateLabelMatch) {
      const templateLabels = templateLabelMatch[1]
        .split(',')
        .map(l => l.trim().toLowerCase())
        .filter(l => l.length > 0);

      templateLabels.forEach(label => {
        // Try to map to standard labels
        const standardLabel = findStandardLabel(label);
        if (standardLabel) {
          labels.add(standardLabel);
        }
      });
    }
  }

  // Add default labels for issues
  if (!Array.from(labels).some(l => l.startsWith('type:'))) {
    labels.add('type:question'); // Default for issues without clear type
  }

  return Array.from(labels);
}

/**
 * Analyze pull request for appropriate labels
 */
async function analyzePullRequestForLabels(pr, files) {
  const labels = new Set();

  const content = `${pr.title} ${pr.body || ''}`.toLowerCase();

  // Check content patterns
  for (const [label, patterns] of Object.entries(CONTENT_PATTERNS)) {
    if (patterns.some(pattern => pattern.test(content))) {
      labels.add(label);
    }
  }

  // Check changed files for automatic labels
  const changedPaths = files.map(f => f.filename);

  for (const [label, patterns] of Object.entries(FILE_PATTERNS)) {
    if (patterns.some(pattern => {
      const glob = new RegExp(pattern.replace(/\*\*/g, '.*').replace(/\*/g, '[^/]*'));
      return changedPaths.some(path => glob.test(path));
    })) {
      labels.add(label);
    }
  }

  // Estimate size based on changes
  const totalChanges = files.reduce((sum, file) => sum + file.changes, 0);
  const sizeLabel = estimateChangeSize(totalChanges);
  if (sizeLabel) {
    labels.add(sizeLabel);
  }

  // Check for breaking changes
  if (content.includes('breaking') || content.includes('breaking change')) {
    labels.add('type:breaking-change');
  }

  // Add default type if none specified
  if (!Array.from(labels).some(l => l.startsWith('type:'))) {
    if (pr.draft) {
      labels.add('status:work-in-progress');
    } else {
      labels.add('type:enhancement'); // Default for PRs
    }
  }

  return Array.from(labels);
}

/**
 * Estimate change size based on line changes
 */
function estimateChangeSize(changes) {
  if (changes <= 10) return 'size:xs';
  if (changes <= 50) return 'size:s';
  if (changes <= 200) return 'size:m';
  if (changes <= 500) return 'size:l';
  if (changes <= 1000) return 'size:xl';
  return 'size:xxl';
}

/**
 * Find standard label for a given input
 */
function findStandardLabel(input) {
  const normalized = input.toLowerCase().trim();

  // Direct matches
  for (const [category, config] of Object.entries(LABEL_CATEGORIES)) {
    const fullLabel = `${config.prefix}${normalized}`;
    if (config.labels.includes(normalized)) {
      return fullLabel;
    }
  }

  // Fuzzy matches
  const mappings = {
    'javascript': 'lang:js',
    'typescript': 'lang:typescript',
    'shell': 'lang:bash',
    'docs': 'area:documentation',
    'doc': 'area:documentation',
    'test': 'area:testing',
    'tests': 'area:testing',
    'ci/cd': 'area:ci',
    'workflow': 'area:ci',
    'github-actions': 'area:ci',
    'bug': 'type:bug',
    'bugfix': 'type:bug',
    'feature': 'type:feature',
    'feat': 'type:feature',
    'enhancement': 'type:enhancement',
    'improve': 'type:enhancement',
    'improvement': 'type:enhancement',
    'fix': 'type:bug',
    'chore': 'type:chore',
    'refactor': 'type:refactor',
  };

  return mappings[normalized] || null;
}

/**
 * Apply labels to an issue or PR
 */
async function applyLabelsToIssue(octokit, context, issueNumber, labels, type) {
  if (config.dryRun) {
    log(`[DRY RUN] Would apply labels to ${type} #${issueNumber}: ${labels.join(', ')}`);
    return;
  }

  try {
    // Get current labels
    const { data: issue } = await octokit.issues.get({
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: issueNumber,
    });

    const currentLabels = issue.labels.map(label => label.name);
    const allLabels = [...new Set([...currentLabels, ...labels])];

    await octokit.issues.setLabels({
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: issueNumber,
      labels: allLabels,
    });

    log(`Applied labels to ${type} #${issueNumber}: ${labels.join(', ')}`);

  } catch (error) {
    log(`Error applying labels: ${error.message}`, 'error');
  }
}

/**
 * Validate repository labels against standards
 */
async function validateRepositoryLabels(octokit, context) {
  log('Validating repository labels...');

  const { data: repoLabels } = await octokit.issues.listLabelsForRepo({
    owner: context.repo.owner,
    repo: context.repo.repo,
    per_page: 100,
  });

  const validation = {
    standardLabels: [],
    nonStandardLabels: [],
    missingLabels: [],
    duplicateLabels: [],
  };

  // Check each existing label
  repoLabels.forEach(label => {
    if (isStandardLabel(label.name)) {
      validation.standardLabels.push(label);
    } else {
      validation.nonStandardLabels.push(label);
    }
  });

  // Check for missing standard labels
  const expectedLabels = generateExpectedLabels();
  const existingLabelNames = repoLabels.map(l => l.name);

  expectedLabels.forEach(expectedLabel => {
    if (!existingLabelNames.includes(expectedLabel.name)) {
      validation.missingLabels.push(expectedLabel);
    }
  });

  // Generate validation report
  await generateLabelValidationReport(octokit, context, validation);
}

/**
 * Check if a label follows standard conventions
 */
function isStandardLabel(labelName) {
  // Check if it matches any category pattern
  return Object.values(LABEL_CATEGORIES).some(category =>
    labelName.startsWith(category.prefix)
  ) || ['good first issue', 'help wanted', 'duplicate', 'invalid', 'wontfix'].includes(labelName);
}

/**
 * Generate expected standard labels
 */
function generateExpectedLabels() {
  const labels = [];

  Object.entries(LABEL_CATEGORIES).forEach(([categoryName, config]) => {
    config.labels.forEach(label => {
      labels.push({
        name: `${config.prefix}${label}`,
        color: config.color,
        description: `${config.description}: ${label}`,
      });
    });
  });

  // Add common GitHub labels
  labels.push(
    { name: 'good first issue', color: '7057FF', description: 'Good for newcomers' },
    { name: 'help wanted', color: '008672', description: 'Extra attention is needed' },
    { name: 'duplicate', color: 'CFD3D7', description: 'This issue or pull request already exists' },
    { name: 'invalid', color: 'E4E669', description: 'This doesn\'t seem right' },
    { name: 'wontfix', color: 'FFFFFF', description: 'This will not be worked on' },
  );

  return labels;
}

/**
 * Sync repository labels with standard set
 */
async function syncLabelsWithStandard(octokit, context) {
  log('Syncing labels with standard set...');

  if (config.dryRun) {
    log('[DRY RUN] Would sync repository labels with standard set');
    return;
  }

  const expectedLabels = generateExpectedLabels();

  try {
    // Create or update each expected label
    for (const label of expectedLabels) {
      try {
        await octokit.issues.createLabel({
          owner: context.repo.owner,
          repo: context.repo.repo,
          name: label.name,
          color: label.color,
          description: label.description,
        });
        log(`Created label: ${label.name}`);
      } catch (error) {
        if (error.status === 422) {
          // Label exists, update it
          try {
            await octokit.issues.updateLabel({
              owner: context.repo.owner,
              repo: context.repo.repo,
              name: label.name,
              color: label.color,
              description: label.description,
            });
            log(`Updated label: ${label.name}`);
          } catch (updateError) {
            log(`Error updating label ${label.name}: ${updateError.message}`, 'warning');
          }
        } else {
          log(`Error creating label ${label.name}: ${error.message}`, 'warning');
        }
      }
    }

    log('Label synchronization completed');

  } catch (error) {
    log(`Error syncing labels: ${error.message}`, 'error');
  }
}

/**
 * Generate issue labeling report
 */
async function generateIssueLabelingReport(octokit, context, issue, suggestedLabels, currentLabels) {
  const newLabels = suggestedLabels.filter(label => !currentLabels.includes(label));

  if (newLabels.length === 0 && config.verbose) {
    return; // No report needed if no new labels
  }

  let reportContent = `## 🏷️ Auto-Labeling Report - Issue #${issue.number}

### Labels Applied:`;

  if (newLabels.length > 0) {
    reportContent += `\n${newLabels.map(label => `- \`${label}\``).join('\n')}`;
  } else {
    reportContent += `\n*No new labels applied - issue already has appropriate labels*`;
  }

  if (suggestedLabels.length > newLabels.length) {
    const existingRelevant = suggestedLabels.filter(label => currentLabels.includes(label));
    reportContent += `\n\n### Existing Relevant Labels:`;
    reportContent += `\n${existingRelevant.map(label => `- \`${label}\``).join('\n')}`;
  }

  reportContent += `\n\n*Labels are automatically applied based on issue content and our [labeling standards](/.github/instructions/labeling-standards.md).*`;

  // Post report if there are new labels or verbose mode
  if ((newLabels.length > 0 || config.verbose) && !config.dryRun) {
    try {
      await octokit.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: issue.number,
        body: reportContent,
      });
      log(`Posted labeling report for issue #${issue.number}`);
    } catch (error) {
      log(`Error posting report: ${error.message}`, 'error');
    }
  }
}

/**
 * Generate pull request labeling report
 */
async function generatePRLabelingReport(octokit, context, pr, suggestedLabels, currentLabels, files) {
  const newLabels = suggestedLabels.filter(label => !currentLabels.includes(label));

  if (newLabels.length === 0 && !config.verbose) {
    return; // No report needed if no new labels
  }

  const changedFiles = files.slice(0, 10); // Limit to first 10 files
  const totalChanges = files.reduce((sum, file) => sum + file.changes, 0);

  let reportContent = `## 🏷️ Auto-Labeling Report - PR #${pr.number}

### Labels Applied:`;

  if (newLabels.length > 0) {
    reportContent += `\n${newLabels.map(label => `- \`${label}\``).join('\n')}`;
  } else {
    reportContent += `\n*No new labels applied - PR already has appropriate labels*`;
  }

  reportContent += `\n\n### Analysis Summary:`;
  reportContent += `\n- **Files changed:** ${files.length}`;
  reportContent += `\n- **Total changes:** ${totalChanges} lines`;

  if (changedFiles.length > 0) {
    reportContent += `\n- **Key files:**`;
    changedFiles.forEach(file => {
      reportContent += `\n  - \`${file.filename}\` (+${file.additions} -${file.deletions})`;
    });

    if (files.length > 10) {
      reportContent += `\n  - *...and ${files.length - 10} more files*`;
    }
  }

  reportContent += `\n\n*Labels are automatically applied based on changed files, PR content, and our [labeling standards](/.github/instructions/labeling-standards.md).*`;

  // Post report if there are new labels or verbose mode
  if ((newLabels.length > 0 || config.verbose) && !config.dryRun) {
    try {
      await octokit.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: pr.number,
        body: reportContent,
      });
      log(`Posted labeling report for PR #${pr.number}`);
    } catch (error) {
      log(`Error posting report: ${error.message}`, 'error');
    }
  }
}

/**
 * Generate label validation report
 */
async function generateLabelValidationReport(octokit, context, validation) {
  const totalLabels = validation.standardLabels.length + validation.nonStandardLabels.length;
  const standardPercentage = Math.round((validation.standardLabels.length / totalLabels) * 100);

  const statusEmoji = validation.nonStandardLabels.length === 0 ? '✅' : '⚠️';

  let reportContent = `## 🏷️ Label Validation Report

${statusEmoji} **Label Standards Compliance: ${standardPercentage}%**

### Summary:
- ✅ **Standard labels:** ${validation.standardLabels.length}
- ${validation.nonStandardLabels.length === 0 ? '✅' : '⚠️'} **Non-standard labels:** ${validation.nonStandardLabels.length}
- ${validation.missingLabels.length === 0 ? '✅' : 'ℹ️'} **Missing recommended labels:** ${validation.missingLabels.length}`;

  if (validation.nonStandardLabels.length > 0) {
    reportContent += `\n\n### ⚠️ Non-Standard Labels:`;
    validation.nonStandardLabels.slice(0, 10).forEach(label => {
      const suggestion = findStandardLabel(label.name);
      reportContent += `\n- \`${label.name}\`${suggestion ? ` → Consider: \`${suggestion}\`` : ''}`;
    });

    if (validation.nonStandardLabels.length > 10) {
      reportContent += `\n- *...and ${validation.nonStandardLabels.length - 10} more*`;
    }
  }

  if (validation.missingLabels.length > 0) {
    reportContent += `\n\n### ℹ️ Missing Recommended Labels:`;
    validation.missingLabels.slice(0, 10).forEach(label => {
      reportContent += `\n- \`${label.name}\` - ${label.description}`;
    });

    if (validation.missingLabels.length > 10) {
      reportContent += `\n- *...and ${validation.missingLabels.length - 10} more*`;
    }
  }

  if (validation.nonStandardLabels.length === 0 && validation.missingLabels.length === 0) {
    reportContent += `\n\n🎉 **All labels follow LightSpeed standards!**`;
  }

  reportContent += `\n\n### Next Steps:`;
  if (validation.nonStandardLabels.length > 0) {
    reportContent += `\n1. Review non-standard labels and consider standardizing`;
    reportContent += `\n2. Use label standardization agent to migrate issues/PRs`;
  }
  if (validation.missingLabels.length > 0) {
    reportContent += `\n3. Add missing recommended labels to improve categorization`;
  }

  reportContent += `\n\nSee our [Labeling Standards](/.github/instructions/labeling-standards.md) for complete guidelines.`;

  log('Label validation completed');
  if (config.verbose) {
    log(reportContent);
  }
}

/**
 * Logging helper
 */
function log(message, level = 'info') {
  if (level === 'info') {
    if (config.verbose || !message.startsWith('[DRY RUN]')) {
      console.log(message);
      if (core.info) core.info(message);
    }
  } else if (level === 'error') {
    console.error(message);
    if (core.error) core.error(message);
  } else if (level === 'warning') {
    console.warn(message);
    if (core.warning) core.warning(message);
  }
}

// Execute if run directly
if (require.main === module) {
  run();
}

module.exports = {
  run,
  analyzeIssueForLabels,
  analyzePullRequestForLabels,
  LABEL_CATEGORIES,
  FILE_PATTERNS,
};
