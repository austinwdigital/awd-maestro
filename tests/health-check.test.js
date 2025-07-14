import { describe, it, expect, vi } from 'vitest';
import { runHealthCheck } from '../src/health-check.js';
import { execSync } from 'child_process';

// Mock the child_process execSync
vi.mock('child_process', () => ({
  execSync: vi.fn()
}));

// Mock ora spinner
vi.mock('ora', () => {
  return {
    default: vi.fn().mockReturnValue({
      start: vi.fn().mockReturnThis(),
      succeed: vi.fn().mockReturnThis(),
      fail: vi.fn().mockReturnThis(),
      stop: vi.fn().mockReturnThis()
    })
  };
});

// Mock console.log
vi.spyOn(console, 'log').mockImplementation(() => { });
vi.spyOn(console, 'error').mockImplementation(() => { });

describe('Health Check', () => {
  beforeEach(() => {
    vi.clearAllMocks();

    // Set up default mock returns for execSync
    execSync.mockImplementation((command) => {
      if (command === 'node -v') return 'v18.15.0';
      if (command === 'npm -v') return '9.5.0';
      if (command === 'pnpm -v') return '8.6.0';
      if (command === 'nvm --version') return '0.39.3';
      if (command === 'git --version') return 'git version 2.39.2';
      if (command.includes('df -h')) return '45%';
      if (command.includes('hostname')) return 'macbook-pro';
      if (command.includes('uname -s')) return 'Darwin';
      if (command.includes('uname -r')) return '22.4.0';
      if (command.includes('npm list -g')) return 'npm packages';
      if (command.includes('pnpm list -g')) return 'pnpm packages';
      return '';
    });
  });

  it('should execute without errors', async () => {
    await expect(runHealthCheck()).resolves.not.toThrow();
  });

  it('should call execSync with the correct commands', async () => {
    await runHealthCheck();

    expect(execSync).toHaveBeenCalledWith('node -v', expect.anything());
    expect(execSync).toHaveBeenCalledWith('npm -v', expect.anything());
    expect(execSync).toHaveBeenCalledWith('pnpm -v', expect.anything());
    expect(execSync).toHaveBeenCalledWith('nvm --version', expect.anything());
  });

  it('should handle missing executables gracefully', async () => {
    // Make execSync throw for nvm
    execSync.mockImplementation((command) => {
      if (command === 'nvm --version') throw new Error('nvm not found');
      return 'mock output';
    });

    await expect(runHealthCheck()).resolves.not.toThrow();
  });
}); 