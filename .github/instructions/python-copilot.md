# Python Copilot Instructions

You are a Python developer working on LightSpeed WP automation tools. Follow our Python standards and testing practices to create maintainable scripts. Avoid unnecessary dependencies unless specified.

## Core Principles

### Script Structure

```python
#!/usr/bin/env python3
"""
Script Name: script_name.py
Description: Brief description of functionality
Usage: python script_name.py [options] [arguments]
Dependencies: List required packages
Author: LightSpeed WP Team
"""

import argparse
import logging
import sys
from pathlib import Path
from typing import Dict, List, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class WorkflowError(Exception):
    """Custom exception for workflow-related errors."""
    pass


def main() -> int:
    """Main entry point."""
    try:
        args = parse_arguments()
        configure_logging(args.verbose)

        # Main logic here
        result = process_workflow(args)

        logger.info("Workflow completed successfully")
        return 0

    except WorkflowError as e:
        logger.error(f"Workflow error: {e}")
        return 1
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
```

### Error Handling

```python
import sys
import traceback
from typing import Optional

class WorkflowError(Exception):
    """Base exception for workflow errors."""

    def __init__(self, message: str, exit_code: int = 1):
        super().__init__(message)
        self.exit_code = exit_code


def handle_error(error: Exception, context: Optional[str] = None) -> None:
    """Handle errors with proper logging and exit codes."""
    if isinstance(error, WorkflowError):
        if context:
            logger.error(f"{context}: {error}")
        else:
            logger.error(str(error))
        sys.exit(error.exit_code)
    else:
        logger.error(f"Unexpected error: {error}")
        logger.debug(traceback.format_exc())
        sys.exit(1)
```

## GitHub API Integration

### PyGithub Patterns

```python
import os
from github import Github, GithubException
from typing import Dict, List

def get_github_client() -> Github:
    """Initialize GitHub client with authentication."""
    token = os.getenv('GITHUB_TOKEN')
    if not token:
        raise WorkflowError("GITHUB_TOKEN environment variable required")

    return Github(token)


def create_pull_request(
    repo_name: str,
    title: str,
    body: str,
    head: str,
    base: str = "main"
) -> Dict:
    """Create a pull request with error handling."""
    try:
        github = get_github_client()
        repo = github.get_repo(repo_name)

        pr = repo.create_pull(
            title=title,
            body=body,
            head=head,
            base=base
        )

        logger.info(f"Created PR #{pr.number}: {title}")
        return {
            "number": pr.number,
            "url": pr.html_url,
            "title": title
        }

    except GithubException as e:
        raise WorkflowError(f"Failed to create PR: {e.data.get('message', str(e))}")


def update_repository_labels(repo_name: str, labels: List[Dict]) -> List[Dict]:
    """Update repository labels with batch processing."""
    github = get_github_client()
    repo = github.get_repo(repo_name)
    results = []

    for label_data in labels:
        try:
            # Try to get existing label
            try:
                label = repo.get_label(label_data['name'])
                # Update existing label
                label.edit(
                    name=label_data['name'],
                    color=label_data['color'],
                    description=label_data.get('description', '')
                )
                results.append({
                    'name': label_data['name'],
                    'status': 'updated'
                })
            except GithubException as e:
                if e.status == 404:
                    # Create new label
                    repo.create_label(
                        name=label_data['name'],
                        color=label_data['color'],
                        description=label_data.get('description', '')
                    )
                    results.append({
                        'name': label_data['name'],
                        'status': 'created'
                    })
                else:
                    raise

        except GithubException as e:
            results.append({
                'name': label_data['name'],
                'status': 'failed',
                'error': str(e)
            })

    return results
```

## Configuration Management

### Environment and CLI Arguments

```python
import argparse
import os
from dataclasses import dataclass
from typing import Optional

@dataclass
class Config:
    """Configuration container."""
    github_token: str
    org_name: str = "lightspeedwp"
    dry_run: bool = False
    verbose: bool = False
    config_file: Optional[str] = None

    @classmethod
    def from_env_and_args(cls, args: argparse.Namespace) -> 'Config':
        """Create config from environment and command line arguments."""
        github_token = os.getenv('GITHUB_TOKEN')
        if not github_token:
            raise WorkflowError("GITHUB_TOKEN environment variable required")

        return cls(
            github_token=github_token,
            org_name=args.org_name or os.getenv('ORG_NAME', 'lightspeedwp'),
            dry_run=args.dry_run or os.getenv('DRY_RUN', '').lower() == 'true',
            verbose=args.verbose or os.getenv('VERBOSE', '').lower() == 'true',
            config_file=args.config_file
        )


def parse_arguments() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="LightSpeed WP workflow automation",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Preview changes without executing'
    )

    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Show detailed output'
    )

    parser.add_argument(
        '--org-name',
        help='GitHub organization name'
    )

    parser.add_argument(
        '-c', '--config-file',
        help='Configuration file path'
    )

    return parser.parse_args()
```

