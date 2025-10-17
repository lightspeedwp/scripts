---
applyTo: '**'
description: 'Prompt for Copilot performance and optimization guidelines for shell script automation.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['copilot', 'performance', 'optimization', 'shell']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# GitHub Copilot Performance and Optimization Guidelines

## Role

You are a performance optimization specialist for shell script automation. Follow our LightSpeed WP standards to ensure modular shell script includes and automation tools operate efficiently, scale effectively, and maintain optimal resource usage across diverse deployment environments.

## Purpose

Establish comprehensive performance guidelines, optimization strategies, and monitoring approaches that ensure modular shell script components deliver optimal execution speed, memory efficiency, and resource utilization while maintaining code quality and maintainability.

## Checklist


## Current Repository State & Action Items

- Modular includes present: `common-functions.sh`, `git-functions.sh` in `scripts/includes/`. Additional includes recommended for full optimization coverage.
- Folder structure: `/scripts/project/` and `/tests/project-scripts/` currently used; planned renaming for consistency.
- Monitoring and profiling scripts are not yet implemented; add in future updates.
- Performance benchmarks and optimization strategies should be documented in README files and implemented in includes.

**Action:** Expand includes, add monitoring/profiling scripts, document performance benchmarks, and update folder names for consistency.
- [ ] Create performance regression testing frameworks

## Instructions

### Performance Benchmarking Framework

#### Baseline Performance Metrics

##### Include Function Performance Standards

```bash
# Performance targets for core include functions
PERFORMANCE_TARGETS=(
    # Function type: max_execution_time_ms
    "logging:5"
    "validation:10"
    "file_operations:50"
    "git_operations:200"
    "network_operations:1000"
    "complex_processing:5000"
)

# Resource usage limits
MAX_MEMORY_USAGE_KB=1024      # 1MB max per include
MAX_SUBPROCESS_COUNT=5        # Limit concurrent processes
MAX_FILE_DESCRIPTORS=20       # Limit open file handles
MAX_EXECUTION_TIME_SEC=30     # Overall script timeout
```

##### Benchmarking Infrastructure

```bash
#!/bin/bash
# scripts/performance/benchmark-framework.sh

# Function: benchmark_function
# Description: Measure execution time and resource usage for a function
# Arguments:
#   $1 - Function name to benchmark
#   $2 - Number of iterations (default: 100)
#   $3 - Test parameters (optional)
# Output: Performance metrics in JSON format
benchmark_function() {
    local function_name="$1"
    local iterations="${2:-100}"
    local test_params="${3:-}"

    # Performance measurement variables
    local total_time=0
    local max_time=0
    local min_time=999999
    local start_memory end_memory memory_usage
    local start_fds end_fds fd_usage

    log_info "Benchmarking $function_name with $iterations iterations"

    # Measure baseline resource usage
    start_memory=$(get_memory_usage)
    start_fds=$(get_fd_count)

    # Execute benchmark iterations
    for ((i=1; i<=iterations; i++)); do
        local iteration_start=$(get_timestamp_ns)

        # Execute function with error handling
        if ! eval "$function_name $test_params" >/dev/null 2>&1; then
            log_warning "Function failed on iteration $i"
        fi

        local iteration_end=$(get_timestamp_ns)
        local iteration_time=$((iteration_end - iteration_start))

        # Update timing statistics
        total_time=$((total_time + iteration_time))
        [[ $iteration_time -gt $max_time ]] && max_time=$iteration_time
        [[ $iteration_time -lt $min_time ]] && min_time=$iteration_time

        # Progress indicator every 10%
        if (( i % (iterations / 10) == 0 )); then
            log_debug "Progress: $((i * 100 / iterations))%"
        fi
    done

    # Measure final resource usage
    end_memory=$(get_memory_usage)
    end_fds=$(get_fd_count)

    # Calculate metrics
    local avg_time_ms=$(echo "scale=3; $total_time / $iterations / 1000000" | bc)
    local max_time_ms=$(echo "scale=3; $max_time / 1000000" | bc)
    local min_time_ms=$(echo "scale=3; $min_time / 1000000" | bc)

    memory_usage=$((end_memory - start_memory))
    fd_usage=$((end_fds - start_fds))

    # Generate performance report
    generate_performance_report "$function_name" "$iterations" \
        "$avg_time_ms" "$max_time_ms" "$min_time_ms" \
        "$memory_usage" "$fd_usage"
}

# Function: get_timestamp_ns
# Description: Get high-precision timestamp in nanoseconds
get_timestamp_ns() {
    if command -v gdate >/dev/null 2>&1; then
        gdate +%s%N  # macOS with GNU coreutils
    else
        date +%s%N   # Linux
    fi 2>/dev/null || echo $(($(date +%s) * 1000000000))
}

# Function: get_memory_usage
# Description: Get current process memory usage in KB
get_memory_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ps -o rss= -p $$ 2>/dev/null || echo 0
    else
        awk '/VmRSS/ {print $2}' "/proc/$$/status" 2>/dev/null || echo 0
    fi
}

# Function: get_fd_count
# Description: Get current file descriptor count
get_fd_count() {
    if [[ -d "/proc/$$/fd" ]]; then
        ls "/proc/$$/fd" | wc -l
    else
        lsof -p $$ 2>/dev/null | wc -l
    fi
}
```

