#!/bin/bash

# === Configuration ===
WINE_HOME="/usr"
WINEPREFIX="$HOME/Games/wine-10.7_staging"

# === Main flow ===
# === Launching winecfg
echo -E "🚀 Launching winecfg..."
WINEPREFIX="$WINEPREFIX" \
    "$WINE_HOME/bin/winecfg"
