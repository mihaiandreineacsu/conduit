# Use Python 3.6-slim for compatibility with Django 1.10.5
FROM python:3.6-slim AS build

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt && \
    python manage.py makemigrations && \
    python manage.py migrate

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