#### Performance Profiling Tools

##### CPU Profiling for Shell Scripts

```bash
# scripts/performance/profile-cpu-usage.sh

profile_script_cpu() {
    local script_path="$1"
    local profile_duration="${2:-30}"
    local output_file="${3:-profile-$(basename "$script_path" .sh).txt}"

    log_info "Profiling CPU usage for $script_path"

    # Start script in background with profiling
    if command -v strace >/dev/null 2>&1; then
        # Linux: Use strace for system call profiling
        strace -f -T -tt -o "strace-$output_file" \
               timeout "$profile_duration" bash "$script_path" &
        local script_pid=$!

        # Monitor CPU usage
        monitor_cpu_usage "$script_pid" "$output_file"

    elif command -v dtruss >/dev/null 2>&1; then
        # macOS: Use dtruss for system call profiling
        sudo dtruss -f -t timeout "$profile_duration" bash "$script_path" \
             > "dtruss-$output_file" 2>&1 &
        local script_pid=$!

        monitor_cpu_usage "$script_pid" "$output_file"
    else
        # Fallback: Basic monitoring
        timeout "$profile_duration" bash "$script_path" &
        local script_pid=$!

        monitor_cpu_usage "$script_pid" "$output_file"
    fi

    wait "$script_pid" 2>/dev/null || true

    # Analyze profiling results
    analyze_cpu_profile "$output_file"
}

monitor_cpu_usage() {
    local pid="$1"
    local output_file="$2"

    # Monitor process CPU usage over time
    {
        echo "# CPU Usage Profile - $(date)"
        echo "# PID: $pid"
        echo "# Time CPU% Memory%"

        while kill -0 "$pid" 2>/dev/null; do
            if command -v ps >/dev/null 2>&1; then
                ps -p "$pid" -o %cpu,%mem --no-headers 2>/dev/null || break
            fi
            sleep 1
        done
    } > "cpu-$output_file"
}
```

### Optimization Strategies

#### Function-Level Optimizations

##### Optimized Logging Implementation

