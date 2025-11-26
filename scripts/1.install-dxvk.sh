#!/bin/bash

source "$(dirname "$0")/logger.sh"

log_error_console "Ten skrypt nie jest już potrzebny. DXVK jest instalowane za pomocą skryptu '2.install-battlenet.sh'"

exit 1

#   !/bin/bash

# === DXVK Installation Script ===
# This script downloads and installs DXVK (DirectX to Vulkan translation layer) 
# into the specified Wine prefix for use with 64-bit and 32-bit applications.
#
# Author: dawciobiel
# GitHub: http://github.com/dawciobiel
# Date: 2025-05-07
#
# This script assumes that you are using Wine with a valid Wine prefix for your game.
# Before using this script, make sure that you have set up a proper Wine prefix.

# === Variables ===
DXVK_VERSION="2.7.1"  # Update to the latest version as needed
DXVK_URL="https://github.com/doitsujin/dxvk/releases/download/$DXVK_VERSION/dxvk-$DXVK_VERSION.tar.gz"
# Read wine variables
source wine.conf

# Show all variables in DEBUG MODE
if [ "$DEBUG_MODE" = "1" ]; then
    log_debug_console "DEBUG_MODE włączony – uruchamiam set -x"
    set -x
fi

# === Download DXVK ===
log_info_console "Downloading DXVK $DXVK_VERSION..."
wget -q $DXVK_URL -O dxvk-$DXVK_VERSION.tar.gz

# === Extract DXVK ===
log_info_console "Extracting DXVK..."
tar -xvzf dxvk-$DXVK_VERSION.tar.gz

# === Install DXVK ===
log_info_console "Installing DXVK into Wine prefix..."

# Ensure the system32 and system64 directories exist
mkdir -p $WINEPREFIX/drive_c/windows/system32
mkdir -p $WINEPREFIX/drive_c/windows/system64

# Copy the DXVK files to Wine's system32 and system64 directories
cp -r dxvk-$DXVK_VERSION/x32/* $WINEPREFIX/drive_c/windows/system32/
cp -r dxvk-$DXVK_VERSION/x64/* $WINEPREFIX/drive_c/windows/system64/

# === Cleanup ===
rm -rf dxvk-$DXVK_VERSION.tar.gz dxvk-$DXVK_VERSION

# === Installation Complete ===
log_success_console "DXVK $DXVK_VERSION has been successfully installed to: $INSTALL_DIR"

