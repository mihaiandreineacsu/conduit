#!/usr/bin/env bash
set -e

(
    python manage.py makemigrations &&
        python manage.py migrate &&
        python manage.py runserver 0.0.0.0:8000
) 2>&1 | tee -a /var/log/container_logs/container.log
