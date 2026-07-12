#!/bin/bash

DISK_USAGE=$(df -h | grep dev | awk '{print $5}')
DISK_USAGE=${DISK_USAGE%\%}
DISK_THRESHOLD=80

if [ $DISK_USAGE -gt $DISK_THRESHOLD ]
then
    echo "WARN"
else
    echo "OK"
fi
