#!/bin/bash

# Update system packages
apt-get update -y

# Install or update required packages
apt-get install -y apache2

# Stop Apache if it's running
systemctl stop apache2 || true

# Create backup of existing web files if they exist
if [ -d /var/www/html ]; then
  timestamp=$(date +%Y%m%d%H%M%S)
  mkdir -p /var/www/backup
  cp -r /var/www/html /var/www/backup/html_$timestamp
  rm -rf /var/www/html/*
fi

# Create directory if it doesn't exist
mkdir -p /var/www/html
