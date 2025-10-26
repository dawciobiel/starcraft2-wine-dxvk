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
#   2025-10-26
#
# LICENSE:
#   MIT
#==============================================================================

# === Configuration ===
DEBUG_MODE=0

source colors

# Check required config files
for conf in dxvk.conf mangohud.conf opengl_vulgan.conf.sh wine.conf; do
    CONF_PATH="$(dirname "$0")/$conf"
    if [ ! -f "$CONF_PATH" ]; then
        echo -e "[\033[0;31merror\033[0m] Missing configuration file: $conf"
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

# === Logging functions ===
function log_info() {
    echo -e "[${GREEN}info${NC}] $*"
    echo "[info] $*" >> "$LOG_FILE"
}

function log_debug() {
    echo -e "[${YELLOW}debug${NC}] $*"
    echo "[debug] $*" >> "$LOG_FILE"
}

function log_error() {
    echo -e "[${RED}error${NC}] $*"
    echo "[error] $*" >> "$LOG_FILE"
}

function log_warn() {
    echo -e "[${RED}warn${NC}] $*"
    echo "[warn] $*" >> "$LOG_FILE"
}

function log_header() {
    echo -e "${BOLD}${CYAN}== $* ==${NC}"
    echo "== $*" >> "$LOG_FILE"
}

# === Argument parsing ===
function parse_args() {
    for arg in "$@"; do
        case "$arg" in
            -v|--verbose)
                DEBUG_MODE=1
                ;;
            -h|--help)
                echo -e ""
                echo "Usage: $0 [--verbose|-v]"
                exit 0
                ;;
            *)
                echo -e ""
                log_warn "Unknown argument: $arg"
                ;;
        esac
    done
}

# === Validation ===
function validate_variables() {
    local -n var_array=$1
    local label=$2
    for var in "${var_array[@]}"; do
        if [[ ! "$var" =~ ^[a-zA-Z_][a-zA-Z0-9_]*=.+ ]]; then
            log_error "Invalid $label variable: $var"
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
            log_error "Command $cmd not found. Install required packages."
            exit 1
        fi
    done
}

function check_files() {
    if [ ! -f "$WINEPREFIX/$BATTLENET_EXE" ]; then
        log_error "Battle.net Launcher file not found. Check path:"
        echo "$WINEPREFIX/$BATTLENET_EXE" >&2
        exit 1
    fi
}

function kill_wineservers() {
    log_header "🧹 Killing existing wineservers..."
    wineserver -k
    "$WINE_HOME$WINE_SERVER_BIN" -k
    pkill wineserver 2>/dev/null || true
}

function cleanup() {
    log_warn "Script interrupted. Cleaning up..."
    echo "🛑 Script interrupted. Cleaning up..." >> "$LOG_FILE"
    wineserver -k
    exit 0
}

# === Info ===
function print_wine_info() {
    if ! command -v wine >/dev/null 2>&1; then
        log_error "Command wine not found. Install required packages."
        exit 1
    fi

    WINE_VERSION=$("$WINE_HOME$WINE_BIN" --version)
    WINE_FILE_ARCH=$(file "$WINE_HOME$WINE_BIN" | grep -q '64-bit' && echo "64-bit" || echo "32-bit")
    PREFIX_ARCH=$(file "$WINEPREFIX/drive_c/windows/explorer.exe" | grep -q 'PE32+' && echo "win64" || echo "win32")

    echo
    log_info "🕓 Start time: $(date)"
    log_info "Wine version: $WINE_VERSION"
    log_info "Wine architecture: $WINE_FILE_ARCH"
    log_info "Wine prefix architecture: $PREFIX_ARCH"
    if [ "$USE_GAMEMODE" = "1" ]; then
        log_info "gamemode ENABLED in config"
    else
        log_info "gamemode DISABLED in config"
    fi
    log_info "gamemode daemon version: $(gamemoded --version 2>/dev/null || echo "not available")"
    echo -e ""
    log_info "Log file [ $LOG_DIR/battlenet-current.log ] (symlink)"
    log_info "Log file [ $LOG_FILE ]"
    echo

    {
        echo "[info] Start time: $(date)"
        echo "[info] Wine home [ $WINE_HOME ]"
        echo "[info] Wine version: $WINE_VERSION"
        echo "[info] Wine architecture: $WINE_FILE_ARCH"
        echo "[info] Wine prefix architecture: $PREFIX_ARCH"
        if [ "$USE_GAMEMODE" = "1" ]; then
            echo "[info] gamemode ENABLED in config"
        else
            echo "[info] gamemode DISABLED in config"
        fi
        echo "[info] gamemode daemon version: $(gamemoded --version 2>/dev/null || echo "not available")"
        echo
    } >> "$LOG_FILE"
}

# === Launcher ===
function launch_battlenet() {
    log_header "🚀 Launching Battle.net Launcher in background..."
    echo -e ""
    echo "[info] Launching Battle.net Launcher" >> "$LOG_FILE"

#     {
        LAUNCH_CMD=("$WINE_HOME$WINE_BIN" "$WINEPREFIX/$BATTLENET_EXE")
        if [ "$USE_GAMEMODE" = "1" ]; then
            LAUNCH_CMD=("gamemoderun" "${LAUNCH_CMD[@]}")
        fi

        if [ "$DEBUG_MODE" = "1" ]; then
            set -x
        fi

        env "${DXVK_VARIABLES[@]}" "${MANGOHUD_VARIABLES[@]}" "${WINE_VARIABLES[@]}" \
        "${LAUNCH_CMD[@]}" \
        2>&1 \
        | grep -v 'dispatch_exception assertion failure exception' \
        | grep -v 'experimental wow64 mode' \
        | grep -v 'apartment not initialised' \
        | grep -v 'fixme:' \
        >> "$LOG_FILE"

        if [ "$DEBUG_MODE" = "1" ]; then
            set +x
        fi
#     } &
}

# === Main flow ===
trap cleanup SIGINT SIGTERM

parse_args "$@"

if [ "$DEBUG_MODE" = "1" ]; then
    log_debug "Final environment before launch:\n"
    env "${DXVK_VARIABLES[@]}" "${MANGOHUD_VARIABLES[@]}" "${WINE_VARIABLES[@]}" | grep -E 'DXVK|MANGOHUD|WINE|GL_|PULSE'
    echo
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
