FROM php:5.6-fpm-alpine

MAINTAINER dishuostecli "dishuostec@gmail.com"

ARG ALPINE_REPO=http://dl-cdn.alpinelinux.org

RUN ver=$(cat /etc/alpine-release | awk -F '.' '{printf "%s.%s", $1, $2;}') \
    && repos=/etc/apk/repositories \
    && mv -f ${repos} ${repos}_bk \
    && echo "${ALPINE_REPO}/alpine/v${ver}/main" > ${repos} \
    && echo "${ALPINE_REPO}/alpine/v${ver}/community" >> ${repos} \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
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
    && docker-php-ext-install -j${nproc} gd
