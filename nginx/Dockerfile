FROM nginx:1.13-alpine

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
    ## ensure www-data user exists
    # 82 is the standard uid/gid for "www-data" in Alpine
    # http://git.alpinelinux.org/cgit/aports/tree/main/apache2/apache2.pre-install?h=v3.3.2
    # http://git.alpinelinux.org/cgit/aports/tree/main/lighttpd/lighttpd.pre-install?h=v3.3.2
    # http://git.alpinelinux.org/cgit/aports/tree/main/nginx-initscripts/nginx-initscripts.pre-install?h=v3.3.2
    && addgroup -Sg 82 www-data 2>/dev/null \
    && addgroup nginx www-data 2>/dev/null

RUN apt-get update -qq && apt-get install -y geoip-database wget

RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
RUN gunzip GeoIP.dat.gz
RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
RUN gunzip GeoLiteCity.dat.gz

RUN mkdir /etc/nginx/geoip/
RUN mv GeoIP.dat /etc/nginx/geoip/
RUN mv GeoLiteCity.dat /etc/nginx/geoip/