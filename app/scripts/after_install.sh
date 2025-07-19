#!/bin/bash
# After installation script for CI/CD demo application

# Set proper permissions
sudo chmod -R 755 /var/www/html/

# Create a deployment marker with timestamp
echo "Deployment completed at $(date)" > /var/www/html/deployment-info.txt
echo "Server: $(hostname)" >> /var/www/html/deployment-info.txt
echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /var/www/html/deployment-info.txt

# Log the completion
echo "$(date): After install completed successfully" >> /var/log/deploy-log.txt
