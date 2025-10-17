
---
applyTo: '**'
description: 'Prompt for workflow documentation integration with automation and CI/CD.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['workflow', 'documentation', 'automation', 'ci-cd']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Workflow Documentation Integration with Automation

## Role

You are a workflow automation documentation specialist. Follow our LightSpeed WP GitHub Actions standards to integrate comprehensive documentation with automated workflow processes.

## Purpose

Define systematic approaches for automatically generating, updating, and maintaining workflow documentation through CI/CD automation and intelligent documentation generation agents.

## Checklist

- [ ] Implement automated workflow documentation generation
- [ ] Create documentation update triggers based on code changes
- [ ] Establish documentation validation and quality gates
- [ ] Define documentation versioning and change tracking
- [ ] Integrate documentation with release management processes
- [ ] Create documentation testing and validation procedures

## Instructions

### Automated Documentation Architecture

#### Documentation Generation Pipeline

**Trigger Mechanisms**
- Workflow file changes in `.github/workflows/`
- Script modifications in `scripts/` directories
- Agent updates in `.github/agents/`
- Release tag creation and version updates
- Manual documentation refresh requests

**Generation Components**
- Workflow metadata extraction
- Script header parsing and analysis
- Agent capability documentation
- Cross-reference validation and linking
- Markdown formatting and validation

**Output Targets**
- README files for workflow directories
- Agent capability matrices
- Script usage documentation
- Integration flow diagrams
- Release notes and changelogs

#### Workflow Documentation Standards

**Workflow File Documentation Requirements**

Every GitHub Actions workflow must include:

```yaml
# .github/workflows/example-workflow.yml
name: Example Workflow
on:
  push:
    branches: [main]
  workflow_dispatch:

# Workflow metadata for documentation generation
# Description: Automated workflow for example processing
# Triggers: Push to main branch, manual dispatch
# Dependencies: Node.js, shell scripts, GitHub CLI
# Outputs: Processed files, test results, status reports
# Maintenance: Weekly dependency updates, monthly review
# Owner: DevOps Team <devops@lightspeedwp.agency>

jobs:
  example:
    name: Example Processing Job
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      # Step documentation inline
      - name: Process Files
        run: |
          # Execute file processing with logging
          ./scripts/utility/process-files.sh --verbose --log-file "logs/process-files.log"
```

**Documentation Generation from Workflows**

```bash
# Extract workflow documentation
extract_workflow_docs() {
    local workflow_file="$1"
    local output_file="$2"

    # Parse workflow metadata
    local workflow_name=$(yq eval '.name' "$workflow_file")
    local description=$(grep -E '^# Description:' "$workflow_file" | sed 's/^# Description: //')
    local triggers=$(yq eval '.on | keys | .[]' "$workflow_file" | tr '\n' ', ' | sed 's/,$//')

    # Generate documentation
    cat > "$output_file" << EOF
# ${workflow_name}

## Overview
${description}

## Triggers
- ${triggers}

## Jobs
$(yq eval '.jobs | keys | .[]' "$workflow_file" | while read job; do
    echo "- **$job**: $(yq eval ".jobs.\"$job\".name" "$workflow_file")"
done)

## Dependencies
$(extract_workflow_dependencies "$workflow_file")

## Usage
\`\`\`yaml
$(cat "$workflow_file")
\`\`\`
EOF
}
```

### Automated Documentation Update Workflows

#### Documentation Refresh Workflow

```yaml
# .github/workflows/update-documentation.yml
name: Update Documentation
on:
  push:
    paths:
      - 'scripts/**/*.sh'
      - '.github/workflows/*.yml'
      - '.github/agents/*.js'
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM
  workflow_dispatch:

jobs:
  update-docs:
    name: Update All Documentation
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install Dependencies
        run: npm install

      - name: Generate Script Documentation
        run: |
          ./scripts/maintenance/generate-script-docs.sh \
            --output-dir docs/scripts/ \
            --format markdown \
            --include-examples true

      - name: Generate Workflow Documentation
        run: |
          node .github/agents/workflow-docs-generator.agent.js \
            --workflows-dir .github/workflows/ \
            --output-dir docs/workflows/ \
            --format markdown

      - name: Generate Agent Documentation
        run: |
          node .github/agents/agent-docs-generator.agent.js \
            --agents-dir .github/agents/ \
            --output-dir docs/agents/ \
            --include-integration-examples true

      - name: Validate Documentation
        run: |
          npm run lint:md docs/
          ./scripts/utility/validate-doc-links.sh docs/

      - name: Update Cross-References
        run: |
          ./scripts/maintenance/update-doc-references.sh \
            --base-dir docs/ \
            --check-external-links false \
            --fix-broken-links true

      - name: Commit Documentation Updates
        uses: stefanzweifel/git-auto-commit-action@v4
        with:
          commit_message: 'docs: Auto-update documentation [skip ci]'
          file_pattern: 'docs/ README.md AGENTS.md'
          commit_user_name: 'github-actions[bot]'
          commit_user_email: 'github-actions[bot]@users.noreply.github.com'
```

