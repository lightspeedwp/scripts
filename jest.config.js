/**
 * ============================================================================
 * Jest Config for LightSpeedWP Repo
 * Location: jest.config.js
 * Description: Configures Jest to run all tests in tests/ directory.
 * Standards: Follows org-wide test match and environment patterns.
 * Contribution:
 *   - Update config if adding new test directory or coverage requirements.
 * ============================================================================
 */
module.exports = {
    testEnvironment: 'node',
    testMatch: ['**/tests/**/*.test.js'],
    verbose: true,
    // transform: { "^.+\\.jsx?$": "babel-jest" }, // Uncomment if using Babel
    // coverageDirectory: "./coverage",
    // collectCoverage: true,
};
