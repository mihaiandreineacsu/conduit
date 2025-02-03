# Use Python 3.6-slim for compatibility with Django 1.10.5
FROM python:3.6-slim

WORKDIR /app
COPY ./conduit-backend/ .
COPY ./backend-entrypoint.sh /app/backend-entrypoint.sh
RUN chmod +x /app/backend-entrypoint.sh

RUN pip install -r requirements.txt

EXPOSE 8000
ENTRYPOINT [ "./backend.entrypoint.sh" ]