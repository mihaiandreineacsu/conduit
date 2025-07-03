FROM python:3.13-alpine3.22

WORKDIR /app
COPY ./conduit-backend/ .
COPY ./backend-entrypoint.sh /entrypoint/backend-entrypoint.sh
RUN chmod +x /entrypoint/backend-entrypoint.sh

RUN pip install -r requirements.txt

EXPOSE 8000
ENTRYPOINT [ "/entrypoint/backend-entrypoint.sh" ]