```bash
# Optimized logging with reduced overhead
# scripts/includes/core/logging-optimized.sh

# Pre-compile color codes to avoid repeated tput calls
if [[ -t 2 ]] && [[ -z "${NO_COLOR:-}" ]]; then
    readonly COLOR_INFO="\033[32m"
    readonly COLOR_ERROR="\033[31m"
    readonly COLOR_SUCCESS="\033[1;32m"
    readonly COLOR_WARNING="\033[33m"
    readonly COLOR_DEBUG="\033[34m"
    readonly COLOR_RESET="\033[0m"
    readonly ICON_INFO="ℹ"
    readonly ICON_ERROR="✗"
    readonly ICON_SUCCESS="✓"
    readonly ICON_WARNING="⚠"
    readonly ICON_DEBUG="🔍"
else
    readonly COLOR_INFO=""
    readonly COLOR_ERROR=""
    readonly COLOR_SUCCESS=""
    readonly COLOR_WARNING=""
    readonly COLOR_DEBUG=""
    readonly COLOR_RESET=""
    readonly ICON_INFO="*"
    readonly ICON_ERROR="!"
    readonly ICON_SUCCESS="+"
    readonly ICON_WARNING="!"
    readonly ICON_DEBUG=">"
fi

# Optimized core logging function with reduced system calls
log_msg_optimized() {
    local level="$1"
    shift

    # Use case statement for faster level processing
    case "$level" in
        "INFO")
            printf "%s%s [INFO] %s%s\n" "$COLOR_INFO" "$ICON_INFO" "$*" "$COLOR_RESET" >&2
            ;;
        "ERROR")
            printf "%s%s [ERROR] %s%s\n" "$COLOR_ERROR" "$ICON_ERROR" "$*" "$COLOR_RESET" >&2
            ;;
        "SUCCESS")
            printf "%s%s [SUCCESS] %s%s\n" "$COLOR_SUCCESS" "$ICON_SUCCESS" "$*" "$COLOR_RESET" >&2
            ;;
        "WARNING")
            printf "%s%s [WARNING] %s%s\n" "$COLOR_WARNING" "$ICON_WARNING" "$*" "$COLOR_RESET" >&2
            ;;
        "DEBUG")
            [[ "${VERBOSE:-false}" == "true" ]] && \
                printf "%s%s [DEBUG] %s%s\n" "$COLOR_DEBUG" "$ICON_DEBUG" "$*" "$COLOR_RESET" >&2
            return
            ;;
    esac

    # Optimize log file writing with fewer system calls
    if [[ -n "${LOG_FILE:-}" ]]; then
        printf "%(%Y-%m-%d %H:%M:%S)T [%s] %s\n" -1 "$level" "$*" >> "$LOG_FILE" 2>/dev/null || true
    fi
}

# Batch logging for high-frequency operations
declare -a LOG_BUFFER=()
LOG_BUFFER_SIZE=10

log_buffered() {
    local level="$1"
    shift
    local message="$*"

    LOG_BUFFER+=("$(printf "%(%Y-%m-%d %H:%M:%S)T [%s] %s" -1 "$level" "$message")")

    # Flush buffer when full
    if [[ ${#LOG_BUFFER[@]} -ge $LOG_BUFFER_SIZE ]]; then
        flush_log_buffer
    fi
}

flush_log_buffer() {
    if [[ ${#LOG_BUFFER[@]} -gt 0 ]] && [[ -n "${LOG_FILE:-}" ]]; then
        printf "%s\n" "${LOG_BUFFER[@]}" >> "$LOG_FILE" 2>/dev/null || true
        LOG_BUFFER=()
    fi
}
```

##### Optimized File Operations

