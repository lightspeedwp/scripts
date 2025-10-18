# Multi-Block Plugin Build Process

This document details the comprehensive build process for creating WordPress multi-block plugins, covering development workflows, tooling, and best practices.

## Table of Contents

1. [Introduction](#introduction)
2. [Development Environment Setup](#development-environment-setup)
3. [Project Structure and Organization](#project-structure-and-organization)
4. [Initialization and Scaffolding](#initialization-and-scaffolding)
5. [Block Development Workflow](#block-development-workflow)
6. [Asset Management](#asset-management)
7. [Block Registration and Integration](#block-registration-and-integration)
8. [Testing Strategy](#testing-strategy)
9. [Deployment and Distribution](#deployment-and-distribution)
10. [Performance Considerations](#performance-considerations)
11. [AI-Assisted Development](#ai-assisted-development)
12. [Maintenance and Updates](#maintenance-and-updates)

## Introduction

A multi-block plugin provides a collection of related blocks that work together to deliver a cohesive set of functionality within WordPress. Unlike single block plugins, multi-block plugins require more sophisticated organization, shared components, and careful management of interdependencies.

Multi-block plugins are ideal for:

- Creating a suite of related functionality (like advanced form blocks)
- Building feature-complete solutions (like e-commerce product displays)
- Providing variations of similar blocks with a consistent interface
- Implementing blocks that share common components or data structures

This document outlines the specialized build process for multi-block plugins, focusing on the unique challenges of managing multiple blocks within a single codebase.

## Development Environment Setup

A solid development environment is essential for complex multi-block projects:

### WordPress Development Environment

Choose one of these options:

1. **@wordpress/env (Recommended)**
   ```bash
   npm i -g @wordpress/env
   wp-env start
   ```

2. **LocalWP**
   - Create a new local site
   - Configure with latest WordPress

3. **Custom Docker Setup**
   - Configure containers for WordPress, MySQL, and PHP
   - Mount plugin directory for development

### Required Development Tools

1. **Node.js and npm**
   - Node.js v16+ recommended
   - npm v7+ or Yarn v1.22+

2. **Development Tools**
   - Modern code editor (VS Code recommended)
   - Git for version control
   - Browser devtools and React Developer Tools

3. **WordPress Block Development Tools**
   - Block Inspector
   - React Developer Tools browser extension
   - Redux DevTools (if using @wordpress/data)

## Project Structure and Organization

The directory structure for a multi-block plugin is more complex than for single blocks:

```
my-blocks-plugin/
├── build/                 # Compiled assets (generated)
│   ├── block-a/           # Built assets for Block A
│   ├── block-b/           # Built assets for Block B
│   └── shared/            # Built shared components/utilities
├── src/
│   ├── blocks/            # Source for individual blocks
│   │   ├── block-a/
│   │   │   ├── block.json # Block A metadata
│   │   │   ├── edit.js    # Block A editor component
│   │   │   ├── icon.js    # Block A icon
│   │   │   ├── index.js   # Block A entry point
│   │   │   ├── save.js    # Block A save component
│   │   │   └── style.scss # Block A styles
│   │   └── block-b/
│   │       └── ...        # Similar structure for Block B
│   ├── components/        # Shared React components
│   ├── hooks/             # Custom React hooks
│   ├── utils/             # Shared utility functions
│   ├── styles/            # Shared styles
│   └── index.js           # Main JS entry point
├── includes/              # PHP functionality
│   ├── blocks/            # Block-specific PHP code
│   ├── rest-api/          # Custom REST API endpoints
│   └── admin/             # Admin-specific functionality
├── my-blocks-plugin.php   # Main plugin file
├── package.json           # Dependencies and scripts
└── webpack.config.js      # Build configuration
```

## Initialization and Scaffolding

### Starting from Scratch

1. Create the plugin directory and main plugin file
2. Initialize package.json:
   ```bash
   npm init
   ```
3. Install core dependencies:
   ```bash
   npm install --save-dev @wordpress/scripts @wordpress/env
   ```

### Using @wordpress/create-block as a Foundation

1. Create an initial block:
   ```bash
   npx @wordpress/create-block my-blocks-plugin
   ```
2. Restructure for multiple blocks:
   ```bash
   cd my-blocks-plugin
   mkdir -p src/blocks/first-block
   # Move initial block files into this directory
   ```

### Adding Additional Blocks

Two approaches for adding more blocks:

1. **Create-Block with --no-plugin Flag**
   ```bash
   cd src/blocks
   npx @wordpress/create-block second-block --no-plugin
   ```

2. **Manual Creation**
   - Create a new directory in src/blocks/
   - Add block.json, edit.js, save.js, etc.
   - Register the block in your index.js

## Block Development Workflow

### Shared Code Base Considerations

When working with multiple blocks, consider:

1. **Component Reusability**
   - Create shared components in src/components/
   - Import these components in multiple blocks

2. **Consistent Styling**
   - Use shared SCSS variables and mixins
   - Create a design system for visual consistency

3. **State Management**
   - Consider using @wordpress/data for shared state
   - Create custom stores for complex state requirements

### Managing Block Variations

For related blocks with similar functionality:

```jsx
// Approach 1: Multiple blocks sharing components
// blocks/feature-block/edit.js
import { SharedControl } from '../../components/shared-control';

export default function Edit({ attributes, setAttributes }) {
  return (
    <div>
      <SharedControl
        value={attributes.feature}
        onChange={(feature) => setAttributes({ feature })}
      />
      {/* Block-specific content */}
    </div>
  );
}

// Approach 2: Single block with variations
// blocks/product/variations.js
export const variations = [
  {
    name: 'card',
    title: 'Product Card',
    attributes: { variant: 'card' },
  },
  {
    name: 'list',
    title: 'Product List',
    attributes: { variant: 'list' },
  }
];

// blocks/product/edit.js
import { variations } from './variations';

export default function Edit({ attributes }) {
  const { variant } = attributes;
  
  return variant === 'card' ? <CardComponent /> : <ListComponent />;
}
```

## Asset Management

Managing assets across multiple blocks requires special consideration:

### Configuring webpack

Extend @wordpress/scripts with a custom webpack configuration:

```js
// webpack.config.js
const defaultConfig = require('@wordpress/scripts/config/webpack.config');
const path = require('path');
const { readdirSync } = require('fs');

// Get all block directories
const blockDirs = readdirSync('./src/blocks').filter(
  (file) => file.indexOf('.') === -1
);

// Create entry points for each block
const entries = {};
blockDirs.forEach((blockDir) => {
  entries[blockDir] = `./src/blocks/${blockDir}/index.js`;
});

// Add shared entry point
entries.shared = './src/index.js';

module.exports = {
  ...defaultConfig,
  entry: entries,
  output: {
    ...defaultConfig.output,
    path: path.resolve(process.cwd(), 'build'),
  },
};
```

### Shared Assets

For styles and assets used across blocks:

```scss
// src/styles/_variables.scss
$primary-color: #007cba;
$secondary-color: #11a0c4;

// src/blocks/block-a/style.scss
@import '../../styles/variables';

.wp-block-myplugin-block-a {
  background-color: $primary-color;
}

// src/blocks/block-b/style.scss
@import '../../styles/variables';

.wp-block-myplugin-block-b {
  border-color: $primary-color;
}
```

## Block Registration and Integration

### PHP Registration

For multi-block plugins, automate block registration:

```php
<?php
// my-blocks-plugin.php

function my_blocks_plugin_register_blocks() {
    // Get all block.json files from build directory
    $block_dirs = glob(plugin_dir_path(__FILE__) . 'build/*', GLOB_ONLYDIR);
    
    foreach ($block_dirs as $block_dir) {
        // Skip the shared directory
        if (basename($block_dir) === 'shared') {
            continue;
        }
        
        if (file_exists($block_dir . '/block.json')) {
            register_block_type($block_dir);
        }
    }
}
add_action('init', 'my_blocks_plugin_register_blocks');
```

### JavaScript Integration

Register all blocks in a centralized file:

```js
// src/index.js
import { registerBlockType } from '@wordpress/blocks';

// Import block.json data
import * as blockA from './blocks/block-a/block.json';
import * as blockB from './blocks/block-b/block.json';

// Import edit and save components
import * as blockAFunctions from './blocks/block-a';
import * as blockBFunctions from './blocks/block-b';

// Register all blocks
[
  { metadata: blockA, ...blockAFunctions },
  { metadata: blockB, ...blockBFunctions },
].forEach(({ metadata, name, settings }) => {
  const { name: blockName, ...restMetadata } = metadata;
  registerBlockType(blockName, {
    ...restMetadata,
    ...settings,
  });
});
```

## Testing Strategy

Testing a multi-block plugin requires a comprehensive approach:

### Unit Testing Components

Test shared components and utilities:

```js
// src/components/__tests__/shared-control.test.js
import { render, screen } from '@testing-library/react';
import { SharedControl } from '../shared-control';

describe('SharedControl', () => {
  test('renders correctly', () => {
    render(<SharedControl value="test" onChange={() => {}} />);
    expect(screen.getByText('test')).toBeInTheDocument();
  });
});
```

### Integration Testing

Test how blocks work together:

```js
// tests/integration/blocks.test.js
import { createBlock } from '@wordpress/blocks';

describe('Block Integration', () => {
  test('blocks can be transformed', () => {
    const blockA = createBlock('my-plugin/block-a', { content: 'Test' });
    const transformed = blockA.transforms.to[0].transform(blockA);
    
    expect(transformed.name).toBe('my-plugin/block-b');
    expect(transformed.attributes.content).toBe('Test');
  });
});
```

### End-to-End Testing

Test the complete user experience:

```js
// e2e/blocks.spec.js
describe('Blocks', () => {
  test('can insert all blocks', async ({ page }) => {
    await page.goto('/wp-admin/post-new.php');
    
    // Insert Block A
    await page.click('.block-editor-inserter__toggle');
    await page.fill('input[placeholder="Search"]', 'Block A');
    await page.click('button:has-text("Block A")');
    await expect(page.locator('.wp-block-my-plugin-block-a')).toBeVisible();
    
    // Insert Block B
    await page.click('.block-editor-inserter__toggle');
    await page.fill('input[placeholder="Search"]', 'Block B');
    await page.click('button:has-text("Block B")');
    await expect(page.locator('.wp-block-my-plugin-block-b')).toBeVisible();
  });
});
```

## Deployment and Distribution

### Production Build

Create optimized assets for all blocks:

```bash
npm run build
```

### Package Organization

Prepare for distribution:

1. Include only necessary files:
   - PHP files
   - build directory (compiled assets)
   - block.json files
   - readme.txt and LICENSE

2. Create a .distignore file to exclude development files:
   ```
   .git
   .github
   node_modules
   src
   tests
   .eslintrc
   .gitignore
   package.json
   package-lock.json
   webpack.config.js
   ```

### Plugin ZIP Creation

Add a script to create the distributable package:

```json
// package.json
"scripts": {
  "build": "wp-scripts build",
  "plugin-zip": "wp-scripts plugin-zip"
}
```

## Performance Considerations

### Code Splitting

Optimize loading by splitting code:

```js
// webpack.config.js
module.exports = {
  ...defaultConfig,
  optimization: {
    ...defaultConfig.optimization,
    splitChunks: {
      cacheGroups: {
        shared: {
          name: 'shared',
          chunks: 'all',
          test: /[\\/]src[\\/](components|utils|hooks)[\\/]/,
          priority: 10,
        },
      },
    },
  },
};
```

### Conditional Loading

Load block assets only when needed:

```php
<?php
function my_blocks_plugin_enqueue_block_assets() {
    // Only enqueue block assets when needed
    if (!is_singular() || !has_block('my-plugin/block-a')) {
        return;
    }
    
    wp_enqueue_style(
        'my-plugin-block-a-style',
        plugins_url('build/block-a/style-index.css', __FILE__),
        [],
        filemtime(plugin_dir_path(__FILE__) . 'build/block-a/style-index.css')
    );
}
add_action('enqueue_block_assets', 'my_blocks_plugin_enqueue_block_assets');
```

## AI-Assisted Development

Leverage AI tools to streamline multi-block development:

### Code Generation with AI

1. **Block Scaffolding**
   - Use AI to generate boilerplate for new blocks
   - Create consistent patterns across blocks

2. **Component Development**
   - Generate shared components based on requirements
   - Refactor duplicate code into reusable components

3. **Testing Assistance**
   - Generate test cases for blocks and components
   - Create mock data for testing

### AI Workflow Integration

Example GitHub Copilot workflow:

```javascript
// Ask Copilot to generate a new block component
// Example: "Generate a pricing table block edit component with toggleable features"

// Copilot will suggest code like:
export default function PricingTableEdit({ attributes, setAttributes }) {
  const { title, price, features = [], currency = '$' } = attributes;
  
  const toggleFeature = (index) => {
    const newFeatures = [...features];
    newFeatures[index].enabled = !newFeatures[index].enabled;
    setAttributes({ features: newFeatures });
  };
  
  return (
    <div className="pricing-table">
      <RichText
        tagName="h3"
        value={title}
        onChange={(title) => setAttributes({ title })}
        placeholder="Plan name"
      />
      
      <div className="pricing-table__price">
        <span className="currency">{currency}</span>
        <RichText
          tagName="span"
          value={price}
          onChange={(price) => setAttributes({ price })}
          placeholder="Price"
        />
      </div>
      
      <ul className="pricing-table__features">
        {features.map((feature, index) => (
          <li 
            key={index}
            className={!feature.enabled ? 'disabled' : ''}
            onClick={() => toggleFeature(index)}
          >
            {feature.text}
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## Maintenance and Updates

### Versioning Strategy

Use semantic versioning for your plugin:

1. **Major version**: Breaking changes to block structure or API
2. **Minor version**: New blocks or features added
3. **Patch version**: Bug fixes and minor improvements

### Block Deprecation

Handle changes to block structure:

```js
// blocks/feature-block/index.js
export const deprecated = [
  {
    attributes: {
      // Old attribute schema
      text: { type: 'string' }
    },
    save: ({ attributes }) => {
      // Old save implementation
      return <p>{attributes.text}</p>;
    },
    migrate: (attributes) => {
      // Migration function to new structure
      return {
        content: attributes.text,
      };
    },
  }
];
```

### Update Management

Consider backward compatibility:

1. Test updates against previous content
2. Provide migration paths for existing blocks
3. Document breaking changes clearly in changelogs

---

This document outlines the comprehensive build process for creating WordPress multi-block plugins. By following these guidelines, you can develop, test, and maintain a collection of blocks that work together seamlessly while keeping your codebase organized and maintainable.
