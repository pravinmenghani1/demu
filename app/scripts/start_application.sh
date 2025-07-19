#!/bin/bash
# Start application script for CI/CD demo application

# Start Apache service
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Log the completion
echo "$(date): Application start completed successfully" >> /var/log/deploy-log.txt
