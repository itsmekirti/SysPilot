#!/bin/bash

failed_ssh_analysis() {
    echo "===== Top 10 Attacking IPs ====="
    SSH_ANALYSIS_PATH="/var/log/auth.log"
    sudo grep "sshd-session\[.*\]: Failed password" "$SSH_ANALYSIS_PATH" | awk '{print $9 }' | sort | uniq -c | sort -rn | head -n 10
    echo "===== Top 10 usernames attempted ====="
    sudo grep "sshd-session\[.*\]: Failed password" "$SSH_ANALYSIS_PATH" | awk '{print $7}' | sort | uniq -c | sort -rn | head -n 10
}
failed_ssh_analysis

system_error_analysis(){
      SYSTEM_ERROR_PATH="/var/log/syslog"
    echo "===== error frequency by hour ====="
    echo "hour count"
    sudo grep -Ei "error|fail|critical" "$SYSTEM_ERROR_PATH" | awk '{print $1}' | cut -d'T' -f2 | cut -d':' -f1 | sort | uniq -c |sort -rn  | awk '{print $2 " " $1}' | awk '
    {
        printf "%s | ", $1
        for(i=1; i<=$2; i++)
            printf "*"  
            printf " (%s)" , $2
            printf "\n"
    }'
}
system_error_analysis


