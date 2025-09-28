FROM php:8.2-apache

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libxml2-dev libzip-dev libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Enable Apache modules
RUN a2enmod rewrite

# 3. Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 4. Set working directory
WORKDIR /var/www/html
COPY .env .env
# 5. Copy composer files first (for Docker cache)
COPY composer.json composer.lock ./

# 6. Install PHP dependencies
RUN composer install --no-scripts --no-interaction --optimize-autoloader

# 7. Copy rest of application (including .env)
COPY . .

# 8. Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 9. Change Apache DocumentRoot
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# 10. Symfony-specific Apache config
RUN echo '<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/symfony.conf \
    && a2enconf symfony

# 11. Expose port
EXPOSE 80

# 12. Run Apache in foreground
CMD ["apache2-foreground"]

