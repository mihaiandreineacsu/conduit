# Stage 1: Build the Angular app
FROM node:20 AS build
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
FROM nginx:alpine AS prod
COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html
EXPOSE 80
CMD ["sh", "-c", "nginx -g 'daemon off;' 2>&1 | tee -a /var/log/container_logs/container.log"]
