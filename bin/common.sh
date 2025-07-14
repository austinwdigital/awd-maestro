#!/bin/bash

# AWDHAUS Maestro - Common utilities and styling
# Modern agency color palette

set -e
set -o pipefail

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
  echo -e "${SECONDARY}  █████╗     ██╗    ██╗    ██████╗ ${RESET}"
  echo -e "${SECONDARY}  ██╔══██╗    ██║    ██║    ██╔══██╗${RESET}"
  echo -e "${SECONDARY}  ███████║    ██║ █╗ ██║    ██║  ██║${RESET}"
  echo -e "${SECONDARY}  ██╔══██║    ██║███╗██║    ██║  ██║${RESET}"
  echo -e "${SECONDARY}  ██║  ██║    ╚███╔███╔╝    ██████╔╝${RESET}"
  echo -e "${SECONDARY}  ╚═╝  ╚═╝     ╚══╝╚══╝     ╚═════╝ ${RESET}"
  echo -e "${PRIMARY}  ███╗   ███╗ █████╗ ███████╗███████╗████████╗██████╗  ██████╗ ${RESET}"
  echo -e "${PRIMARY}  ████╗ ████║██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗${RESET}"
  echo -e "${PRIMARY}  ██╔████╔██║███████║█████╗  ███████╗   ██║   ██████╔╝██║   ██║${RESET}"
  echo -e "${PRIMARY}  ██║╚██╔╝██║██╔══██║██╔══╝  ╚════██║   ██║   ██╔══██╗██║   ██║${RESET}"
  echo -e "${PRIMARY}  ██║ ╚═╝ ██║██║  ██║███████╗███████║   ██║   ██║  ██║╚██████╔╝${RESET}"
  echo -e "${PRIMARY}  ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ${RESET}"
}

function print_header() {
  clear
  echo -e "${PRIMARY}╭$(printf '%0.s═' $(seq 1 65))╮${RESET}"
  echo -e "${PRIMARY}│${RESET}                                                                 ${PRIMARY}│${RESET}"
  print_logo
  echo -e "${PRIMARY}│${RESET}                                                                 ${PRIMARY}│${RESET}"
  echo -e "${PRIMARY}│${RESET}  ${SECONDARY}CREATIVE DEVELOPMENT ENVIRONMENT ORCHESTRATION${RESET}                 ${PRIMARY}│${RESET}"
  echo -e "${PRIMARY}╰$(printf '%0.s═' $(seq 1 65))╯${RESET}"
  echo
}

function print_divider() {
  echo -e "${SECONDARY}$(printf '%0.s─' $(seq 1 67))${RESET}"
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
  echo -e "${PRIMARY}┌─ ${BOLD}${1}${RESET} ${SECONDARY}$2${RESET}"
  echo -e "${PRIMARY}└$(printf '%0.s─' $(seq 1 15))${RESET}"
}

function print_maestro_header() {
  echo -e "${PRIMARY}${BOLD}╭── MAESTRO CONCIERGE $(printf '%0.s─' $(seq 1 47))╮${RESET}"
  echo -e "${PRIMARY}${BOLD}│${RESET} ${WHITE}Comprehensive system maintenance and optimization${RESET}             ${PRIMARY}${BOLD}│${RESET}"
  echo -e "${PRIMARY}${BOLD}╰$(printf '%0.s─' $(seq 1 67))╯${RESET}"
  echo
}

# Export NVM directories
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
