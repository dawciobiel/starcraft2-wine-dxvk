#!/bin/bash
#
# create-sc2-desktop.sh
# Description: Creates a .desktop shortcut to easily launch StarCraft II from the desktop or application menu.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
# Read wine variables
source wine.conf
source "$(dirname "$0")/logger.sh"

# Show all variables in DEBUG MODE
if [ "$DEBUG_MODE" = "1" ]; then
    log_debug_console "DEBUG_MODE true"
    set -x
fi

# === Check if executable exists ===
if [ ! -f "$SC2_EXE" ]; then
  log_error_console "StarCraft II executable not found at:"
  log_error_console "   $SC2_EXE"
  log_info_console "🛠️  Please verify the path and update this script."
  exit 1
fi

# === Create .desktop file ===
log_info_console "📄 Creating .desktop shortcut..."

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

log_success_console ".desktop file created at: $BATTLENET_DESKTOP_LINK"
log_info_console "➡️ You can now find StarCraft II in your application menu."
