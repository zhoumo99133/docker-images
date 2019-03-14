FROM alpine:latest
MAINTAINER dishuostecli "dishuostec@gmail.com"
USER 1000:1000
RUN apk --no-cache add aria2 \
    && mkdir /home/aria2 \
    && mkdir /home/aria2/download \
    && chown 1000.1000 -R /home/aria2 \
    && addgroup -g 1000 -S aria2 2>/dev/null \
    && adduser -u 1000 -h /home/aria2 -s /sbin/nologin -D -G aria2 aria2
ENTRYPOINT aria2c
CMD -h