## File Operations

### Safe File Handling

```python
import json
import yaml
from pathlib import Path
from typing import Any, Dict, Union

def read_json_file(file_path: Union[str, Path]) -> Dict[str, Any]:
    """Read and parse JSON file with error handling."""
    path = Path(file_path)

    if not path.exists():
        raise WorkflowError(f"File not found: {path}")

    try:
        with path.open('r', encoding='utf-8') as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        raise WorkflowError(f"Invalid JSON in {path}: {e}")
    except Exception as e:
        raise WorkflowError(f"Failed to read {path}: {e}")


def write_json_file(file_path: Union[str, Path], data: Dict[str, Any],
                   indent: int = 2) -> None:
    """Write data to JSON file with error handling."""
    path = Path(file_path)

    try:
        # Create parent directories if needed
        path.parent.mkdir(parents=True, exist_ok=True)

        with path.open('w', encoding='utf-8') as f:
            json.dump(data, f, indent=indent, ensure_ascii=False)

        logger.info(f"Written: {path}")
    except Exception as e:
        raise WorkflowError(f"Failed to write {path}: {e}")


def create_backup(file_path: Union[str, Path]) -> Path:
    """Create a backup of the file with timestamp."""
    from datetime import datetime

    path = Path(file_path)

    if not path.exists():
        raise WorkflowError(f"Cannot backup non-existent file: {path}")

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = path.with_suffix(f".backup.{timestamp}{path.suffix}")

    try:
        backup_path.write_bytes(path.read_bytes())
        logger.info(f"Backup created: {backup_path}")
        return backup_path
    except Exception as e:
        raise WorkflowError(f"Failed to create backup: {e}")
```

## Testing Patterns

### Pytest Structure

```python
# tests/test_workflow_script.py
import pytest
from unittest.mock import Mock, patch, MagicMock
from pathlib import Path

from workflow_script import process_workflow, WorkflowError, Config


class TestWorkflowScript:
    """Test cases for workflow script."""

    def setup_method(self):
        """Set up test environment."""
        self.config = Config(
            github_token="fake-token",
            dry_run=True
        )

    def test_config_from_env_missing_token(self, monkeypatch):
        """Test config creation fails without GitHub token."""
        monkeypatch.delenv("GITHUB_TOKEN", raising=False)

        args = Mock(
            org_name=None,
            dry_run=False,
            verbose=False,
            config_file=None
        )

        with pytest.raises(WorkflowError, match="GITHUB_TOKEN.*required"):
            Config.from_env_and_args(args)

    @patch('workflow_script.get_github_client')
    def test_process_workflow_success(self, mock_github):
        """Test successful workflow processing."""
        mock_client = Mock()
        mock_github.return_value = mock_client

        result = process_workflow(self.config)

        assert result is not None
        mock_github.assert_called_once()

    def test_file_operations(self, tmp_path):
        """Test file reading and writing."""
        test_file = tmp_path / "test.json"
        test_data = {"key": "value"}

        write_json_file(test_file, test_data)
        result = read_json_file(test_file)

        assert result == test_data


@pytest.fixture
def mock_github_repo():
    """Mock GitHub repository."""
    repo = Mock()
    repo.create_pull.return_value = Mock(
        number=42,
        html_url="https://github.com/test/test/pull/42"
    )
    return repo
```

### Test Configuration

```python
# conftest.py
import pytest
import os
from unittest.mock import Mock

@pytest.fixture(autouse=True)
def setup_test_env(monkeypatch):
    """Set up test environment variables."""
    monkeypatch.setenv("GITHUB_TOKEN", "fake-test-token")
    monkeypatch.setenv("DRY_RUN", "true")

@pytest.fixture
def temp_config_file(tmp_path):
    """Create temporary configuration file."""
    config_file = tmp_path / "config.json"
    config_data = {
        "org_name": "test-org",
        "repositories": ["repo1", "repo2"]
    }

    with config_file.open('w') as f:
        json.dump(config_data, f)

    return config_file
```

## Logging and Monitoring

### Structured Logging

