#!/bin/bash
#
# create-sc2-desktop.sh
# Description: Creates a .desktop shortcut to easily launch StarCraft II from the desktop or application menu.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
WINEPREFIX="$HOME/Games/swine-10.7_stagin"
SC2_EXECUTABLE="$HOME/Games/StarCraft II/Support64/SC2Switcher_x64.exe"
DESKTOP_FILE="$HOME/.local/share/applications/starcraft2.desktop"

# === Check if executable exists ===
if [ ! -f "$SC2_EXECUTABLE" ]; then
  echo "❌ StarCraft II executable not found at:"
  echo "   $SC2_EXECUTABLE"
  echo "🛠️  Please verify the path and update this script."
  exit 1
fi

# === Create .desktop file ===
echo "📄 Creating .desktop shortcut..."

cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Name=StarCraft II
Comment=Play StarCraft II with Wine
Exec=env WINEPREFIX="$WINEPREFIX" wine "$SC2_EXECUTABLE"
Icon=starcraft2
Terminal=false
Type=Application
Categories=Game;
EOF

# === Make the .desktop file executable ===
chmod +x "$DESKTOP_FILE"

echo "✅ .desktop file created at: $DESKTOP_FILE"
echo "➡️ You can now find StarCraft II in your application menu."
