#!/bin/bash
#
# install-battlenet.sh
# Description: Installs Battle.net Launcher into a specified WINEPREFIX.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
WINEPREFIX="$HOME/Games/starcraft2"
INSTALLER="Battle.net-Setup.exe"  # Change to the path of the Battle.net installer

# === Check if Battle.net installer exists ===
if [ ! -f "$INSTALLER" ]; then
  echo "❌ Battle.net installer not found in the current directory."
  echo "🔗 Download it from: https://www.blizzard.com/download"
  exit 1
fi

# === Create a fresh 64-bit WINEPREFIX ===
echo "📦 Creating a new 64-bit WINEPREFIX..."
WINEARCH=win64 WINEPREFIX="$WINEPREFIX" wineboot -u

# === Install corefonts, vcrun2017, and set Windows 10 as the version ===
echo "🔧 Installing corefonts, vcrun2017, and setting Windows 10..."
WINEPREFIX="$WINEPREFIX" winetricks -q corefonts vcrun2017 settings win10

# === Install DXVK for better performance ===
echo "⚙️ Installing DXVK for better performance..."
WINEPREFIX="$WINEPREFIX" winetricks -q dxvk

# === Run the Battle.net installer ===
echo "🚀 Running Battle.net installer..."
WINEPREFIX="$WINEPREFIX" wine "$INSTALLER"

echo "✅ Battle.net Launcher installed successfully."
echo "➡️ After installation, use the following to run Battle.net:"
echo "    WINEPREFIX=\"$WINEPREFIX\" wine \"\$HOME/.wine/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe\""
