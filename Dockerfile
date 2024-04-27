# Use a Node.js base image
FROM node:latest AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the frontend
RUN npm run build

# Stage 2 - Production environment
FROM nginx:alpine

# Copy the built frontend files from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

