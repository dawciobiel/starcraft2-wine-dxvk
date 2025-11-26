#!/bin/bash

# ────────────────────────────────────────────────────────────────
# Garuda Linux: Wine + Vulkan + Gamemode Setup Script
# ────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(dirname "$0")"

# Load centralized logging functions
if [[ ! -f "$SCRIPT_DIR/logger.sh" ]]; then
    echo -e "\033[0;31mERROR\033[0m: Missing logger.sh script" >&2
    exit 1
fi
source "$SCRIPT_DIR/logger.sh"

# ────────────────────────────────────────────────────────────────
log_info_console "Installing Wine Staging and WoW64 support..."
sudo pacman -S --needed --noconfirm wine-staging && log_success_console "Wine installed successfully." || log_warn_console "Consider installing wine-staging-wow64 from AUR if needed."

# Nie instaluj wine-staging-wow64 w Arch, bo to pakiet z innych dystrybucji. W Archu WoW64 jest już wbudowane w wine-staging

# Nie trzeba tego instalować w Arch/Garuda:
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
# Creating folders...
bash "$SCRIPT_DIR/16.create-directories.sh"

# ────────────────────────────────────────────────────────────────
log_success_console "✅ All components installed. You're ready to game!"
