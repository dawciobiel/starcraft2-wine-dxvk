# 📝 TODO: Logging Enhancements for Game Launcher

This file outlines planned improvements to the logging system for both console output and `.log` file generation.

---

## ✅ System Information Logging

**Goal:** Add detailed system information to both screen output and `.log` file at launch.

### 🔧 Details to include:
- Kernel version
- Linux distribution name
- GPU model
- GPU driver version

### 📌 Tasks:
- [ ] Retrieve system info using `uname`, `/etc/os-release`, and `nvidia-smi`
- [ ] Format output for readability (e.g. timestamped, labeled)
- [ ] Append to `.log` file
- [ ] Display on screen during launcher startup

---

## ✅ Application & Framework Version Logging

**Goal:** Log versions of key runtime components used by the game environment.

### 🔧 Components to include:
- Wine
- DXVK
- Vulkan
- Gamemode
- MangoHUD
- Others (e.g. Lutris, Proton, if applicable)

### 📌 Tasks:
- [ ] Detect and parse version info from binaries or environment
- [ ] Include version info in `.log` file
- [ ] Display version info on screen at launch
- [ ] Handle missing components gracefully (e.g. fallback message)

---

## 📁 Output Targets
- Console (stdout)
- Log file (e.g. `battlenet-YYYYMMDD-HHMMSS.log`)

---

## 🧪 Optional Enhancements
- [ ] Add color-coded output for console readability
- [ ] Include DXVK HUD toggle status
- [ ] Add timestamp to each log section

---

## 📅 Timeline
- [ ] Draft implementation
- [ ] Test with Starcraft 2 via WINE
- [ ] Review and refine output formatting

