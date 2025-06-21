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
#   2025-05-09
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

function check_dependencies() {
  for cmd in wine wineserver; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "❌ Error: Command $cmd not found. Install required packages." >&2
      exit 1
    fi
  done
}

function check_executable() {
  if [ ! -f "$SC2_EXE" ]; then
    echo "❌ Error: StarCraft II executable not found at:" >&2
    echo "   [ $SC2_EXE ]" >&2
    echo "🛠️  Please verify the path and update this script." >&2
    exit 1
  fi

  echo "✅ StarCraft II executable found."
}

function cleanup() {
  echo "🛑 Script interrupted. Cleaning up..." >> "$LOG"
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
  {
    echo "🕓 Start time: $(date)"
    echo "Wine HOME [ $WINE_HOME ]"
    echo "Wine version:"
    "$WINE_HOME/bin/wine" --version
    echo
  } >> "$LOG"
}

function launch_sc2() {
        echo "🚀 Launching StarCraft II..."
        echo "[info] Launching StarCraft II" >> "$LOG_FILE"
        {
            env $DXVK_VARIABLES \
            env $MANGOHUD_VARIABLES \
            WINE_ARCH="$WINE_ARCH" \
            WINEPREFIX="$WINEPREFIX" \
            WINEDEBUG="$WINEDEBUG" \
            "$WINE_HOME/bin/wine" "$SC2_EXE" \
            2>&1 | grep -v 'dispatch_exception assertion failure exception' \
            >> "$LOG_FILE"
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
