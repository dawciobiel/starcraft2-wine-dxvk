#!/usr/bin/env python3
#
# run_sc2.py
# Description: Launch StarCraft II (64-bit) using a predefined WINEPREFIX.
# Author: dawciobiel (converted to Python by ChatGPT)
# Date: 2025-05-09

import os
import subprocess
from datetime import datetime
import sys

# === Configuration ===
WINE_HOME = "/usr"
WINEPREFIX = os.path.expanduser("~/Games/wine-10.7_staging")
SC2_EXE = "/12.TB.sdc1.ext4.luks.dane/games/StarCraft II/Support64/SC2Switcher_x64.exe"

timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
LOG_FILE = f"sc2-{timestamp}.log"

def log_line(text):
    with open(LOG_FILE, "a") as f:
        f.write(text + "\n")

def check_executable():
    if not os.path.isfile(SC2_EXE):
        print("❌ StarCraft II executable not found:")
        print(f"   [ {SC2_EXE} ]")
        print("🛠️  Please verify the path and update this script.")
        sys.exit(1)

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

def launch_sc2():
    print("🚀 Launching StarCraft II...")
    wine_exe = os.path.join(WINE_HOME, "bin", "wine")

    env = os.environ.copy()
    env["WINEPREFIX"] = WINEPREFIX
    env["DXVK_HUD"] = "1"
    env["DXVK_ASYNC"] = "1"
    env["WINEDEBUG"] = "fixme,err"

    with open(LOG_FILE, "a") as log_file:
        subprocess.call(
            [wine_exe, SC2_EXE],
            env=env,
            stdout=log_file,
            stderr=subprocess.STDOUT
        )

# === Main flow ===
check_executable()
print_wine_info()
launch_sc2()

