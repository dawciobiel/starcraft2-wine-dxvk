#!/bin/bash

source "$(dirname "$0")/wine.conf"
source "$(dirname "$0")/logger.sh"

log_info_console "Installing Wine Staging and WoW64 support..."
sudo zypper install wine-staging wine-staging-wow64 && log_success_console "Wine Staging and WoW64 installed."

log_info_console "Installing Wine Gecko and Mono..."
sudo zypper install wine-gecko wine-mono && log_success_console "Wine Gecko and Mono installed."

log_info_console "Installing Vulkan support..."
sudo zypper install libvulkan1 && log_success_console "Vulkan support installed."

log_info_console "Installing Gamemode..."
sudo zypper install gamemode && log_success_console "Gamemode installed."
