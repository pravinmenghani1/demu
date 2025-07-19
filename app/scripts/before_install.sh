#!/bin/bash
# Before installation script for CI/CD demo application

# Update system packages
sudo apt-get update -y

# Install Apache if not already installed
if ! command -v apache2 &> /dev/null; then
    sudo apt-get install -y apache2
fi

# Stop Apache service
sudo systemctl stop apache2

# Clean up the deployment directory
sudo rm -rf /var/www/html/*

# Log the completion
echo "$(date): Before install completed successfully" >> /var/log/deploy-log.txt
