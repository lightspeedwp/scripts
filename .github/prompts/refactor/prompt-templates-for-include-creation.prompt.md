
---
applyTo: '**'
description: 'Prompt for structured templates for shell script modularization and include creation.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['prompt', 'template', 'includes', 'modular']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Prompt Templates for Include Creation

## Role

You are a prompt engineering specialist for shell script modularization. Follow our LightSpeed WP prompt framework to create structured templates that guide systematic extraction of functions into reusable includes.

## Purpose

Comprehensive prompt templates ensure systematic and high-quality creation of modular shell script includes with consistent standards, thorough validation, and seamless integration into enterprise automation workflows.


## Checklist

- [ ] Create function extraction prompt templates
- [ ] Design include file creation prompts with quality gates
- [ ] Develop testing prompt templates for include validation
- [ ] Create documentation generation prompts for includes
- [ ] Establish integration and migration prompt workflows
- [ ] Design troubleshooting and optimization prompts

## Instructions

### Core Include Creation Prompts

#### 1. Function Analysis and Extraction Planning

##### Initial Function Discovery Prompt

```text
OBJECTIVE: Discover and analyze duplicated functions across the LightSpeed WP scripts repository for extraction into reusable includes.

CONTEXT: We have shell scripts in multiple directories (deployment/, maintenance/, project/, utility/) with duplicated functionality that should be modularized.

ANALYSIS FRAMEWORK:
1. Function Pattern Detection
2. Usage Frequency Analysis
3. Complexity and Dependency Assessment
4. Extraction Priority Ranking

EXECUTION STEPS:

Step 1 - Function Discovery:
- Scan all .sh files in scripts/ subdirectories
- Extract function definitions using pattern matching
- Identify functions with similar names or purposes
- Create function inventory with locations and signatures

Step 2 - Usage Analysis:
- Count function usage across all scripts
- Identify parameter variations and calling patterns
- Document dependencies between functions
- Assess potential impact of changes

Step 3 - Extraction Planning:
- Group related functions by purpose and complexity
- Prioritize by usage frequency and risk level
- Plan extraction order to minimize disruption
- Identify testing requirements for each function

DELIVERABLES:
- Complete function inventory with metadata
- Usage frequency analysis
- Extraction priority matrix
- Risk assessment for each function group

START HERE: Begin with scanning the scripts/ directory and identifying the top 10 most frequently duplicated functions.

```

##### Function Categorization Prompt

```text
TASK: Categorize extracted functions into logical include groups following LightSpeed WP architecture patterns.

INPUT: Function inventory from discovery phase

CATEGORIZATION FRAMEWORK:

Core System Functions:
- logging.sh: log_info, log_error, log_success, log_warning, log_debug
- validation.sh: command_exists, validate_file_exists, validate_directory_exists, check_dependencies
- error-handling.sh: handle_error, exit_with_error, cleanup_on_exit
- path-utils.sh: resolve_script_dir, resolve_repo_root, normalize_path

CLI Utilities:
- argument-parsing.sh: parse_arguments, show_help, validate_options
- interactive.sh: confirm_action, prompt_user, select_option
- output-formatting.sh: format_output, create_table, progress_indicator

File Operations:
- file-operations.sh: safe_write, atomic_move, secure_delete
- backup-management.sh: create_backup, restore_backup, cleanup_backups
- directory-utils.sh: ensure_directory, copy_directory, sync_directories

Network Operations:
- http-client.sh: make_request, download_file, check_connectivity
- github-api.sh: gh_authenticate, gh_api_call, gh_check_rate_limit

CATEGORIZATION CRITERIA:
- Functional cohesion (related operations)
- Dependency relationships (minimize cross-include dependencies)
- Usage patterns (frequently used together)
- Complexity level (simple utilities vs complex operations)

OUTPUT REQUIRED:
- Include file specifications with function lists
- Dependency graph between includes
- Interface contracts for each include
- Migration impact assessment

Execute this categorization for the discovered functions.
```

#### 2. Include File Creation Templates

##### Core Include Template Prompt

