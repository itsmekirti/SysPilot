#!/bin/bash

echo "Installing SysPilot..."

sudo mkdir -p /etc/syspilot
sudo mkdir -p /var/log/syspilot
sudo mkdir -p /var/log/syspilot/audit
sudo mkdir -p /opt/backups

sudo cp config/syspilot.conf /etc/syspilot/

sudo chmod +x modules/*.sh
sudo chmod +x syspilot.sh

echo
echo "Installation Completed Successfully."