FROM php:8.2-apache

# 1. Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libxml2-dev libzip-dev libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Activer les modules Apache nécessaires
RUN a2enmod rewrite

# 3. Installer Composer globalement
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 4. Définir le répertoire de travail
WORKDIR /var/www/html

# 5. Copier les fichiers Composer (meilleure gestion du cache Docker)
COPY composer.json composer.lock ./

# 6. Installer les dépendances PHP avec Composer
RUN composer install --no-interaction --optimize-autoloader

# 7. Copier le reste de l'application Symfony
COPY . .

# 8. Définir les permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 9. Modifier le DocumentRoot Apache
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# 10. Ajouter la configuration spécifique à Symfony
RUN echo '<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/symfony.conf \
    && a2enconf symfony

# 11. Exposer le port 80
EXPOSE 80

# 12. Lancer Apache au démarrage
CMD ["apache2-foreground"]
