#!/usr/bin/env python3
#
# run_battlenet_launcher.py
# Description: Run Battle.net Launcher using Wine.
# Author: dawciobiel (converted to Python by ChatGPT)
# Date: 2025-05-09

import os
import subprocess
from datetime import datetime

# === Configuration ===
WINE_HOME = "/usr"
WINEPREFIX = os.path.expanduser("~/Games/wine-10.7_staging")
BATTLENET_EXE = "drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"

timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
LOG_FILE = f"battlenet-{timestamp}.log"

def log_line(text):
    with open(LOG_FILE, "a") as f:
        f.write(text + "\n")

def kill_wineservers():
    print("🧹 Killing existing wineservers...")
    subprocess.call(["wineserver", "-k"])
    subprocess.call([os.path.join(WINE_HOME, "bin", "wineserver"), "-k"])
    subprocess.call(["pkill", "wineserver"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def print_wine_info():
    log_line(f"🕓 Start time: {datetime.now()}")
    log_line(f"Wine HOME [ {WINE_HOME} ]")
    
    try:
        result = subprocess.run(
            [os.path.join(WINE_HOME, "bin", "wine"), "--version"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        log_line("Wine version:")
        log_line(result.stdout.strip())
    except Exception as e:
        log_line(f"Error retrieving Wine version: {e}")

def launch_battlenet():
    print("🚀 Launching Battle.net Launcher...")
    wine_exe = os.path.join(WINE_HOME, "bin", "wine")
    battlenet_path = os.path.join(WINEPREFIX, BATTLENET_EXE)

    env = os.environ.copy()
    env["WINEPREFIX"] = WINEPREFIX
    env["DXVK_HUD"] = "1"
    env["DXVK_ASYNC"] = "1"
    env["WINEDEBUG"] = "fixme,err"

    with open(LOG_FILE, "a") as log_file:
        subprocess.call(
            [wine_exe, battlenet_path],
            env=env,
            stdout=log_file,
            stderr=subprocess.STDOUT
        )

# === Main flow ===
kill_wineservers()
print_wine_info()
launch_battlenet()

