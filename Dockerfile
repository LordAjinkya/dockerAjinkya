# Start by pulling the official Node.js image and name this build stage as 'build'
FROM node AS build 

# Set the working directory inside the container to /react-app
WORKDIR /react-app

# Copy all package.json files (including package-lock.json, if it exists) into the working directory
COPY package*.json ./

# Install all dependencies listed in package.json using Yarn
RUN yarn install

# Copy all files from the current directory into the container's working directory
COPY . .

# Build the React application, generating optimized static files for production
RUN yarn run build

# Switch to the official Nginx image for the production environment
FROM nginx

# Copy the custom Nginx configuration file to the appropriate directory inside the container
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the build output from the 'build' stage to Nginx's default document root
COPY --from=build /react-app/build /usr/share/nginx/html
