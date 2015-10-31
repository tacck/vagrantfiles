FROM php:5.6-apache
ADD apache2.conf /etc/apache2/apache2.conf
RUN docker-php-ext-install pdo_mysql mysqli mbstring && a2enmod rewrite
