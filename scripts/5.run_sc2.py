#!/usr/bin/env python3
#==============================================================================
# run_sc2.py
#
# DESCRIPTION:
#   Python launcher script for StarCraft II (64-bit) under Wine on Linux.
#   Uses a predefined WINEPREFIX and handles logging.
#
# USAGE:
#   ./run_sc2.py
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
SC2_EXE = "/12.TB.sdc1.ext4.luks.dane/games/StarCraft II/Support64/SC2Switcher_x64.exe"

# Set up logging directory
LOG_DIR = os.path.expanduser("~/Games/sc2-logs")
os.makedirs(LOG_DIR, exist_ok=True)
timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
LOG_FILE = os.path.join(LOG_DIR, f"sc2-{timestamp}.log")

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

def check_executable():
    """Check if StarCraft II executable exists"""
    if not os.path.isfile(SC2_EXE):
        print("❌ Error: StarCraft II executable not found:")
        print(f"   [ {SC2_EXE} ]")
        print("🛠️  Please verify the path and update this script.")
        sys.exit(1)

    print("✅ StarCraft II executable found.")

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

def launch_sc2():
    """Launch StarCraft II with appropriate environment settings"""
    print("🚀 Launching StarCraft II...")
    wine_exe = os.path.join(WINE_HOME, "bin", "wine")

    # Prepare environment
    env = os.environ.copy()
    env["WINEPREFIX"] = WINEPREFIX
    env["DXVK_HUD"] = "1"
    env["DXVK_ASYNC"] = "1"
    env["WINEDEBUG"] = "fixme,err"

    # Uncomment for NVIDIA cards:
    # env["__GL_SHADER_DISK_CACHE"] = "1"
    # env["__GL_SHADER_DISK_CACHE_PATH"] = os.path.join(WINEPREFIX, "shader_cache")

    # Uncomment for AMD cards:
    # env["RADV_PERFTEST"] = "aco"

    # Launch the application
    with open(LOG_FILE, "a") as log_file:
        try:
            subprocess.call(
                [wine_exe, SC2_EXE],
                env=env,
                stdout=log_file,
                stderr=subprocess.STDOUT
            )
        except Exception as e:
            log_line(f"Error launching StarCraft II: {e}")
            print(f"❌ Error launching StarCraft II: {e}")
            sys.exit(1)

# === Main flow ===
if __name__ == "__main__":
    # Set up signal handlers for graceful termination
    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    check_dependencies()
    check_executable()
    kill_wineservers()
    print_wine_info()
    launch_sc2()
