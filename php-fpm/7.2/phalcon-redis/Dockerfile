FROM dishuostec/php:7.2-fpm-phalcon

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps
 
