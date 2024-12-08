# FROM nginx:stable-alpine
# COPY . ./usr/share/nginx/html
# COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# Use a PHP base image
FROM php:7.4-apache

WORKDIR /var/www/html

# Copy the website files to the container
COPY . /var/www/html

# Install required PHP extensions and other dependencies
RUN apt-get update \
    && apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libpq-dev \
    && docker-php-ext-install \
        gd \
        mysqli \
        pdo_mysql \
        pdo_pgsql

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set the document root to the website folder
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Configure Apache to use the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Expose port 80 for the web server
EXPOSE 80