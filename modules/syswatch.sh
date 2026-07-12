#!/bin/bash
check_disk_usage(){
    DISK_USAGE=$(df -h | grep dev | awk '{print $5}')
    DISK_USAGE=${DISK_USAGE%\%}
    DISK_THRESHOLD=80
    LOG_FILE=../logs/syswatch.log
    CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")

    if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
    then
        echo ""$CURRENT_DATE" [WARN] "$DISK_USAGE%" THRESHOLD "$DISK_THRESHOLD"" >> "$LOG_FILE"
    else
        echo ""$CURRENT_DATE" [OK] "$DISK_USAGE%" THRESHOLD "$DISK_THRESHOLD"" >> "$LOG_FILE"
    fi
}
check_disk_usage