#### Release Documentation Integration

```yaml
# .github/workflows/release-docs.yml
name: Release Documentation
on:
  release:
    types: [published]

jobs:
  release-docs:
    name: Generate Release Documentation
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Generate Release Notes
        run: |
          # Extract release information
          RELEASE_TAG="${{ github.event.release.tag_name }}"
          RELEASE_NOTES="${{ github.event.release.body }}"

          # Generate comprehensive release documentation
          ./scripts/maintenance/generate-release-docs.sh \
            --version "$RELEASE_TAG" \
            --notes "$RELEASE_NOTES" \
            --output-dir "docs/releases/" \
            --include-migration-guide true

      - name: Update Version Documentation
        run: |
          # Update version references across documentation
          ./scripts/maintenance/update-version-docs.sh \
            --new-version "${{ github.event.release.tag_name }}" \
            --docs-dir docs/ \
            --update-examples true
```

### Documentation Quality Assurance

#### Automated Documentation Testing

**Documentation Validation Pipeline**

```bash
# Comprehensive documentation validation
validate_documentation() {
    local docs_dir="$1"
    local validation_config="$2"

    log_info "Starting documentation validation for: $docs_dir"

    # Markdown linting
    if ! npx markdownlint "$docs_dir/**/*.md" --config "$validation_config/markdownlint.json"; then
        log_error "Markdown linting failed"
        return 1
    fi

    # Link validation
    if ! ./scripts/utility/validate-doc-links.sh "$docs_dir" --check-external true; then
        log_error "Link validation failed"
        return 1
    fi

    # Content completeness check
    if ! node .github/agents/docs-completeness-checker.agent.js --docs-dir "$docs_dir"; then
        log_error "Documentation completeness check failed"
        return 1
    fi

    # Cross-reference validation
    if ! ./scripts/utility/validate-cross-references.sh "$docs_dir"; then
        log_error "Cross-reference validation failed"
        return 1
    fi

    log_success "Documentation validation completed successfully"
    return 0
}
```

**Documentation Coverage Analysis**

```bash
# Analyze documentation coverage
analyze_doc_coverage() {
    local scripts_dir="$1"
    local docs_dir="$2"

    local total_scripts=0
    local documented_scripts=0
    local coverage_report="$docs_dir/coverage-report.md"

    # Count total scripts
    total_scripts=$(find "$scripts_dir" -name "*.sh" | wc -l)

    # Check documentation coverage
    while IFS= read -r script_file; do
        local script_name=$(basename "$script_file" .sh)
        local doc_file="$docs_dir/scripts/$script_name.md"

        if [[ -f "$doc_file" ]]; then
            ((documented_scripts++))
        else
            log_warning "Missing documentation for: $script_file"
        fi
    done < <(find "$scripts_dir" -name "*.sh")

    # Calculate coverage percentage
    local coverage_percent=$(echo "scale=2; $documented_scripts * 100 / $total_scripts" | bc)

    # Generate coverage report
    cat > "$coverage_report" << EOF
# Documentation Coverage Report

## Summary
- Total Scripts: $total_scripts
- Documented Scripts: $documented_scripts
- Coverage: ${coverage_percent}%

## Coverage Requirements
- Minimum Coverage: 90%
- Current Status: $([ $(echo "$coverage_percent >= 90" | bc) -eq 1 ] && echo "✅ PASSED" || echo "❌ FAILED")

## Missing Documentation
$(find "$scripts_dir" -name "*.sh" | while read script; do
    script_name=$(basename "$script" .sh)
    doc_file="$docs_dir/scripts/$script_name.md"
    [[ ! -f "$doc_file" ]] && echo "- $script"
done)
EOF

    log_info "Documentation coverage: ${coverage_percent}% ($documented_scripts/$total_scripts)"

    if [[ $(echo "$coverage_percent >= 90" | bc) -eq 1 ]]; then
        return 0
    else
        return 1
    fi
}
```

### Documentation Integration Agents

#### Workflow Documentation Generator Agent

```javascript
// .github/agents/workflow-docs-generator.agent.js
const fs = require('fs').promises;
const path = require('path');
const yaml = require('yaml');

class WorkflowDocsGenerator {
    constructor(config) {
        this.workflowsDir = config.workflowsDir;
        this.outputDir = config.outputDir;
        this.format = config.format || 'markdown';
    }

    async generateAllDocs() {
        const workflowFiles = await this.discoverWorkflows();
        const docs = [];

        for (const workflowFile of workflowFiles) {
            const doc = await this.generateWorkflowDoc(workflowFile);
            docs.push(doc);
        }

        await this.writeDocumentation(docs);
        await this.generateIndex(docs);

        return docs;
    }

    async generateWorkflowDoc(workflowFile) {
        const content = await fs.readFile(workflowFile, 'utf8');
        const workflow = yaml.parse(content);
        const metadata = this.extractMetadata(content);

        return {
            name: workflow.name,
            file: workflowFile,
            description: metadata.description,
            triggers: this.extractTriggers(workflow.on),
            jobs: this.extractJobs(workflow.jobs),
            dependencies: metadata.dependencies,
            owner: metadata.owner
        };
    }
}
```

