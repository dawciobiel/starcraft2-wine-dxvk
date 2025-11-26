#!/bin/bash
#
# Script Name: wine_dxvk_setup.sh
# Description: Automates creation of Wine and DXVK cache directories,
#              loads configuration files, and sets proper ownership.
# Author: Dawid Bielecki (https://github.com/dawciobiel)
# License: MIT
# Version: 1.1
# Date: 17.11.2025
#
# Usage:
#   ./wine_dxvk_setup.sh
#
# Notes:
# - Requires wine.conf, dxvk.conf, and logger.sh in the same directory.
# - Ensures directories for WINEPREFIX, DXVK state cache, and GL shader cache exist.
# - Sets ownership of cache directories to the current user.
#

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

# Check required config files
for cfg in wine.conf dxvk.conf; do
    if [[ ! -f "$SCRIPT_DIR/$cfg" ]]; then
        echo -e "\033[0;31mERROR\033[0m: Missing required configuration file: $cfg" >&2
        exit 1
    fi
done

# Load wine configuration
source "$SCRIPT_DIR/wine.conf"
source "$SCRIPT_DIR/dxvk.conf"

# Load centralized logging functions
if [[ ! -f "$SCRIPT_DIR/logger.sh" ]]; then
    log_error_console "Missing logger.sh script" >&2
    exit 1
fi
source "$SCRIPT_DIR/logger.sh"

log_info_console "Creating folders..."
mkdir -p "$LOG_DIR"

# WINEPREFIX
log_info_console "Creating directory WINEPREFIX [ $WINEPREFIX ]"
mkdir -p "$WINEPREFIX"

# DXVK_STATE_CACHE_PATH
log_info_console "Creating directory dxvk_state [ $DXVK_STATE_CACHE_PATH ]"
mkdir -p "$DXVK_STATE_CACHE_PATH"

# __GL_SHADER_DISK_CACHE_PATH
log_info_console "Creating directory dxvk_shader [ $__GL_SHADER_DISK_CACHE_PATH ]"
mkdir -p "$__GL_SHADER_DISK_CACHE_PATH"

log_info_console "Changing owner to user for cache directories [ $DXVK_STATE_CACHE_PATH ], [ $__GL_SHADER_DISK_CACHE_PATH ]"
chown -R "$USER:$USER" "$DXVK_STATE_CACHE_PATH" "$__GL_SHADER_DISK_CACHE_PATH"
