BACKUP_TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
BACKUP_SOURCE=/home/kirti/Projects/SysPilot/test_data
FOLDER_NAME=$(basename "$BACKUP_SOURCE")
BACKUP_DEST=/home/kirti/Projects/SysPilot/backups
BACKUP_NAME=backup-$FOLDER_NAME-$BACKUP_TIMESTAMP.tar.gz

#check if backup source available or not
if [ ! -d "$BACKUP_SOURCE" ]
then
    echo "ERROR: Source directory does not exist."
    exit 1
fi

#check backup destination is available or not 
if [ ! -d "$BACKUP_DEST" ]
then
    echo "ERROR: Backup destination does not exist."
    exit 1
fi
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

OLDEST_BACKUP=$(ls -tr ../backups | head -1)
BACKUP_KEEP=7