```bash
# scripts/includes/utilities/file-operations-optimized.sh

# Batch file operations to reduce system calls
batch_file_operations() {
    local operations_file="$1"
    local batch_size="${2:-50}"
    local current_batch=()
    local line_count=0

    # Process operations in batches
    while IFS= read -r operation || [[ -n "$operation" ]]; do
        current_batch+=("$operation")
        ((line_count++))

        # Process batch when full
        if (( line_count >= batch_size )); then
            execute_file_batch "${current_batch[@]}"
            current_batch=()
            line_count=0
        fi
    done < "$operations_file"

    # Process remaining operations
    if [[ ${#current_batch[@]} -gt 0 ]]; then
        execute_file_batch "${current_batch[@]}"
    fi
}

execute_file_batch() {
    local operations=("$@")

    # Group similar operations together
    local create_ops=()
    local copy_ops=()
    local delete_ops=()

    for op in "${operations[@]}"; do
        case "$op" in
            create:*) create_ops+=("${op#create:}") ;;
            copy:*) copy_ops+=("${op#copy:}") ;;
            delete:*) delete_ops+=("${op#delete:}") ;;
        esac
    done

    # Execute grouped operations
    [[ ${#create_ops[@]} -gt 0 ]] && batch_create_files "${create_ops[@]}"
    [[ ${#copy_ops[@]} -gt 0 ]] && batch_copy_files "${copy_ops[@]}"
    [[ ${#delete_ops[@]} -gt 0 ]] && batch_delete_files "${delete_ops[@]}"
}

# Optimized file existence checking with caching
declare -A FILE_EXISTS_CACHE=()
CACHE_TTL=300  # 5 minutes

cached_file_exists() {
    local file_path="$1"
    local current_time cache_key cache_entry cache_time cache_exists

    current_time=$(date +%s)
    cache_key=$(echo "$file_path" | sha256sum | cut -d' ' -f1)
    cache_entry="${FILE_EXISTS_CACHE[$cache_key]:-}"

    if [[ -n "$cache_entry" ]]; then
        cache_time="${cache_entry%:*}"
        cache_exists="${cache_entry#*:}"

        # Check if cache entry is still valid
        if (( current_time - cache_time < CACHE_TTL )); then
            [[ "$cache_exists" == "true" ]]
            return $?
        fi
    fi

    # Cache miss or expired - check file and update cache
    if [[ -f "$file_path" ]]; then
        FILE_EXISTS_CACHE[$cache_key]="$current_time:true"
        return 0
    else
        FILE_EXISTS_CACHE[$cache_key]="$current_time:false"
        return 1
    fi
}
```

#### Memory Optimization Strategies

##### Memory-Efficient Data Structures

```bash
# scripts/includes/utilities/memory-efficient-collections.sh

# Memory-efficient associative arrays using files
create_persistent_map() {
    local map_name="$1"
    local map_file="/tmp/lightspeed-map-$map_name-$$"

    # Store map file path in global variable
    declare -g "MAP_FILE_$map_name=$map_file"

    # Initialize empty map file
    : > "$map_file"
}

put_map_entry() {
    local map_name="$1"
    local key="$2"
    local value="$3"
    local map_file_var="MAP_FILE_$map_name"
    local map_file="${!map_file_var}"

    # Remove existing entry and add new one
    grep -v "^$key:" "$map_file" > "$map_file.tmp" 2>/dev/null || true
    echo "$key:$value" >> "$map_file.tmp"
    mv "$map_file.tmp" "$map_file"
}

get_map_entry() {
    local map_name="$1"
    local key="$2"
    local map_file_var="MAP_FILE_$map_name"
    local map_file="${!map_file_var}"

    grep "^$key:" "$map_file" 2>/dev/null | cut -d: -f2- || return 1
}

# Memory monitoring and cleanup
monitor_memory_usage() {
    local threshold_kb="${1:-10240}"  # 10MB default
    local current_usage

    while true; do
        current_usage=$(get_memory_usage)

        if (( current_usage > threshold_kb )); then
            log_warning "Memory usage high: ${current_usage}KB > ${threshold_kb}KB"
            cleanup_memory_resources
        fi

        sleep 30
    done
}

cleanup_memory_resources() {
    # Clear cached data
    FILE_EXISTS_CACHE=()

    # Clear temporary files
    find /tmp -name "lightspeed-*-$$" -mtime +1 -delete 2>/dev/null || true

    # Force garbage collection where possible
    unset LARGE_ARRAYS 2>/dev/null || true

    log_info "Memory cleanup completed"
}
```

### Caching and Memoization

#### Function Result Caching

