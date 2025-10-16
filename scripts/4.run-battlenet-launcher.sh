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
#   2025-05-18
#
# LICENSE:
#   MIT
#==============================================================================

# === Configuration ===
# Read wine variables
source wine.conf

# Read configuration variables to one line and remove comments from it
MANGOHUD_VARIABLES=$(grep -v '^\s*#' mangohud.conf | tr -d '\n' | sed 's/\\//g' | xargs)
DXVK_VARIABLES=$(grep -v '^\s*#' dxvk.conf | tr -d '\n' | sed 's/\\//g' | xargs)

# Show all variables in DEBUG MODE
if [ "$DEBUG_MODE" = "1" ]; then
    echo "DEBUG_MODE true"
    set -x
fi

# === Functions ===

function create_log_file_symlink() {
	ln --symbolic --force "$LOG_FILE" "$LOG_DIR"/battlenet-current.log
}

function launch_battlenet() {
        echo "🚀 Launching Battle.net Launcher..."
        echo "[info] Launching Battle.net Launcher" >> "$LOG_FILE"

        # There can be no comments between the lines below
        {
                env $DXVK_VARIABLES \
                env $MANGOHUD_VARIABLES \
                WINEPREFIX="$WINEPREFIX" \
                WINE_ARCH="$WINE_ARCH" \
                WINEDEBUG="$WINEDEBUG" \
                "$WINE_HOME/bin/wine" "$WINEPREFIX/$BATTLENET_EXE" \
                2>&1 | grep -v 'dispatch_exception assertion failure exception' \
                >> "$LOG_FILE"
        } &
	# Mozna uruchamiac przez `gamemoderun` - ze niby ma byc lepiej

}

function check_dependencies() {
        for cmd in wine wineserver; do
          if ! command -v "$cmd" &> /dev/null; then
            echo "❌ Error: Command $cmd not found. Install required packages." >&2
            exit 1
          fi
        done
}

function check_files() {
        if [ ! -f "$WINEPREFIX/$BATTLENET_EXE" ]; then
          echo "❌ Error: Battle.net Launcher file not found. Check path:" >&2
          echo "$WINEPREFIX/$BATTLENET_EXE" >&2
          exit 1
        fi
}

function cleanup() {
        echo "🛑 Script interrupted. Cleaning up..." >> "$LOG_FILE"
        wineserver -k
        exit 0
}

function kill_wineservers() {
        echo "🧹 Killing existing wineservers..."
        wineserver -k
        "$WINE_HOME/bin/wineserver" -k
        pkill wineserver 2>/dev/null || true
}

function print_wine_info() {
        if ! command -v wine >/dev/null 2>&1; then
            echo "❌ Error: Command wine not found. Install required packages." >&2
            exit 1
        fi

        WINE_VERSION=$("$WINE_HOME/bin/wine" --version)
        WINE_ARCH=$(file "$(which wine)" | grep -o '32-bit\|64-bit')

        echo
        echo "🕓 Start time: $(date)"
        echo "Wine version: $WINE_VERSION"
        echo "Wine architecture: $WINE_ARCH"
	echo "Log file [ $LOG_DIR/battlenet-current.log ] (symlink)"
        echo "Log file [ $LOG_FILE ]"
        echo

        {
          echo "[info] Start time: $(date)"
          echo "[info] Wine HOME [ $WINE_HOME ]"
          echo "[info] Wine version: $WINE_VERSION"
          echo "[info] Wine architecture: $WINE_ARCH"
	  echo "[info] gamemode deamon version: $(gamemoded --version)"
          echo
        } >> "$LOG_FILE"
}

# === Main flow ===
trap cleanup SIGINT SIGTERM

create_log_file_symlink
check_dependencies
check_files
kill_wineservers
print_wine_info
launch_battlenet
echo "[info] $(gamemoded -s)"

