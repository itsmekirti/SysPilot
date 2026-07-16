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