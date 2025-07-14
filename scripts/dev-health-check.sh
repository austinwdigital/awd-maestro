#!/bin/bash

# AWD Maestro - Development Environment Health Check
# Provides comprehensive information about the development environment

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

# Check if running in quiet mode
if [[ "$1" == "--quiet" ]]; then
  QUIET=true
else
  QUIET=false
  print_header
fi

# SYSTEM INFORMATION
print_section "SYSTEM INFORMATION"
echo -e "${SECONDARY}Operating System:${RESET} $(uname -s) $(uname -r)"
echo -e "${SECONDARY}Hostname:${RESET} $(hostname)"
echo -e "${SECONDARY}Disk Usage:${RESET} $(df -h / | tail -1 | awk '{print $5}')"
echo -e "${SECONDARY}Memory:${RESET} $(sysctl -n hw.memsize 2>/dev/null | awk '{print $1/1073741824" GB"}' 2>/dev/null || echo "Unknown")"
echo

# RUNTIME VERSIONS
print_section "RUNTIME VERSIONS"
echo -e "${BOLD}Node.js:${RESET} $(node -v 2>/dev/null || echo "Not installed")"
echo -e "${BOLD}NPM:${RESET} $(npm -v 2>/dev/null || echo "Not installed")"
echo -e "${BOLD}PNPM:${RESET} $(pnpm -v 2>/dev/null || echo "Not installed")"
echo -e "${BOLD}NVM:${RESET} $(nvm --version 2>/dev/null || echo "Not installed")"
echo -e "${BOLD}Git:${RESET} $(git --version 2>/dev/null || echo "Not installed")"
echo

# NODE.JS VERSIONS
print_section "NODE.JS VERSIONS"
echo -e "${SECONDARY}Current version:${RESET} $(node -v 2>/dev/null || echo "Not installed")"
echo -e "${SECONDARY}Default version:${RESET} $(nvm which default 2>/dev/null || echo "Not set")"
echo -e "${SECONDARY}Installed versions:${RESET}"
if command -v nvm &>/dev/null; then
  versions=$(nvm ls --no-colors 2>/dev/null)
  if [ -n "$versions" ]; then
    # Use awk to get unique versions and handle the current marker
    current_version=$(node -v 2>/dev/null)
    echo "$versions" | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" | sort -V | uniq | while read -r version; do
      if [[ "$current_version" == "$version" ]]; then
        echo -e "  ${SUCCESS}${BOLD}${version}${RESET} ${SECONDARY}(current)${RESET}"
      else
        echo -e "  ${GRAY}${version}${RESET}"
      fi
    done
  else
    echo "  No Node.js versions installed via NVM"
  fi
else
  echo "  NVM not installed"
fi
echo

# NPM GLOBAL PACKAGES
print_section "NPM GLOBAL PACKAGES"
if command -v npm &>/dev/null; then
  echo -e "${SECONDARY}Installed packages:${RESET}"
  npm_packages=$(npm list -g --depth=0 2>/dev/null)
  if [ -n "$npm_packages" ]; then
    echo "$npm_packages" | tail -n +2 | sed 's/[├└]── //g' | while read -r line; do
      if [ -n "$line" ]; then
        echo -e "  ${line}"
      fi
    done
  else
    echo "  No global NPM packages installed"
  fi
  
  echo
  echo -e "${SECONDARY}Outdated packages:${RESET}"
  outdated=$(npm outdated -g --depth=0 2>/dev/null)
  if [ -z "$outdated" ]; then
    echo -e "  ${SUCCESS}No outdated packages${RESET}"
  else
    echo "$outdated" | tail -n +2 | while read -r line; do
      if [ -n "$line" ]; then
        echo -e "  ${line}"
      fi
    done
  fi
else
  echo "  NPM not installed"
fi
echo

# PNPM GLOBAL PACKAGES
print_section "PNPM GLOBAL PACKAGES"
if command -v pnpm &>/dev/null; then
  echo -e "${SECONDARY}Installed packages:${RESET}"
  pnpm_packages=$(pnpm list -g --depth=0 2>/dev/null)
  if [ -n "$pnpm_packages" ]; then
    echo "$pnpm_packages" | tail -n +2 | while read -r line; do
      if [ -n "$line" ]; then
        echo -e "  ${line}"
      fi
    done
  else
    echo "  No global PNPM packages installed"
  fi
  
  echo
  echo -e "${SECONDARY}Outdated packages:${RESET}"
  outdated=$(pnpm outdated -g --depth=0 2>/dev/null)
  if [ -z "$outdated" ]; then
    echo -e "  ${SUCCESS}No outdated packages${RESET}"
  else
    echo "$outdated" | tail -n +2 | while read -r line; do
      if [ -n "$line" ]; then
        echo -e "  ${line}"
      fi
    done
  fi
else
  echo "  PNPM not installed"
fi
echo

# ENVIRONMENT HEALTH
print_section "ENVIRONMENT HEALTH"
# Check disk space (root filesystem only)
disk_space=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
if [ "$disk_space" -gt 80 ]; then
  echo -e "${WARNING}! Root filesystem space is running low (${disk_space}%)${RESET}"
else
  echo -e "${SUCCESS}✓ Root filesystem space is adequate (${disk_space}%)${RESET}"
fi
echo -e "${SECONDARY}Note: This only checks the root (/) filesystem, not your entire disk${RESET}"

# Check for outdated npm packages
if command -v npm &>/dev/null; then
  outdated_npm=$(npm outdated -g --depth=0 2>/dev/null | wc -l)
  outdated_npm=$(echo "$outdated_npm" | tr -d ' ')
  if [ "$outdated_npm" -gt 1 ]; then
    echo -e "${WARNING}! ${outdated_npm} outdated NPM packages${RESET}"
  else
    echo -e "${SUCCESS}✓ NPM packages are up to date${RESET}"
  fi
fi

# Check for outdated pnpm packages
if command -v pnpm &>/dev/null; then
  outdated_pnpm=$(pnpm outdated -g --depth=0 2>/dev/null | wc -l)
  outdated_pnpm=$(echo "$outdated_pnpm" | tr -d ' ')
  if [ "$outdated_pnpm" -gt 1 ]; then
    echo -e "${WARNING}! ${outdated_pnpm} outdated PNPM packages${RESET}"
  else
    echo -e "${SUCCESS}✓ PNPM packages are up to date${RESET}"
  fi
fi

print_success "Health check complete"
echo
echo -e "${SECONDARY}Run ${BOLD}awd-maestro${RESET} ${SECONDARY}to manage your environment${RESET}"
