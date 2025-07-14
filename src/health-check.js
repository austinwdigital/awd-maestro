#!/usr/bin/env node

'use strict';

/**
 * AWD Maestro - Health Check Module
 * Provides a comprehensive health check of the developer environment
 * @package @awd/maestro
 */

import { execSync } from 'child_process';
import chalk from 'chalk';
import ora from 'ora';
import { fileURLToPath } from 'url';

// Define color palette
const primary = chalk.hex('#C8FF00');    // Lime
const secondary = chalk.hex('#767676');  // Gray
const white = chalk.hex('#FFFFFF');      // White
const success = chalk.hex('#10B981');    // Green
const gray = chalk.gray;

// Icons using unicode
const icons = {
  success: '✓',
  warning: '⚠️',
  info: 'ℹ️',
  error: '✗',
  node: '📦',
  npm: '📦',
  pnpm: '⚡',
  nvm: '🔄',
  disk: '💾',
  memory: '🧠',
  git: '🔀'
};

/**
 * Run a command and return the trimmed output
 */
function runCommand(command) {
  try {
    return execSync(command, { encoding: 'utf8' }).trim();
  } catch (error) {
    return null;
  }
}

/**
 * Print a section header
 */
function printSection(title) {
  console.log('\n' + primary.bold(title));
  console.log(gray('─'.repeat(title.length + 20)));
}

/**
 * Print info with icon
 */
function printInfo(icon, label, value) {
  console.log(`${icon}  ${gray(label)} ${value}`);
}

/**
 * Get system stats
 */
async function getSystemInfo() {
  printSection('SYSTEM');

  const spinner = ora('Gathering system information').start();

  // Get OS info
  const osType = runCommand('uname -s');
  const osVersion = runCommand('uname -r');
  const hostname = runCommand('hostname');

  // Get disk usage
  const diskUsage = runCommand("df -h / | tail -1 | awk '{print $5}'");

  // Get memory usage
  const memoryTotal = runCommand("sysctl -n hw.memsize | awk '{print $1/1073741824\" GB\"}'");

  spinner.succeed('System information gathered');

  printInfo(icons.info, 'OS:', `${osType} ${osVersion}`);
  printInfo(icons.info, 'Hostname:', hostname);
  printInfo(icons.disk, 'Disk usage:', diskUsage);
  printInfo(icons.memory, 'Memory:', memoryTotal);
}

/**
 * Get runtime versions
 */
async function getRuntimeInfo() {
  printSection('RUNTIMES');

  const spinner = ora('Checking installed runtimes').start();

  // Get runtime versions
  const nodeVersion = runCommand('node -v');
  const npmVersion = runCommand('npm -v');
  const pnpmVersion = runCommand('pnpm -v');
  const nvmVersion = runCommand('nvm --version');

  // Get Git info
  const gitVersion = runCommand('git --version');

  spinner.succeed('Runtime check complete');

  printInfo(icons.node, 'Node:', white.bold(nodeVersion));
  printInfo(icons.npm, 'NPM:', white.bold(npmVersion));
  printInfo(icons.pnpm, 'PNPM:', white.bold(pnpmVersion));
  printInfo(icons.nvm, 'NVM:', white.bold(nvmVersion));
  printInfo(icons.git, 'Git:', white.bold(gitVersion));
}

/**
 * Get global packages
 */
async function getPackageInfo() {
  printSection('GLOBAL PACKAGES');

  // Get PNPM global packages
  const pnpmSpinner = ora('Checking PNPM global packages').start();
  const pnpmGlobals = runCommand('pnpm list -g --depth=0');
  pnpmSpinner.succeed('PNPM global packages checked');

  console.log(gray('\nPNPM Globals:'));
  console.log(pnpmGlobals);

  // Get NPM global packages
  const npmSpinner = ora('Checking NPM global packages').start();
  const npmGlobals = runCommand('npm list -g --depth=0');
  npmSpinner.succeed('NPM global packages checked');

  console.log(gray('\nNPM Globals:'));
  console.log(npmGlobals);
}

/**
 * Check for potential issues
 */
async function getHealthIssues() {
  printSection('HEALTH CHECK');

  const spinner = ora('Running health diagnostics').start();

  // Check for outdated packages
  const outdatedNpm = runCommand('npm outdated -g');
  const outdatedPnpm = runCommand('pnpm outdated -g');

  // Check disk space
  const diskSpace = runCommand("df -h / | tail -1 | awk '{print $5}'");
  const diskSpacePercentage = parseInt(diskSpace);

  spinner.succeed('Diagnostics complete');

  let issuesFound = false;

  // Check disk space
  if (diskSpacePercentage > 80) {
    console.log(`${icons.warning}  ${secondary('Disk space is running low:')} ${diskSpace} used`);
    issuesFound = true;
  }

  // Check for outdated packages
  if (outdatedNpm && outdatedNpm.length > 0) {
    console.log(`${icons.warning}  ${secondary('Outdated NPM packages detected')}`);
    issuesFound = true;
  }

  if (outdatedPnpm && outdatedPnpm.length > 0) {
    console.log(`${icons.warning}  ${secondary('Outdated PNPM packages detected')}`);
    issuesFound = true;
  }

  if (!issuesFound) {
    console.log(`${icons.success}  ${success('All systems healthy!')}`);
  }
}

/**
 * Run the health check
 */
export async function runHealthCheck() {
  console.log(`\n${primary.bold('AWD MAESTRO HEALTH CHECK')}\n`);

  try {
    await getSystemInfo();
    await getRuntimeInfo();
    await getPackageInfo();
    await getHealthIssues();

    console.log(`\n${icons.success}  ${success.bold('Health check complete!')}\n`);
  } catch (error) {
    console.error(`\n${icons.error}  ${chalk.red('Error during health check:')} ${error.message}\n`);
  }
}

// Run directly if called from command line
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  runHealthCheck();
} 