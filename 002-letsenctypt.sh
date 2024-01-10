#!/bin/bash

# Update apt repository
sudo apt update

# Install snapd
sudo apt install snapd

# Install certbot
sudo snap install core
sudo snap refresh core
sudo ln -s /snap/bin/* /usr/local/bin
sudo snap install certbot --classic

# Obtain SSL certificate
sudo certbot certonly --standalone --preferred-challenges http-01 --http-01-port 80 --no-redirect --agree-tos --register-unsafely-without-email --domains example.com,www.example.com

# Copy SSL certificate and key to Nginx config directory
sudo cp /etc/letsencrypt/live/example.com/fullchain.pem /etc/nginx/ssl/example.com.crt
sudo cp /etc/letsencrypt/live/example.com/privkey.pem /etc/nginx/ssl/example.com.key

# Add SSL configuration to Nginx config file
sudo nano /etc/nginx/sites-available/example.com

# Paste the following configuration into the file
server {
        listen 443 ssl;
        server_name example.com www.example.com;

        ssl_certificate /etc/nginx/ssl/example.com.crt;
        ssl_certificate_key /etc/nginx/ssl/example.com.key;

        # Other configurations...
}

# Restart Nginx
sudo systemctl restart nginx
