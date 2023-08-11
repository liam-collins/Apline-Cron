#!/bin/ash

export LOG_FILE="start-up.log"

echo "Starting at `date`" > "${LOG_FILE}"

ls -l /tmp >> "${LOG_FILE}"

crond -b -l 5 -L /tmp/msg

sleep 300