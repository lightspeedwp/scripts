---
applyTo: '**'
description: 'Prompt for security considerations for modular shell script automation.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['security', 'modular', 'shell', 'automation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Security Considerations for Modular Shell Scripts

## Role

You are a security specialist for shell script automation systems. Follow our LightSpeed WP security standards to ensure modular shell script includes and automation tools maintain robust security postures, prevent vulnerabilities, and follow security best practices across all deployment scenarios.

## Purpose

Establish comprehensive security guidelines, threat modeling approaches, and defensive programming practices that ensure modular shell script components resist common attack vectors while maintaining functionality, performance, and maintainability.

## Checklist

- [ ] Define security threat model for modular shell script architecture
- [ ] Establish input validation and sanitization standards
- [ ] Implement secure file handling and path traversal prevention
- [ ] Create authentication and authorization frameworks
- [ ] Define secrets management and credential handling procedures
- [ ] Establish security testing and vulnerability assessment protocols

## Instructions

### Security Threat Model

#### Common Attack Vectors for Shell Scripts

##### Input Injection Attacks

```bash
# scripts/includes/security/input-validation.sh

# Function: sanitize_input
# Description: Sanitize user input to prevent injection attacks
# Arguments:
#   $1 - Input string to sanitize
#   $2 - Input type (filename|path|command|url|email)
# Returns: Sanitized input string
# Output: Error message if input is invalid
sanitize_input() {
    local input="$1"
    local input_type="${2:-general}"
    local sanitized=""

    # Input validation - reject empty or null input
    if [[ -z "$input" ]]; then
        log_error "sanitize_input: Input cannot be empty"
        return 1
    fi

    case "$input_type" in
        "filename")
            # Remove dangerous characters from filename
            sanitized=$(echo "$input" | tr -cd '[:alnum:]._-')

            # Prevent directory traversal
            sanitized="${sanitized//..\/}"
            sanitized="${sanitized//\.\.\\}"

            # Remove leading dots and dashes
            sanitized="${sanitized#.}"
            sanitized="${sanitized#-}"

            # Ensure filename is not empty after sanitization
            if [[ -z "$sanitized" ]]; then
                log_error "Filename becomes empty after sanitization: $input"
                return 1
            fi
            ;;

        "path")
            # Validate and sanitize file paths
            sanitized=$(realpath "$input" 2>/dev/null) || {
                log_error "Invalid path: $input"
                return 1
            }

            # Ensure path is within allowed directories
            if ! is_path_allowed "$sanitized"; then
                log_error "Path access denied: $sanitized"
                return 1
            fi
            ;;

        "command")
            # Validate command names (alphanumeric, dash, underscore only)
            if [[ ! "$input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                log_error "Invalid command format: $input"
                return 1
            fi

            # Check if command is in whitelist
            if ! is_command_allowed "$input"; then
                log_error "Command not allowed: $input"
                return 1
            fi

            sanitized="$input"
            ;;

        "url")
            # Basic URL validation and sanitization
            sanitized=$(echo "$input" | tr -cd '[:alnum:]._~:/?#[]@!$&'\''()*+,;=-')

            # Validate URL format
            if [[ ! "$sanitized" =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]]; then
                log_error "Invalid URL format: $input"
                return 1
            fi
            ;;

        "email")
            # Email validation and sanitization
            sanitized=$(echo "$input" | tr -cd '[:alnum:]@._-')

            # Validate email format
            if [[ ! "$sanitized" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                log_error "Invalid email format: $input"
                return 1
            fi
            ;;

        "general"|*)
            # General sanitization - remove dangerous characters
            sanitized=$(echo "$input" | tr -d ';&|`$(){}[]<>*?!')

            # Remove control characters
            sanitized=$(echo "$sanitized" | tr -cd '[:print:]')
            ;;
    esac

    echo "$sanitized"
    return 0
}

# Function: is_path_allowed
# Description: Check if path is within allowed directories
# Arguments: $1 - Absolute path to validate
# Returns: 0 if allowed, 1 if denied
is_path_allowed() {
    local path="$1"
    local allowed_paths=(
        "/tmp"
        "$HOME"
        "$(pwd)"
        "/usr/local/share/lightspeed-wp"
        "/opt/lightspeed-wp"
    )

    # Check if path starts with any allowed directory
    for allowed in "${allowed_paths[@]}"; do
        if [[ "$path" == "$allowed"* ]]; then
            return 0
        fi
    done

    return 1
}

