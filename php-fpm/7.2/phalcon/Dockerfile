FROM php:7.2-fpm-alpine3.7

MAINTAINER dishuostecli "dishuostec@gmail.com"

ARG ALPINE_REPO=http://dl-cdn.alpinelinux.org

ENV PHALCON_VERSION=3.3.2

RUN ver=$(cat /etc/alpine-release | awk -F '.' '{printf "%s.%s", $1, $2;}') \
    && repos=/etc/apk/repositories \
    && mv -f ${repos} ${repos}_bk \
    && echo "${ALPINE_REPO}/alpine/v${ver}/main" > ${repos} \
    && echo "${ALPINE_REPO}/alpine/v${ver}/community" >> ${repos} \
    && apk add --no-cache --virtual .tz tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
    && apk del .tz \
    && apk add --no-cache \
        tzdata \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        gettext-dev \
        libintl \
        icu-dev \
        libxml2-dev \
    && nproc=$(getconf _NPROCESSORS_ONLN) \
    && docker-php-ext-install -j${nproc} \
        gettext \
        intl \
        mysqli \
        pdo_mysql \
        xmlrpc \
        zip \
        opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j${nproc} gd \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        m4 \
        autoconf \
        openssl-dev \
    && curl -fsSL "https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz" -o phalcon.tar.gz \
    && mkdir -p /tmp/phalcon \
    && tar -xf phalcon.tar.gz -C /tmp/phalcon --strip-components=1 \
    && rm phalcon.tar.gz \
    && cd /tmp/phalcon/build \
    && sh install \
    && cd /var/www/html \
    && rm -r /tmp/phalcon \
    && docker-php-ext-enable phalcon \
    && apk del .build-deps

