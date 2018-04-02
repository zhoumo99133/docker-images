#FROM php:7.2-fpm-alpine3.7
FROM php:7.1-fpm-alpine3.4

MAINTAINER dishuostecli "dishuostec@gmail.com"

RUN ver=$(cat /etc/alpine-release | awk -F '.' '{printf "%s.%s", $1, $2;}') \
    && repos=/etc/apk/repositories \
        && mv -f ${repos} ${repos}_bk \
    && echo "https://mirrors.ustc.edu.cn/alpine/v${ver}/main" > ${repos} \
    && echo "https://mirrors.ustc.edu.cn/alpine/v${ver}/community" >> ${repos} \
    && apk add --no-cache --virtual .tz tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
    && apk del .tz \
    && apk add --no-cache \
        tzdata \
        freetype-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmcrypt \
        gettext-dev \
        libintl \
        icu-dev \
        libxml2-dev \
    && nproc=$(getconf _NPROCESSORS_ONLN) \
    && docker-php-ext-install -j${nproc} \
        gettext \
        intl \
        mcrypt \
        mysqli \
        pdo_mysql \
        xmlrpc \
        zip \
        opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j${nproc} gd

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        m4 \
        autoconf \
        openssl-dev \
    && pecl install mongodb \
    && pecl install redis \
    && docker-php-ext-enable mongodb redis \
    && rm -rf /tmp/* \
    \
    && curl -fsSL "https://github.com/phalcon/cphalcon/archive/v3.3.1.tar.gz" -o phalcon.tar.gz \
    && mkdir -p /tmp/phalcon \
    && tar -xf phalcon.tar.gz -C /tmp/phalcon --strip-components=1 \
    && rm phalcon.tar.gz \
    && cd /tmp/phalcon/build \
    && sh install \
    && cd /var/www/html \
    && rm -r /tmp/phalcon \
    && docker-php-ext-enable phalcon \
    && apk del .build-deps

