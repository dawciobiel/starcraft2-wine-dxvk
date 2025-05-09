#!/bin/bash
#
# run-battlenet-launcher.sh
# Description: Run Battle.net Launcher.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-08

# === Configuration ===
set -x
WINE_HOME="/usr"
WINEPREFIX="$HOME/Games/wine-10.7_staging"
BATTLENET_EXE="drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"
LOG="battlenet-$(date +'%Y%m%d-%H%M%S').log"

function kill_wineservers() {
    echo "🧹 Killing existing wineservers..."
    wineserver -k
    "$WINE_HOME/bin/wineserver" -k
    pkill wineserver
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

function launch_battlenet() {
    echo "🚀 Launching Battle.net Launcher..."

    WINEDEBUG=fixme,err \
    WINEPREFIX="$WINEPREFIX" \
    DXVK_HUD=1 DXVK_ASYNC=1 \
    "$WINE_HOME/bin/wine" "$WINEPREFIX/$BATTLENET_EXE" 2>> "$LOG"
}

# === Main flow ===
kill_wineservers
print_wine_info
launch_battlenet