```text
TASK: Create the logging.sh include file following LightSpeed WP standards.

REQUIREMENTS:
- Comprehensive header with all required metadata
- All logging functions with standardized interfaces
- Error handling and input validation
- Color support with fallback for non-TTY environments
- Log file management with directory creation
- Environment variable configuration support
- Full inline documentation

FUNCTION SPECIFICATIONS:

log_msg(level, message...):
- Core logging function used by all other log functions
- Parameters: level (INFO|SUCCESS|WARNING|ERROR|DEBUG), message components
- Behavior: Write to stderr with colors, append to log file with timestamp
- Error handling: Create log directory if missing, handle write failures

log_info(message...):
- Wrapper for log_msg with INFO level
- Green color output, informational icon
- Standard informational logging

log_success(message...):
- Wrapper for log_msg with SUCCESS level
- Bright green color, checkmark icon
- Success confirmation logging

log_error(message...):
- Wrapper for log_msg with ERROR level
- Red color output, error icon
- Error condition logging

log_warning(message...):
- Wrapper for log_msg with WARNING level
- Yellow color output, warning icon
- Warning condition logging

log_debug(message...):
- Conditional wrapper for log_msg with DEBUG level
- Blue color output, debug icon
- Only active when VERBOSE environment variable is true

IMPLEMENTATION REQUIREMENTS:
- Use color variables from standardized color definitions
- Support LOG_FILE environment variable for output destination
- Handle missing log directories by creating them
- Provide graceful fallback when log writing fails
- Include comprehensive error handling for all edge cases

CREATE: /scripts/includes/core/logging.sh with complete implementation.
```

##### Validation Include Template Prompt

```text
OBJECTIVE: Create validation.sh include with comprehensive input and system validation functions.

FUNCTION REQUIREMENTS:

command_exists(command_name):
- Purpose: Check if command is available in PATH
- Parameters: command_name (string)
- Returns: 0 if exists, 1 if not found
- Implementation: Use 'command -v' for POSIX compatibility
- Error handling: Silent operation, return code only

validate_file_exists(file_path, description):
- Purpose: Validate file exists and is readable
- Parameters: file_path (string), description (optional string for errors)
- Returns: 0 if valid, 1 if invalid
- Output: Error message using log_error if file missing/unreadable
- Dependencies: Requires logging.sh functions

validate_directory_exists(directory_path, description):
- Purpose: Validate directory exists and is accessible
- Parameters: directory_path (string), description (optional string)
- Returns: 0 if valid, 1 if invalid
- Output: Error message using log_error if directory missing/inaccessible
- Dependencies: Requires logging.sh functions

check_dependencies(command_list...):
- Purpose: Verify all required commands are available
- Parameters: Variable list of command names
- Returns: 0 if all found, 1 if any missing
- Output: List of missing commands via log_error
- Implementation: Use command_exists for each command

validate_version_format(version_string):
- Purpose: Validate semantic version format
- Parameters: version_string (string, may include 'v' prefix)
- Returns: 0 if valid semver, 1 if invalid
- Pattern: Match semantic versioning specification
- Examples: 1.0.0, v2.1.3, 1.0.0-alpha.1

validate_email_format(email_address):
- Purpose: Basic email format validation
- Parameters: email_address (string)
- Returns: 0 if valid format, 1 if invalid
- Pattern: Basic regex for email validation (not RFC compliant, but practical)

QUALITY REQUIREMENTS:
- All functions must handle edge cases gracefully
- Input validation must prevent security issues
- Error messages must be clear and actionable
- Functions must be independent and atomic
- No global state modifications
- Comprehensive parameter validation

DEPENDENCIES:
- Must source logging.sh for error reporting
- No other external dependencies allowed
- Use only POSIX-compatible commands

CREATE: /scripts/includes/core/validation.sh with complete implementation.
```

#### 3. Testing Template Prompts

##### Include Testing Strategy Prompt

