#!/bin/sh
set -e

python manage.py makemigrations
python manage.py migrate

if [ "$DJANGO_SUPERUSER_EMAIL" ] && [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
    python manage.py createsuperuser --no-input || {
        echo "Admin was not created!"
    }
fi

if [ "${DJANGO_DEBUG}" = "True" ]; then
    exec python manage.py runserver 0.0.0.0:8000
else
    python manage.py collectstatics --no-input
    exec gunicorn conduit.wsgi:application --bind 0.0.0.0:8000
fi
