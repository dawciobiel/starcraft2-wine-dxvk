#!/bin/bash
#
# 14.kill-all-Battle.net.exe-process.sh
# Description: Kill all "battlenet" or "battle.net" processes in interactive, force or dry-run mode.
# Author: dawciobiel (http://github.com/dawciobiel)
# Date: 2025-09-02

# ─────────────────────────────────────────────────────────────
# Parse command-line arguments
FORCE=false
DRYRUN=false

for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --dry-run) DRYRUN=true ;;
    esac
done

# ─────────────────────────────────────────────────────────────
# Get list of matching processes, excluding this script and any process running it
mypid=$$
myname=$(basename "$0")
tempfile=$(mktemp)

ps -eo pid,args \
    | grep -Ei 'battle\.net|battlenet' \
    | grep -v grep \
    | awk -v mypid="$mypid" -v myname="$myname" '$1 != mypid && $0 !~ myname' > "$tempfile"

if [ ! -s "$tempfile" ]; then
    echo "No processes containing 'battlenet' or 'battle.net' were found."
    rm "$tempfile"
    exit 0
fi

# ─────────────────────────────────────────────────────────────
# Open terminal input as file descriptor for interactive mode
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
