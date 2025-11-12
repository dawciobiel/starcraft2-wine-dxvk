#!/bin/bash

# ────────────────────────────────────────────────────────────────
# Garuda Linux: Wine + Vulkan + Gamemode Setup Script
# ────────────────────────────────────────────────────────────────

# Load configuration if available
CONFIG_FILE="wine.conf"
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
fi

# Define colors
COLORS_FILE="colors"
if [[ -f "$COLORS_FILE" ]]; then
  source "$COLORS_FILE"
fi

info()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[ OK ]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()   { echo -e "${RED}[FAIL]${RESET} $1"; }

# ────────────────────────────────────────────────────────────────
info "Installing Wine Staging and WoW64 support..."
sudo pacman -S --needed --noconfirm wine-staging wine-wow64 && success "Wine installed successfully." || warn "Consider installing wine-staging-wow64 from AUR if needed."

# Uncomment if using AUR helper:
# paru -S wine-staging-wow64
# yay -S wine-staging-wow64

# ────────────────────────────────────────────────────────────────
info "Installing Wine Gecko and Mono..."
sudo pacman -S --needed --noconfirm wine-gecko wine-mono && success "Gecko and Mono installed." || warn "These components are usually installed automatically on first run."

# ────────────────────────────────────────────────────────────────
info "Installing Vulkan support (generic)..."
sudo pacman -S --needed --noconfirm vulkan-icd-loader lib32-vulkan-icd-loader && success "Vulkan ICD loaders installed."

# Uncomment the appropriate section for your GPU:
# AMD:
# info "Installing Vulkan drivers for AMD..."
# sudo pacman -S --needed --noconfirm vulkan-radeon lib32-vulkan-radeon && success "AMD Vulkan drivers installed."

# NVIDIA:
info "Installing Vulkan drivers for NVIDIA..."
sudo pacman -S --needed --noconfirm nvidia-utils lib32-nvidia-utils && success "NVIDIA Vulkan drivers installed."

# ────────────────────────────────────────────────────────────────
info "Installing Gamemode..."
sudo pacman -S --needed --noconfirm gamemode && success "Gamemode installed."

# ────────────────────────────────────────────────────────────────
info "Creating folders..."
# TODO The paths to the folders below should be set the same as the paths in the .conf configuration files
# It is possible to read .conf files (`source wine.conf`) and then to make directories by variables ('mkdir -p $LOG_DIR')
# LOG_DIR
mkdir -p "$HOME/Games/battlenet-logs"

# WINEPREFIX
info "Creating directory WINEPREFIX [ $WINEPREFIX ]"
mkdir -p "$WINEPREFIX"
# DXVK_STATE_CACHE_PATH
info "Creating directory dxvk_state [ $HOME/.cache/dxvk_state ]"
mkdir -p "$HOME/.cache/dxvk_state"

# __GL_SHADER_DISK_CACHE_PATH
info "Creating directory dxvk_shader [ $HOME/.cache/dxvk_shader ]"
mkdir -p "$HOME/.cache/dxvk_shader"

info "Changing owner to user for cache directories [ $HOME/.cache/dxvk_state ], [ $HOME/.cache/dxvk_shader ]"
chown -R $USER:$USER ~/.cache/dxvk_state ~/.cache/dxvk_shader

# ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${GREEN}✅ All components installed. You're ready to game!${RESET}"
