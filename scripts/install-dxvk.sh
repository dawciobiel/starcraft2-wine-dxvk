#!/bin/bash
#
# install-dxvk.sh
# Description: Downloads and installs a specified DXVK version into a WINEPREFIX.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-05-07

# === Configuration ===
DXVK_VERSION="2.9"  # Change to the desired DXVK version
WINEPREFIX="$HOME/Games/starcraft2"
ARCHIVE="dxvk-${DXVK_VERSION}.tar.gz"
DXVK_DIR="$HOME/dxvk-${DXVK_VERSION}"

# === Download DXVK ===
cd "$HOME"
wget -O "$ARCHIVE" "https://github.com/doitsujin/dxvk/releases/download/v${DXVK_VERSION}/dxvk-${DXVK_VERSION}.tar.gz"

# === Extract archive ===
tar -xf "$ARCHIVE"

# === Install DXVK into the selected WINEPREFIX ===
cd "$DXVK_DIR"
./setup_dxvk.sh install --without-dxgi --prefix "$WINEPREFIX"

echo "✅ DXVK $DXVK_VERSION has been installed to: $WINEPREFIX"
