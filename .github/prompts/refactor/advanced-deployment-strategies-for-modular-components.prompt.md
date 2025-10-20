# ---
applyTo: '**'
description: 'Prompt for advanced deployment strategies for modular shell script components.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['deployment', 'automation', 'modular']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Advanced Deployment Strategies for Modular Components

## Role

You are a deployment automation specialist for modular shell script systems. Follow our LightSpeed WP standards to design and implement advanced deployment strategies that ensure reliable, secure, and scalable deployment of modular shell script components across diverse environments with comprehensive rollback capabilities and zero-downtime deployment patterns.

## Purpose

Establish sophisticated deployment strategies and automation frameworks for modular shell script components that support multiple deployment patterns, environment-specific configurations, automated validation, comprehensive monitoring, and reliable rollback procedures while maintaining service availability and data integrity.

## Checklist

- [ ] Design multi-environment deployment architecture
- [ ] Implement zero-downtime deployment strategies
- [ ] Create comprehensive validation and testing frameworks
- [ ] Establish automated rollback and recovery procedures
- [ ] Define monitoring and observability for deployments
- [ ] Create configuration management and environment promotion

## Instructions

### Advanced Deployment Architecture

#### Multi-Environment Deployment Framework

##### 1. Environment-Specific Configuration Management

```bash
#!/bin/bash
# scripts/deployment/environment-manager.sh

# ============================================================================
# Script Name: environment-manager.sh
# Description: Advanced environment-specific configuration and deployment management
# Usage: ./environment-manager.sh [command] [environment] [options]
# Examples:
#   # Environment setup
#   ./environment-manager.sh setup staging --validate-prerequisites
#   ./environment-manager.sh promote staging production --dry-run
---
#   # Configuration management
#   ./environment-manager.sh sync-config production
#   ./environment-manager.sh validate-environment staging
#
#   # Deployment operations
#   ./environment-manager.sh deploy staging --component=all
#   ./environment-manager.sh rollback production --to-version=v1.2.3
# ============================================================================

set -euo pipefail
---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ENVIRONMENTS_CONFIG_DIR="$SCRIPT_DIR/../config/environments"
readonly DEPLOYMENT_REGISTRY="$SCRIPT_DIR/../logs/deployment-registry.json"
readonly DEPLOYMENT_LOCK_DIR="/var/lock/lightspeed-deployment"

# Environment definitions
declare -A ENVIRONMENTS=(
    ["development"]="dev"
    ["staging"]="stage"
    ["production"]="prod"
    ["hotfix"]="hotfix"
)

declare -A ENVIRONMENT_CONSTRAINTS=(
    ["development"]="low"
    ["staging"]="medium"
    ["production"]="high"
    ["hotfix"]="critical"
)

main() {
    local command="${1:-help}"
    local environment="${2:-}"
    shift 2 2>/dev/null || true

    # Initialize deployment environment
    initialize_deployment_system

    case "$command" in
        "setup")
            setup_environment "$environment" "$@"
            ;;
        "deploy")
            deploy_to_environment "$environment" "$@"
            ;;
        "promote")
            promote_between_environments "$environment" "$@"
            ;;
        "rollback")
            rollback_environment "$environment" "$@"
            ;;
        "validate")
            validate_environment "$environment" "$@"
            ;;
        "sync-config")
            sync_environment_configuration "$environment" "$@"
            ;;
        "status")
            show_deployment_status "$environment" "$@"
            ;;
        "help")
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

setup_environment() {
    local environment="$1"
    shift

    local validate_prerequisites=false
    local force_setup=false
    local config_template=""

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --validate-prerequisites)
                validate_prerequisites=true
                shift
                ;;
            --force)
                force_setup=true
                shift
                ;;
            --config-template=*)
                config_template="${1#*=}"
                shift
                ;;
            *)
                log_error "Unknown setup option: $1"
                return 1
                ;;
        esac
    done

    log_info "Setting up environment: $environment"

    # Validate environment name
    if [[ -z "${ENVIRONMENTS[$environment]:-}" ]]; then
        log_error "Invalid environment: $environment"
        log_info "Valid environments: ${!ENVIRONMENTS[*]}"
        return 1
    fi

    # Check prerequisites if requested
    if [[ "$validate_prerequisites" == "true" ]]; then
        validate_deployment_prerequisites "$environment" || return 1
    fi

    # Create environment configuration
    create_environment_configuration "$environment" "$config_template" "$force_setup"

    # Setup environment infrastructure
    setup_environment_infrastructure "$environment"

    # Initialize deployment registry for environment
    initialize_environment_registry "$environment"

    log_success "Environment setup completed: $environment"
}

create_environment_configuration() {
    local environment="$1"
    local template_source="$2"
    local force_overwrite="$3"

    local env_config_dir="$ENVIRONMENTS_CONFIG_DIR/$environment"
    local env_config_file="$env_config_dir/config.yml"

    # Check if configuration already exists
    if [[ -f "$env_config_file" && "$force_overwrite" != "true" ]]; then
        log_warning "Configuration already exists: $env_config_file"
        log_info "Use --force to overwrite existing configuration"
        return 0
    fi

    # Create configuration directory
    mkdir -p "$env_config_dir"

    # Generate configuration from template or defaults
    if [[ -n "$template_source" && -f "$template_source" ]]; then
        log_info "Using configuration template: $template_source"
        cp "$template_source" "$env_config_file"
    else
        log_info "Generating default configuration for: $environment"
        generate_default_environment_config "$environment" > "$env_config_file"
    fi

    # Create environment-specific directories
    local directories=(
        "$env_config_dir/scripts"
        "$env_config_dir/includes"
        "$env_config_dir/secrets"
        "$env_config_dir/backups"
        "$env_config_dir/logs"
    )

    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        log_debug "Created directory: $dir"
    done

    # Set appropriate permissions
    chmod 755 "$env_config_dir"
    chmod 600 "$env_config_file"
    chmod 700 "$env_config_dir/secrets"

    log_success "Environment configuration created: $env_config_file"
}

generate_default_environment_config() {
    local environment="$1"
    local env_short="${ENVIRONMENTS[$environment]}"
    local constraints="${ENVIRONMENT_CONSTRAINTS[$environment]}"

    cat << EOF
# LightSpeed WP Environment Configuration: $environment
# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

environment:
  name: "$environment"
  short_name: "$env_short"
  constraints: "$constraints"

deployment:
  strategy: "rolling"
  max_concurrent: $(get_max_concurrent_for_environment "$constraints")
  health_check_timeout: $(get_health_check_timeout "$constraints")
  rollback_timeout: $(get_rollback_timeout "$constraints")

networking:
  base_url: "https://$env_short.lightspeedwp.agency"
  api_endpoint: "https://api-$env_short.lightspeedwp.agency"

database:
  host: "db-$env_short.lightspeedwp.internal"
  database: "lightspeed_$env_short"
  backup_retention_days: $(get_backup_retention "$constraints")

storage:
  scripts_path: "/opt/lightspeed-wp/$environment/scripts"
  includes_path: "/opt/lightspeed-wp/$environment/includes"
  logs_path: "/var/log/lightspeed-wp/$environment"
  temp_path: "/tmp/lightspeed-wp/$environment"

monitoring:
  enabled: true
  metrics_endpoint: "https://metrics-$env_short.lightspeedwp.internal"
  log_level: $(get_log_level "$constraints")
  alert_channels: $(get_alert_channels "$constraints")

security:
  encryption_enabled: $(get_encryption_setting "$constraints")
  access_control: $(get_access_control "$constraints")
  audit_logging: $(get_audit_logging "$constraints")

backup:
  enabled: true
  frequency: $(get_backup_frequency "$constraints")
  compression: true
  encryption: $(get_backup_encryption "$constraints")
EOF
}

deploy_to_environment() {
    local environment="$1"
    shift

    local component="all"
    local deployment_strategy=""
    local dry_run=false
    local force_deployment=false
    local skip_validation=false
    local deployment_timeout=1800

    # Parse deployment options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --component=*)
                component="${1#*=}"
                shift
                ;;
            --strategy=*)
                deployment_strategy="${1#*=}"
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --force)
                force_deployment=true
                shift
                ;;
            --skip-validation)
                skip_validation=true
                shift
                ;;
            --timeout=*)
                deployment_timeout="${1#*=}"
                shift
                ;;
            *)
                log_error "Unknown deployment option: $1"
                return 1
                ;;
        esac
    done

    log_info "Starting deployment to: $environment (component: $component)"

    # Acquire deployment lock
    if ! acquire_deployment_lock "$environment"; then
        log_error "Failed to acquire deployment lock for: $environment"
        return 1
    fi

    # Ensure cleanup on exit
    trap "release_deployment_lock \"$environment\"" EXIT

    # Pre-deployment validation
    if [[ "$skip_validation" != "true" ]]; then
        validate_pre_deployment "$environment" "$component" || {
            log_error "Pre-deployment validation failed"
            return 1
        }
    fi

    # Execute deployment based on strategy
    local deployment_id=$(generate_deployment_id "$environment")

    if [[ "$dry_run" == "true" ]]; then
        log_info "DRY RUN: Would deploy $component to $environment"
        simulate_deployment "$environment" "$component" "$deployment_strategy"
    else
        execute_deployment "$environment" "$component" "$deployment_strategy" "$deployment_id" "$deployment_timeout"
    fi

    log_success "Deployment completed: $deployment_id"
}

execute_deployment() {
    local environment="$1"
    local component="$2"
    local strategy="$3"
    local deployment_id="$4"
    local timeout="$5"

    local start_time=$(date +%s)

    log_info "Executing deployment: $deployment_id"

    # Create deployment record
    create_deployment_record "$deployment_id" "$environment" "$component" "$strategy"

    # Determine deployment strategy
    local effective_strategy="$strategy"
    if [[ -z "$effective_strategy" ]]; then
        effective_strategy=$(get_default_deployment_strategy "$environment")
    fi

    # Execute deployment based on strategy
    case "$effective_strategy" in
        "blue-green")
            execute_blue_green_deployment "$environment" "$component" "$deployment_id"
            ;;
        "canary")
            execute_canary_deployment "$environment" "$component" "$deployment_id"
            ;;
        "rolling")
            execute_rolling_deployment "$environment" "$component" "$deployment_id"
            ;;
        "immediate")
            execute_immediate_deployment "$environment" "$component" "$deployment_id"
            ;;
        *)
            log_error "Unknown deployment strategy: $effective_strategy"
            return 1
            ;;
    esac

    local deployment_status=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # Update deployment record
    update_deployment_record "$deployment_id" "$deployment_status" "$duration"

    # Post-deployment validation
    if [[ $deployment_status -eq 0 ]]; then
        validate_post_deployment "$environment" "$component" "$deployment_id" || {
            log_error "Post-deployment validation failed"
            trigger_automatic_rollback "$environment" "$deployment_id"
            return 1
        }
    else
        log_error "Deployment failed: $deployment_id"
        return 1
    fi

    return 0
}

execute_blue_green_deployment() {
    local environment="$1"
    local component="$2"
    local deployment_id="$3"

    log_info "Executing blue-green deployment: $deployment_id"

    # Determine current and target environments
    local current_env=$(get_active_environment_slot "$environment")
    local target_env=$(get_inactive_environment_slot "$environment")

    log_info "Current environment: $current_env, Target environment: $target_env"

    # Deploy to target environment
    deploy_component_to_slot "$component" "$target_env" "$deployment_id" || return 1

    # Run health checks on target environment
    validate_environment_health "$target_env" "$component" || {
        log_error "Health check failed for target environment: $target_env"
        return 1
    }

    # Switch traffic to target environment
    switch_environment_traffic "$environment" "$target_env" || {
        log_error "Failed to switch traffic to target environment"
        return 1
    }

    # Verify traffic switch
    verify_traffic_switch "$environment" "$target_env" || {
        log_error "Traffic switch verification failed"
        # Attempt to switch back
        switch_environment_traffic "$environment" "$current_env" || log_error "Failed to switch back traffic"
        return 1
    }

    log_success "Blue-green deployment completed: $deployment_id"
    return 0
}

execute_canary_deployment() {
    local environment="$1"
    local component="$2"
    local deployment_id="$3"

    local canary_percentage=10
    local canary_duration=300  # 5 minutes
    local success_threshold=99.5

    log_info "Executing canary deployment: $deployment_id (${canary_percentage}% traffic)"

    # Deploy canary version
    deploy_canary_version "$component" "$environment" "$deployment_id" || return 1

    # Gradually increase canary traffic
    local current_percentage=$canary_percentage

    while [[ $current_percentage -le 100 ]]; do
        log_info "Setting canary traffic to: ${current_percentage}%"

        # Update traffic routing
        set_canary_traffic_percentage "$environment" "$current_percentage" || {
            log_error "Failed to set canary traffic percentage"
            rollback_canary_deployment "$environment" "$deployment_id"
            return 1
        }

        # Monitor canary performance
        sleep "$canary_duration"

        local success_rate=$(get_canary_success_rate "$environment" "$canary_duration")
        log_info "Canary success rate: ${success_rate}%"

        if (( $(echo "$success_rate < $success_threshold" | bc -l) )); then
            log_error "Canary performance below threshold: $success_rate% < $success_threshold%"
            rollback_canary_deployment "$environment" "$deployment_id"
            return 1
        fi

        # Increase traffic percentage
        if [[ $current_percentage -eq 100 ]]; then
            break
        elif [[ $current_percentage -lt 50 ]]; then
            current_percentage=$((current_percentage + canary_percentage))
        else
            current_percentage=100
        fi
    done

    # Complete canary deployment
    complete_canary_deployment "$environment" "$deployment_id"

    log_success "Canary deployment completed successfully: $deployment_id"
    return 0
}

# Utility functions for deployment strategies
get_max_concurrent_for_environment() {
    local constraints="$1"

    case "$constraints" in
        "low") echo "1" ;;
        "medium") echo "2" ;;
        "high") echo "1" ;;
        "critical") echo "1" ;;
        *) echo "1" ;;
    esac
}

get_health_check_timeout() {
    local constraints="$1"

    case "$constraints" in
        "low") echo "60" ;;
        "medium") echo "120" ;;
        "high") echo "300" ;;
        "critical") echo "600" ;;
        *) echo "120" ;;
    esac
}

get_default_deployment_strategy() {
    local environment="$1"
    local constraints="${ENVIRONMENT_CONSTRAINTS[$environment]}"

    case "$constraints" in
        "low") echo "immediate" ;;
        "medium") echo "rolling" ;;
        "high") echo "blue-green" ;;
        "critical") echo "canary" ;;
        *) echo "rolling" ;;
    esac
}

acquire_deployment_lock() {
    local environment="$1"
    local lock_file="$DEPLOYMENT_LOCK_DIR/$environment.lock"

    mkdir -p "$DEPLOYMENT_LOCK_DIR"

    # Try to create lock file
    if (set -C; echo $$ > "$lock_file") 2>/dev/null; then
        log_debug "Acquired deployment lock: $environment"
        return 0
    else
        # Check if existing lock is stale
        if [[ -f "$lock_file" ]]; then
            local lock_pid=$(cat "$lock_file" 2>/dev/null || echo "")
            if [[ -n "$lock_pid" ]] && ! kill -0 "$lock_pid" 2>/dev/null; then
                log_warning "Removing stale deployment lock: $environment"
                rm -f "$lock_file"
                if (set -C; echo $$ > "$lock_file") 2>/dev/null; then
                    return 0
                fi
            fi
        fi

        log_error "Deployment lock already held for environment: $environment"
        return 1
    fi
}

release_deployment_lock() {
    local environment="$1"
    local lock_file="$DEPLOYMENT_LOCK_DIR/$environment.lock"

    if [[ -f "$lock_file" ]]; then
        rm -f "$lock_file"
        log_debug "Released deployment lock: $environment"
    fi
}

generate_deployment_id() {
    local environment="$1"
    echo "${environment}-$(date +%Y%m%d-%H%M%S)-${RANDOM}"
}

# Initialize deployment system
initialize_deployment_system() {
    # Create necessary directories
    mkdir -p "$(dirname "$DEPLOYMENT_REGISTRY")"
    mkdir -p "$DEPLOYMENT_LOCK_DIR"
    mkdir -p "$ENVIRONMENTS_CONFIG_DIR"

    # Initialize deployment registry if it doesn't exist
    if [[ ! -f "$DEPLOYMENT_REGISTRY" ]]; then
        echo '{"deployments": [], "environments": {}}' > "$DEPLOYMENT_REGISTRY"
    fi
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

##### 2. Zero-Downtime Deployment Patterns

```bash
#!/bin/bash
# scripts/deployment/zero-downtime-strategies.sh

