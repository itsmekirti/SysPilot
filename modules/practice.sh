#!/bin/bash

CPU_USAGE=$(mpstat | grep all | awk '{printf "%.0f\n",(100-$12)}')

echo $CPU_USAGE