# Function: is_command_allowed
# Description: Check if command is in whitelist
# Arguments: $1 - Command name to validate
# Returns: 0 if allowed, 1 if denied
is_command_allowed() {
    local command="$1"
    local allowed_commands=(
        "git" "curl" "wget" "grep" "sed" "awk"
        "find" "sort" "uniq" "head" "tail"
        "cat" "ls" "mkdir" "rm" "mv" "cp"
        "chmod" "chown" "tar" "gzip" "gunzip"
        "ssh" "scp" "rsync" "jq" "yq"
    )

    # Check if command is in whitelist
    for allowed in "${allowed_commands[@]}"; do
        if [[ "$command" == "$allowed" ]]; then
            return 0
        fi
    done

    return 1
}
```

##### Command Injection Prevention

```bash
# scripts/includes/security/safe-execution.sh

# Function: safe_execute
# Description: Safely execute commands with input validation
# Arguments:
#   $1 - Command to execute
#   $@ - Command arguments (properly quoted)
# Returns: Command exit code
# Output: Command output or error messages
safe_execute() {
    local command="$1"
    shift
    local args=("$@")

    # Validate command is allowed
    if ! is_command_allowed "$command"; then
        log_error "Command execution denied: $command"
        return 1
    fi

    # Validate command exists
    if ! command -v "$command" >/dev/null 2>&1; then
        log_error "Command not found: $command"
        return 1
    fi

    # Sanitize all arguments
    local safe_args=()
    for arg in "${args[@]}"; do
        local safe_arg
        safe_arg=$(sanitize_input "$arg" "general")
        safe_args+=("$safe_arg")
    done

    # Execute with timeout and resource limits
    timeout 30s "$command" "${safe_args[@]}"
}

# Function: safe_eval
# Description: Safely evaluate expressions with strict validation
# Arguments: $1 - Expression to evaluate
# Returns: Evaluation result
safe_eval() {
    local expression="$1"

    # Validate expression contains only safe characters
    if [[ ! "$expression" =~ ^[a-zA-Z0-9\ _=\+\-\*\/\(\)]+$ ]]; then
        log_error "Unsafe expression: $expression"
        return 1
    fi

    # Use arithmetic evaluation instead of eval
    if [[ "$expression" =~ ^[0-9\ \+\-\*\/\(\)]+$ ]]; then
        echo $(( expression ))
    else
        log_error "Expression evaluation not supported: $expression"
        return 1
    fi
}

# Function: execute_with_limits
# Description: Execute command with resource and time limits
# Arguments:
#   $1 - Command to execute
#   $2 - Time limit in seconds (default: 30)
#   $3 - Memory limit in KB (default: 10240)
execute_with_limits() {
    local command="$1"
    local time_limit="${2:-30}"
    local memory_limit="${3:-10240}"

    # Set resource limits if ulimit is available
    if command -v ulimit >/dev/null 2>&1; then
        # Set memory limit (in KB)
        ulimit -v "$memory_limit" 2>/dev/null || true

        # Set CPU time limit
        ulimit -t "$time_limit" 2>/dev/null || true

        # Limit file size (10MB)
        ulimit -f 10240 2>/dev/null || true
    fi

    # Execute with timeout
    timeout "$time_limit" bash -c "$command"
}
```

#### Secure File Operations

##### Path Traversal Prevention

```bash
# scripts/includes/security/secure-file-ops.sh

# Function: secure_file_access
# Description: Safely access files with path traversal prevention
# Arguments:
#   $1 - Base directory (must be absolute)
#   $2 - Requested file path
#   $3 - Operation type (read|write|execute)
# Returns: 0 if access allowed, 1 if denied
# Output: Resolved safe path if allowed
secure_file_access() {
    local base_dir="$1"
    local requested_path="$2"
    local operation="${3:-read}"

    # Validate base directory is absolute
    if [[ "${base_dir:0:1}" != "/" ]]; then
        log_error "Base directory must be absolute: $base_dir"
        return 1
    fi

    # Resolve the real path to prevent traversal
    local resolved_path
    if ! resolved_path=$(realpath "$base_dir/$requested_path" 2>/dev/null); then
        log_error "Cannot resolve path: $base_dir/$requested_path"
        return 1
    fi

    # Ensure resolved path is within base directory
    if [[ "$resolved_path" != "$base_dir"* ]]; then
        log_error "Path traversal attempt detected: $resolved_path not under $base_dir"
        return 1
    fi

    # Check operation permissions
    case "$operation" in
        "read")
            if [[ ! -r "$resolved_path" ]]; then
                log_error "Read permission denied: $resolved_path"
                return 1
            fi
            ;;
        "write")
            local parent_dir=$(dirname "$resolved_path")
            if [[ ! -w "$parent_dir" ]]; then
                log_error "Write permission denied: $resolved_path"
                return 1
            fi
            ;;
        "execute")
            if [[ ! -x "$resolved_path" ]]; then
                log_error "Execute permission denied: $resolved_path"
                return 1
            fi
            ;;
    esac

    echo "$resolved_path"
    return 0
}