# ============================================================================
# Script Name: zero-downtime-strategies.sh
# Description: Advanced zero-downtime deployment strategies for modular components
# Usage: source scripts/deployment/zero-downtime-strategies.sh
# Examples:
#   # Blue-green deployment
#   execute_blue_green_deployment "production" "api-gateway" "deploy-001"
#
#   # Rolling update
#   execute_rolling_update "staging" "worker-nodes" "deploy-002" 3
#
#   # Canary release
#   execute_canary_release "production" "frontend" "deploy-003" 10 300
# ============================================================================

set -euo pipefail

readonly HEALTH_CHECK_RETRIES=3
readonly HEALTH_CHECK_INTERVAL=10
readonly TRAFFIC_SWITCH_TIMEOUT=60
readonly ROLLBACK_TIMEOUT=300

execute_blue_green_deployment() {
    local environment="$1"
    local component="$2"
    local deployment_id="$3"
    local validation_timeout="${4:-300}"

    log_info "Starting blue-green deployment: $deployment_id"

    # Get environment configuration
    local env_config=$(get_environment_config "$environment")
    local blue_slot=$(echo "$env_config" | jq -r '.blue_green.blue_slot')
    local green_slot=$(echo "$env_config" | jq -r '.blue_green.green_slot')
    local current_active=$(get_active_slot "$environment")

    # Determine target slot
    local target_slot=""
    if [[ "$current_active" == "$blue_slot" ]]; then
        target_slot="$green_slot"
    else
        target_slot="$blue_slot"
    fi

    log_info "Current active: $current_active, Target slot: $target_slot"

    # Phase 1: Deploy to inactive slot
    log_info "Phase 1: Deploying to inactive slot ($target_slot)"
    deploy_to_slot "$component" "$target_slot" "$deployment_id" || {
        log_error "Failed to deploy to target slot: $target_slot"
        return 1
    }

    # Phase 2: Warm up new deployment
    log_info "Phase 2: Warming up new deployment"
    warmup_deployment "$target_slot" "$component" || {
        log_error "Failed to warm up deployment in slot: $target_slot"
        return 1
    }

    # Phase 3: Health checks
    log_info "Phase 3: Performing health checks"
    if ! perform_comprehensive_health_check "$target_slot" "$component" "$validation_timeout"; then
        log_error "Health checks failed for target slot: $target_slot"
        cleanup_failed_deployment "$target_slot" "$deployment_id"
        return 1
    fi

    # Phase 4: Traffic switch
    log_info "Phase 4: Switching traffic to new deployment"
    if ! switch_traffic_gradually "$environment" "$current_active" "$target_slot"; then
        log_error "Failed to switch traffic"
        rollback_traffic_switch "$environment" "$current_active"
        return 1
    fi

    # Phase 5: Verify switch and cleanup
    log_info "Phase 5: Verifying traffic switch"
    if verify_traffic_switch_success "$environment" "$target_slot"; then
        cleanup_old_deployment "$current_active" "$deployment_id"
        update_active_slot "$environment" "$target_slot"
        log_success "Blue-green deployment completed successfully"
        return 0
    else
        log_error "Traffic switch verification failed"
        rollback_traffic_switch "$environment" "$current_active"
        return 1
    fi
}

