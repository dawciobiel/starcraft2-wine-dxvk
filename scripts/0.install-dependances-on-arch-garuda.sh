#!/bin/bash

# ────────────────────────────────────────────────────────────────
# Garuda Linux: Wine + Vulkan + Gamemode Setup Script
# ────────────────────────────────────────────────────────────────

# Load centralized logging functions
source "$(dirname "$0")/logger.sh"

# ────────────────────────────────────────────────────────────────
log_info_console "Installing Wine Staging and WoW64 support..."
sudo pacman -S --needed --noconfirm wine-staging wine-wow64 && log_success_console "Wine installed successfully." || log_warn_console "Consider installing wine-staging-wow64 from AUR if needed."

# Uncomment if using AUR helper:
# paru -S wine-staging-wow64
# yay -S wine-staging-wow64

# ────────────────────────────────────────────────────────────────
log_info_console "Installing Wine Gecko and Mono..."
sudo pacman -S --needed --noconfirm wine-gecko wine-mono && log_success_console "Gecko and Mono installed." || log_warn_console "These components are usually installed automatically on first run."

# ────────────────────────────────────────────────────────────────
log_info_console "Installing Vulkan support (generic)..."
sudo pacman -S --needed --noconfirm vulkan-icd-loader lib32-vulkan-icd-loader && log_success_console "Vulkan ICD loaders installed."

# Uncomment the appropriate section for your GPU:
# AMD:
# log_info_console "Installing Vulkan drivers for AMD..."
# sudo pacman -S --needed --noconfirm vulkan-radeon lib32-vulkan-radeon && log_success_console "AMD Vulkan drivers installed."

# NVIDIA:
log_info_console "Installing Vulkan drivers for NVIDIA..."
sudo pacman -S --needed --noconfirm nvidia-utils lib32-nvidia-utils && log_success_console "NVIDIA Vulkan drivers installed."

# ────────────────────────────────────────────────────────────────
log_info_console "Installing Gamemode..."
sudo pacman -S --needed --noconfirm gamemode && log_success_console "Gamemode installed."

# ────────────────────────────────────────────────────────────────
log_info_console "Creating folders..."
# TODO The paths to the folders below should be set the same as the paths in the .conf configuration files
# It is possible to read .conf files (`source wine.conf`) and then to make directories by variables ('mkdir -p $LOG_DIR')
# LOG_DIR
mkdir -p "$HOME/Games/battlenet-logs"

# WINEPREFIX
log_info_console "Creating directory WINEPREFIX [ $WINEPREFIX ]"
mkdir -p "$WINEPREFIX"
# DXVK_STATE_CACHE_PATH
log_info_console "Creating directory dxvk_state [ $HOME/.cache/dxvk_state ]"
mkdir -p "$HOME/.cache/dxvk_state"

# __GL_SHADER_DISK_CACHE_PATH
log_info_console "Creating directory dxvk_shader [ $HOME/.cache/dxvk_shader ]"
mkdir -p "$HOME/.cache/dxvk_shader"

log_info_console "Changing owner to user for cache directories [ $HOME/.cache/dxvk_state ], [ $HOME/.cache/dxvk_shader ]"
chown -R $USER:$USER ~/.cache/dxvk_state ~/.cache/dxvk_shader

# ────────────────────────────────────────────────────────────────
log_success_console "✅ All components installed. You're ready to game!"
