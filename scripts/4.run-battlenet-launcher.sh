#!/bin/bash
#==============================================================================
# run-battlenet-launcher.sh
#
# DESCRIPTION:
#   Launcher script for Battle.net under Wine on Linux.
#   Handles Wine environment setup, logging, and process management.
#
# USAGE:
#   ./run-battlenet-launcher.sh
#
# AUTHOR:
#   dawciobiel (http://github.com/dawciobiel)
#
# CREATED:
#   2025-05-08
#
# MODIFIED:
#   2025-11-12
#
# LICENSE:
#   MIT
#==============================================================================

# === Configuration ===
DEBUG_MODE=0 # Read proper value from wine.conf later.

# Load centralized logging functions
source "$(dirname "$0")/logger.sh"

# Check required config files
for conf in dxvk.conf mangohud.conf opengl_vulgan.conf.sh wine.conf; do
    CONF_PATH="$(dirname "$0")/$conf"
    if [ ! -f "$CONF_PATH" ]; then
        log_error "Missing configuration file: $conf"
        exit 1
    fi
done

# Read config files
source "$(dirname "$0")/wine.conf"
source "$(dirname "$0")/opengl_vulgan.conf.sh"

readarray -t DXVK_VARIABLES < <(
    grep -v -e '^\s*#' -e '^\s*$' dxvk.conf |
    sed 's/[[:space:]]*$//' |
    envsubst
)

readarray -t MANGOHUD_VARIABLES < <(
    grep -v -e '^\s*#' -e '^\s*$' mangohud.conf |
    sed 's/[[:space:]]*$//' |
    envsubst
)

WINE_VARIABLES=(
  WINEPREFIX="$WINEPREFIX"
  WINEDEBUG="$WINEDEBUG"
)

# === Argument parsing ===
function parse_args() {
    for arg in "$@"; do
        case "$arg" in
            -v|--verbose)
                DEBUG_MODE=1
                ;;
            -h|--help)
                echo "Usage: $0 [--verbose|-v]"
                exit 0
                ;;
            *)
                log_warn "Unknown argument: $arg"
                ;;
        esac
    done
}

# === Validation ===
function validate_variables() {
    local -n var_array=$1
    local label=$2
    log_info "Validating $label variables..."
    for var in "${var_array[@]}"; do
        log_debug "Variable: $var"
        if [[ ! "$var" =~ ^[a-zA-Z_][a-zA-Z0-9_]*=.+ ]]; then
            log_error "Invalid $label variable format: $var"
            exit 1
        fi
    done
}

# === Environment setup ===
function create_log_file_symlink() {
    ln --symbolic --force "$LOG_FILE" "$LOG_DIR"/battlenet-current.log
}

function check_dependencies() {
    for cmd in wine wineserver; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Command '$cmd' not found. Please install required packages."
            exit 1
        fi
    done
}

function check_files() {
    if [ ! -f "$WINEPREFIX/$BATTLENET_EXE" ]; then
        log_error "Battle.net Launcher executable not found. Check path:"
        log_error_console "$WINEPREFIX/$BATTLENET_EXE"
        exit 1
    fi
}

function kill_wineservers() {
    log_header "Killing existing wineservers..."
    wineserver -k
    "$WINE_HOME$WINE_SERVER_BIN" -k
    pkill wineserver 2>/dev/null || true
}

function cleanup() {
    log_info_file "Killing Battle.net processes..."
    pkill -f Battle.net.exe
    pkill -f Agent.exe

    log_warn "Script interrupted. Cleaning up..."
    wineserver -k

    log_info_file "Refreshing screen..."
    command -v xrefresh && xrefresh

    log_info_file "Restarting Budgie panel..."
    budgie-panel --replace &

    exit 0
}

# === Info ===
function print_wine_info() {
    if ! command -v wine >/dev/null 2>&1; then
        log_error "Command 'wine' not found. Install required packages."
        exit 1
    fi

    WINE_VERSION=$("$WINE_HOME$WINE_BIN" --version)
    WINE_FILE_ARCH=$(file "$WINE_HOME$WINE_BIN" | grep -q '64-bit' && echo "64-bit" || echo "32-bit")
    PREFIX_ARCH=$(file "$WINEPREFIX/drive_c/windows/explorer.exe" | grep -q 'PE32+' && echo "win64" || echo "win32")

    log_info "Start time: $(date)"
    log_info "Wine version: $WINE_VERSION"
    log_info "Wine architecture: $WINE_FILE_ARCH"
    log_info "Wine prefix architecture: $PREFIX_ARCH"
    if [ "$USE_GAMEMODE" = "1" ]; then
        log_info "Gamemode: ENABLED in config"
    else
        log_info "Gamemode: DISABLED in config"
    fi
    log_info "Gamemode daemon version: $(gamemoded --version 2>/dev/null || echo "not available")"
    log_info "Log file (symlink): $LOG_DIR/battlenet-current.log"
    log_info "Log file (actual): $LOG_FILE"

    # Log runtime information to file
    source "$(dirname "$0")/15.runtime-info.sh"
}

# === Launcher ===
function launch_battlenet() {
    log_header "Launching Battle.net Launcher..."
    log_info_file "Launching Battle.net Launcher"

    LAUNCH_CMD=("$WINE_HOME$WINE_BIN" "$WINEPREFIX/$BATTLENET_EXE")
    if [ "$USE_GAMEMODE" = "1" ]; then
        LAUNCH_CMD=("gamemoderun" "${LAUNCH_CMD[@]}")
    fi

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [ "$DEBUG_MODE" = "1" ]; then
        set -x
    fi

    env DXVK_CONFIG_FILE="$SCRIPT_DIR/dxvk_hud.conf" \
    "${DXVK_VARIABLES[@]}" \
    "${MANGOHUD_VARIABLES[@]}" \
    "${WINE_VARIABLES[@]}" \
    "${LAUNCH_CMD[@]}" &>> "$LOG_FILE" &

    if [ "$DEBUG_MODE" = "1" ]; then
        set +x
    fi
}

# === Main flow ===
trap cleanup SIGINT SIGTERM

parse_args "$@"

if [ "$DEBUG_MODE" = "1" ]; then
    log_debug "Final environment before launch:"
    env "${DXVK_VARIABLES[@]}" "${MANGOHUD_VARIABLES[@]}" "${WINE_VARIABLES[@]}" | grep -i -E 'DXVK|MANGOHUD|WINE|GL_|PULSE|LOG|log|DEBUG'
fi

validate_variables DXVK_VARIABLES "DXVK"
validate_variables MANGOHUD_VARIABLES "MANGOHUD"
validate_variables WINE_VARIABLES "WINE"

create_log_file_symlink
check_dependencies
check_files
kill_wineservers
print_wine_info
launch_battlenet

log_info "The startup script completed successfully."
exit 0