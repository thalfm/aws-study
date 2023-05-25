FROM php:8.0.2-fpm-alpine3.12

RUN apk add --update --no-cache libintl icu icu-dev libxml2-dev zip libzip-dev libzip

RUN  docker-php-ext-configure zip \
    && docker-php-ext-install mysqli pdo pdo_mysql xml zip \
    && docker-php-ext-enable pdo_mysql

ADD . /var/www
WORKDIR /var/www

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN composer install --no-interaction --verbose --no-dev --no-scripts

#ENTRYPOINT ["tail", "-f", "/dev/null"] #comment to run in ecs
