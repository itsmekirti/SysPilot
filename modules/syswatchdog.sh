#!/bin/bash
initialize_variable() {

    CONFIG_FILE="/home/kirti/Projects/SysPilot/config/syspilot.conf"
    source "$CONFIG_FILE"
}
initialize_variable
mkdir -p "$LOG_DIR"

for SERVICE in "${SERVICES[@]}"
do
    STATUS=$(systemctl is-active "$SERVICE")

    if [ "$STATUS" != "active" ]
    then
        COUNT_FILE="$LOG_DIR/${SERVICE}.count"

        CURRENT_TIME=$(date +%s)
        ONE_HOUR_AGO=$((CURRENT_TIME - 3600))

        # Create file if it doesn't exist
        sudo touch "$COUNT_FILE"

        # Keep only timestamps from the last hour
        sudo awk -v limit="$ONE_HOUR_AGO" '$1 >= limit' "$COUNT_FILE" > /tmp/${SERVICE}.tmp
        sudo mv /tmp/${SERVICE}.tmp "$COUNT_FILE"

        RESTART_COUNT=$(sudo wc -l < "$COUNT_FILE")

        if [ "$RESTART_COUNT" -ge 3 ]
        then
            echo "CRITICAL: $SERVICE restarted more than 3 times in the last hour."

            echo "$(date '+%Y-%m-%d %H:%M:%S') : CRITICAL - $SERVICE restarted more than 3 times in the last hour." \
            | sudo tee -a "$LOG_FILES" > /dev/null

            continue
        fi

        echo "Service $SERVICE is down. Restarting..."

        sudo systemctl start "$SERVICE"

        NEW_STATUS=$(systemctl is-active "$SERVICE")

        if [ "$NEW_STATUS" = "active" ]
        then
            echo "$CURRENT_TIME" | sudo tee -a "$COUNT_FILE" > /dev/null

            echo "Restart successful."

            echo "$(date '+%Y-%m-%d %H:%M:%S') : $SERVICE restarted successfully." \
            | sudo tee -a "$LOG_FILE" > /dev/null
        else
            echo "Restart failed."

            echo "$(date '+%Y-%m-%d %H:%M:%S') : Failed to restart $SERVICE." \
            | sudo tee -a "$LOG_FILES" > /dev/null
        fi
    fi
done