#!/bin/bash

# Stop Apache if it's running
systemctl stop apache2 || true
echo "Apache stopped"
