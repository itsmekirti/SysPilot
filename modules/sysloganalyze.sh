#!/bin/bash
initialize_variable() {

    CONFIG_FILE="/home/kirti/Projects/SysPilot/config/syspilot.conf"
    source "$CONFIG_FILE"
}

REPORT_NAME="report-$(date +%Y-%m-%d).txt"
REPORT_FILE="$REPORT_GENERATION_PATH/$REPORT_NAME"

failed_ssh_analysis() {
    initialize_variable
    echo "===== Top 10 Attacking IPs ====="
    SSH_ANALYSIS_PATH="/var/log/auth.log"
    sudo grep "sshd-session\[.*\]: Failed password" "$SSH_ANALYSIS_PATH" |
    awk '{
        if ($7 == "invalid")
            print $11
        else
            print $9
    }' | sort | uniq -c | sort -rn | head -n 10 
    echo "===== Top 10 usernames attempted ====="
    sudo grep "sshd-session\[.*\]: Failed password" "$SSH_ANALYSIS_PATH" | 
    awk '{
        if ($7 == "invalid")
            print $9
        else
            print $7
    }' | sort | uniq -c | sort -rn | head -n 10 
    } 

system_error_analysis(){
    initialize_variable
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

successful_logins(){
    initialize_variable
    sudo grep "sshd-session\[.*\]: Accepted password" "$SSH_ANALYSIS_PATH" | awk '{
        split($1, arr , "T")
        printf "Timestamp: %s %s", arr[1], arr[2]
        printf " | Username: %s", $7
        printf " | IP: %s\n", $9
    }'
}

check_report_directory() {
    initialize_variable
    if [ ! -d "$REPORT_GENERATION_PATH" ]
    then
        sudo mkdir -p "$REPORT_GENERATION_PATH"
    fi
}

generate_report(){
    initialize_variable
    check_report_directory
    echo "========================================="
    echo "       SysPilot Security Report          "
    echo
    echo "$(date +%Y-%m-%d)"
    echo
    echo "========================================="
    echo
    echo "===== Failed SSH Analysis ====="
    echo 
    failed_ssh_analysis
    echo "========================================="
    echo
    echo "=====System Errors Analysis===="
    echo
    system_error_analysis
    echo
    echo "========================================="
    echo
    echo "===== Successful Logins ======"
    echo
    successful_logins
    echo
}
generate_report | tee  "$REPORT_FILE"


