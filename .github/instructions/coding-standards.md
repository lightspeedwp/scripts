# Coding Standards - LightSpeed WP Automation

You are a code quality specialist. Follow our LightSpeed WP coding standards framework to ensure consistent, maintainable, and secure code across all languages and frameworks. Avoid deviating from established patterns unless specified for specific use cases.

## Overview

This document establishes comprehensive coding standards for the LightSpeed WP automation ecosystem, covering multiple programming languages, frameworks, and toolchains used in our development and operations workflows.

## Universal Coding Principles

### Code Quality Foundations

- **Readability**: Code is written for humans first, machines second
- **Consistency**: Follow established patterns within each codebase
- **Security**: Secure by default, validate all inputs, handle errors gracefully
- **Performance**: Efficient algorithms and data structures, avoid premature optimization
- **Maintainability**: Modular design, comprehensive documentation, automated testing

### Naming Conventions

```bash
# File naming patterns by type
scripts/              # kebab-case for shell scripts
deployment/deploy-wordpress-site.sh
maintenance/prune-labels.sh
utility/backup-database.sh

# JavaScript/Node.js files  
lib/                  # camelCase for JS files and functions
utils/stringHelpers.js
config/databaseConfig.js
services/deploymentService.js

# Configuration files
config/               # kebab-case for config files
database-config.json
deployment-settings.yml
linting-rules.yaml
```

### Documentation Requirements

- **File Headers**: All source files require comprehensive headers
- **Function Documentation**: Public functions and complex private functions need documentation
- **Inline Comments**: Explain complex logic, non-obvious decisions, and business rules
- **README Files**: Each directory with scripts/code needs usage documentation
- **API Documentation**: All REST APIs and CLI tools need complete documentation

## Language-Specific Standards

### Shell Script Standards

```bash
#!/bin/bash
#
# Script Name: example-script.sh
# Description: Example demonstrating LightSpeed shell script standards
# Usage: ./example-script.sh [OPTIONS] [ARGUMENTS]
# Author: LightSpeed WP Team
# Date: 2024-01-01
#

set -euo pipefail  # Mandatory error handling

# Constants in UPPER_CASE
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_TIMEOUT=30
readonly LOG_FILE="/var/log/lightspeed/$(basename "$0" .sh).log"

# Configuration variables
config_file=""
dry_run=false
verbose=false

# Function with proper documentation
#######################################
# Validates configuration file format and required fields
# Arguments:
#   $1 - Path to configuration file
# Returns:
#   0 if valid, 1 if invalid
# Outputs:
#   Error messages to stderr if validation fails
#######################################
validate_config() {
    local config_path="$1"
    
    # Validation logic with clear error messages
    if [[ ! -f "$config_path" ]]; then
        echo "Error: Configuration file not found: $config_path" >&2
        return 1
    fi
    
    # Additional validation...
    return 0
}

# Main execution with argument parsing
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--config)
                config_file="$2"
                shift 2
                ;;
            -d|--dry-run)
                dry_run=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                show_usage >&2
                exit 1
                ;;
        esac
    done
    
    # Validation and execution
    validate_config "$config_file" || exit 1
    
    # Main script logic...
}

# Execute main function with all arguments
main "$@"
```

#### Shell Script Requirements

- **Shebang**: Use `#!/bin/bash` for consistency
- **Error Handling**: Mandatory `set -euo pipefail`
- **Quoting**: Quote all variable expansions: `"$variable"`
- **Functions**: Prefer functions over inline code for reusability
- **Constants**: Use `readonly` for constants in UPPER_CASE
- **Local Variables**: Use `local` for function variables
- **Testing**: Every script needs corresponding Bats tests
- **Linting**: Pass ShellCheck without warnings

### JavaScript/Node.js Standards

