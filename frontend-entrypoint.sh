#!/bin/bash
set -e

# Start NGINX and log output
exec nginx -g "daemon off;" 2>&1 | tee -a /var/log/container_logs/container.log
