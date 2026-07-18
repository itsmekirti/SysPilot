#!/bin/bash

initialize_variable() {
    source ../config/syspilot.conf

    BACKUP_TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
    FOLDER_NAME=$(basename "$BACKUP_SOURCE")
    BACKUP_NAME="backup-$FOLDER_NAME-$BACKUP_TIMESTAMP.tar.gz"
}

restore_backup(){
    if [ "$1" = "--restore" ]
    then 
        if [ ! -d "$BACKUP_DEST" ]
        then 
            echo "Error: Backup directory doesnt exist"
            exit 1
        else
            if [ ! -f "$BACKUP_DEST/$2" ]
            then
                echo "error: Backup file doesnt exist"
                exit 1
            else
                if [ ! -d "$3" ]
                then
                    echo "error : target directory doesnt exist"
                    exit 1
                else
                    if tar -xzf "$BACKUP_DEST/$2" -C "$3"
                    then 
                        echo "Backup file restored successfully"
                        exit 0
                    else
                        echo "Error: Backup file could not restore successfully"
                        exit 1
                    fi
                fi
            fi
        fi
    fi
}
check_source_directory(){
    #check if backup source available or not
    if [ ! -d "$BACKUP_SOURCE" ]
    then
        echo "ERROR: Source directory does not exist."
        exit 1
    fi
}
check_backup_directory(){
    #check backup destination is available or not 
    if [ ! -d "$BACKUP_DEST" ]
    then
        echo "ERROR: Backup destination does not exist."
        exit 1
    fi
}
create_backup(){
    # create and verify backup 
    if tar -czf "$BACKUP_DEST/$BACKUP_NAME" "$BACKUP_SOURCE"
    then
        echo "Backup created successfully."
        if tar -tzf "$BACKUP_DEST/$BACKUP_NAME" 
        then
            echo "Backup verification successful."
        else
            echo "Backup verification failed."
        fi
    else
        echo "Backup creation failed."
    fi    
}

remove_last_backup(){
    Total_bacups=$(ls ../backups | wc -l)
    OLDEST_BACKUP=$(ls -tr ../backups | head -1)
    if [ $Total_bacups -gt $BACKUP_KEEP ]
    then
        rm "$BACKUP_DEST/$OLDEST_BACKUP"
        echo "Oldest Backup File is removed"
    else
        echo "Backup files is less than 7"
    fi
}

initialize_variable
if [ "$1" = "--restore" ]
then
    restore_backup "$2" "$3"
fi
check_source_directory
check_backup_directory
create_backup
remove_last_backup


            


    