```javascript
/**
 * @fileoverview Example demonstrating LightSpeed JavaScript standards
 * @author LightSpeed WP Team
 * @version 1.0.0
 */

'use strict';

const fs = require('fs').promises;
const path = require('path');
const { Octokit } = require('@octokit/rest');

// Constants in UPPER_SNAKE_CASE
const DEFAULT_TIMEOUT = 30000;
const MAX_RETRY_ATTEMPTS = 3;
const LOG_LEVELS = {
  ERROR: 'error',
  WARN: 'warn',
  INFO: 'info',
  DEBUG: 'debug',
};

/**
 * Configuration class for deployment automation
 */
class DeploymentConfig {
  /**
   * Creates a new deployment configuration
   * @param {Object} options - Configuration options
   * @param {string} options.environment - Target environment
   * @param {string} options.configPath - Path to configuration file
   * @param {boolean} [options.dryRun=false] - Enable dry-run mode
   */
  constructor(options) {
    this.environment = options.environment;
    this.configPath = options.configPath;
    this.dryRun = options.dryRun || false;
    this.logger = this._createLogger();
  }

  /**
   * Validates the configuration file format and required fields
   * @async
   * @returns {Promise<boolean>} True if valid, throws Error if invalid
   * @throws {Error} When configuration is invalid or file not found
   */
  async validate() {
    try {
      const configData = await fs.readFile(this.configPath, 'utf8');
      const config = JSON.parse(configData);
      
      // Validate required fields
      const requiredFields = ['environment', 'database', 'deployment'];
      for (const field of requiredFields) {
        if (!config[field]) {
          throw new Error(`Missing required configuration field: ${field}`);
        }
      }
      
      this.logger.info('Configuration validation successful');
      return true;
    } catch (error) {
      this.logger.error('Configuration validation failed', { error: error.message });
      throw error;
    }
  }

  /**
   * Creates a configured logger instance
   * @private
   * @returns {Object} Logger instance
   */
  _createLogger() {
    // Logger implementation...
    return {
      error: (message, meta = {}) => console.error(message, meta),
      warn: (message, meta = {}) => console.warn(message, meta),
      info: (message, meta = {}) => console.log(message, meta),
      debug: (message, meta = {}) => console.debug(message, meta),
    };
  }
}

module.exports = { DeploymentConfig };
```

#### JavaScript/Node.js Requirements

- **Strict Mode**: Use `'use strict';` in all files
- **Documentation**: JSDoc comments for all public functions and classes
- **Error Handling**: Comprehensive try-catch blocks, proper error propagation
- **Async/Await**: Prefer async/await over Promises and callbacks
- **Constants**: UPPER_SNAKE_CASE for module-level constants
- **Classes**: Use ES6 classes with proper encapsulation
- **Testing**: Jest tests with high coverage requirements
- **Linting**: ESLint with LightSpeed configuration

### Python Standards

