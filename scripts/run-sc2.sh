#!/bin/bash
#
# run-sc2.sh
# Description: Launches StarCraft II (64-bit) using a predefined WINEPREFIX.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
WINEPREFIX="$HOME/Games/starcraft2"
SC2_EXECUTABLE="$HOME/Games/StarCraft II/Support64/SC2Switcher_x64.exe"

# === Check if executable exists ===
if [ ! -f "$SC2_EXECUTABLE" ]; then
  echo "❌ StarCraft II executable not found at:"
  echo "   $SC2_EXECUTABLE"
  echo "🛠️  Please verify the path and update this script."
  exit 1
fi

# === Launch StarCraft II ===
echo "🚀 Launching StarCraft II..."
WINEPREFIX="$WINEPREFIX" wine "$SC2_EXECUTABLE"
