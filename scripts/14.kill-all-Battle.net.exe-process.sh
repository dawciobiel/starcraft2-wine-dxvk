#!/bin/bash
# =============================================================================
# Script Name: kill-all-battlenet-processes.sh
# Description: Terminates all running Battle.net-related processes in interactive, force, or dry-run mode.
#              Also attempts to kill the tracked StarCraft II process via PID file (/tmp/sc2.pid).
# Author: Dawid Bielecki ("dawciobiel")
# Date: 2025-11-03
# GitHub: https://github.com/dawciobiel
# =============================================================================

# ─────────────────────────────────────────────────────────────
# Help message
show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Terminates all running Battle.net-related processes.

Options:
  --force        Kill processes without asking for confirmation.
  --dry-run      Show which processes would be killed, without actually killing them.
  -h, --help     Display this help message and exit.

Examples:
  $0             Interactive mode (asks before killing each process)
  $0 --force     Force kill all matching processes
  $0 --dry-run   Preview which processes would be killed

EOF
    exit 0
}

# ─────────────────────────────────────────────────────────────
# Parse command-line arguments
FORCE=false
DRYRUN=false

for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --dry-run) DRYRUN=true ;;
        -h|--help) show_help ;;
    esac
done




# Check required config files
for conf in wine.conf; do
    CONF_PATH="$(dirname "$0")/$conf"
    if [ ! -f "$CONF_PATH" ]; then
        log_error "Missing configuration file: $conf"
        exit 1
    fi
done

# Read config files
source "$(dirname "$0")/wine.conf"



# Kill all wineservers
echo "Killing existing wineservers..."
    wineserver -k
    "$WINE_HOME$WINE_SERVER_BIN" -k
    pkill wineserver 2>/dev/null || true

# Show all 'defunct' processes
echo "Show again all 'defunct' processes"
  ps -eo pid=,args= | grep -Ei '<defunct>'








# ─────────────────────────────────────────────────────────────
# Get list of matching Battle.net processes, excluding this script
mypid=$$
myname=$(basename "$0")
tempfile=$(mktemp)

ps -eo pid,args \
    | grep -Ei 'battle\.net|battlenet' \
    | grep -v grep \
    | awk -v mypid="$mypid" -v myname="$myname" '$1 != mypid && $0 !~ myname' > "$tempfile"

if [ ! -s "$tempfile" ]; then
    echo "✅ No Battle.net-related processes found."
    rm "$tempfile"
    exit 0
fi

# ─────────────────────────────────────────────────────────────
# Open terminal input for interactive mode
exec 3</dev/tty

# ─────────────────────────────────────────────────────────────
# Process each matching line
while IFS= read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    cmd=$(echo "$line" | cut -d' ' -f2-)

    echo ""
    echo "🔍 Found process:"
    echo "PID: $pid"
    echo "Command: $cmd"

    if [ "$DRYRUN" = true ]; then
        echo "🧪 Dry run: would kill PID $pid"
    elif [ "$FORCE" = true ]; then
        kill "$pid" && echo "✅ Process $pid has been terminated." || echo "❌ Failed to terminate process $pid."
    else
        echo -n "Do you want to kill this process? (y/n): "
        read -r answer <&3
        case "$answer" in
            [Yy]* )
                kill "$pid" && echo "✅ Process $pid has been terminated." || echo "❌ Failed to terminate process $pid."
                ;;
            * )
                echo "⏭️ Process $pid skipped."
                ;;
        esac
    fi
done < "$tempfile"

# ─────────────────────────────────────────────────────────────
# Cleanup
rm "$tempfile"