```text
OBJECTIVE: Create comprehensive Bats test suite for the logging.sh include following LightSpeed WP testing standards.

TESTING REQUIREMENTS:

Test Coverage Categories:
1. Unit Tests - Individual function testing
2. Integration Tests - Function interaction testing
3. Error Condition Tests - Failure scenario handling
4. Environment Tests - Different environment configurations
5. Performance Tests - Execution time and resource usage

Test File Structure:
- Header with metadata and helper loading
- Setup/teardown for test isolation
- Grouped test sections with clear descriptions
- Individual test documentation blocks

SPECIFIC TEST SCENARIOS:

For log_info():
- Normal message logging to stderr and file
- Multiple parameter handling
- Color output verification (when TTY available)
- Log file creation when directory missing
- Timestamp format validation in log file
- Behavior when LOG_FILE is unset
- Write permission failure handling
- Message with special characters and quotes

For log_error():
- Error message formatting and coloring
- Integration with error handling workflows
- Proper exit code handling (should not exit, just log)
- Stderr vs file output content comparison

For log_debug():
- Conditional behavior based on VERBOSE setting
- No output when VERBOSE is false/unset
- Proper output when VERBOSE is true
- Performance impact when debug logging is disabled

Environment Testing:
- Different LOG_FILE locations and formats
- Missing log directory creation
- Permission denied scenarios
- Read-only filesystem handling
- TTY vs non-TTY environments

Integration Testing:
- Multiple log functions in sequence
- Concurrent logging from different processes
- Log rotation and file size handling
- Integration with error handling functions

IMPLEMENTATION REQUIREMENTS:
- Use temporary directories for all file operations
- Mock environment variables appropriately
- Capture both stderr and file outputs for comparison
- Test cleanup must be comprehensive
- No test dependencies or ordering requirements

CREATE: /tests/includes/core/test-logging.bats with complete test coverage.
```

##### Integration Testing Prompt

```text
TASK: Create integration tests that validate include interactions and real-world usage scenarios.

INTEGRATION SCENARIOS:

Script Migration Testing:
- Load original script behavior (before includes)
- Load modified script behavior (after includes)
- Compare outputs, exit codes, and side effects
- Verify no regression in functionality

Cross-Include Dependencies:
- Test validation.sh functions that use logging.sh
- Verify error propagation between includes
- Test include loading order dependencies
- Validate shared environment variable usage

Workflow Integration:
- Test includes in CI/CD pipeline scenarios
- Verify includes work in different shell environments
- Test performance impact of include loading
- Validate memory usage with multiple includes loaded

Error Recovery Testing:
- Test behavior when include files are missing
- Verify graceful degradation when functions unavailable
- Test include loading failures and error messages
- Validate fallback behavior for essential functions

TESTING METHODOLOGY:
- Create realistic usage scenarios matching actual scripts
- Use production-like data and environments
- Simulate common error conditions
- Measure and validate performance characteristics

DELIVERABLES:
- Integration test suite with comprehensive scenarios
- Performance benchmark baselines
- Error condition handling validation
- Compatibility testing across shell versions

Execute comprehensive integration testing for the created includes.
```

#### 4. Documentation Generation Prompts

##### API Documentation Prompt

```text
OBJECTIVE: Generate comprehensive API documentation for shell script includes.

DOCUMENTATION STRUCTURE:

Function Reference Format:

```text
## function_name(parameters...)

### Function Purpose

Brief description of what the function does and why it exists.

### Function Parameters

- parameter1 (type): Description of parameter and constraints
- parameter2 (optional, type): Description with default value information

### Function Returns

- Exit Code: 0 for success, 1 for failure, other codes as applicable
- Output: Description of stdout/stderr output format

### Function Dependencies

- Required includes that must be loaded first
- External commands that must be available
- Environment variables that affect behavior

### Function Examples

```bash
# Basic usage example
result=$(function_name "parameter1")

# Advanced usage with error handling
if function_name "param1" "param2"; then
    log_success "Operation completed"
else
    log_error "Operation failed"
fi
```

### Function Error Conditions

- List of possible error scenarios and their handling
- Common troubleshooting steps
- Related error codes and meanings

### Function Notes

- Performance considerations
- Security implications
- Compatibility information
- Version history and changes

```markdown

DOCUMENTATION REQUIREMENTS:
- All public functions must be documented
- Examples must be tested and working
- Error conditions must be comprehensive
- Cross-references between related functions
- Usage patterns and best practices

QUALITY STANDARDS:
- Documentation must pass markdown linting
- All code examples must be syntax-highlighted
- Links must be validated and functional
- Version information must be current

CREATE: Comprehensive API documentation for all include functions.

```text

#### Usage Guide Prompt

