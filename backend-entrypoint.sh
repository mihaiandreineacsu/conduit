#!/bin/sh
set -e

if [ "${DJANGO_DEBUG}" = "True" ]; then
    exec python manage.py runserver 0.0.0.0:8000
else
    python manage.py collectstatic --no-input
    exec gunicorn conduit.wsgi:application --bind 0.0.0.0:8000
fi