# Function: create_secure_temp_file
# Description: Create temporary file with secure permissions
# Arguments:
#   $1 - Filename prefix (optional)
#   $2 - Directory (optional, defaults to /tmp)
# Returns: Path to created temporary file
create_secure_temp_file() {
    local prefix="${1:-lightspeed}"
    local temp_dir="${2:-/tmp}"

    # Validate temp directory
    if [[ ! -d "$temp_dir" ]] || [[ ! -w "$temp_dir" ]]; then
        log_error "Invalid temp directory: $temp_dir"
        return 1
    fi

    # Create temp file with secure permissions
    local temp_file
    temp_file=$(mktemp "$temp_dir/$prefix.XXXXXX")

    # Set secure permissions (owner read/write only)
    chmod 600 "$temp_file"

    # Schedule cleanup on exit
    trap "rm -f '$temp_file'" EXIT

    echo "$temp_file"
}

# Function: secure_file_copy
# Description: Safely copy files with validation and permission preservation
# Arguments:
#   $1 - Source file path
#   $2 - Destination path
#   $3 - Preserve permissions (true|false, default: true)
secure_file_copy() {
    local source="$1"
    local destination="$2"
    local preserve_perms="${3:-true}"

    # Validate source file exists and is readable
    if [[ ! -f "$source" ]] || [[ ! -r "$source" ]]; then
        log_error "Source file not accessible: $source"
        return 1
    fi

    # Validate destination directory is writable
    local dest_dir=$(dirname "$destination")
    if [[ ! -d "$dest_dir" ]] || [[ ! -w "$dest_dir" ]]; then
        log_error "Destination directory not writable: $dest_dir"
        return 1
    fi

    # Perform secure copy
    if [[ "$preserve_perms" == "true" ]]; then
        cp -p "$source" "$destination"
    else
        cp "$source" "$destination"
        chmod 644 "$destination"  # Set safe default permissions
    fi

    # Verify copy was successful
    if ! cmp -s "$source" "$destination"; then
        log_error "File copy verification failed: $source -> $destination"
        rm -f "$destination"
        return 1
    fi

    log_debug "Secure file copy completed: $source -> $destination"
}
```

### Secrets Management

#### Secure Credential Handling

```bash
# scripts/includes/security/secrets-management.sh

