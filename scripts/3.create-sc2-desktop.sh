#!/bin/bash
#
# create-sc2-desktop.sh
# Description: Creates a .desktop shortcut to easily launch StarCraft II from the desktop or application menu.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
# Read wine variables
source wine.conf

# Show all variables in DEBUG MODE
if [ "$DEBUG_MODE" = "1" ]; then
    echo "DEBUG_MODE true"
    set -x
fi

# === Check if executable exists ===
if [ ! -f "$SC2_EXE" ]; then
  echo "❌ StarCraft II executable not found at:"
  echo "   $SC2_EXE"
  echo "🛠️  Please verify the path and update this script."
  exit 1
fi

# === Create .desktop file ===
echo "📄 Creating .desktop shortcut..."

cat << EOF > "$BATTLENET_DESKTOP_LINK"
[Desktop Entry]
Version=1.0
Name=StarCraft II
Comment=Play StarCraft II with Wine
Exec=env WINEPREFIX="$WINEPREFIX" wine "$SC2_EXE"
Icon=starcraft2
Terminal=false
Type=Application
Categories=Game;
EOF

# === Make the .desktop file executable ===
chmod +x "$BATTLENET_DESKTOP_LINK"

echo "✅ .desktop file created at: $BATTLENET_DESKTOP_LINK"
echo "➡️ You can now find StarCraft II in your application menu."
