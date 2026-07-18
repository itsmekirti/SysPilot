#!/bin/bash

failed_ssh_analysis() {
    echo "===== Top 10 Attacking IPs ====="
    SSH_ANALYSIS_PATH="/var/log/auth.log"
    sudo grep "sshd-session\[.*\]: Failed password" "$SSH_ANALYSIS_PATH" | awk '{print $9 }' | sort | uniq -c | sort -rn | head -n 10
    echo "===== Top 10 usernames attempted ====="
    sudo grep "sshd-session\[.*\]: Failed password" "$SSH_ANALYSIS_PATH" | awk '{print $7}' | sort | uniq -c | sort -rn | head -n 10
}
failed_ssh_analysis