```python
#!/usr/bin/env python3
"""
Example demonstrating LightSpeed Python standards.

This module provides automation utilities for LightSpeed WP workflows,
including configuration management, API integration, and deployment
coordination.

Author: LightSpeed WP Team
Version: 1.0.0
Date: 2024-01-01
"""

import logging
import sys
from pathlib import Path
from typing import Dict, List, Optional, Union
from dataclasses import dataclass
from abc import ABC, abstractmethod

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Type aliases for clarity
ConfigDict = Dict[str, Union[str, int, bool, List[str]]]
EnvironmentName = str


@dataclass(frozen=True)
class DeploymentResult:
    """
    Represents the result of a deployment operation.
    
    Attributes:
        success: Whether the deployment succeeded
        environment: Target environment name
        duration_seconds: Deployment duration in seconds
        error_message: Error description if deployment failed
        rollback_available: Whether rollback is possible
    """
    success: bool
    environment: EnvironmentName
    duration_seconds: float
    error_message: Optional[str] = None
    rollback_available: bool = False


class DeploymentError(Exception):
    """Custom exception for deployment-related errors."""
    
    def __init__(self, message: str, error_code: int = 1) -> None:
        """
        Initialize deployment error.
        
        Args:
            message: Error description
            error_code: Numeric error code for categorization
        """
        super().__init__(message)
        self.error_code = error_code


class BaseDeploymentStrategy(ABC):
    """Abstract base class for deployment strategies."""
    
    @abstractmethod
    def deploy(self, config: ConfigDict) -> DeploymentResult:
        """
        Execute deployment with given configuration.
        
        Args:
            config: Deployment configuration dictionary
            
        Returns:
            DeploymentResult with operation details
            
        Raises:
            DeploymentError: When deployment fails
        """
        pass


class WordPressDeploymentStrategy(BaseDeploymentStrategy):
    """
    WordPress-specific deployment strategy implementation.
    
    Handles WordPress site deployment including database migration,
    file synchronization, and configuration management.
    """
    
    def __init__(self, dry_run: bool = False, timeout: int = 300) -> None:
        """
        Initialize WordPress deployment strategy.
        
        Args:
            dry_run: Enable preview mode without actual changes
            timeout: Maximum deployment time in seconds
        """
        self.dry_run = dry_run
        self.timeout = timeout
        self._deployment_steps = [
            self._backup_database,
            self._sync_files,
            self._run_migrations,
            self._update_configuration,
            self._verify_deployment,
        ]
    
    def deploy(self, config: ConfigDict) -> DeploymentResult:
        """
        Execute WordPress deployment process.
        
        Args:
            config: WordPress deployment configuration
            
        Returns:
            DeploymentResult with deployment status and details
        """
        import time
        start_time = time.time()
        
        try:
            logger.info(f"Starting WordPress deployment to {config['environment']}")
            
            # Validate configuration
            self._validate_config(config)
            
            # Execute deployment steps
            for step in self._deployment_steps:
                if self.dry_run:
                    logger.info(f"[DRY RUN] Would execute: {step.__name__}")
                else:
                    logger.info(f"Executing: {step.__name__}")
                    step(config)
            
            duration = time.time() - start_time
            logger.info(f"Deployment completed in {duration:.2f} seconds")
            
            return DeploymentResult(
                success=True,
                environment=config['environment'],
                duration_seconds=duration,
                rollback_available=True
            )
            
        except Exception as error:
            duration = time.time() - start_time
            error_msg = f"Deployment failed: {str(error)}"
            logger.error(error_msg)
            
            return DeploymentResult(
                success=False,
                environment=config['environment'],
                duration_seconds=duration,
                error_message=error_msg,
                rollback_available=False
            )
    
    def _validate_config(self, config: ConfigDict) -> None:
        """Validate deployment configuration."""
        required_keys = ['environment', 'database_url', 'target_path']
        missing_keys = [key for key in required_keys if key not in config]
        
        if missing_keys:
            raise DeploymentError(
                f"Missing required configuration keys: {', '.join(missing_keys)}"
            )
    
    def _backup_database(self, config: ConfigDict) -> None:
        """Create database backup before deployment."""
        # Implementation details...
        pass
    
    def _sync_files(self, config: ConfigDict) -> None:
        """Synchronize application files."""
        # Implementation details...
        pass
    
    def _run_migrations(self, config: ConfigDict) -> None:
        """Execute database migrations."""
        # Implementation details...
        pass
    
    def _update_configuration(self, config: ConfigDict) -> None:
        """Update application configuration."""
        # Implementation details...
        pass
    
    def _verify_deployment(self, config: ConfigDict) -> None:
        """Verify deployment health and functionality."""
        # Implementation details...
        pass


def main() -> int:
    """
    Main entry point for deployment script.
    
    Returns:
        Exit code (0 for success, non-zero for failure)
    """
    try:
        # Configuration and execution logic
        config = {
            'environment': 'staging',
            'database_url': 'mysql://localhost/wp_staging',
            'target_path': '/var/www/staging'
        }
        
        strategy = WordPressDeploymentStrategy(dry_run=False)
        result = strategy.deploy(config)
        
        if result.success:
            logger.info("Deployment completed successfully")
            return 0
        else:
            logger.error(f"Deployment failed: {result.error_message}")
            return 1
            
    except KeyboardInterrupt:
        logger.info("Deployment cancelled by user")
        return 130
    except Exception as error:
        logger.error(f"Unexpected error: {str(error)}")
        return 1


if __name__ == '__main__':
    sys.exit(main())
```

#### Python Requirements

- **Type Hints**: Comprehensive type annotations for all functions
- **Docstrings**: Google-style docstrings for modules, classes, and functions
- **Error Handling**: Custom exceptions, proper error propagation
- **Logging**: Structured logging with appropriate levels
- **Data Classes**: Use dataclasses for data structures
- **Testing**: pytest with high coverage and property-based testing
- **Linting**: Black, isort, flake8, mypy compliance

## Configuration and Toolchain Standards

### Linting Configuration

#### ESLint Configuration (`.eslintrc.json`)

```json
{
  "extends": [
    "eslint:recommended",
    "@wordpress/eslint-config"
  ],
  "env": {
    "node": true,
    "es6": true,
    "jest": true
  },
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module"
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": "error",
    "prefer-const": "error",
    "no-var": "error",
    "object-shorthand": "error",
    "prefer-arrow-callback": "error"
  }
}
```

#### Prettier Configuration (`.prettierrc`)

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
```

#### Python Configuration (`pyproject.toml`)

```toml
[tool.black]
line-length = 100
target-version = ['py39']
include = '\.pyi?$'

