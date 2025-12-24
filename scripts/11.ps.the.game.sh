 #!/bin/bash
# =============================================================================
# Script Name: ps-the-game.sh
# Description: Displays running Battle.net Launcher and StarCraft II processes
#              with their PIDs and executable paths only (no extra arguments).
#              Separates zombie (<defunct>) processes into a separate list.
# Author: Dawid Bielecki ("dawciobiel")
# Date: 2025-11-03
# GitHub: https://github.com/dawciobiel
# =============================================================================
# Usage:
#   ./ps-the-game.sh
#
# Requirements:
#   - Bash shell
#   - ps (standard on Linux)
#
# Notes:
#   - This script searches for Windows executables run under Wine/Proton
#     (Battle.net.exe, Agent.exe, SC2Switcher_x64.exe).
#   - Zombie (<defunct>) processes are also listed separately.
# =============================================================================

COLORS_FILE="$(dirname "$0")/colors"
if [[ -f "$COLORS_FILE" ]]; then
  source "$COLORS_FILE"
fi

info()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[ OK ]${RESET} $1"; }

# Funkcja: aktywne procesy (PID + ścieżka .exe)
list_active() {
  local pattern="$1"
  ps -eo pid=,args= \
    | grep -Ei "$pattern" \
    | grep -v '<defunct>' \
    | sed -E 's/^([0-9]+) (.*\.exe)(.*)/\1 \2/' \
    | sort -n
}

# Funkcja: zombie procesy (PID + pełna linia z <defunct>)
list_zombie() {
  local pattern="$1"
  ps -eo pid=,args= \
    | grep -Ei "$pattern" \
    | grep '<defunct>' \
    | sort -n
}

echo ""
info "Battle.net Launcher processes (active) ====="
echo "PID     COMMAND"
if ! list_active 'Battle\.net\.exe|Agent\.exe'; then
    success "No active Battle.net processes found."
fi

echo ""
info "Battle.net Launcher processes (zombie) ====="
echo "PID     COMMAND"
if ! list_zombie 'Battle\.net\.exe|Agent\.exe'; then
    success "No zombie Battle.net processes found."
fi

echo ""
info "StarCraft II game processes (active) ======="
echo "PID     COMMAND"
if ! list_active 'SC2Switcher_x64\.exe'; then
    success "No active StarCraft II processes found."
fi

echo ""
info "StarCraft II game processes (zombie) ======="
echo "PID     COMMAND"
if ! list_zombie 'SC2Switcher_x64\.exe'; then
    success "No zombie StarCraft II processes found."
fi

echo ""
