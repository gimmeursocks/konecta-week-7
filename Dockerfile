# Use a lightweight Nginx base image
FROM nginx:alpine

# Remove the default Nginx welcome page
RUN rm /usr/share/nginx/html/index.html

# Copy our custom index.html file
COPY index.html /usr/share/nginx/html/index.html