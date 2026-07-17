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
create_user
initialize_variables(){
    CURRENT_TIMESTAMP=$(date "+Y%-%m-%d -%H:%M:%S")
    LOG_FILE="/home/kirti/Projects/SysPilot/logs/sysusers.log"
}
disable_user(){
    initialize_variables
    read -p "Enter Username: " USERNAME

    if id "$USERNAME"
    then 
        read -p "Enter Reason: " REASON
        sudo usermod -L "$USERNAME"
        STATUS=$(sudo passwd -S "$USERNAME" | awk '{print $2}')
        if [ "$STATUS" = "L" ]
        then 
            echo "User: $USERNAME locked successfully."
            sudo chage -E 0 "$USERNAME"
            echo "$CURRENT_TIMESTAMP | User: $USERNAME | Disabled | Reason: $REASON" >> $LOG_FILE
            echo "Successfully expired the $USERNAME account."
        else
            echo "$USERNAME" is not locked succefully. Please try again.
        fi
    else
        echo "Error: $USERNAME doesn't exist."
    fi
}