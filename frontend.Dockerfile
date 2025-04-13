# Stage 1: Build the Angular app
FROM bitnami/node:20 AS build
WORKDIR /app
COPY ./conduit-frontend/ .

# Declare the build argument with a default value
ARG API_PORT="8000"
ARG API_URL="localhost"
ENV BASE_API_URL=${API_URL}
ENV BASE_API_PORT=${API_PORT}


# Replace the placeholder in environment.prod.ts, install dependencies and build production configuration
RUN npm install && \
    npm run build

# Production stage
FROM bitnami/nginx:1.27.4 AS prod
COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html
USER root
COPY ./conduit-frontend/entrypoint.sh /app/frontend-entrypoint.sh
RUN chmod +x /app/frontend-entrypoint.sh
USER 1001
EXPOSE 80
ENTRYPOINT [ "./frontend-entrypoint.sh" ]