[tool.isort]
profile = "black"
line_length = 100
multi_line_output = 3

[tool.mypy]
python_version = "3.9"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

### Testing Standards

#### Test Coverage Requirements

- **Shell Scripts**: 90% statement coverage with Bats
- **JavaScript/Node.js**: 85% branch coverage with Jest
- **Python**: 90% branch coverage with pytest
- **Integration Tests**: All API endpoints and CLI commands

#### Test Organization

```
tests/
├── unit/                    # Fast unit tests
│   ├── test-utility-functions.bats
│   ├── deployment.test.js
│   └── test_wordpress_strategy.py
├── integration/             # Integration tests
│   ├── test-api-endpoints.bats
│   ├── github-integration.test.js
│   └── test_database_integration.py
└── e2e/                    # End-to-end tests
    ├── test-full-deployment.bats
    └── complete-workflow.test.js
```

## Security Standards

### Input Validation

```bash
# Shell script input validation
validate_input() {
    local input="$1"
    local pattern="^[a-zA-Z0-9_-]+$"
    
    if [[ ! "$input" =~ $pattern ]]; then
        echo "Error: Invalid input format" >&2
        return 1
    fi
}

# Sanitize file paths
sanitize_path() {
    local path="$1"
    # Remove dangerous characters and sequences
    path="${path//..\/}"        # Remove parent directory traversal
    path="${path//;}"           # Remove command separators
    path="${path//|}"           # Remove pipes
    echo "$path"
}
```

```javascript
// JavaScript input validation
const validator = require('validator');

function validateEnvironmentName(name) {
  if (!name || typeof name !== 'string') {
    throw new Error('Environment name must be a non-empty string');
  }
  
  if (!validator.matches(name, /^[a-zA-Z0-9_-]+$/)) {
    throw new Error('Environment name contains invalid characters');
  }
  
  if (name.length > 50) {
    throw new Error('Environment name too long (max 50 characters)');
  }
  
  return name.toLowerCase();
}
```

### Secrets Management

- **No Hardcoded Secrets**: Never commit credentials, API keys, or sensitive data
- **Environment Variables**: Use environment variables for configuration
- **Secret Rotation**: Regular rotation of API keys and passwords
- **Encryption**: Encrypt sensitive data at rest and in transit

### Access Controls

- **File Permissions**: Restrict script and config file permissions (600/700)
- **User Context**: Run scripts with minimum required privileges
- **Audit Logging**: Log all security-relevant actions with timestamps
- **Network Security**: Use TLS for all network communications

## Enforcement and Quality Gates

### Pre-commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

set -euo pipefail

echo "Running pre-commit quality checks..."

# Shell script validation
echo "Checking shell scripts..."
for script in $(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$'); do
    if ! shellcheck "$script"; then
        echo "ShellCheck failed for $script"
        exit 1
    fi
done

# JavaScript linting
if [[ -f package.json ]]; then
    echo "Linting JavaScript..."
    npm run lint:check || exit 1
fi

# Python linting
if [[ -f pyproject.toml ]]; then
    echo "Linting Python..."
    black --check . || exit 1
    isort --check-only . || exit 1
    flake8 . || exit 1
fi

echo "All quality checks passed!"
```

### CI/CD Integration

Quality gates are enforced through:

1. **Automated Linting**: All code must pass language-specific linters
2. **Test Coverage**: Minimum coverage thresholds must be met
3. **Security Scanning**: Automated vulnerability detection
4. **Code Review**: Human review required for all changes
5. **Documentation**: All public APIs must have complete documentation

### Review Guidelines

Code reviewers should verify:

- [ ] Code follows language-specific style guidelines
- [ ] All functions have appropriate documentation
- [ ] Error handling is comprehensive and appropriate
- [ ] Tests cover new functionality and edge cases
- [ ] Security best practices are followed
- [ ] Performance implications are considered
- [ ] Breaking changes are documented and justified

## Continuous Improvement

### Standards Evolution

- **Quarterly Review**: Review and update standards based on team feedback
- **Tool Updates**: Keep linting tools and configurations current
- **Best Practice Sharing**: Regular team discussions on code quality
- **Training**: Ongoing education on new languages and frameworks
- **Metrics**: Track code quality metrics and improvement trends

This comprehensive approach to coding standards ensures that LightSpeed WP automation code remains secure, maintainable, and consistent across all projects and team members.
