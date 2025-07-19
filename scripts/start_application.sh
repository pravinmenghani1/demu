#!/bin/bash

# Start Apache
systemctl start apache2
systemctl enable apache2

# Print status
echo "Apache started and enabled"
systemctl status apache2
