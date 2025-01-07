# Use Python 3.6-slim for compatibility with Django 1.10.5
FROM python:3.6-slim

WORKDIR /app
COPY . .

RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["sh", "-c", "(python manage.py makemigrations && python manage.py migrate && python manage.py runserver 0.0.0.0:8000) 2>&1 | tee -a /var/log/container_logs/container.log"]