```python
import logging
import json
from datetime import datetime
from typing import Any, Dict

class JsonFormatter(logging.Formatter):
    """JSON formatter for structured logging."""

    def format(self, record: logging.LogRecord) -> str:
        log_data = {
            'timestamp': datetime.utcnow().isoformat(),
            'level': record.levelname,
            'message': record.getMessage(),
            'logger': record.name
        }

        if record.exc_info:
            log_data['exception'] = self.formatException(record.exc_info)

        return json.dumps(log_data)


def configure_logging(verbose: bool = False) -> None:
    """Configure logging with appropriate level and format."""
    level = logging.DEBUG if verbose else logging.INFO

    handler = logging.StreamHandler()
    handler.setFormatter(JsonFormatter())

    root_logger = logging.getLogger()
    root_logger.setLevel(level)
    root_logger.addHandler(handler)
```

### Progress Tracking

```python
from tqdm import tqdm
from typing import Iterable, TypeVar, Callable

T = TypeVar('T')

def process_with_progress(
    items: Iterable[T],
    processor: Callable[[T], Any],
    description: str = "Processing"
) -> List[Any]:
    """Process items with progress bar."""
    results = []

    for item in tqdm(items, desc=description):
        try:
            result = processor(item)
            results.append(result)
        except Exception as e:
            logger.error(f"Failed to process {item}: {e}")
            results.append(None)

    return results
```

## Performance and Best Practices

### Async Operations

```python
import asyncio
import aiohttp
from typing import List, Dict

async def fetch_repository_data(
    session: aiohttp.ClientSession,
    repo_name: str,
    token: str
) -> Dict:
    """Fetch repository data asynchronously."""
    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    url = f"https://api.github.com/repos/{repo_name}"

    async with session.get(url, headers=headers) as response:
        if response.status == 200:
            return await response.json()
        else:
            raise WorkflowError(f"Failed to fetch {repo_name}: {response.status}")


async def process_repositories_async(
    repo_names: List[str],
    token: str
) -> List[Dict]:
    """Process multiple repositories concurrently."""
    async with aiohttp.ClientSession() as session:
        tasks = [
            fetch_repository_data(session, repo, token)
            for repo in repo_names
        ]

        return await asyncio.gather(*tasks, return_exceptions=True)
```

### Caching

```python
from functools import lru_cache
import time
from typing import Any, Callable, Dict

class TimedCache:
    """Simple time-based cache implementation."""

    def __init__(self, ttl_seconds: int = 300):
        self.ttl = ttl_seconds
        self._cache: Dict[str, Dict[str, Any]] = {}

    def get(self, key: str) -> Any:
        if key in self._cache:
            if time.time() - self._cache[key]['timestamp'] < self.ttl:
                return self._cache[key]['value']
            else:
                del self._cache[key]
        return None

    def set(self, key: str, value: Any) -> None:
        self._cache[key] = {
            'value': value,
            'timestamp': time.time()
        }

# Usage with decorator
def cached_github_call(cache_key: str):
    """Decorator for caching GitHub API calls."""
    cache = TimedCache(ttl_seconds=300)  # 5 minutes

    def decorator(func: Callable) -> Callable:
        def wrapper(*args, **kwargs):
            key = f"{cache_key}:{hash(str(args) + str(kwargs))}"

            result = cache.get(key)
            if result is not None:
                logger.debug(f"Cache hit for {key}")
                return result

            result = func(*args, **kwargs)
            cache.set(key, result)
            return result

        return wrapper
    return decorator
```

## Integration with LightSpeed Workflow

### Requirements File

```text
# requirements.txt
PyGithub>=1.58.0
requests>=2.28.0
pyyaml>=6.0
tqdm>=4.64.0
aiohttp>=3.8.0

# Development dependencies
pytest>=7.0.0
pytest-mock>=3.8.0
pytest-asyncio>=0.21.0
black>=22.0.0
flake8>=5.0.0
mypy>=0.991
```

### Setup Configuration

```python
# setup.py or pyproject.toml configuration
from setuptools import setup, find_packages

setup(
    name="lightspeed-automation",
    version="1.0.0",
    description="LightSpeed WP automation tools",
    author="LightSpeed WP Team",
    packages=find_packages(),
    python_requires=">=3.8",
    install_requires=[
        "PyGithub>=1.58.0",
        "requests>=2.28.0",
        "pyyaml>=6.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "black>=22.0.0",
            "flake8>=5.0.0",
            "mypy>=0.991",
        ]
    },
    entry_points={
        "console_scripts": [
            "lightspeed-automation=lightspeed_automation.cli:main",
        ]
    }
)
```
