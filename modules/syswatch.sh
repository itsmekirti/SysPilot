#!/bin/bash
echo "=================================================="
echo
echo "        SYSPILOT HEALTH MONITOR REPORT            "
echo
echo "=================================================="
echo
echo "    DISK USAGE   "
echo

initialize_variables(){
    source ../config/syspilot.conf
    CURRENT_DATE=$(date "+%Y-%m-%d %I:%M:%S %p")
    LOG_FILE=../logs/syswatch.log
}

check_disk_usage(){
    DISK_USAGE=$(df -h | grep dev | awk '{print $5}')
    DISK_USAGE=${DISK_USAGE%\%}
    initialize_variables

    if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
    then
        echo "$CURRENT_DATE [WARN] Disk Usage $DISK_USAGE% exceeds Threshold $DISK_THRESHOLD%" >> $LOG_FILE
        echo "DISK_USAGE:$DISK_USAGE%"
        echo "Status=WARN"
    else
        echo "$CURRENT_DATE [OK] Disk Usage $DISK_USAGE% | Threshold $DISK_THRESHOLD%" >> $LOG_FILE
        echo "DISK_USAGE:$DISK_USAGE%"
        echo "Status=OK"
    fi
}
check_disk_usage
echo "--------------------------------"
echo
echo "    MEMORY USAGE   "
echo

check_memory_usage(){
    MEMORY_USAGE=$(free -m | grep Mem | awk '{printf "%.0f\n", ($3/$2)*100}')
    initialize_variables

    if [ $MEMORY_USAGE -gt $MEM_THRESHOLD ]
    then
        echo "$CURRENT_DATE [WARN] Memory Usage $MEMORY_USAGE% exceeds Threshold $MEM_THRESHOLD%" >> $LOG_FILE
        echo "Memory Usage: $MEMORY_USAGE%"
        echo "Status: WARN"
    else
        echo "$CURRENT_DATE [OK] Memory Usage $MEMORY_USAGE% | Threshold $MEM_THRESHOLD%" >> $LOG_FILE
        echo "Memory Usage: $MEMORY_USAGE%"
        echo "Status: OK"
    fi   
    
}
check_memory_usage
echo "--------------------------------"
echo
echo "   CPU USAGE   "
echo
check_CPU_load(){
    CPU_USAGE=$(mpstat | grep all | awk '{printf "%.0f\n",(100-$12)}')
    initialize_variables

    if [ $CPU_USAGE -gt $CPU_THRESHOLD ]
    then
        echo "$CURRENT_DATE [WARN] CPU Usage $CPU_USAGE% exceeds Threshold $CPU_THRESHOLD%" >> $LOG_FILE
        echo "CPU Usage: $CPU_USAGE%"
        echo "Status: WARN" 
    else
        echo "$CURRENT_DATE [OK] CPU Usage $CPU_USAGE% | Threshold $CPU_THRESHOLD%" >> $LOG_FILE
        echo "CPU Usage: $CPU_USAGE%"
        echo "Status: OK"
   fi
}
check_CPU_load
echo "--------------------------------"
echo
check_top_processes(){
    TOP5_RESOURCE=$(ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-8s %-8s %-8s %s\n",$2,$3,$4,$11}')
    echo "    Top 5 Memory Processes      "
    echo
    echo "PID      CPU%    MEM%    COMMAND"
    echo "--------------------------------"
    echo "$TOP5_RESOURCE"
}

check_top_processes

echo 
echo "Health Monitor Checkup Completed"