#### Documentation Completeness Checker Agent

```javascript
// .github/agents/docs-completeness-checker.agent.js
class DocsCompletenessChecker {
    constructor(config) {
        this.docsDir = config.docsDir;
        this.requirements = config.requirements || this.getDefaultRequirements();
    }

    async checkCompleteness() {
        const results = {
            passed: true,
            issues: [],
            coverage: {}
        };

        // Check script documentation coverage
        const scriptsCoverage = await this.checkScriptsCoverage();
        results.coverage.scripts = scriptsCoverage;

        // Check workflow documentation coverage
        const workflowsCoverage = await this.checkWorkflowsCoverage();
        results.coverage.workflows = workflowsCoverage;

        // Check agent documentation coverage
        const agentsCoverage = await this.checkAgentsCoverage();
        results.coverage.agents = agentsCoverage;

        // Validate cross-references
        const crossRefResults = await this.validateCrossReferences();
        results.crossReferences = crossRefResults;

        // Determine overall pass/fail
        results.passed = this.evaluateResults(results);

        return results;
    }
}
```

### Documentation Maintenance Automation

#### Scheduled Documentation Updates

```bash
# Scheduled documentation maintenance
maintain_documentation() {
    local maintenance_type="$1"
    local config_file="$2"

    case "$maintenance_type" in
        "weekly")
            # Weekly maintenance tasks
            update_cross_references
            validate_external_links
            check_documentation_coverage
            generate_metrics_report
            ;;
        "monthly")
            # Monthly maintenance tasks
            full_documentation_audit
            update_documentation_templates
            review_documentation_standards
            archive_outdated_documentation
            ;;
        "release")
            # Release-specific maintenance
            update_version_references
            generate_release_documentation
            validate_migration_guides
            update_api_documentation
            ;;
    esac
}
```

#### Documentation Metrics and Reporting

```bash
# Generate documentation metrics
generate_doc_metrics() {
    local output_file="$1"

    # Collect metrics
    local total_docs=$(find docs/ -name "*.md" | wc -l)
    local last_update=$(git log -1 --format="%ai" -- docs/)
    local contributors=$(git log --format="%an" -- docs/ | sort -u | wc -l)
    local word_count=$(find docs/ -name "*.md" -exec wc -w {} + | tail -1 | awk '{print $1}')

    # Generate report
    cat > "$output_file" << EOF
# Documentation Metrics Report

Generated: $(date)

## Overview
- Total Documentation Files: $total_docs
- Total Word Count: $word_count
- Last Updated: $last_update
- Contributors: $contributors

## Coverage Analysis
$(analyze_doc_coverage scripts/ docs/)

## Quality Metrics
- Markdown Linting: $(npm run lint:md docs/ > /dev/null 2>&1 && echo "✅ PASSED" || echo "❌ FAILED")
- Link Validation: $(validate_doc_links docs/ > /dev/null 2>&1 && echo "✅ PASSED" || echo "❌ FAILED")
- Cross-Reference Check: $(validate_cross_references docs/ > /dev/null 2>&1 && echo "✅ PASSED" || echo "❌ FAILED")

## Recommendations
$(generate_doc_recommendations)
EOF
}
```

## System Constraints

- Documentation generation must not break existing workflows
- All generated documentation must pass markdown linting
- Documentation updates must preserve manual edits
- Automated processes must handle merge conflicts gracefully
- Documentation must remain accessible and searchable

## Example First Message to Copilot

```
Implement automated documentation generation for workflows, scripts, and agents. Create CI/CD integration for documentation updates, validation pipelines, and quality assurance. Ensure documentation stays current with code changes through intelligent automation.
```

## Verification Steps

- [ ] Documentation generation workflows are functional
- [ ] Generated documentation passes all quality checks
- [ ] Cross-references are maintained automatically
- [ ] Documentation coverage meets minimum requirements
- [ ] Release documentation is generated correctly
- [ ] Maintenance automation runs without errors

## References

- [GitHub Actions CI/CD Best Practices](../.github/instructions/github-actions-ci-cd-best-practices.instructions.md)
- [Documentation Standards](../.github/instructions/documentation-standards.instructions.md)
- [Agent Integration with Scripts](./agent-integration-with-scripts.md)

## Closing Statement

Automated documentation integration ensures comprehensive, accurate, and up-to-date documentation that evolves with the codebase while maintaining high quality standards through continuous validation and improvement processes.
