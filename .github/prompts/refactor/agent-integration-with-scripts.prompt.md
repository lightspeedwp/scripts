---
applyTo: '**'
description: 'Prompt for agent integration patterns with shell scripts.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['agent', 'integration', 'automation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Agent Integration with Scripts Documentation

## Role

You are an AI automation integration specialist. Follow our LightSpeed WP agent framework to document integration patterns between shell scripts and AI automation agents.

## Purpose

Define comprehensive integration strategies for connecting shell scripts with AI agents to enable automated code review, testing, documentation generation, and workflow orchestration.

## Checklist

- [ ] Document agent integration patterns for shell script automation
- [ ] Define agent trigger mechanisms and event handling
- [ ] Create agent communication protocols with scripts
- [ ] Establish agent testing and validation procedures
- [ ] Define agent configuration management and deployment strategies
- [ ] Document agent monitoring and error handling approaches

## Instructions

### Agent Integration Architecture

#### Core Integration Components

**Agent-Script Communication Layer**
- Standardized input/output protocols
- Event-driven trigger mechanisms
- Error propagation and handling
- State management between agent and script execution
- Logging and audit trail integration

**Configuration Management**
- Agent configuration via environment variables
- Script metadata for agent discovery
- Runtime parameter passing
- Dynamic configuration updates

**Testing Integration**
- Agent behavior validation
- Integration test automation
- Performance monitoring
- Error simulation and recovery testing

### Agent Types and Script Integration

#### 1. Script Header Documentation Agent

**Integration Pattern**: Pre-commit hooks and pull request validation

**Script Integration Points**:
```bash
# Header validation trigger in scripts
# Automatically invoked by git hooks
validate_script_header() {
    local script_file="$1"
    local validation_result

    # Invoke agent for header validation
    validation_result=$(node .github/agents/script-header-docs.agent.js "$script_file")

    if [[ $? -ne 0 ]]; then
        log_error "Script header validation failed: $validation_result"
        return 1
    fi

    log_success "Script header validation passed"
    return 0
}
```

**Agent Configuration**:
```javascript
// .github/agents/script-header-docs.agent.js
const config = {
    requiredFields: [
        'Script Name',
        'Description',
        'Version',
        'Author',
        'Usage',
        'Options'
    ],
    headerFormat: 'lightspeed-wp',
    validationLevel: process.env.HEADER_VALIDATION_LEVEL || 'strict'
};
```

**Integration Workflow**:
1. Git pre-commit hook detects shell script changes
2. Hook invokes header validation script
3. Script calls agent with file path
4. Agent analyzes header compliance
5. Agent returns validation result and suggestions
6. Script logs results and blocks commit if validation fails

#### 2. Bats Test Runner Agent

**Integration Pattern**: Continuous integration and automated testing

**Script Integration**:
```bash
# Test execution with agent orchestration
run_tests_with_agent() {
    local test_category="$1"
    local agent_config="$2"

    # Configure agent for test run
    export TEST_CATEGORY="$test_category"
    export AGENT_CONFIG_FILE="$agent_config"

    # Execute agent-managed test run
    node .github/agents/bats-tests-runner.agent.js \
        --scripts-dir "$SCRIPTS_DIR" \
        --tests-dir "$TESTS_DIR" \
        --category "$test_category" \
        --output-format json
}
```

**Agent Responsibilities**:
- Discover and categorize test files
- Execute tests in appropriate order
- Collect and aggregate results
- Generate comprehensive reports
- Handle test failures and retries
- Update test coverage metrics

**Integration Events**:
- Script file modifications trigger relevant tests
- New script creation triggers test file generation
- Test failures trigger notification workflows
- Coverage drops trigger review requirements

#### 3. Release Management Agent

**Integration Pattern**: Release workflow automation and validation

**Script Integration**:
```bash
# Release validation with agent
validate_release_with_agent() {
    local version="$1"
    local release_type="$2"

    # Prepare release context for agent
    local context_file=$(mktemp)
    cat > "$context_file" << EOF
{
    "version": "$version",
    "releaseType": "$release_type",
    "scriptsModified": $(git diff --name-only HEAD~1 HEAD -- scripts/ | jq -R . | jq -s .),
    "testsModified": $(git diff --name-only HEAD~1 HEAD -- tests/ | jq -R . | jq -s .),
    "changelogUpdated": $(git diff --name-only HEAD~1 HEAD CHANGELOG.md | wc -l)
}
EOF

    # Execute agent validation
    node .github/agents/release.agent.js \
        --context-file "$context_file" \
        --validation-mode full \
        --output-format detailed

    local agent_result=$?
    rm -f "$context_file"
    return $agent_result
}
```

**Agent Validation Checklist**:
- Version format compliance
- Changelog completeness
- Test coverage requirements
- Breaking change documentation
- Migration guide availability
- Dependency compatibility

#### 4. Linting Workflow Agent

**Integration Pattern**: Code quality enforcement and automated fixes

**Script Integration**:
```bash
# Linting with agent orchestration
lint_with_agent() {
    local file_patterns=("$@")

    # Execute multi-language linting through agent
    node .github/agents/linting-workflow.agent.js \
        --patterns "${file_patterns[@]}" \
        --auto-fix true \
        --report-format json \
        --config .github/linting-config.json

    local lint_result=$?

    if [[ $lint_result -eq 0 ]]; then
        log_success "All linting checks passed"
    elif [[ $lint_result -eq 2 ]]; then
        log_warning "Linting issues found and auto-fixed"
        log_error "Linting failed with unresolvable issues"
    fi

    return $lint_result
}
```

**Agent Capabilities**:
- Multi-language linting coordination
- Automatic fix application

- Custom rule enforcement

- Integration with code formatters

### Agent Communication Protocols

#### Input/Output Standardization

**Standard Input Format**:
```json
{
    "action": "validate|fix|analyze|report",
    "target": {
        "type": "file|directory|repository",
        "path": "/path/to/target",
        "patterns": ["*.sh", "*.bats"]
    },
    "config": {
        "level": "strict|moderate|lenient",
        "autoFix": true,
        "outputFormat": "json|text|markdown"
    },
    "context": {
        "branch": "main",
        "pullRequest": 123,
        "triggered-by": "pre-commit|ci|manual"
    }
}
```

**Standard Output Format**:
```json
{
    "status": "success|warning|error",
    "exitCode": 0,
    "summary": {
        "filesProcessed": 15,
        "issuesFound": 3,
        "issuesFixed": 2,
        "duration": "2.3s"
    },
    "results": [
        {
            "file": "/path/to/file.sh",
            "status": "passed|failed|fixed",
            "issues": [],
            "suggestions": []
        }
    ],
    "reports": {
        "detailed": "/tmp/detailed-report.json",
        "summary": "/tmp/summary.txt"
    }
}
```

#### Error Handling Protocol

**Agent Error Categories**:
- Configuration errors (invalid config, missing dependencies)
- Runtime errors (file access, network issues)
- Validation errors (rule violations, format issues)
- Integration errors (communication failures, timeout issues)

**Error Propagation**:
```bash
handle_agent_error() {
    local agent_output="$1"
    local error_code="$2"

    case $error_code in
        1) log_error "Agent configuration error: $agent_output" ;;
        2) log_warning "Agent validation warnings: $agent_output" ;;
        3) log_error "Agent runtime error: $agent_output" ;;
        *) log_error "Unknown agent error ($error_code): $agent_output" ;;
    esac

    # Extract structured error information
    if command_exists jq && echo "$agent_output" | jq . >/dev/null 2>&1; then
        local error_details=$(echo "$agent_output" | jq -r '.error.details // "No details available"')
        log_debug "Agent error details: $error_details"
    fi
}
```

### Agent Configuration Management

#### Environment-Based Configuration

**Development Environment**:
```bash
# .env.development
AGENT_VALIDATION_LEVEL=lenient
AGENT_AUTO_FIX=true
AGENT_TIMEOUT=30
AGENT_PARALLEL_EXECUTION=false
AGENT_LOGGING_LEVEL=debug
```

**Production Environment**:
```bash
# .env.production
AGENT_VALIDATION_LEVEL=strict
AGENT_AUTO_FIX=false
AGENT_TIMEOUT=60
AGENT_PARALLEL_EXECUTION=true
AGENT_LOGGING_LEVEL=info
```

#### Runtime Configuration

**Dynamic Agent Configuration**:
```bash
configure_agent() {
    local agent_name="$1"
    local config_overrides="$2"

    # Load base configuration
    local base_config=".github/agents/${agent_name}.config.json"
    local runtime_config=$(mktemp)

    # Apply environment-specific overrides
    jq ". + $config_overrides" "$base_config" > "$runtime_config"

    export AGENT_CONFIG_FILE="$runtime_config"
    log_debug "Agent $agent_name configured with: $(cat $runtime_config)"
}
```

### Integration Testing Strategy

#### Agent Behavior Validation

**Integration Test Framework**:
```bash
# Test agent integration behavior
test_agent_integration() {
    local agent_name="$1"
    local test_scenario="$2"

    # Setup test environment
    local test_dir=$(mktemp -d)
    local test_script="$test_dir/test.sh"
    local expected_output="$test_dir/expected.json"

    # Create test script with known issues
    create_test_script_with_issues "$test_script" "$test_scenario"

    # Execute agent
    local agent_output=$(node ".github/agents/${agent_name}.agent.js" \
        --target "$test_script" \
        --config-level test)

    # Validate agent response
    validate_agent_output "$agent_output" "$expected_output"

    # Cleanup
    rm -rf "$test_dir"
}
```

#### Performance Testing

**Agent Performance Monitoring**:
```bash
monitor_agent_performance() {
    local agent_name="$1"
    local test_files=("$@")

    local start_time=$(date +%s.%N)
    local memory_before=$(ps -o rss= -p $$ 2>/dev/null || echo 0)

    # Execute agent
    node ".github/agents/${agent_name}.agent.js" "${test_files[@]}"
    local exit_code=$?

    local end_time=$(date +%s.%N)
    local memory_after=$(ps -o rss= -p $$ 2>/dev/null || echo 0)
    local duration=$(echo "$end_time - $start_time" | bc)
    local memory_used=$(echo "$memory_after - $memory_before" | bc)

    # Log performance metrics
    log_info "Agent $agent_name performance:"
    log_info "  Duration: ${duration}s"
    log_info "  Memory used: ${memory_used}KB"
    log_info "  Exit code: $exit_code"
    log_info "  Files processed: ${#test_files[@]}"
}
```

## System Constraints

- Agents must be stateless and idempotent
- All agent communication must be through standard protocols
- Agents must handle timeout and cancellation gracefully
- Agent configuration must be version controlled
- Agent errors must not break script execution flow

## Example First Message to Copilot

```
Integrate AI agents with shell script automation following the documented patterns. Implement agent communication protocols, error handling, and configuration management. Ensure agents can be triggered from scripts, process standardized input/output, and integrate with CI/CD workflows.
```

## Verification Steps

- [ ] All agents have standardized input/output protocols
- [ ] Script-to-agent communication is reliable and tested
- [ ] Agent configuration management works across environments
- [ ] Error handling prevents script failures from agent issues
- [ ] Performance monitoring identifies bottlenecks
- [ ] Integration tests validate end-to-end workflows

## References

- [Agent Registry and Management](../.github/agents/agent.md)
- [GitHub Actions CI/CD Best Practices](../.github/instructions/github-actions-ci-cd-best-practices.instructions.md)
- [Shell Script Copilot Instructions](../.github/instructions/shell-script-copilot.instructions.md)

## Closing Statement

Effective agent integration enables intelligent automation while maintaining reliable script execution and providing comprehensive feedback for continuous improvement of the codebase.
