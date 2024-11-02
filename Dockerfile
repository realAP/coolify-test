# Use an official Node image as the base for building
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# Use a lightweight image for serving the built files
FROM nginx:alpine

# Copy the built application from the build stage to the appropriate directory
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/dist/coolify-test/browser /usr/share/nginx/html
COPY --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
