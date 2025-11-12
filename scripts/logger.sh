#!/bin/bash
#==============================================================================
# logger.sh
#
# DESCRIPTION:
#   Provides centralized logging functions for other scripts.
#   Defines standard functions for INFO, WARN, ERROR, and DEBUG levels,
#   with options to log to console, file, or both.
#
# USAGE:
#   source "$(dirname "$0")/logger.sh"
#
# AUTHOR:
#   dawciobiel (http://github.com/dawciobiel)
#
# CREATED:
#   2025-11-12
#==============================================================================

# Load colors for logging output
if [ -f "$(dirname "$0")/colors" ]; then
    source "$(dirname "$0")/colors"
else
    # Fallback colors if the file is missing
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
    BOLD='\033[1m'
fi

# === Internal Logging Helpers ===
_log_to_console() {
    local color="$1"
    local level="$2"
    shift 2
    echo -e "[${color}${level}${NC}] $*"
}

_log_to_file() {
    local level="$1"
    shift
    if [ -n "$LOG_FILE" ]; then
        echo "[$level] $*" >> "$LOG_FILE"
    fi
}

# === Public Logging Functions ===

# --- INFO ---
log_info_console() { _log_to_console "$GREEN" "INFO" "$*"; }
log_info_file() { _log_to_file "INFO" "$*"; }
log_info() {
    log_info_console "$*"
    log_info_file "$*"
}

# --- WARN ---
log_warn_console() { _log_to_console "$YELLOW" "WARN" "$*" >&2; }
log_warn_file() { _log_to_file "WARN" "$*"; }
log_warn() {
    log_warn_console "$*"
    log_warn_file "$*"
}

# --- ERROR ---
log_error_console() { _log_to_console "$RED" "ERROR" "$*" >&2; }
log_error_file() { _log_to_file "ERROR" "$*"; }
log_error() {
    log_error_console "$*"
    log_error_file "$*"
}

# --- SUCCESS ---
log_success_console() { _log_to_console "$GREEN" "OK" "$*"; }
log_success_file() { _log_to_file "OK" "$*"; }
log_success() {
    log_success_console "$*"
    log_success_file "$*"
}

# --- DEBUG ---
log_debug_console() { [ "$DEBUG_MODE" = "1" ] && _log_to_console "$CYAN" "DEBUG" "$*"; }
log_debug_file() { [ "$DEBUG_MODE" = "1" ] && _log_to_file "DEBUG" "$*"; }
log_debug() {
    log_debug_console "$*"
    log_debug_file "$*"
}

# --- HEADER ---
log_header_console() { echo -e "\n${BOLD}${CYAN}== $* ==${NC}"; }
log_header_file() { [ -n "$LOG_FILE" ] && echo -e "\n== $* ==" >> "$LOG_FILE"; }
log_header() {
    log_header_console "$*"
    log_header_file "$*"
}