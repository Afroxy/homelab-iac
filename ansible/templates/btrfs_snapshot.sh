#!/bin/bash


# Check if a subvolume path is provided
if [[ "$#" -ne 2 ]]; then
    echo "Usage: $(basename "$0") <subvolume_path> <snapshot_parent>"
    exit 1
fi


# Get absolute path of the subvolume
SUBVOLUME_PATH=$(realpath "$1")
SNAPSHOT_PARENT=$(realpath "$2")

SUBVOLUME_NAME=$(basename "$SUBVOLUME_PATH")

LOG_PATH="/var/log/btrfs"
LOG_FILE="snapshot_$SUBVOLUME_NAME_$(date +%Y-%m-%d_%H-%M-%S).log"

# Ensure log directory exists
if [[ ! -d "$LOG_PATH" ]]; then
    echo "Error: Log directory does not exist: $LOG_PATH"
    exit 1
fi

# Check if the subvolume path exists and is a Btrfs subvolume
if ! btrfs subvolume show "$SUBVOLUME_PATH" &>/dev/null; then
    echo "Error: $SUBVOLUME_PATH is not a valid Btrfs subvolume."
    exit 1
fi

# Define the snapshot directory
SNAPSHOT_NAME="${SUBVOLUME_NAME}_snapshot_$(date +"%Y-%m-%d_%H-%M-%S")"
SNAPSHOT_PATH="$SNAPSHOT_PARENT/$SNAPSHOT_NAME"


# Create a read-only snapshot and log output
{
    echo "[$(date)] Starting Btrfs snapshot creation..."
    btrfs subvolume snapshot -r "$SUBVOLUME_PATH" "$SNAPSHOT_PATH"

    if [ $? -eq 0 ]; then
        echo "[$(date)] Snapshot created at: $SNAPSHOT_PATH"
    else
        echo "[$(date)] ERROR: Failed to create snapshot." | tee -a "$LOG_PATH/$LOG_FILE"
        exit 1
    fi
} | tee -a "$LOG_PATH/$LOG_FILE"

exit 0