```bash
# scripts/includes/utilities/caching.sh

# Memoization framework for expensive operations
declare -A MEMOIZATION_CACHE=()
CACHE_MAX_SIZE=1000
CACHE_HIT_COUNT=0
CACHE_MISS_COUNT=0

# Function: memoize
# Description: Cache function results for repeated calls with same parameters
# Arguments:
#   $1 - Function name to memoize
#   $@ - Function parameters
# Returns: Cached or computed result
memoize() {
    local func_name="$1"
    shift
    local params="$*"
    local cache_key="${func_name}:$(echo "$params" | sha256sum | cut -d' ' -f1)"

    # Check cache first
    if [[ -n "${MEMOIZATION_CACHE[$cache_key]:-}" ]]; then
        ((CACHE_HIT_COUNT++))
        echo "${MEMOIZATION_CACHE[$cache_key]}"
        return 0
    fi

    # Cache miss - compute result
    ((CACHE_MISS_COUNT++))
    local result
    result=$(eval "$func_name $params")
    local exit_code=$?

    # Cache result if successful and cache not full
    if [[ $exit_code -eq 0 ]] && [[ ${#MEMOIZATION_CACHE[@]} -lt $CACHE_MAX_SIZE ]]; then
        MEMOIZATION_CACHE[$cache_key]="$result"
    fi

    echo "$result"
    return $exit_code
}

# Function: clear_memoization_cache
# Description: Clear all cached results
clear_memoization_cache() {
    MEMOIZATION_CACHE=()
    CACHE_HIT_COUNT=0
    CACHE_MISS_COUNT=0
    log_debug "Memoization cache cleared"
}

# Function: get_cache_stats
# Description: Display cache performance statistics
get_cache_stats() {
    local total_calls=$((CACHE_HIT_COUNT + CACHE_MISS_COUNT))
    local hit_rate=0

    if [[ $total_calls -gt 0 ]]; then
        hit_rate=$(( CACHE_HIT_COUNT * 100 / total_calls ))
    fi

    cat << EOF
Cache Statistics:
- Cache Size: ${#MEMOIZATION_CACHE[@]}/$CACHE_MAX_SIZE
- Cache Hits: $CACHE_HIT_COUNT
- Cache Misses: $CACHE_MISS_COUNT
- Hit Rate: $hit_rate%
EOF
}
```

#### Persistent Caching

```bash
# scripts/includes/utilities/persistent-cache.sh

# Persistent disk-based caching for long-running operations
PERSISTENT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lightspeed-wp"
CACHE_EXPIRY_SECONDS=3600  # 1 hour default

# Function: persistent_cache_get
# Description: Retrieve value from persistent cache
# Arguments:
#   $1 - Cache key
# Returns: Cached value if exists and not expired, 1 if not found
persistent_cache_get() {
    local key="$1"
    local cache_file="$PERSISTENT_CACHE_DIR/$(echo "$key" | sha256sum | cut -d' ' -f1)"

    # Check if cache file exists
    if [[ ! -f "$cache_file" ]]; then
        return 1
    fi

    # Check if cache has expired
    local cache_time file_time current_time
    cache_time=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
    current_time=$(date +%s)

    if (( current_time - cache_time > CACHE_EXPIRY_SECONDS )); then
        rm -f "$cache_file"
        return 1
    fi

    # Return cached content
    cat "$cache_file"
    return 0
}

# Function: persistent_cache_set
# Description: Store value in persistent cache
# Arguments:
#   $1 - Cache key
#   $2 - Cache value
persistent_cache_set() {
    local key="$1"
    local value="$2"
    local cache_file="$PERSISTENT_CACHE_DIR/$(echo "$key" | sha256sum | cut -d' ' -f1)"

    # Create cache directory if needed
    mkdir -p "$PERSISTENT_CACHE_DIR"

    # Write value to cache file
    echo "$value" > "$cache_file"
}

# Function: cached_command
# Description: Execute command with result caching
# Arguments:
#   $1 - Cache key
#   $@ - Command to execute
cached_command() {
    local cache_key="$1"
    shift
    local command="$*"

    # Try to get cached result
    local cached_result
    if cached_result=$(persistent_cache_get "$cache_key"); then
        echo "$cached_result"
        return 0
    fi

    # Execute command and cache result
    local result exit_code
    result=$(eval "$command")
    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        persistent_cache_set "$cache_key" "$result"
        echo "$result"
    fi

    return $exit_code
}
```