# Function: load_secrets
# Description: Safely load secrets from environment or secure files
# Arguments:
#   $1 - Secrets file path (optional)
# Output: Sets environment variables for loaded secrets
load_secrets() {
    local secrets_file="${1:-$HOME/.lightspeed-wp/secrets}"

    # Check if secrets file exists and has secure permissions
    if [[ -f "$secrets_file" ]]; then
        # Verify file permissions (600 or 400)
        local file_perms=$(stat -f %A "$secrets_file" 2>/dev/null || stat -c %a "$secrets_file" 2>/dev/null)

        if [[ "$file_perms" != "600" ]] && [[ "$file_perms" != "400" ]]; then
            log_error "Insecure permissions on secrets file: $secrets_file ($file_perms)"
            log_info "Expected permissions: 600 (rw-------) or 400 (r-------)"
            return 1
        fi

        # Load secrets from file
        while IFS='=' read -r key value; do
            # Skip empty lines and comments
            [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue

            # Validate key format (alphanumeric and underscore only)
            if [[ ! "$key" =~ ^[A-Z_][A-Z0-9_]*$ ]]; then
                log_warning "Invalid secret key format: $key"
                continue
            fi

            # Set environment variable
            export "$key=$value"
            log_debug "Loaded secret: $key"

        done < "$secrets_file"
    fi

    # Validate required secrets are present
    validate_required_secrets
}

# Function: validate_required_secrets
# Description: Ensure all required secrets are available
validate_required_secrets() {
    local required_secrets=(
        "GITHUB_TOKEN"
        "LIGHTSPEED_API_KEY"
    )

    local missing_secrets=()

    for secret in "${required_secrets[@]}"; do
        if [[ -z "${!secret:-}" ]]; then
            missing_secrets+=("$secret")
        fi
    done

    if [[ ${#missing_secrets[@]} -gt 0 ]]; then
        log_error "Missing required secrets: ${missing_secrets[*]}"
        log_info "Set secrets via environment variables or ~/.lightspeed-wp/secrets file"
        return 1
    fi

    log_debug "All required secrets are available"
}

# Function: mask_secret
# Description: Mask secret values in logs and output
# Arguments: $1 - String potentially containing secrets
# Output: String with secrets masked
mask_secret() {
    local input="$1"
    local masked="$input"

    # List of secret patterns to mask
    local secret_patterns=(
        # GitHub tokens
        's/ghp_[A-Za-z0-9_]{36}/ghp_***MASKED***/g'
        # AWS keys
        's/AKIA[0-9A-Z]{16}/AKIA***MASKED***/g'
        # Generic API keys (32+ alphanumeric chars)
        's/[A-Za-z0-9]{32,}/***MASKED***/g'
        # URLs with credentials
        's|://[^:/@]+:[^:/@]+@|://***:***@|g'
    )

    # Apply masking patterns
    for pattern in "${secret_patterns[@]}"; do
        masked=$(echo "$masked" | sed "$pattern")
    done

    echo "$masked"
}

# Function: secure_cleanup
# Description: Securely clean up sensitive data
secure_cleanup() {
    # Clear sensitive environment variables
    local sensitive_vars=(
        "GITHUB_TOKEN" "LIGHTSPEED_API_KEY" "AWS_ACCESS_KEY_ID"
        "AWS_SECRET_ACCESS_KEY" "PASSWORD" "PASSPHRASE"
    )

    for var in "${sensitive_vars[@]}"; do
        unset "$var" 2>/dev/null || true
    done

    # Clear bash history of sensitive commands
    if [[ -n "${HISTFILE:-}" ]] && [[ -f "$HISTFILE" ]]; then
        # Remove lines containing sensitive patterns
        sed -i.bak '/export.*PASSWORD\|export.*TOKEN\|export.*KEY/d' "$HISTFILE" 2>/dev/null || true
    fi

    # Clear temporary files
    find /tmp -name "lightspeed-*-$$" -type f -exec shred -f {} \; 2>/dev/null || true

    log_debug "Secure cleanup completed"
}
```

### Security Testing Framework

#### Vulnerability Assessment

```bash
# scripts/security/security-audit.sh

#!/bin/bash

# Security audit script for modular shell scripts
run_security_audit() {
    local audit_report="security-audit-$(date +%Y%m%d-%H%M%S).json"
    local findings=()

    log_info "Starting security audit"

    # Initialize audit report
    cat > "$audit_report" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "version": "1.0",
    "findings": []
}
EOF

    # Run security checks
    check_file_permissions
    check_hardcoded_secrets
    check_input_validation
    check_command_injection_risks
    check_path_traversal_risks
    check_insecure_temp_files

    # Generate final report
    generate_security_report "$audit_report"

    log_info "Security audit completed: $audit_report"
}

check_file_permissions() {
    log_info "Checking file permissions"

    # Check for world-writable files
    while IFS= read -r -d '' file; do
        if [[ -w "$file" ]]; then
            add_finding "MEDIUM" "World-writable file" "$file" \
                "File has world-writable permissions, potential security risk"
        fi
    done < <(find scripts/ -type f -perm -002 -print0 2>/dev/null)

    # Check for executable files without proper shebang
    while IFS= read -r -d '' file; do
        if [[ -x "$file" ]] && ! head -1 "$file" | grep -q '^#!/'; then
            add_finding "LOW" "Executable without shebang" "$file" \
                "Executable file missing proper shebang line"
        fi
    done < <(find scripts/ -type f -executable -print0 2>/dev/null)
}

check_hardcoded_secrets() {
    log_info "Scanning for hardcoded secrets"

    # Patterns for common secrets
    local secret_patterns=(
        'password[[:space:]]*=[[:space:]]*"[^"]{8,}"'
        'token[[:space:]]*=[[:space:]]*"[^"]{20,}"'
        'api[_-]?key[[:space:]]*=[[:space:]]*"[^"]{16,}"'
        'secret[[:space:]]*=[[:space:]]*"[^"]{12,}"'
        '[A-Za-z0-9+/]{40,}={0,2}'  # Base64 encoded data
    )

    for pattern in "${secret_patterns[@]}"; do
        while IFS=: read -r file line_num line_content; do
            add_finding "HIGH" "Potential hardcoded secret" "$file:$line_num" \
                "Possible secret found: $(echo "$line_content" | head -c 50)..."
        done < <(grep -rn -i "$pattern" scripts/ 2>/dev/null || true)
    done
}

check_input_validation() {
    log_info "Checking input validation"

    # Look for direct use of user input without validation
    local dangerous_patterns=(
        '\$[1-9]\+\|${[^}]*}'  # Direct parameter usage
        'eval.*\$'             # Eval with variables
        'sh.*\$\|bash.*\$'     # Shell execution with variables
    )

    for pattern in "${dangerous_patterns[@]}"; do
        while IFS=: read -r file line_num line_content; do
            # Skip if line is in a validation function or contains sanitization
            if echo "$line_content" | grep -q 'sanitize\|validate\|check_input'; then
                continue
            fi

            add_finding "MEDIUM" "Unvalidated input usage" "$file:$line_num" \
                "Direct use of input without validation: $line_content"
        done < <(grep -rn "$pattern" scripts/ 2>/dev/null || true)
    done
}

add_finding() {
    local severity="$1"
    local title="$2"
    local location="$3"
    local description="$4"

    # Add finding to report
    jq --arg sev "$severity" \
       --arg title "$title" \
       --arg loc "$location" \
       --arg desc "$description" \
       '.findings += [{
           "severity": $sev,
           "title": $title,
           "location": $loc,
           "description": $desc,
           "timestamp": now | strftime("%Y-%m-%dT%H:%M:%SZ")
       }]' "$audit_report" > "$audit_report.tmp" && mv "$audit_report.tmp" "$audit_report"
}
```

### Compliance and Standards

#### Security Compliance Framework

```bash
# scripts/security/compliance-check.sh

check_security_compliance() {
    local compliance_standards=("OWASP" "CIS" "NIST")
    local compliance_report="compliance-$(date +%Y%m%d-%H%M%S).json"

    # Initialize compliance report
    cat > "$compliance_report" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "standards": {}
}
EOF

    for standard in "${compliance_standards[@]}"; do
        check_standard_compliance "$standard" "$compliance_report"
    done

    log_info "Compliance check completed: $compliance_report"
}

