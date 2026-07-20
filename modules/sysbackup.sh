#!/bin/bash

initialize_variable() {

    CONFIG_FILE="/home/kirti/Projects/SysPilot/config/syspilot.conf"
    source "$CONFIG_FILE"

    BACKUP_TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
    FOLDER_NAME=$(basename "$BACKUP_SOURCE")
    BACKUP_NAME="backup-$FOLDER_NAME-$BACKUP_TIMESTAMP.tar.gz"

}

restore_backup(){

    if [ ! -d "$BACKUP_DEST" ]
    then
        echo "Error: Backup directory doesn't exist"
        exit 1
    fi

    if [ ! -f "$BACKUP_DEST/$1" ]
    then
        echo "Error: Backup file doesn't exist"
        exit 1
    fi

    if [ ! -d "$2" ]
    then
        echo "Error: Target directory doesn't exist"
        exit 1
    fi

    if tar -xzf "$BACKUP_DEST/$1" -C "$2"
    then
        echo "Backup restored successfully."
        exit 0
    else
        echo "Error: Backup restore failed."
        exit 1
    fi

}

check_source_directory(){

    if [ ! -d "$BACKUP_SOURCE" ]
    then
        echo "ERROR: Source directory does not exist."
        exit 1
    fi

}

check_backup_directory(){

    if [ ! -d "$BACKUP_DEST" ]
    then
        echo "ERROR: Backup destination does not exist."
        exit 1
    fi

}

create_backup(){

    if tar -czf "$BACKUP_DEST/$BACKUP_NAME" "$BACKUP_SOURCE"
    then
        echo "Backup created successfully."

        if tar -tzf "$BACKUP_DEST/$BACKUP_NAME" > /dev/null
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

    TOTAL_BACKUPS=$(ls "$BACKUP_DEST" | wc -l)
    OLDEST_BACKUP=$(ls -tr "$BACKUP_DEST" | head -1)

    if [ "$TOTAL_BACKUPS" -gt "$BACKUP_KEEP" ]
    then
        rm "$BACKUP_DEST/$OLDEST_BACKUP"
        echo "Oldest backup removed."
    else
        echo "Backup files are less than $BACKUP_KEEP."
    fi

}

initialize_variable

if [ "$1" = "--restore" ]
then
    restore_backup "$2" "$3"
    exit 0
fi

check_source_directory
check_backup_directory
create_backup
remove_last_backup