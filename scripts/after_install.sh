#!/bin/bash

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Create a simple index.html if it doesn't exist
if [ ! -f /var/www/html/index.html ]; then
  echo "<html><body><h1>CI/CD Demo - Default Page</h1><p>This is a default page. Replace with your application.</p><p>Deployment time: $(date)</p></body></html>" > /var/www/html/index.html
fi
