#!/bin/bash

# Validate input
if [ $# -lt 2 ]; then
    echo "Usage: $0 <command> <log_file>"
    exit 1
fi

CMD="$1"            # First argument: command string
LOG_FILE="$2"       # Second argument: log file path


log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}


log "Running: $CMD"
bash -c "$CMD" 
STATUS=$?

if [ $STATUS -eq 0 ]; then
    log "Success: '$CMD' exited with code 0"
else
    log "Error: '$CMD' exited with code $STATUS"
fi

# Blank line for spacing
echo "" >> "$LOG_FILE"
