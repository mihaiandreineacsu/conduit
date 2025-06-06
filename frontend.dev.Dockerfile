# Use a Node.js image for development
FROM bitnami/node:20

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies first
COPY ./conduit-frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY ./conduit-frontend/ .

# Expose the development server port
EXPOSE 8080

# Start the Angular development server with hot-reloading
CMD ["npm", "run", "start", "--", "--host", "0.0.0.0", "--port", "8080", "--watch"]
