#!/bin/bash

while true
do
    clear

    echo "========================================="
    echo "          SYSPILOT MENU"
    echo "========================================="
    echo
    echo "1. Health Monitor"
    echo "2. Backup Manager"
    echo "3. User Management"
    echo "4. Log Analyzer"
    echo "5. Service Watchdog"
    echo "6. Exit"
    echo

    read -p "Choose Option: " OPTION

    case "$OPTION" in

        1)
            ./modules/syswatch.sh
            ;;

        2)
            ./modules/sysbackup.sh
            ;;

        3)
            ./modules/sysusers.sh
            ;;

        4)
            ./modules/sysloganalyze.sh
            ;;

        5)
            ./modules/syswatchdog.sh
            ;;

        6)
            echo "Thank You for using SysPilot."
            exit 0
            ;;

        *)
            echo "Invalid Choice"
            ;;
    esac

    echo
    read -p "Press Enter to Continue..."

done