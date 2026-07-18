#!/bin/bash

initialize_variables(){
    source ../config/syspilot.conf
    CURRENT_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    LOG_FILE="/home/kirti/Projects/SysPilot/logs/sysusers.log"
    AUDIT_TIMESTAMP=$(date "+%Y-%m-%d-%H%M%S")
    AUDIT_DIR="/home/kirti/Projects/SysPilot/audit"
    AUDIT_REPORT="/home/kirti/Projects/SysPilot/audit/audit-report-$AUDIT_TIMESTAMP.txt"
}

create_user(){
    initialize_variables
    read -p "Enter username: " USERNAME

    if getent group "$DEFAULT_GROUP" 
    then 
        echo "group exist"
        echo "$CURRENT_TIMESTAMP | Group $DEFAULT_GROUP exist" >> "$LOG_FILE"
    else
        echo "Group doesnt exist"
        echo "$CURRENT_TIMESTAMP | Group $DEFAULT_GROUP doesn't exist" >> "$LOG_FILE"
        sudo groupadd "$DEFAULT_GROUP"  
        echo "$CURRENT_TIMESTAMP | Group $DEFAULT_GROUP create successfully" >> "$LOG_FILE"   
    fi
        
    if id "$USERNAME"
    then 
        echo "user exist"
        echo "$CURRENT_TIMESTAMP | User: $USERNAME | $USERNAME exist." >> "$LOG_FILE"
    else
        echo "User doesn't exist"
        echo "$CURRENT_TIMESTAMP | User: $USERNAME | $USERNAME exist." >> "$LOG_FILE"
        sudo useradd -m -g "$DEFAULT_GROUP" "$USERNAME"
        if id "$USERNAME"
        then 
            echo "user $USERNAME created successfully"
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | $USERNAME create successfully." >> "$LOG_FILE"
            sudo passwd "$USERNAME"
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Password set for $USERNAME" >> "$LOG_FILE"
            sudo chage -d 0 "$USERNAME"
            echo Password change required on first login.
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Password change required on first login." >> "$LOG_FILE"
            sudo chage -M 90 "$USERNAME"
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Password expires after 90 days." >> "$LOG_FILE"  
            echo Password expires after 90 days.
        else
            echo "user doesnt create. there is some issue"
            echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | $USERNAME doesn't exist." >> "$LOG_FILE"
        fi
    fi
}

disable_user(){
    initialize_variables
    read -p "Enter Username: " USERNAME

    if id "$USERNAME" >/dev/null 2>&1
    then 
        read -p "Enter Reason: " REASON
        sudo usermod -L "$USERNAME"
        STATUS=$(sudo passwd -S "$USERNAME" | awk '{print $2}')
        if [ "$STATUS" = "L" ]
        then 
            echo "User: $USERNAME locked successfully."
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Locked Successfully | Reason: $REASON" >> "$LOG_FILE"
            sudo chage -E 0 "$USERNAME"
            if [ $? -eq 0 ]
            then
                echo "Account expired successfully."
                echo "$CURRENT_TIMESTAMP | User: $USERNAME | Disabled Successfully | Reason: $REASON" >> "$LOG_FILE"
            else
                echo "Failed to expire account."
                echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | Disabled Failed | Reason: $REASON" >> "$LOG_FILE"
            fi
        else
            echo "$USERNAME is not locked successfully. Please try again."
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Locked Failed | Reason: $REASON" >> "$LOG_FILE"
        fi
    else
        echo "Error: $USERNAME doesn't exist."
        echo "$CURRENT_TIMESTAMP | User: $USERNAME | Disabled Failed | User Not Found" >> "$LOG_FILE"
    fi
}

delete_user() {
    initialize_variables

    read -p "Enter User: " USERNAME

    HOME_DIR=$(grep "^$USERNAME:" /etc/passwd | awk -F: '{print $6}')
    BACKUP_TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
    BACKUP_DEST="/home/kirti/Projects/SysPilot/backups"
    FOLDER_NAME=$(basename "$HOME_DIR")
    USER_BACKUP_NAME="backup-$FOLDER_NAME-$BACKUP_TIMESTAMP.tar.gz"

    if id "$USERNAME" >/dev/null 2>&1
    then
        if [ -d "$HOME_DIR" ]
        then
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Directory exists" >> "$LOG_FILE"

            mkdir -p "$BACKUP_DEST"

            if tar -czf "$BACKUP_DEST/$USER_BACKUP_NAME" "$HOME_DIR" >/dev/null 2>&1
            then
                if [ -f "$BACKUP_DEST/$USER_BACKUP_NAME" ]
                then
                    if tar -tzf "$BACKUP_DEST/$USER_BACKUP_NAME" >/dev/null 2>&1
                    then
                        echo "User backup created successfully."
                        echo "$CURRENT_TIMESTAMP | User: $USERNAME | Backup created | Backup: $USER_BACKUP_NAME" >> "$LOG_FILE"

                        sudo userdel -r "$USERNAME"

                        if id "$USERNAME" >/dev/null 2>&1
                        then
                            echo "User $USERNAME still exists."
                            echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | User still exists" >> "$LOG_FILE"
                        else
                            echo "User $USERNAME deleted successfully."
                            echo "$CURRENT_TIMESTAMP | User: $USERNAME | User deleted successfully." >> "$LOG_FILE"
                        fi
                    else
                        echo "Backup archive verification failed."
                        echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | Backup archive verification failed." >> "$LOG_FILE"
                    fi
                else
                    echo "Backup file not found."
                    echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | Backup file not found." >> "$LOG_FILE"
                fi
            else
                echo "User backup creation failed."
                echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | Backup creation failed." >> "$LOG_FILE"
            fi
        else
            echo "Home directory doesn't exist."
            echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | Home directory doesn't exist." >> "$LOG_FILE"
        fi
    else
        echo "Error: User $USERNAME doesn't exist."
        echo "Error: $CURRENT_TIMESTAMP | User: $USERNAME | User doesn't exist." >> "$LOG_FILE"
    fi
}


audit_mode(){
    initialize_variables
    mkdir -p "$AUDIT_DIR"
    touch "$AUDIT_REPORT"
    awk -F: '$2=="" {print $1}' /etc/shadow | while read -r USERNAME
    do
        echo "========== Empty Password Users =========="
        echo "$CURRENT_TIMESTAMP | User: $USERNAME | Empty Password" >> "$AUDIT_REPORT"
    done
    UID0_COUNT=$(awk -F: '$3==0 {print $1}' /etc/passwd | wc -l)
    if [ "$UID0_COUNT" -gt 1 ]
    then
        awk -F: '$3==0 {print $1}' /etc/passwd | while read -r USERNAME
        do
            echo "==========Report any duplicate UID 0 accounts =========="
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Duplicate UID 0 Accounts" >> "$AUDIT_REPORT"
        done
    fi
}

world_Writeable_file(){
    initialize_variables
    find /home -type f -perm -002 | while read -r FILE
    do
        echo "$CURRENT_TIMESTAMP | File: $FILE | World Writable File" >> "$AUDIT_REPORT"
    done
}

echo "1. Create User"
echo "2. Disable User"
echo "3. Delete User"
echo "4. Audit"
echo "5. World Writable Files"
echo "6. Exit"

read -p "Choose option: " OPTION

case "$OPTION" in
    1) create_user ;;
    2) disable_user ;;
    3) delete_user ;;
    4) audit_mode ;;
    5) world_Writeable_file ;;
    6) exit ;;
    *) echo "Invalid option" ;;
esac
