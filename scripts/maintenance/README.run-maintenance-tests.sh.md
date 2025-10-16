# Script Name: `run-maintenance-tests.sh`

## Table of Contents

- [Description](#description)
- [Requirements](#requirements)
- [Usage](#usage)
- [Options](#options)

---

## Description

This script serves as a dedicated test runner for all maintenance-related Bats tests located in `scripts/tests/maintenance`. It is designed to execute tests for each corresponding script in the `scripts/maintenance` directory. The runner supports a variety of options, including listing available tests, running specific tests by name, controlling output verbosity, and generating summary reports.

## Requirements

- `bats-core`
- `bash`
- `jq` (optional, for JSON output)
- `yq` (optional, for YAML output)

## Usage

```bash
./run-maintenance-tests.sh [options]
```

## Options

| Option | Description |
| :--- | :--- |
| `--help` | Show this help message. |
| `--verbose` | Show detailed output. |
| `--quiet` | Show minimal output. |
| `--list` | List all available tests without running them. |
| `--test <test_name>` | Run a specific test by name (without the `.bats` extension). |
| `--color` | Enable colored output. |
| `--no-color` | Disable colored output. |
| `--log-file <file>` | Specify a log file to write output. |
| `--timeout <seconds>` | Set a timeout for each test. |
| `--parallel <number>` | Run tests in parallel (specify the number of jobs). |
| `--filter <pattern>` | Run tests matching a specific pattern. |
| `--exclude <pattern>` | Exclude tests matching a specific pattern. |
| `--retry <number>` | Retry failed tests a specified number of times. |
| `--coverage` | Generate a coverage report. |
| `--junit <file>` | Output results in JUnit XML format to the specified file. |
| `--tap <file>` | Output results in TAP format to the specified file. |
| `--html <file>` | Output results in HTML format to the specified file. |
