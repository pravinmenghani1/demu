#!/bin/bash
# Validate service script for CI/CD demo application

# Check if Apache is running
if systemctl is-active --quiet apache2; then
    echo "Apache service is running"
else
    echo "Apache service is not running"
    exit 1
fi

# Check if the website is accessible
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "Website is accessible"
else
    echo "Website is not accessible, HTTP code: $HTTP_CODE"
    exit 1
fi

# Log the completion
echo "$(date): Service validation completed successfully" >> /var/log/deploy-log.txt
