#!/bin/bash
## Create a shutdown script that calculates tomorrow's wake time and powers off


# Check if two necessary arguments are provided
if [[ "$#" -ne 2 ]]; then
    echo "Usage: $(basename "$0") <wake_hour> <wake_minute>"
    exit 1
fi

# Desired wake-up time
WAKE_HOUR=$1
WAKE_MINUTE=$2


# Get the current time and today's target wake time
NOW=$(date +%s)
TARGET_TODAY=$(date -d "today $WAKE_HOUR:$WAKE_MINUTE" +%s)

# Determine if target time is still in the future today
if [ "$NOW" -lt "$TARGET_TODAY" ]; then
    TARGET_LOCAL="$TARGET_TODAY"
else
    # Otherwise, use the same time tomorrow
    TARGET_LOCAL=$(date -d "tomorrow $WAKE_HOUR:$WAKE_MINUTE" +%s)
fi

WAKE_TIMESTAMP_LOCAL=$TARGET_LOCAL
# Convert to UTC for rtcwake
WAKE_TIMESTAMP_UTC=$(date -u -d @"$TARGET_LOCAL" +%s)

# Schedule wake-up and suspend (S3-state)
echo "Current system time is: $(date -d @$NOW)"
echo "Scheduling wake-up at: $(date -d @$TARGET_LOCAL) (local)"
echo "RTC wake timestamp: $(date -u -d @$WAKE_TIMESTAMP_UTC) (UTC)"
#sudo rtcwake --mode mem --utc --time "$WAKE_TIMESTAMP_UTC"
sudo rtcwake -m no -t "$WAKE_TIMESTAMP_UTC" 
sync # flush all writes to disk
sudo systemctl suspend