FROM alpine:latest

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
    && apk add --no-cache minidlna \
    && rm -rf /usr/share/man/man5/minidlna.* \
    && rm -rf /usr/share/man/man8/minidlna.*

EXPOSE 1900/udp
EXPOSE 8200/tcp

CMD ["minidlnad", "-d"]
