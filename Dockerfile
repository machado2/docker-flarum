FROM composer/composer as composer
WORKDIR /app
RUN composer create-project flarum/flarum
RUN composer require fof/upload
RUN composer require fof/formatting:"*"
RUN composer require fof/links
RUN composer require fof/user-bio:"*"
RUN composer require fof/polls
RUN composer require fof/pages
RUN composer require fof/user-directory:"*"
RUN composer require fof/follow-tags:"*"
RUN composer require fof/profile-image-crop:"*"
RUN composer require fof/nightmode:"*"
RUN composer require fof/byobu:"*"
RUN composer require fof/reactions:"*"
RUN composer require fof/merge-discussions:"*"
RUN composer require fof/split:"*"
RUN composer require fof/drafts:"*"
RUN composer require fof/sitemap
RUN composer require fof/gamification
RUN composer require fof/analytics:*
RUN composer require fof/default-user-preferences:"*"
RUN composer require fof/moderator-notes:"*"
RUN composer require fof/oauth
RUN composer require fof/forum-statistics-widget:"*"
RUN composer require fof/share-social
RUN composer require fof/frontpage
RUN composer require fof/filter:"*"
RUN composer require fof/webhooks
RUN composer require fof/bbcode-details
RUN composer require fof/secure-https:"*"
RUN composer require fof/bbcode-tabs:"*"
RUN composer require fof/passport:*
RUN composer require fof/discussion-thumbnail:"*"
RUN composer require "fof/auth-discord:*"

FROM php:8.1-apache
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
RUN docker-php-ext-install exif;
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY --from=composer /app/flarum /app/flarum
COPY flarum.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite
VOLUME ["/var/www/flarum"]
WORKDIR /var/www/flarum
COPY entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh