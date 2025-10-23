---
applyTo: '**'
description: 'Prompt for interactive Copilot implementation for modular shell script architecture.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['copilot', 'prompt', 'interactive', 'modular']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Interactive Prompts for Copilot Implementation

## Role

You are a prompt engineering specialist. Follow our LightSpeed WP Copilot framework to create interactive prompt templates that guide effective implementation of modular shell script architecture.

## Purpose

Comprehensive interactive prompt implementation ensures systematic and guided development of modular shell script components with consistent quality, thorough validation, and seamless integration into enterprise automation workflows.

## Checklist

## Current Repository State & Action Items

- Modular includes present: `common-functions.sh`, `git-functions.sh` in `scripts/includes/`. Additional includes recommended for full modularization.
- Folder structure: `/scripts/project/` and `/tests/project-scripts/` currently used; planned renaming for consistency.
- Interactive prompt templates should reference actual includes and folder names, and guide implementation/testing for each component.

**Action:** Expand prompt templates to cover all planned includes, update folder names, and ensure validation/troubleshooting steps are actionable for the current branch.

## Instructions

### Implementation Prompt Categories

#### 1. Initial Assessment and Planning Prompts

##### Project Analysis Prompt Template

```text
SYSTEM: You are analyzing the LightSpeed WP scripts repository for modularization opportunities.

CONTEXT: We need to extract common functions from shell scripts into reusable includes following our standards.

TASK: Analyze the current codebase and create an implementation plan.

STEPS:
1. Scan all shell scripts in /scripts/ directories
2. Identify duplicated function patterns
3. Categorize functions by purpose (logging, validation, utilities, etc.)
4. Assess complexity and dependencies
5. Prioritize extraction order based on usage frequency and risk

DELIVERABLES:
- Function inventory with locations and usage counts
- Extraction priority matrix
- Risk assessment for each function group
- Implementation timeline with milestones

CONSTRAINTS:
- Maintain backward compatibility
- Follow LightSpeed WP shell script standards
- Ensure comprehensive test coverage
- Document all breaking changes

Please start by analyzing the scripts directory structure and identifying the most commonly duplicated functions.
```

##### Architecture Decision Prompt

```text
CONTEXT: We're designing the includes architecture for LightSpeed WP shell scripts.

DECISION NEEDED: Directory structure and naming conventions for includes.

OPTIONS TO EVALUATE:
1. Single includes directory: /scripts/includes/
2. Category-based: /scripts/includes/{logging,validation,utils}/
3. Feature-based: /scripts/includes/{github,deployment,maintenance}/

EVALUATION CRITERIA:
- Ease of discovery and usage
- Maintenance complexity
- Future extensibility
- Alignment with existing patterns

QUESTIONS TO ANSWER:
- Which structure best supports our use cases?
- How should we handle cross-category dependencies?
- What naming conventions ensure clarity?
- How do we prevent circular dependencies?

Please recommend a structure with detailed rationale and examples.
```

#### 2. Function Extraction Guidance Prompts

##### Function Analysis Prompt

```text
OBJECTIVE: Extract the logging functions from existing shell scripts into a reusable include.

CURRENT STATE: Logging functions are duplicated across multiple scripts with slight variations.

ANALYSIS TASKS:
1. Compare logging implementations across all scripts
2. Identify the most complete and robust implementation
3. Document parameter variations and usage patterns
4. Plan unified interface that supports all current use cases
5. Create migration strategy for existing scripts

SPECIFIC FUNCTIONS TO ANALYZE:
- log_info() - found in: validate-release.sh, standardize-logging.sh, utility-functions.sh
- log_error() - found in: most scripts with different implementations
- log_success() - found in: validate-release.sh, deployment scripts
- log_warning() - some scripts use log_warn(), others log_warning()

DELIVERABLES:
- Unified function specifications
- Parameter compatibility matrix
- Migration checklist for each affected script
- Test requirements for each function

Please start with the log_info() function and provide a complete analysis.
```

##### Step-by-Step Extraction Prompt

```text
TASK: Extract logging functions into /scripts/includes/logging.sh

REQUIREMENTS:
- Maintain all existing functionality
- Standardize on consistent naming
- Add comprehensive error handling
- Include full documentation
- Create comprehensive tests

STEP-BY-STEP PROCESS:
1. Create the include file with proper header
2. Implement core log_msg() function
3. Implement wrapper functions (log_info, log_error, etc.)
4. Add color support and formatting
5. Test the include file independently
6. Update first script to use the include
7. Validate functionality matches original
8. Repeat for remaining scripts

VALIDATION AT EACH STEP:
- Function works as expected
- All original use cases are supported
- Error handling is comprehensive
- Documentation is complete

Please implement Step 1: Create /scripts/includes/logging.sh with proper header and core structure.
```

#### 3. Testing and Validation Prompts

##### Test Strategy Development Prompt

```text
OBJECTIVE: Create comprehensive test strategy for extracted include functions.

CONTEXT: We need to ensure extracted functions work correctly in all scenarios while maintaining backward compatibility.

TEST CATEGORIES NEEDED:
1. Unit tests for individual functions
2. Integration tests for function interactions
3. Compatibility tests with existing scripts
4. Edge case and error condition tests
5. Performance and load tests

FOR EACH FUNCTION, CREATE TESTS FOR:
- Normal operation with typical inputs
- Edge cases (empty strings, special characters, long inputs)
- Error conditions (invalid parameters, missing files, permission issues)
- Environment variations (different shells, operating systems, locales)
- Performance characteristics (execution time, memory usage)

SPECIFIC TEST REQUIREMENTS:
- Use Bats testing framework
- Follow LightSpeed WP test standards
- Include setup/teardown for test isolation
- Create mock data and test fixtures
- Validate both output and side effects

Please start by creating the test structure for logging functions.
```

##### Interactive Testing Prompt

```text
CURRENT: We have extracted logging.sh and need to create comprehensive tests.

TESTING APPROACH:
1. Test each function individually (unit tests)
2. Test functions working together (integration tests)
3. Test with actual script usage (compatibility tests)
4. Test error conditions and edge cases

QUESTIONS FOR IMPLEMENTATION:
Q1: What test scenarios are most critical for log_info()?
Q2: How should we mock file system operations for testing?
Q3: What environment variables need to be controlled in tests?
Q4: How do we test color output in different terminal environments?

VALIDATION CRITERIA:
- All tests pass in CI/CD environment
- Tests are deterministic and repeatable
- Test coverage is >90% for all functions
- Edge cases are comprehensively covered

Please implement unit tests for log_info() with comprehensive coverage.
```

#### 4. Integration and Deployment Prompts

##### Script Migration Prompt

```text
OBJECTIVE: Migrate existing scripts to use the new logging include.

TARGET SCRIPT: scripts/utility/validate-release.sh

MIGRATION STEPS:
1. Analyze current logging usage in the script
2. Identify required modifications for include compatibility
3. Update script to source the logging include
4. Replace function calls with standardized versions
5. Test modified script thoroughly
6. Compare behavior before and after migration

COMPATIBILITY CHECKLIST:
- All log messages appear correctly
- Log files are created in expected locations
- Color output works as before
- Error handling behavior is preserved
- Performance impact is minimal

VALIDATION PROCESS:
- Run original script and capture all outputs
- Run modified script and compare outputs
- Verify log file contents match expectations
- Test edge cases and error conditions
- Confirm no regression in functionality

Please start the migration for validate-release.sh.
```

##### Integration Validation Prompt

```text
PHASE: Post-migration validation across all updated scripts.

OBJECTIVE: Ensure all migrated scripts work correctly with shared includes.

VALIDATION MATRIX:
Script | Include Used | Functions Called | Status | Issues
-------|-------------|------------------|--------|-------
validate-release.sh | logging.sh | log_info, log_error | ✓ | None
standardize-logging.sh | logging.sh | all functions | ✓ | None
[continue for all scripts]

INTEGRATION TESTS:
1. Run all scripts individually
2. Test scripts in combination (workflow scenarios)
3. Verify shared state doesn't cause conflicts
4. Test concurrent execution scenarios
5. Validate resource cleanup

REGRESSION TESTING:
- Compare outputs with baseline recordings
- Verify all existing functionality preserved
- Check performance characteristics
- Validate error handling behavior

Please perform comprehensive integration testing and report any issues found.
```

#### 5. Documentation and Quality Assurance Prompts

##### Documentation Generation Prompt

```text
TASK: Generate comprehensive documentation for the new includes architecture.

DOCUMENTATION REQUIREMENTS:
1. Include file documentation (purpose, functions, usage examples)
2. Migration guide for script authors
3. Testing documentation and examples
4. Best practices and coding standards
5. Troubleshooting guide and FAQ

FOR EACH INCLUDE FILE:
- Purpose and scope explanation
- Function reference with parameters and examples
- Usage patterns and common scenarios
- Error conditions and handling
- Performance considerations
- Dependencies and requirements

AUDIENCE CONSIDERATIONS:
- New developers learning the codebase
- Existing maintainers updating scripts
- CI/CD automation requirements
- External contributors

QUALITY STANDARDS:
- All examples must be tested and working
- Cross-references must be accurate and up-to-date
- Markdown must pass linting requirements
- Documentation must be discoverable and searchable

Please create comprehensive documentation for logging.sh include.
```

##### Quality Assurance Prompt

```text
OBJECTIVE: Comprehensive quality review of the implemented includes architecture.

REVIEW AREAS:
1. Code quality and standards compliance
2. Test coverage and quality
3. Documentation completeness and accuracy
4. Performance and resource usage
5. Security considerations
6. Maintainability and extensibility

QUALITY GATES:
- All code passes linting (ShellCheck, markdownlint)
- Test coverage >90% for all includes
- All documentation is accurate and complete
- No performance regressions detected
- Security best practices followed
- Migration completed without breaking changes

VALIDATION CHECKLIST:
□ All includes follow LightSpeed WP standards
□ Function interfaces are clean and consistent
□ Error handling is comprehensive
□ Tests cover all critical scenarios
□ Documentation is complete and accurate
□ Migration preserves all functionality
□ Performance is acceptable
□ No security issues introduced

Please perform a comprehensive quality review and provide recommendations.
```

#### 6. Troubleshooting and Debugging Prompts

##### Issue Diagnosis Prompt

```text
SITUATION: A script is failing after migration to use includes.

DEBUGGING APPROACH:
1. Identify the specific failure point
2. Compare behavior with pre-migration version
3. Isolate the issue to include or script code
4. Analyze error messages and logs
5. Check environment and dependencies
6. Verify include loading and function availability

COMMON ISSUES TO CHECK:
- Include file not found or not sourced correctly
- Function name mismatches or parameter differences
- Environment variable conflicts
- File permission issues
- Path resolution problems
- Dependencies missing or misconfigured

DIAGNOSTIC TOOLS:
- bash -x for execution tracing
- set -euo pipefail for error detection
- function existence checks (type -t function_name)
- environment inspection (env, set)
- file system validation (ls -la, file permissions)

ERROR ANALYSIS:
Script: [script name]
Error: [error message]
Expected: [expected behavior]
Actual: [actual behavior]

Please diagnose the issue and provide resolution steps.
```

##### Performance Debugging Prompt

```text
CONCERN: Scripts seem slower after migration to includes.

PERFORMANCE ANALYSIS NEEDED:
1. Baseline performance measurements
2. Include loading overhead analysis
3. Function call performance comparison
4. Memory usage impact assessment
5. File I/O efficiency review

MEASUREMENT APPROACH:
- Use time command for execution duration
- Profile with bash time builtin for detailed breakdown
- Monitor memory usage with ps or similar tools
- Analyze function call frequency and patterns
- Compare with pre-migration benchmarks

OPTIMIZATION OPPORTUNITIES:
- Lazy loading of includes
- Function call optimization
- Reduced file I/O operations
- Improved error handling efficiency
- Better resource management

Please analyze performance and identify optimization opportunities.
```

### Interactive Decision Trees

#### Include Design Decision Flow

```text
DECISION POINT: How should we structure the validation functions include?

OPTION A: Single validation.sh with all validation functions
PROS: Simple to use, single import
CONS: Large file, mixed concerns

OPTION B: Separate files by validation type (file-validation.sh, input-validation.sh)
PROS: Better separation of concerns, smaller files
CONS: Multiple imports needed, dependency management

OPTION C: Hierarchical structure with main validation.sh sourcing sub-modules
PROS: Best of both worlds, extensible
CONS: More complex, potential circular dependencies

RECOMMENDATION CRITERIA:
- Ease of use for script authors
- Maintainability and extensibility
- Performance implications
- Consistency with existing patterns

Which option do you recommend and why? Please provide implementation details.
```

## System Constraints

- All prompts must align with LightSpeed WP standards
- Implementation must maintain backward compatibility
- Quality gates must be enforced throughout process
- Documentation must be comprehensive and accurate
- Testing must cover all critical scenarios

## Example First Message to Copilot

```text
I need to implement modular shell script architecture following LightSpeed WP standards. Please use the interactive prompts to guide me through systematic extraction of common functions into reusable includes, comprehensive testing, and seamless migration of existing scripts.

Start with the initial assessment and planning phase.
```

## Verification Steps

- [ ] All prompt templates produce actionable guidance
- [ ] Decision trees cover all major implementation choices
- [ ] Quality assurance prompts ensure standards compliance
- [ ] Troubleshooting prompts resolve common issues
- [ ] Implementation flows are logical and comprehensive
- [ ] Progress tracking enables milestone management

## References

- [Prompts Overview](../.github/prompts/prompts.md)
- [Shell Script Copilot Instructions](../.github/instructions/shell-script-copilot.instructions.md)
- [Script Functions Breakdown Spec](./script-functions-breakdown-spec.md)

## Closing Statement

Interactive prompts enable systematic, guided implementation of complex modularization projects while ensuring quality, compatibility, and adherence to organizational standards throughout the development process.
