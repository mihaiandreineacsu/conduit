#!/bin/bash
set -e

# Start NGINX and log output
exec nginx -g "daemon off;"