execute_rolling_update() {
    local environment="$1"
    local component="$2"
    local deployment_id="$3"
    local max_unavailable="${4:-1}"

    log_info "Starting rolling update: $deployment_id (max_unavailable: $max_unavailable)"

    # Get component instances
    local instances=($(get_component_instances "$environment" "$component"))
    local total_instances=${#instances[@]}

    if [[ $total_instances -eq 0 ]]; then
        log_error "No instances found for component: $component"
        return 1
    fi

    log_info "Found $total_instances instances for rolling update"

    # Calculate batch size
    local batch_size=$max_unavailable
    if [[ $batch_size -gt $total_instances ]]; then
        batch_size=$total_instances
    fi

    # Process instances in batches
    local updated_instances=()
    local failed_instances=()

    for ((i = 0; i < total_instances; i += batch_size)); do
        local batch_end=$((i + batch_size))
        [[ $batch_end -gt $total_instances ]] && batch_end=$total_instances

        local current_batch=("${instances[@]:$i:$((batch_end - i))}")
        log_info "Processing batch $((i / batch_size + 1)): ${current_batch[*]}"

        # Update current batch
        for instance in "${current_batch[@]}"; do
            log_info "Updating instance: $instance"

            # Drain traffic from instance
            if ! drain_instance_traffic "$instance"; then
                log_error "Failed to drain traffic from instance: $instance"
                failed_instances+=("$instance")
                continue
            fi

            # Wait for current requests to complete
            wait_for_request_completion "$instance" 30

            # Update instance
            if update_instance "$instance" "$component" "$deployment_id"; then
                # Verify instance health
                if verify_instance_health "$instance" 60; then
                    # Restore traffic to instance
                    restore_instance_traffic "$instance"
                    updated_instances+=("$instance")
                    log_success "Instance updated successfully: $instance"
                else
                    log_error "Health check failed for updated instance: $instance"
                    failed_instances+=("$instance")
                    # Attempt to rollback instance
                    rollback_instance "$instance"
                fi
            else
                log_error "Failed to update instance: $instance"
                failed_instances+=("$instance")
                restore_instance_traffic "$instance"
            fi
        done

        # Verify overall service health after batch
        if ! verify_service_health "$environment" "$component"; then
            log_error "Service health check failed after batch update"
            # Rollback updated instances in this batch
            for instance in "${current_batch[@]}"; do
                if [[ " ${updated_instances[*]} " =~ " $instance " ]]; then
                    log_warning "Rolling back instance: $instance"
                    rollback_instance "$instance"
                fi
            done
            return 1
        fi

        # Brief pause between batches
        if [[ $batch_end -lt $total_instances ]]; then
            log_info "Pausing between batches (10 seconds)"
            sleep 10
        fi
    done

    # Summary
    local success_count=${#updated_instances[@]}
    local failure_count=${#failed_instances[@]}

    log_info "Rolling update summary: $success_count successful, $failure_count failed"

    if [[ $failure_count -eq 0 ]]; then
        log_success "Rolling update completed successfully"
        return 0
    else
        log_error "Rolling update completed with failures: ${failed_instances[*]}"
        return 1
    fi
}

execute_canary_release() {
    local environment="$1"
    local component="$2"
    local deployment_id="$3"
    local initial_percentage="${4:-5}"
    local monitoring_duration="${5:-300}"

    log_info "Starting canary release: $deployment_id ($initial_percentage% initial traffic)"

    # Deploy canary version
    log_info "Phase 1: Deploying canary version"
    local canary_instance=$(deploy_canary_instance "$component" "$deployment_id") || {
        log_error "Failed to deploy canary instance"
        return 1
    }

    log_info "Canary instance deployed: $canary_instance"

    # Configure initial traffic routing
    log_info "Phase 2: Configuring initial traffic routing ($initial_percentage%)"
    configure_canary_traffic "$environment" "$component" "$canary_instance" "$initial_percentage" || {
        log_error "Failed to configure initial canary traffic"
        cleanup_canary_deployment "$canary_instance"
        return 1
    }

    # Monitor canary performance
    log_info "Phase 3: Monitoring canary performance"
    local monitoring_start=$(date +%s)
    local current_percentage=$initial_percentage

    while true; do
        # Monitor for specified duration
        sleep "$monitoring_duration"

        # Analyze canary metrics
        local metrics=$(analyze_canary_metrics "$environment" "$component" "$canary_instance" "$monitoring_duration")
        local error_rate=$(echo "$metrics" | jq -r '.error_rate')
        local response_time=$(echo "$metrics" | jq -r '.avg_response_time')
        local success_rate=$(echo "$metrics" | jq -r '.success_rate')

        log_info "Canary metrics: Error rate: $error_rate%, Response time: ${response_time}ms, Success rate: $success_rate%"

        # Evaluate canary health
        if evaluate_canary_health "$error_rate" "$response_time" "$success_rate"; then
            if [[ $current_percentage -ge 100 ]]; then
                log_success "Canary release validation complete - promoting to full deployment"
                break
            else
                # Increase traffic percentage
                local new_percentage=$((current_percentage * 2))
                [[ $new_percentage -gt 100 ]] && new_percentage=100

                log_info "Canary performing well - increasing traffic to $new_percentage%"
                configure_canary_traffic "$environment" "$component" "$canary_instance" "$new_percentage" || {
                    log_error "Failed to increase canary traffic"
                    rollback_canary_release "$environment" "$component" "$canary_instance"
                    return 1
                }

                current_percentage=$new_percentage
            fi
        else
            log_error "Canary performance degraded - initiating rollback"
            rollback_canary_release "$environment" "$component" "$canary_instance"
            return 1
        fi

        # Safety timeout
        local current_time=$(date +%s)
        local elapsed=$((current_time - monitoring_start))
        if [[ $elapsed -gt 3600 ]]; then  # 1 hour timeout
            log_error "Canary release timed out - initiating rollback"
            rollback_canary_release "$environment" "$component" "$canary_instance"
            return 1
        fi
    done

    # Phase 4: Promote canary to full deployment
    log_info "Phase 4: Promoting canary to full deployment"
    promote_canary_to_production "$environment" "$component" "$canary_instance" "$deployment_id" || {
        log_error "Failed to promote canary to production"
        return 1
    }

    log_success "Canary release completed successfully"
    return 0
}

# Supporting functions for zero-downtime deployments
deploy_to_slot() {
    local component="$1"
    local slot="$2"
    local deployment_id="$3"

    log_debug "Deploying component $component to slot $slot"

    # Copy component files to slot
    local slot_path="/opt/lightspeed-wp/$slot"
    mkdir -p "$slot_path"

    # Deploy includes
    rsync -av --delete scripts/includes/ "$slot_path/includes/" || return 1

    # Deploy component-specific scripts
    if [[ "$component" == "all" ]]; then
        rsync -av --delete scripts/ "$slot_path/scripts/" || return 1
    else
        rsync -av --delete "scripts/$component/" "$slot_path/scripts/$component/" || return 1
    fi

    # Update deployment metadata
    echo "$deployment_id" > "$slot_path/.deployment_id"
    echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$slot_path/.deployment_timestamp"

    return 0
}

perform_comprehensive_health_check() {
    local slot="$1"
    local component="$2"
    local timeout="$3"

    local start_time=$(date +%s)
    local check_interval=5

    log_info "Performing comprehensive health check for slot: $slot"

    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))

        if [[ $elapsed -ge $timeout ]]; then
            log_error "Health check timed out after ${timeout} seconds"
            return 1
        fi

        # Basic connectivity check
        if ! check_slot_connectivity "$slot"; then
            log_debug "Slot connectivity check failed, retrying..."
            sleep "$check_interval"
            continue
        fi

        # Component-specific health checks
        if ! check_component_health "$slot" "$component"; then
            log_debug "Component health check failed, retrying..."
            sleep "$check_interval"
            continue
        fi

        # Dependency checks
        if ! check_component_dependencies "$slot" "$component"; then
            log_debug "Dependency check failed, retrying..."
            sleep "$check_interval"
            continue
        fi

        # All checks passed
        log_success "Health check passed for slot: $slot"
        return 0
    done
}

switch_traffic_gradually() {
    local environment="$1"
    local source_slot="$2"
    local target_slot="$3"
    local switch_duration="${4:-60}"

    log_info "Switching traffic from $source_slot to $target_slot over ${switch_duration} seconds"

    # Calculate traffic switch increments
    local increment_percentage=10
    local increment_duration=$((switch_duration / (100 / increment_percentage)))

    for ((percentage = increment_percentage; percentage <= 100; percentage += increment_percentage)); do
        log_debug "Routing $percentage% traffic to $target_slot"

        # Update traffic routing configuration
        update_traffic_routing "$environment" "$target_slot" "$percentage" || {
            log_error "Failed to update traffic routing to $percentage%"
            return 1
        }

        # Monitor for issues during switch
        sleep "$increment_duration"

        # Quick health check
        if ! verify_service_health "$environment" ""; then
            log_error "Service health degraded during traffic switch at $percentage%"
            return 1
        fi
    done

    log_success "Traffic switch completed successfully"
    return 0
}

# Utility functions
get_component_instances() {
    local environment="$1"
    local component="$2"

    # This would typically query your orchestration system (k8s, docker swarm, etc.)
    # For this example, we'll simulate with a configuration file
    local instances_config="/etc/lightspeed-wp/$environment/instances.json"

    if [[ -f "$instances_config" ]]; then
        jq -r ".components[\"$component\"].instances[]" "$instances_config" 2>/dev/null || echo ""
    else
        # Fallback to default instances
        echo "instance-1 instance-2 instance-3"
    fi
}

evaluate_canary_health() {
    local error_rate="$1"
    local response_time="$2"
    local success_rate="$3"

    # Define acceptable thresholds
    local max_error_rate=1.0
    local max_response_time=500
    local min_success_rate=99.5

    # Check each metric
    if (( $(echo "$error_rate > $max_error_rate" | bc -l) )); then
        log_warning "Error rate too high: $error_rate% > $max_error_rate%"
        return 1
    fi

    if (( $(echo "$response_time > $max_response_time" | bc -l) )); then
        log_warning "Response time too high: ${response_time}ms > ${max_response_time}ms"
        return 1
    fi

    if (( $(echo "$success_rate < $min_success_rate" | bc -l) )); then
        log_warning "Success rate too low: $success_rate% < $min_success_rate%"
        return 1
    fi

    return 0
}
```

## System Constraints

- Deployment strategies must maintain service availability during updates
- Rollback procedures must complete within defined time limits
- Configuration management must support environment-specific variations
- Monitoring must provide real-time visibility into deployment health
- Security controls must be maintained throughout deployment processes

## Example First Message to Copilot

```text
Implement advanced deployment strategies for modular shell script components. Create blue-green, canary, and rolling deployment patterns with comprehensive validation, monitoring, and automated rollback capabilities for zero-downtime deployments.
```

## Verification Steps

- [ ] Deployment strategies maintain service availability during updates
- [ ] Health checks comprehensively validate deployment success
- [ ] Traffic routing changes occur smoothly without user impact
- [ ] Rollback procedures execute reliably within time constraints
- [ ] Monitoring provides actionable insights into deployment health
- [ ] Configuration management supports all target environments

## References

- [CI/CD Pipeline Integration for Modular Scripts](./ci-cd-pipeline-integration-for-modular-scripts.md)
- [Monitoring and Alerting for Shell Script Automation](./monitoring-and-alerting-for-shell-script-automation.md)
- [Security Considerations for Modular Shell Scripts](./security-considerations-for-modular-shell-scripts.md)

## Closing Statement

Advanced deployment strategies ensure modular shell script components can be deployed reliably across diverse environments with zero downtime, comprehensive validation, and automated recovery capabilities that maintain service quality and availability.