### Performance Monitoring

#### Real-Time Performance Dashboard

```bash
# scripts/performance/performance-monitor.sh

start_performance_monitoring() {
    local monitor_interval="${1:-5}"
    local output_file="${2:-performance-$(date +%Y%m%d-%H%M%S).log}"

    # Create performance monitoring background process
    {
        echo "# LightSpeed WP Performance Monitor"
        echo "# Started: $(date)"
        echo "# PID: $$"
        echo "# Interval: ${monitor_interval}s"
        echo ""
        echo "Timestamp,CPU%,Memory_KB,FD_Count,Load_Avg,Disk_IO"

        while kill -0 $$ 2>/dev/null; do
            local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            local cpu_percent=$(get_cpu_percent)
            local memory_kb=$(get_memory_usage)
            local fd_count=$(get_fd_count)
            local load_avg=$(uptime | awk -F'load averages: ' '{print $2}' | cut -d' ' -f1)
            local disk_io=$(get_disk_io)

            echo "$timestamp,$cpu_percent,$memory_kb,$fd_count,$load_avg,$disk_io"

            sleep "$monitor_interval"
        done
    } > "$output_file" &

    MONITOR_PID=$!
    echo "$MONITOR_PID" > "/tmp/lightspeed-monitor-$$.pid"

    log_info "Performance monitoring started (PID: $MONITOR_PID)"
    log_info "Monitor output: $output_file"
}

stop_performance_monitoring() {
    local monitor_pid_file="/tmp/lightspeed-monitor-$$.pid"

    if [[ -f "$monitor_pid_file" ]]; then
        local monitor_pid=$(cat "$monitor_pid_file")

        if kill "$monitor_pid" 2>/dev/null; then
            log_info "Performance monitoring stopped (PID: $monitor_pid)"
        fi

        rm -f "$monitor_pid_file"
    fi
}

get_cpu_percent() {
    if command -v top >/dev/null 2>&1; then
        top -l 1 -n 0 | awk '/CPU usage/ {print $3}' | tr -d '%' 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

get_disk_io() {
    if command -v iostat >/dev/null 2>&1; then
        iostat -d 1 2 | tail -1 | awk '{print $4+$5}' 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}
```

## System Constraints

- Performance optimizations must not compromise code readability
- Memory usage must stay within defined limits per include
- Caching strategies must handle cache invalidation correctly
- Monitoring overhead must be minimal
- All optimizations must be measurable and verified

## Example First Message to Copilot

```text
Implement comprehensive performance optimization for the modular shell script architecture. Focus on function-level optimizations, memory efficiency, intelligent caching, and real-time monitoring to ensure optimal execution across diverse deployment environments.
```

## Verification Steps

- [ ] Performance benchmarks establish baseline metrics
- [ ] Optimization strategies demonstrate measurable improvements
- [ ] Caching mechanisms provide significant speedup for repeated operations
- [ ] Memory usage stays within defined constraints
- [ ] Monitoring provides actionable performance insights
- [ ] Performance regression tests prevent degradation

## References

- [Specific Implementation Examples](./specific-implementation-examples-for-each-component.md)
- [Documentation and Testing Integration Strategies](./documentation-and-testing-integration-strategies.md)
- [Performance Optimization Guidelines](../.github/instructions/performance-optimization.instructions.md)

## Closing Statement

Comprehensive performance optimization ensures modular shell script automation operates at peak efficiency with systematic monitoring, proactive optimization, and reliable performance characteristics that support enterprise-scale operations.