check_standard_compliance() {
    local standard="$1"
    local report_file="$2"

    case "$standard" in
        "OWASP")
            check_owasp_top10 "$report_file"
            ;;
        "CIS")
            check_cis_controls "$report_file"
            ;;
        "NIST")
            check_nist_framework "$report_file"
            ;;
    esac
}

check_owasp_top10() {
    local report_file="$1"
    local owasp_checks=(
        "injection:check_injection_prevention"
        "broken_auth:check_authentication_security"
        "sensitive_data:check_data_protection"
        "xxe:check_xml_security"
        "broken_access:check_access_controls"
        "security_misconfig:check_security_configuration"
        "xss:check_output_encoding"
        "insecure_deserial:check_deserialization_security"
        "known_vulns:check_dependency_vulnerabilities"
        "insufficient_log:check_logging_security"
    )

    local owasp_results=()

    for check in "${owasp_checks[@]}"; do
        local vuln_type="${check%:*}"
        local check_func="${check#*:}"

        local result
        if result=$($check_func); then
            owasp_results+=("\"$vuln_type\": {\"status\": \"PASS\", \"details\": \"$result\"}")
        else
            owasp_results+=("\"$vuln_type\": {\"status\": \"FAIL\", \"details\": \"$result\"}")
        fi
    done

    # Update compliance report
    local owasp_json=$(printf '%s\n' "${owasp_results[@]}" | tr '\n' ',' | sed 's/,$//')
    jq ".standards.OWASP = {$owasp_json}" "$report_file" > "$report_file.tmp" && \
        mv "$report_file.tmp" "$report_file"
}
```

## System Constraints

- Security measures must not significantly impact performance
- All security checks must be automatable and integrable with CI/CD
- Security policies must be configurable for different environments
- Audit trails must be comprehensive and tamper-resistant
- Compliance reporting must be accurate and verifiable

## Example First Message to Copilot

```text
Implement comprehensive security framework for the modular shell script architecture. Focus on input validation, secure file operations, secrets management, and vulnerability prevention while maintaining usability and performance.
```

## Verification Steps

- [ ] Threat model covers all relevant attack vectors
- [ ] Input validation prevents injection attacks effectively
- [ ] File operations resist path traversal attacks
- [ ] Secrets management follows industry best practices
- [ ] Security testing identifies real vulnerabilities
- [ ] Compliance checks validate adherence to security standards

## References

- [Specific Implementation Examples](./specific-implementation-examples-for-each-component.md)
- [Performance and Optimization Guidelines](./github-copilot-performance-and-optimization-guidelines.md)
- [Security Guidelines](../.github/instructions/wordpress.instructions.md#security-patterns)

## Closing Statement

Comprehensive security implementation ensures modular shell script components resist common attack vectors while maintaining functionality and performance, providing developers with secure-by-default automation tools that meet enterprise security requirements.
