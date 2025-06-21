# StarCraft II Installation with Wine and DXVK

This repository contains a series of scripts to help you install and run **StarCraft II** with **Wine** and **DXVK** for better performance. It guides you through setting up the **Battle.net Launcher**, installing necessary dependencies, and creating a desktop shortcut for easy access.

## Prerequisites

Before running the scripts, make sure you have the following installed on your system:

- **Wine** (latest version recommended)
- **Winetricks**
- **wget** (for downloading DXVK)
- **Git** (optional, for cloning the repo)
- **bash** shell (tested on version 5.2+)
- **python 3.6+** (optional)

Make sure you have the **Battle.net installer** (Battle.net-Setup.exe) downloaded from the official Blizzard website:
[https://www.blizzard.com/download](https://www.blizzard.com/download).
Place this file in the same directory in which the  starcraft2-wine-dxvk scripts are.

### Recommended:

- **Graphics Driver**: NVIDIA or AMD with proper Vulkan support.
- **DXVK** version: Latest stable release (e.g., 2.6.1 or higher).

## Installation Steps

### 1. Install DXVK

DXVK improves performance and compatibility for DirectX games running under Wine. To install it, use the following script:

```bash
chmod +x install-dxvk.sh
./install-dxvk.sh
````

### 2. Install Battle.net Launcher

This script installs **Battle.net Launcher** into your Wine environment. Make sure the **Battle.net-Setup.exe** file is in your current directory.

```bash
chmod +x install-battlenet.sh
./install-battlenet.sh
```

### 3. Create Desktop Shortcut for StarCraft II

After installing Battle.net and StarCraft II, create a desktop shortcut for easy launching. This will add StarCraft II to your application menu.

```bash
chmod +x create-sc2-desktop.sh
./create-sc2-desktop.sh
```

### 4. Run StarCraft II

Finally, to run **StarCraft II** using Wine, you can use the following script:

```bash
chmod +x run-sc2.sh
./run-sc2.sh
```

---

## Summary of Commands:

1. **Install DXVK:**

   ```bash
   chmod +x install-dxvk.sh
   ./install-dxvk.sh
   ```

2. **Install Battle.net Launcher:**

   ```bash
   chmod +x install-battlenet.sh
   ./install-battlenet.sh
   ```

3. **Create a Desktop Shortcut:**

   ```bash
   chmod +x create-sc2-desktop.sh
   ./create-sc2-desktop.sh
   ```

4. **Run StarCraft II:**

   ```bash
   chmod +x run-sc2.sh
   ./run-sc2.sh
   ```

---

## Additional Information

* **WINEPREFIX**: The environment where Wine stores your installed applications. All the scripts above assume a **64-bit Wine prefix** located at `~/Games/starcraft2`.

* If you're experiencing issues, try to run the game from a clean prefix:

  ```bash
  export WINEPREFIX=~/Games/starcraft2
  export WINEARCH=win64
  wineboot
  ```

* **Support**: If you encounter issues, check the Wine and DXVK official documentation or visit the [Wine Application Database](https://appdb.winehq.org/) for troubleshooting.

---

## Author

* **dawciobiel** - [GitHub Profile](http://github.com/dawciobiel)
* **Date**: 2025-05-07

---
