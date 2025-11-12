#!/bin/bash
#==============================================================================
# run-sc2.sh
#
# DESCRIPTION:
#   Launcher script for StarCraft II (64-bit) under Wine on Linux.
#   Uses a predefined WINEPREFIX and handles logging.
#
# USAGE:
#   ./run-sc2.sh
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
# Read wine variables
source wine.conf
source "$(dirname "$0")/logger.sh"

# Read configuration variables to one line and remove comments from it
MANGOHUD_VARIABLES=$(grep -v '^\s*#' mangohud.conf | tr -d '\n' | sed 's/\\//g' | xargs)
DXVK_VARIABLES=$(grep -v '^\s*#' dxvk.conf | tr -d '\n' | sed 's/\\//g' | xargs)

# Show all variables in DEBUG MODE
if [ "$DEBUG_MODE" = "1" ]; then
    log_debug_console "DEBUG_MODE true"
    set -x
fi

function check_dependencies() {
  for cmd in wine wineserver; do
    if ! command -v "$cmd" &> /dev/null; then
      log_error_console "Command '$cmd' not found. Install required packages."
      exit 1
    fi
  done
}

function check_executable() {
  if [ ! -f "$SC2_EXE" ]; then
    log_error_console "StarCraft II executable not found at:"
    log_error_console "   [ $SC2_EXE ]"
    log_info_console "Please verify the path and update this script."
    exit 1
  fi

  log_success_console "StarCraft II executable found."
}

function cleanup() {
  log_info_file "Script interrupted. Cleaning up..."
  wineserver -k
  exit 0
}

function kill_wineservers() {
  log_info_console "Killing existing wineservers..."
  wineserver -k
  "$WINE_HOME/bin/wineserver" -k
  pkill wineserver 2>/dev/null || true
}

function print_wine_info() {
    log_info_file "Start time: $(date)"
    log_info_file "Wine HOME [ $WINE_HOME ]"
    log_info_file "Wine version: $($WINE_HOME/bin/wine --version)"
}

function launch_sc2() {
        log_info_console "Launching StarCraft II..."
        log_info_file "Launching StarCraft II"
        {
            env $DXVK_VARIABLES \
            env $MANGOHUD_VARIABLES \
            WINEARCH="$WINEARCH" \
            WINEPREFIX="$WINEPREFIX" \
            WINEDEBUG="$WINEDEBUG" \
            "$WINE_HOME/bin/wine" "$SC2_EXE" \
            &>> "$LOG_FILE"
        } &
        # SC2_EXE na chwile obecną jest w folderze który nie jest wewnątrz folderu WINEPREFIX
        #  więc chyba nie może tak zdiałać. Chociaż z drugiej strony Battlenet Launcher i tak odpala w ten sposób ten plik - czyli spoza wewnętrznego folderu WINEPREFIX
}

# === Main flow ===
trap cleanup SIGINT SIGTERM

check_dependencies
check_executable
kill_wineservers
print_wine_info
launch_sc2

