#/bin/bash

# Use externally provided LOG_FILE if set, otherwise fallback to wine.conf
if [ -z "$LOG_FILE" ]; then
    # LOG_FILE is not set — source wine.conf
    if [ -f "wine.conf" ]; then
        echo "LOG_FILE not set. Sourcing wine.conf..."
        source "$(dirname "$0")/wine.conf"
    else
        echo "LOG_FILE not set and wine.conf not found!"
        exit 1
    fi
fi


# === System Information ===
echo "=== System Information ===" | tee -a "$LOG_FILE"

# Linux distribution
if [ -f /etc/os-release ]; then
    DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
else
    DISTRO="Unknown"
fi
echo "Linux Distribution: $DISTRO" | tee -a "$LOG_FILE"

# Kernel version
KERNEL=$(uname -r)
echo "Kernel Version: $KERNEL" | tee -a "$LOG_FILE"

# GPU vendor, model and driver version
echo "GPU Info:" | tee -a "$LOG_FILE"
if command -v lspci &>/dev/null; then
    GPU_LINE=$(lspci | grep -E "VGA|3D|Display")
    echo "Detected GPU: $GPU_LINE" | tee -a "$LOG_FILE"
else
    echo "lspci not available" | tee -a "$LOG_FILE"
fi

# NVIDIA driver version
if command -v nvidia-smi &>/dev/null; then
    NVIDIA_DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
    echo "NVIDIA Driver Version: $NVIDIA_DRIVER" | tee -a "$LOG_FILE"
fi

# AMD driver version (simplified check)
if command -v glxinfo &>/dev/null; then
    AMD_DRIVER=$(glxinfo | grep "OpenGL version string" | cut -d: -f2 | xargs)
    echo "OpenGL Driver Version: $AMD_DRIVER" | tee -a "$LOG_FILE"
fi

# === Wine & Components ===
echo "=== Wine & Runtime Components ===" | tee -a "$LOG_FILE"

# Wine version
if command -v wine &>/dev/null; then
    WINE_VER=$(wine --version)
    echo "Wine Version: $WINE_VER" | tee -a "$LOG_FILE"
fi

# DXVK version
if [ -f "$WINEPREFIX/drive_c/windows/system32/dxvk_config.dll" ]; then
    DXVK_VER=$(strings "$WINEPREFIX/drive_c/windows/system32/dxvk_config.dll" | grep -i dxvk | head -n 1)
    echo "DXVK Version: $DXVK_VER" | tee -a "$LOG_FILE"
else
    echo "DXVK not detected in prefix" | tee -a "$LOG_FILE"
fi

# Vulkan version
if command -v vulkaninfo &>/dev/null; then
    VULKAN_VER=$(vulkaninfo | grep "Vulkan Instance Version" | head -n 1 | cut -d: -f2 | xargs)
    echo "Vulkan Version: $VULKAN_VER" | tee -a "$LOG_FILE"
fi

# MangoHUD version
if command -v mangohud &>/dev/null; then
    MANGOHUD_VER=$(mangohud --version 2>&1 | head -n 1)
    echo "MangoHUD Version: $MANGOHUD_VER" | tee -a "$LOG_FILE"
fi

# Gamemode version
if command -v gamemoded &>/dev/null; then
    GAMEMODE_VER=$(gamemoded --version 2>&1)
    echo "Gamemode Version: $GAMEMODE_VER" | tee -a "$LOG_FILE"
fi

