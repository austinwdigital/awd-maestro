#!/bin/bash

# AWDHAUS Maestro Installation Script
# Creative Development Environment Orchestration
# Version: 0.1.0

set -e
set -o pipefail

# Terminal styling
RESET='\033[0m'
BOLD='\033[1m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BRIGHT_BLACK='\033[0;90m'
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_YELLOW='\033[0;93m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_MAGENTA='\033[0;95m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_WHITE='\033[0;97m'

# Modern agency colors
PRIMARY='\033[38;2;200;255;0m'  # Lime #C8FF00
SECONDARY='\033[38;2;118;118;118m'  # Gray #767676
WHITE='\033[38;2;255;255;255m'  # White #FFFFFF
SUCCESS='\033[0;92m'      # Green
WARNING='\033[0;93m'      # Amber
ERROR='\033[0;91m'        # Red
DARK='\033[0;30m'         # Dark gray
LIGHT='\033[0;97m'        # Light gray

# Symbols
CHECK="${SUCCESS}✓${RESET}"
CROSS="${ERROR}✗${RESET}"
ARROW="${SECONDARY}→${RESET}"
INFO="${BLUE}ⓘ${RESET}"

# Installation paths
INSTALL_DIR="$HOME/.awdhaus-maestro"
BIN_DIR="$INSTALL_DIR/bin"
SCRIPTS_DIR="$INSTALL_DIR/scripts"

# ASCII art logo
function print_logo() {
  echo -e "${SECONDARY}  █████╗  ██╗    ██╗ ██████╗  ██╗  ██╗  █████╗  ██╗   ██╗ ███████╗${RESET}"
  echo -e "${SECONDARY}  ██╔══██╗ ██║    ██║ ██╔══██╗ ██║  ██║ ██╔══██╗ ██║   ██║ ██╔════╝${RESET}"
  echo -e "${SECONDARY}  ███████║ ██║ █╗ ██║ ██║  ██║ ███████║ ███████║ ██║   ██║ ███████╗${RESET}"
  echo -e "${SECONDARY}  ██╔══██║ ██║███╗██║ ██║  ██║ ██╔══██║ ██╔══██║ ██║   ██║ ╚════██║${RESET}"
  echo -e "${SECONDARY}  ██║  ██║ ╚███╔███╔╝ ██████╔╝ ██║  ██║ ██║  ██║ ╚██████╔╝ ███████║${RESET}"
  echo -e "${SECONDARY}  ╚═╝  ╚═╝  ╚══╝╚══╝  ╚═════╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝  ╚═════╝  ╚══════╝${RESET}"
  echo -e "${PRIMARY}  ███╗   ███╗ █████╗ ███████╗███████╗████████╗██████╗  ██████╗ ${RESET}"
  echo -e "${PRIMARY}  ████╗ ████║██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗${RESET}"
  echo -e "${PRIMARY}  ██╔████╔██║███████║█████╗  ███████╗   ██║   ██████╔╝██║   ██║${RESET}"
  echo -e "${PRIMARY}  ██║╚██╔╝██║██╔══██║██╔══╝  ╚════██║   ██║   ██╔══██╗██║   ██║${RESET}"
  echo -e "${PRIMARY}  ██║ ╚═╝ ██║██║  ██║███████╗███████║   ██║   ██║  ██║╚██████╔╝${RESET}"
  echo -e "${PRIMARY}  ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ${RESET}"
}

# Print header
function print_header() {
  clear
  echo -e "${PRIMARY}╔$(printf '%0.s═' $(seq 1 65))╗${RESET}"
  echo -e "${PRIMARY}║${RESET}                                                           ${PRIMARY}║${RESET}"
  print_logo
  echo -e "${PRIMARY}║${RESET}                                                           ${PRIMARY}║${RESET}"
  echo -e "${PRIMARY}║${RESET}   ${SECONDARY}CREATIVE DEVELOPMENT ENVIRONMENT ORCHESTRATION${RESET}            ${PRIMARY}║${RESET}"
  echo -e "${PRIMARY}╚$(printf '%0.s═' $(seq 1 65))╝${RESET}"
  echo
  echo -e "${ARROW} ${WHITE}${BOLD}Installing AWDHAUS Maestro v0.1.0${RESET}"
  echo
}

# Print section header
function print_section() {
  echo
  echo -e "${PRIMARY}┌─ ${BOLD}${1}${RESET}"
  echo -e "${PRIMARY}└$(printf '%0.s─' $(seq 1 15))${RESET}"
}

# Print step
function print_step() {
  echo -e "${ARROW} ${1}"
}

# Print success
function print_success() {
  echo -e "${CHECK} ${1}"
}

# Print warning
function print_warning() {
  echo -e "${WARNING}! ${1}"
}

# Print error
function print_error() {
  echo -e "${CROSS} ${1}"
}

# Print info
function print_info() {
  echo -e "${INFO} ${1}"
}

# Check if command exists
function command_exists() {
  command -v "$1" &> /dev/null
}

# Create directory if it doesn't exist
function create_dir_if_not_exists() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

# Display the header
print_header

# Check for existing installation
print_section "CHECKING EXISTING INSTALLATION"

if [ -d "$INSTALL_DIR" ]; then
  print_warning "Existing installation found at $INSTALL_DIR"
  print_step "Removing existing installation..."
  rm -rf "$INSTALL_DIR"
  print_success "Old installation removed"
else
  print_success "No existing installation found"
fi

# Initialize environment
print_section "INITIALIZING ENVIRONMENT"
print_step "Creating directory structure"
create_dir_if_not_exists "$INSTALL_DIR"
create_dir_if_not_exists "$BIN_DIR"
create_dir_if_not_exists "$SCRIPTS_DIR"
print_success "Directory structure created at $INSTALL_DIR"

# Check for Homebrew
print_section "DEPENDENCY HOMEBREW"
if command_exists brew; then
  print_success "Homebrew is already installed"
else
  print_step "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_success "Homebrew installed"
fi

# Check for NVM
print_section "DEPENDENCY NODE VERSION MANAGER"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command_exists nvm; then
  print_success "NVM is already installed"
else
  print_step "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  print_success "NVM installed"
fi

# Install latest Node.js LTS
print_step "Installing latest Node LTS"
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'
print_success "Node.js $(node -v) is now the default"

# Install PNPM
print_section "DEPENDENCY PACKAGE MANAGER"
print_step "Enabling Corepack"
corepack enable

if command_exists pnpm; then
  print_success "PNPM is already installed: $(pnpm --version)"
else
  print_step "Installing PNPM..."
  npm install -g pnpm
  print_success "PNPM installed: $(pnpm --version)"
fi

# Install global tools
print_section "INSTALLING GLOBAL TOOLS"
print_step "Installing global packages via PNPM"
pnpm add -g npm-check-updates
print_success "Global packages installed"

# Generate common functions script
print_section "GENERATING COMMON FUNCTIONS"
print_step "Creating common.sh"

cat > "$BIN_DIR/common.sh" << 'EOL'
#!/bin/bash

# AWDHAUS Maestro - Common utilities and styling
# Modern agency color palette

# Rich color palette
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BRIGHT_BLACK='\033[0;90m'
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_YELLOW='\033[0;93m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_MAGENTA='\033[0;95m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_WHITE='\033[0;97m'
BOLD='\033[1m'
RESET='\033[0m'

# Modern agency colors
PRIMARY='\033[38;2;200;255;0m'  # Lime #C8FF00
SECONDARY='\033[38;2;118;118;118m'  # Gray #767676
WHITE='\033[38;2;255;255;255m'  # White #FFFFFF
SUCCESS='\033[0;92m'      # Green
WARNING='\033[0;93m'      # Amber
ERROR='\033[0;91m'        # Red
DARK='\033[0;30m'         # Dark gray
LIGHT='\033[0;97m'        # Light gray

# Symbols
CHECK="${SUCCESS}✓${RESET}"
CROSS="${ERROR}✗${RESET}"
ARROW="${SECONDARY}>${RESET}"

# ASCII art logo from install.sh
function print_logo() {
  echo -e "${SECONDARY}  █████╗  ██╗    ██╗ ██████╗  ██╗  ██╗  █████╗  ██╗   ██╗ ███████╗${RESET}"
  echo -e "${SECONDARY}  ██╔══██╗ ██║    ██║ ██╔══██╗ ██║  ██║ ██╔══██╗ ██║   ██║ ██╔════╝${RESET}"
  echo -e "${SECONDARY}  ███████║ ██║ █╗ ██║ ██║  ██║ ███████║ ███████║ ██║   ██║ ███████╗${RESET}"
  echo -e "${SECONDARY}  ██╔══██║ ██║███╗██║ ██║  ██║ ██╔══██║ ██╔══██║ ██║   ██║ ╚════██║${RESET}"
  echo -e "${SECONDARY}  ██║  ██║ ╚███╔███╔╝ ██████╔╝ ██║  ██║ ██║  ██║ ╚██████╔╝ ███████║${RESET}"
  echo -e "${SECONDARY}  ╚═╝  ╚═╝  ╚══╝╚══╝  ╚═════╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝  ╚═════╝  ╚══════╝${RESET}"
  echo -e "${PRIMARY}  ███╗   ███╗ █████╗ ███████╗███████╗████████╗██████╗  ██████╗ ${RESET}"
  echo -e "${PRIMARY}  ████╗ ████║██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗${RESET}"
  echo -e "${PRIMARY}  ██╔████╔██║███████║█████╗  ███████╗   ██║   ██████╔╝██║   ██║${RESET}"
  echo -e "${PRIMARY}  ██║╚██╔╝██║██╔══██║██╔══╝  ╚════██║   ██║   ██╔══██╗██║   ██║${RESET}"
  echo -e "${PRIMARY}  ██║ ╚═╝ ██║██║  ██║███████╗███████║   ██║   ██║  ██║╚██████╔╝${RESET}"
  echo -e "${PRIMARY}  ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ${RESET}"
}

function print_header() {
  clear
  echo -e "${PRIMARY}╭${"═"*65}╮${RESET}"
  echo -e "${PRIMARY}│${RESET}                                                                 ${PRIMARY}│${RESET}"
  print_logo
  echo -e "${PRIMARY}│${RESET}                                                                 ${PRIMARY}│${RESET}"
  echo -e "${PRIMARY}│${RESET}  ${SECONDARY}CREATIVE DEVELOPMENT ENVIRONMENT ORCHESTRATION${RESET}                 ${PRIMARY}│${RESET}"
  echo -e "${PRIMARY}╰${"═"*65}╯${RESET}"
  echo
}

function print_divider() {
  echo -e "${SECONDARY}${"─"*67}${RESET}"
}

function print_step() {
  echo -e "${ARROW} ${WHITE}${BOLD}${1}${RESET}"
}

function print_success() {
  echo -e "${CHECK} ${SUCCESS}${1}${RESET}"
}

function print_error() {
  echo -e "${CROSS} ${ERROR}${1}${RESET}"
}

function print_warning() {
  echo -e "${WARNING}! ${WARNING}${1}${RESET}"
}

function print_info() {
  echo -e "${SECONDARY}${1}${RESET}"
}

function print_section() {
  echo
  echo -e "${PRIMARY}┌─ ${BOLD}${1}${RESET}"
  echo -e "${PRIMARY}└$(printf '%0.s─' $(seq 1 15))${RESET}"
}

function print_maestro_header() {
  echo -e "${PRIMARY}${BOLD}╭── MAESTRO CONCIERGE ───────────────────────────────────────────────╮${RESET}"
  echo -e "${PRIMARY}${BOLD}│${RESET} ${WHITE}Comprehensive system maintenance and optimization${RESET}             ${PRIMARY}${BOLD}│${RESET}"
  echo -e "${PRIMARY}${BOLD}╰───────────────────────────────────────────────────────────────────╯${RESET}"
  echo
}

# Export NVM directories
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOL

chmod +x "$BIN_DIR/common.sh"
print_success "Common functions script created"

# Generate utility scripts
print_section "GENERATING UTILITY SCRIPTS"
print_step "Creating utility scripts"

# Create scripts directory if it doesn't exist
mkdir -p "$SCRIPTS_DIR"

# Copy scripts from the project directory if running from a git repository
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_SCRIPTS_DIR="$SCRIPT_DIR/scripts"

if [ -d "$PROJECT_SCRIPTS_DIR" ]; then
  cp -R "$PROJECT_SCRIPTS_DIR"/* "$SCRIPTS_DIR/"
  chmod +x "$SCRIPTS_DIR"/*.sh
  print_success "Utility scripts created"
else
  print_info "Running from npm installation, files already in place"
fi

# Install project files
print_section "INSTALLING PROJECT FILES"
print_step "Setting up project files"

# Copy bin files from the project directory if running from a git repository
PROJECT_BIN_DIR="$SCRIPT_DIR/bin"

if [ -d "$PROJECT_BIN_DIR" ]; then
  cp -R "$PROJECT_BIN_DIR"/* "$BIN_DIR/"
  chmod +x "$BIN_DIR/maestro"
  print_success "Project files installed"
else
  print_info "Running from npm installation, files already in place"
fi

# Install dependencies
print_section "INSTALLING DEPENDENCIES"
print_step "Installing Node.js dependencies"

# If running from a git repository, install dependencies
if [ -f "$SCRIPT_DIR/package.json" ]; then
  cd "$SCRIPT_DIR" && npm install
  print_success "Dependencies installed successfully"
else
  # If running from npm, dependencies are already installed
  print_info "Running from npm installation, dependencies already installed"
fi

# Create symlink
print_section "INSTALLING SYSTEM LINK"
print_step "Creating symlink in $(dirname $(which node))"

# Create symlink to the maestro script
chmod +x "$BIN_DIR/maestro"
npm link

# Add alias to shell config if it doesn't exist
if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "alias awdhaus-maestro=" "$HOME/.zshrc"; then
    echo "alias awdhaus-maestro='$BIN_DIR/maestro'" >> "$HOME/.zshrc"
    print_success "Added alias to .zshrc"
  else
    print_info "Alias already exists in .zshrc"
  fi
fi

# Final message
echo
echo -e "${PRIMARY}${BOLD}╭── INSTALLATION COMPLETE ───────────────────────────────────────────╮${RESET}"
echo -e "${PRIMARY}${BOLD}│${RESET} ${SUCCESS}AWDHAUS Maestro has been installed successfully!${RESET}                ${PRIMARY}${BOLD}│${RESET}"
echo -e "${PRIMARY}${BOLD}│${RESET} ${WHITE}Run ${BOLD}awdhaus-maestro${RESET} ${WHITE}to get started${RESET}                            ${PRIMARY}${BOLD}│${RESET}"
echo -e "${PRIMARY}${BOLD}╰───────────────────────────────────────────────────────────────────╯${RESET}"
echo

exit 0