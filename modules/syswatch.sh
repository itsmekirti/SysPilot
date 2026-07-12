#!/bin/bash

DISK_USAGE=$(df -h | grep dev | awk '{print $5}')
DISK_USAGE=${DISK_USAGE%\%}
DISK_THRESHOLD=80
LOG_FILE=../logs/syswatch.log

if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
then
    echo "WARN"
    echo "WARN" >> "$LOG_FILE"
else
    echo "OK"
    echo "OK" >> "$LOG_FILE"
fi

