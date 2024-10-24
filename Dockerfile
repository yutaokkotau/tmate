# Use the official Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install tmate and a lightweight HTTP server (Nginx)
RUN apt-get update && \
    apt-get install -y tmate nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create directory for serving the HTML page
RUN mkdir -p /var/www/html

# Create a script to keep the VPS running
RUN echo '#!/bin/bash\nwhile true; do\n  tmate -F | tee /var/www/html/index.html\n  sleep 10\n done' > /keep-alive.sh
RUN chmod +x /keep-alive.sh

# Replace the default Nginx config with a basic one
RUN echo 'server { listen 80; location / { root /var/www/html; try_files $uri $uri/ =404; } }' > /etc/nginx/sites-available/default

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx and the keep-alive script in the foreground to keep the container alive
CMD ["bash", "-c", "/keep-alive.sh & nginx -g 'daemon off;'"]
