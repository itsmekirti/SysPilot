#!/bin/bash

DISK_USAGE=$(df -h | grep dev | awk '{print $5}')
DISK_USAGE=${DISK_USAGE%\%}

if [ $DISK_USAGE -gt 80 ]
then
    echo "WARN"
else
    echo "OK"
fi
