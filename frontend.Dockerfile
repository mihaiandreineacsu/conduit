# Stage 1: Build the Angular app
FROM node:20 AS build
WORKDIR /app
COPY . .
RUN npm install && \
    npm run build

# Production stage
FROM nginx:alpine AS prod
COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