```text
TASK: Create user-friendly usage guides for implementing and migrating to modular includes.

GUIDE STRUCTURE:

Getting Started Guide:
1. Understanding the Include System
2. Loading Includes in Scripts
3. Basic Function Usage
4. Common Patterns and Examples
5. Troubleshooting Common Issues

Migration Guide:
1. Pre-migration Checklist
2. Step-by-Step Migration Process
3. Testing Migration Results
4. Rollback Procedures
5. Post-migration Validation

Best Practices Guide:
1. Include Design Principles
2. Function Naming Conventions
3. Error Handling Patterns
4. Performance Considerations
5. Security Guidelines

CONTENT REQUIREMENTS:

Practical Examples:
- Before/after code comparisons
- Common usage patterns
- Integration with existing scripts
- Error handling examples

Migration Support:
- Automated migration tools usage
- Manual migration procedures
- Validation and testing approaches
- Common pitfalls and solutions

Troubleshooting:
- Diagnostic procedures
- Common error messages and solutions
- Performance debugging techniques
- Compatibility issue resolution

AUDIENCE CONSIDERATIONS:
- New developers learning the system
- Experienced developers migrating existing code
- System administrators deploying changes
- CI/CD automation requirements

CREATE: Complete usage and migration documentation suite.
```

#### 5. Quality Assurance and Optimization Prompts

##### Code Quality Review Prompt

```text
OBJECTIVE: Comprehensive quality review of created includes following LightSpeed WP standards.

REVIEW CATEGORIES:

Code Quality:
- Adherence to shell scripting best practices
- POSIX compliance and portability
- Error handling comprehensiveness
- Input validation and sanitization
- Resource cleanup and management

Standards Compliance:
- LightSpeed WP coding standards conformance
- Naming convention consistency
- Documentation completeness
- Header and inline comment quality
- Function interface design

Security Review:
- Input validation effectiveness
- Path traversal prevention
- Command injection prevention
- Secure temporary file handling
- Privilege escalation prevention

Performance Analysis:
- Function execution time measurement
- Memory usage assessment
- Resource utilization optimization
- Startup time impact evaluation
- Scalability considerations

REVIEW CHECKLIST:
□ All functions have comprehensive error handling
□ Input parameters are validated appropriately
□ Functions are atomic and side-effect free
□ Dependencies are minimal and well-documented
□ Security best practices are followed
□ Performance is acceptable for intended usage
□ Code is readable and maintainable
□ Documentation is accurate and complete

DELIVERABLES:
- Quality assessment report with scores
- Specific improvement recommendations
- Security vulnerability analysis
- Performance optimization suggestions

Execute comprehensive quality review for all created includes.
```

##### Performance Optimization Prompt

```text
TASK: Analyze and optimize performance of modular includes for production usage.

PERFORMANCE ANALYSIS:

Execution Time Profiling:
- Measure individual function execution times
- Identify bottlenecks in function implementations
- Analyze include loading overhead
- Compare performance with original implementations

Memory Usage Analysis:
- Monitor memory consumption during execution
- Identify memory leaks or excessive usage
- Optimize variable usage and cleanup
- Minimize persistent state requirements

Resource Utilization:
- File descriptor usage optimization
- Process spawning minimization
- Network request efficiency
- Temporary file management

Optimization Strategies:
- Function call optimization
- Conditional execution improvements
- Caching frequently computed values
- Lazy loading of expensive operations

BENCHMARKING REQUIREMENTS:
- Baseline measurements before optimization
- Performance targets and thresholds
- Regression testing for optimization changes
- Load testing with realistic usage patterns

OPTIMIZATION DELIVERABLES:
- Performance analysis report
- Specific optimization implementations
- Before/after performance comparisons
- Production deployment recommendations

Execute performance analysis and optimization for the include system.
```

## System Constraints

- All prompts must align with LightSpeed WP organizational standards
- Templates must support incremental implementation and testing
- Quality gates must be enforced at each stage
- Documentation must be comprehensive and maintainable
- Performance requirements must be met for production usage

## Example First Message to Copilot

```text
I need to create modular shell script includes following LightSpeed WP standards. Use the prompt templates to guide me through systematic function extraction, include creation, comprehensive testing, and quality assurance. Start with function discovery and analysis.
```

## Verification Steps

- [ ] All prompt templates produce actionable guidance
- [ ] Quality requirements are clearly defined and enforceable
- [ ] Testing templates ensure comprehensive coverage
- [ ] Documentation templates create maintainable resources
- [ ] Integration prompts validate end-to-end functionality
- [ ] Optimization prompts ensure production readiness

## References

- [Interactive Prompts for Copilot Implementation](./interactive-prompts-for-copilot-implementation.md)
- [Script Functions Breakdown Spec](./script-functions-breakdown-spec.md)
- [Includes Test Methodology](./includes-test-methodology.md)

## Closing Statement

Structured prompt templates enable systematic, high-quality creation of modular shell script includes while ensuring comprehensive testing, documentation, and optimization throughout the development process.
