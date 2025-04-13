#!/bin/bash
set -e

# Create log folder and set correct permissions
mkdir -p /var/log/container_logs
chown -R 1001:1001 /var/log/container_logs

# Start NGINX and log output
exec nginx -g "daemon off;" 2>&1 | tee -a /var/log/container_logs/container.log
