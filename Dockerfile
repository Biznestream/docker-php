FROM php:7.1-apache

RUN usermod -u 1000 www-data
RUN a2enmod rewrite
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libicu-dev \
        libpng-dev \
        gnupg \
        libssl-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) exif

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get -y install nodejs git
RUN npm i -g gulp-cli bower

COPY ./extensions.ini /usr/local/etc/php/conf.d/extensions.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
