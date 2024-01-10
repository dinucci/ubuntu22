#!/bin/bash

# Install Nginx
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install nginx

# Setup Nginx Configuration File
sudo rm /etc/nginx/sites-available/default
sudo tee /etc/nginx/sites-available/default << END
server {
    listen 80;
    server_name finart.club;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name finart.club;

    ssl_certificate /etc/nginx/ssl/finart.club.crt;
    ssl_certificate_key /etc/nginx/ssl/finart.club.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
END

# Enable Site
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Start Nginx Service
sudo systemctl start nginx

# Test Nginx Configuration
sudo nginx -t

# Restart Nginx Service
sudo systemctl restart nginx
