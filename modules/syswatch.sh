#!/bin/bash
check_disk_usage(){
    DISK_USAGE=$(df -h | grep dev | awk '{print $5}')
    DISK_USAGE=${DISK_USAGE%\%}
    source ../config/syspilot.conf
    LOG_FILE=../logs/syswatch.log
    CURRENT_DATE=$(date "+%Y-%m-%d %I:%M:%S %p")

    if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
    then
        echo ""$CURRENT_DATE" [WARN] "$DISK_USAGE%" THRESHOLD "$DISK_THRESHOLD"" >> "$LOG_FILE"
        echo "DISK_USAGE:$DISK_USAGE"
        echo "Status=WARN"
    else
        echo ""$CURRENT_DATE" [OK] "$DISK_USAGE%" THRESHOLD "$DISK_THRESHOLD"" >> "$LOG_FILE"
        echo "DISK_USAGE:$DISK_USAGE"
        echo "Status=OK"
    fi
}
check_disk_usage

check_memory_usage(){
    MEMORY_USAGE=$(free -m | grep Mem | awk '{printf "%.0f\n", ($3/$2)*100}')
    source ../config/syspilot.conf

    if [ $MEMORY_USAGE -gt $MEM_THRESHOLD ]
    then
        echo "Memory Usage: $MEMORY_USAGE"
        echo "Status: WARN"
    else
        echo "Memory Usage: $MEMORY_USAGE"
        echo "Status: OK"
    fi   
    
}
check_memory_usage

