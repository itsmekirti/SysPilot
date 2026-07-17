create_user(){
    read -p "Enter username: " USERNAME

    if getent group "$DEFAULT_GROUP" 
    then 
        echo "group exist"
    else
        echo "Group doesnt exist"
        sudo groupadd "$DEFAULT_GROUP"     
    fi
        
    if id "$USERNAME"
    then 
        echo "user exist"
    else
        echo "User doesn't exist"
        sudo useradd -m -g "$DEFAULT_GROUP" "$USERNAME"
        if id "$USERNAME"
        then 
            echo "user $USERNAME created successfully"
            sudo passwd "$USERNAME"
            sudo chage -d 0 "$USERNAME"
            sudo chage -M 90 "$USERNAME"
            echo Password change required on first login.
            echo Password expires after 90 days.
        else
            echo "user doesnt create. there is some issue"
        fi
    fi
}

initialize_variables(){
    CURRENT_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    LOG_FILE="/home/kirti/Projects/SysPilot/logs/sysusers.log"
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
        echo "$CURRENT_TIMESTAMP | User: $USERNAME | Disabled Failed | User Not Found >> "$LOG_FILE"

    fi
}

