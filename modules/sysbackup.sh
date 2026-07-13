BACKUP_TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
BACKUP_SOURCE=/home/kirti/Projects/SysPilot/test_data
FOLDER_NAME=$(basename "$BACKUP_SOURCE")
BACKUP_DEST=/home/kirti/Projects/SysPilot/backups
BACKUP_NAME=backup-$FOLDER_NAME-$BACKUP_TIMESTAMP.tar.gz

if [ ! -d "$BACKUP_SOURCE" ]
then
    echo "ERROR: Source directory does not exist."
    exit 1
fi

if [ ! -d "$BACKUP_DEST" ]
then
    echo "ERROR: Backup destination does not exist."
    exit 1
fi

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
