#!/usr/bin/env python3
#==============================================================================
# run_battlenet_launcher.py
#
# DESCRIPTION:
#   Python launcher script for Battle.net under Wine on Linux.
#   Handles Wine environment setup, logging, and process management.
#
# USAGE:
#   ./run_battlenet_launcher.py
#
# AUTHOR:
#   dawciobiel (http://github.com/dawciobiel)
#   (converted to Python by ChatGPT)
#
# CREATED:
#   2025-05-09
#
# MODIFIED:
#   2025-05-09
#
# LICENSE:
#   MIT
#==============================================================================

import os
import sys
import signal
import subprocess
from datetime import datetime
import shutil

# === Configuration ===
WINE_HOME = "/usr"
WINEPREFIX = os.path.expanduser("~/Games/wine-10.7_staging")
BATTLENET_EXE = "drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"

# Set up logging directory
LOG_DIR = os.path.expanduser("~/Games/battlenet-logs")
os.makedirs(LOG_DIR, exist_ok=True)
timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
LOG_FILE = os.path.join(LOG_DIR, f"battlenet-{timestamp}.log")

def log_line(text):
    """Write a line to the log file"""
    with open(LOG_FILE, "a") as f:
        f.write(f"{text}\n")

def check_dependencies():
    """Check if required dependencies are installed"""
    required_cmds = ["wine", "wineserver"]
    for cmd in required_cmds:
        if not shutil.which(cmd):
            print(f"❌ Error: Command {cmd} not found. Install required packages.")
            sys.exit(1)

def check_files():
    """Check if required files exist"""
    battlenet_path = os.path.join(WINEPREFIX, BATTLENET_EXE)
    if not os.path.isfile(battlenet_path):
        print("❌ Error: Battle.net Launcher file not found. Check path:")
        print(battlenet_path)
        sys.exit(1)

def cleanup(signum=None, frame=None):
    """Clean up when script is interrupted"""
    log_line("🛑 Script interrupted. Cleaning up...")
    subprocess.call(["wineserver", "-k"])
    sys.exit(0)

def kill_wineservers():
    """Kill any existing wineserver processes"""
    print("🧹 Killing existing wineservers...")
    subprocess.call(["wineserver", "-k"])
    subprocess.call([os.path.join(WINE_HOME, "bin", "wineserver"), "-k"])
    try:
        subprocess.call(["pkill", "wineserver"],
                       stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL)
    except subprocess.SubprocessError:
        # Ignore errors if no wineserver processes found
        pass

def print_wine_info():
    """Print Wine version and environment information to log"""
    log_line(f"🕓 Start time: {datetime.now()}")
    log_line(f"Wine HOME [ {WINE_HOME} ]")

    try:
        result = subprocess.run(
            [os.path.join(WINE_HOME, "bin", "wine"), "--version"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            check=True
        )
        log_line("Wine version:")
        log_line(result.stdout.strip())
        log_line("")
    except Exception as e:
        log_line(f"Error retrieving Wine version: {e}")

def launch_battlenet():
    """Launch Battle.net with appropriate environment settings"""
    print("🚀 Launching Battle.net Launcher...")
    wine_exe = os.path.join(WINE_HOME, "bin", "wine")
    battlenet_path = os.path.join(WINEPREFIX, BATTLENET_EXE)

    # Prepare environment
    env = os.environ.copy()
    env["WINEPREFIX"] = WINEPREFIX
    env["DXVK_HUD"] = "0"
    env["DXVK_ASYNC"] = "1"
    env["DXVK_LOG_LEVEL"] = "none"
    env["WINEDEBUG"] = "-all"
    # env["WINEDEBUG"] = "-fixme,+err"

    # Uncomment for NVIDIA cards:
    # env["__GL_SHADER_DISK_CACHE"] = "1"
    # env["__GL_SHADER_DISK_CACHE_PATH"] = os.path.join(WINEPREFIX, "shader_cache")

    # Uncomment for AMD cards:
    # env["RADV_PERFTEST"] = "aco"

    # Launch the application
    with open(LOG_FILE, "a") as log_file:
        try:
            subprocess.call(
                [wine_exe, battlenet_path],
                env=env
                # env=env,
                #stdout=log_file,
                #stderr=subprocess.STDOUT
            )
        except Exception as e:
            log_line(f"Error launching Battle.net: {e}")
            print(f"❌ Error launching Battle.net: {e}")
            sys.exit(1)

# === Main flow ===
if __name__ == "__main__":
    # Set up signal handlers for graceful termination
    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    check_dependencies()
    check_files()
    kill_wineservers()
    print_wine_info()
    launch_battlenet()
