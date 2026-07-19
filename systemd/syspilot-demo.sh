#!/bin/bash

LOG_FILE="/tmp/syspilot-heartbeat.log"

while true
do
    echo "$(date '+%Y-%m-%d %H:%M:%S') Heartbeat" >> "$LOG_FILE"

    sleep 30
done