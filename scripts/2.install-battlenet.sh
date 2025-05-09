#!/bin/bash
#
# install-battlenet.sh
# Description: Installs Battle.net Launcher into a specified WINEPREFIX.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
# set -x
WINEPREFIX="$HOME/Games/wine-10.7_staging"
INSTALLER="Battle.net-Setup.exe"

# === Check if Battle.net installer exists ===
if [ ! -f "$INSTALLER" ]; then
  echo "❌ Battle.net installer not found in the current directory."
  echo "🔗 Download it from: https://www.blizzard.com/download"
  exit 1
fi

# === Create a fresh 64-bit WINEPREFIX ===
echo "📦 Creating a new 64-bit WINEPREFIX... - fixme: winboot -u is updating already existed wine configuration after system update or update of wine"
WINEARCH=win64 WINEPREFIX="$WINEPREFIX" wineboot -u

# === Install corefonts, vcrun2017, and set Windows 10 as the version ===
echo "🔧 Installing corefonts, vcrun2017, and setting Windows 10..."
WINEPREFIX="$WINEPREFIX" winetricks -q corefonts vcrun2017 settings win10

# === Install DXVK for better performance ===
echo "⚙️ Installing DXVK for better performance..."
WINEPREFIX="$WINEPREFIX" winetricks -q dxvk

# === Launching Battle.net installer installer ===
echo "🚀 Launching Battle.net installer..."
WINEPREFIX="$WINEPREFIX" wine "$INSTALLER"

