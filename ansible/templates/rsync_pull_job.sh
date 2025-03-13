#!/bin/bash

## Run rsync job, retry on errors until a maximum number of retries is reached

MAX_RETRIES=10
RSYNC_PULL_COMMAND=(rsync -av {{ rsync_user }}@{{ rsync_host }}:{{ rsync_source_path }} {{ rsync_destination_path }} -A -X --inplace --delete --log-file="/var/log/rsync/rsync_pull_job_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log" )
i=0

while [ $i -lt $MAX_RETRIES ]; do
  i=$((i + 1))
  
  # Run rsync command
  "${RSYNC_PULL_COMMAND[@]}"
  
  # If rsync succeeds, break the loop
  if [ $? -eq 0 ]; then
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

exit 0  # Success


