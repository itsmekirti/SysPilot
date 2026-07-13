BACKUP_TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
echo $BACKUP_TIMESTAMP
BACKUP_SOURCE=/home/kirti/Projects/SysPilot/test_data
FOLDER_NAME=$(basename "$BACKUP_SOURCE")
BACKUP_DEST=/home/kirti/Projects/SysPilot/backups