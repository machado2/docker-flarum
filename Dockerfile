FROM composer/composer as composer
WORKDIR /app
RUN composer create-project flarum/flarum

FROM php:apache
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype6-dev \
            libssl-dev \
            libwebp-dev \
            libxpm-dev \
            libmcrypt-dev \
            libonig-dev;
RUN set -eux; \
    docker-php-ext-install pdo_mysql; \
    docker-php-ext-configure gd \
            --prefix=/usr \
            --with-jpeg \
            --with-webp \
            --with-xpm \
            --with-freetype; \
    docker-php-ext-install gd; 

COPY --from=composer /app/flarum /app/flarum
COPY flarum.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite
VOLUME ["/var/www/flarum"]
WORKDIR /var/www/flarum
COPY entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh