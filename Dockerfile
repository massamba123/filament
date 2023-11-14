# Utiliser l'image officielle PHP 8.1 basée sur Debian
FROM php:8.1

# Définir le répertoire de travail dans le conteneur
WORKDIR /var/www/html

# Copier les fichiers de l'application dans le conteneur
COPY . .

# Installer les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y \
    unzip \
    git \
    libzip-dev \
    && docker-php-ext-install zip pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installer les dépendances de l'application
RUN composer install --no-interaction --optimize-autoloader

# Exposer le port 8000 (ou le port que votre application utilise)
EXPOSE 8181

# Commande pour exécuter l'application
CMD php artisan serve --host=0.0.0.0 --port 8181
