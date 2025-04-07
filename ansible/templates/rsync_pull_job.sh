#!/bin/bash



# Check if four necessary arguments are provided
if [[ "$#" -ne 4 ]]; then
    echo "Usage: $(basename "$0") <rsync_user> <rsync_host> <source_path> <destination_path>"
    exit 1
fi

RSYNC_USER=$1
RSYNC_HOST=$2
SOURCE_PATH=$3
DESTINATION_PATH=$4

LOG_PATH="/var/log/rsync"
LOG_FILE="rsync_pull_job_$(date +'%Y-%m-%d_%H-%M-%S').log"

## Run rsync job, retry on errors until a maximum number of retries is reached
MAX_RETRIES=10
RSYNC_PULL_COMMAND=(rsync -e "ssh -i /home/banas1/.ssh/id_rsa" -av $RSYNC_USER@$RSYNC_HOST:$SOURCE_PATH $DESTINATION_PATH -A -X --inplace --delete --log-file="$LOG_PATH/$LOG_FILE" )
i=0

echo "[$(date)] Starting Rsync pull job from $SOURCE_PATH ..."

while [ $i -lt $MAX_RETRIES ]; do
  i=$((i + 1))
  
  # Run rsync command (create full log, but output only errors, warnings, etc)
  "${RSYNC_PULL_COMMAND[@]}"  | grep -iE '(^sent|^received|^total|error|warning|permission|rsync)'
  rsync_exit_code=${PIPESTATUS[0]}  # Get exit code of rsync, not grep
  
  # If rsync succeeds, break the loop
  if [[ $rsync_exit_code -eq 0 ]]; then
    break
  fi

  echo "Rsync failed, retrying... ($i/$MAX_RETRIES)"
  sleep 5  # Optional: Avoid hammering the server too quickly
done

# Exit with error if we hit max retries
if [ $i -eq $MAX_RETRIES ]; then
  echo "Hit maximum number of retries, giving up."
  exit 1
fi

echo "[$(date)] Rsync pull job from $SOURCE_PATH finished after $i retries."
exit 0  # Success


