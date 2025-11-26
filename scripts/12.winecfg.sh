#!/bin/bash
#
# Script Name: launch_winecfg.sh
# Description: Validates presence of wine.conf, loads Wine configuration variables,
#              and launches winecfg with the specified WINEPREFIX.
# Author: Dawid Bielecki (https://github.com/dawciobiel)
# License: MIT
# Version: 1.0
# Date: 17.11.2025
#
# Usage:
#   ./launch_winecfg.sh
#
# Requirements:
# - wine.conf must exist in the same directory as this script.
# - wine.conf should define WINEPREFIX and WINE_HOME variables.
#
# Notes:
# - Displays error in red if wine.conf is missing.
# - Uses 🚀 emoji to indicate winecfg launch.
#

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

# Check required config file
if [[ ! -f "$SCRIPT_DIR/wine.conf" ]]; then
    echo -e "\033[0;31mERROR\033[0m: Missing required configuration file: wine.conf" >&2
    exit 1
fi

# === Configuration ===
# Read wine variables
source "$SCRIPT_DIR/wine.conf"

# === Main flow ===
# === Launching winecfg
echo "🚀 Launching winecfg..."
WINEPREFIX="$WINEPREFIX" \
    "$WINE_HOME/bin/winecfg"
