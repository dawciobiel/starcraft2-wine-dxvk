#!/bin/bash
#
# run-sc2.sh
# Description: Launches StarCraft II (64-bit) using a predefined WINEPREFIX.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-08

# === Configuration ===
set -x
WINE_HOME="/usr"
WINEPREFIX="$HOME/Games/wine-10.7_staging"
SC2_EXE="/12.TB.sdc1.ext4.luks.dane/games/StarCraft II/Support64/SC2Switcher_x64.exe"
LOG="sc2-$(date +'%Y%m%d-%H%M%S').log"

function check_executable() {
    if [ ! -f "$SC2_EXE" ]; then
        echo "❌ StarCraft II executable not found at:"
        echo "   [ $SC2_EXE ]"
        echo "🛠️  Please verify the path and update this script."
        exit 1
    fi
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

    WINEDEBUG=fixme,err \
    WINEPREFIX="$WINEPREFIX" \
    DXVK_HUD=1 DXVK_ASYNC=1 \
    "$WINE_HOME/bin/wine" "$SC2_EXE" &>> "$LOG"
}

# === Main flow ===
check_executable
print_wine_info
launch_sc2
