FROM alpine:3.7

LABEL maintainer="dishuostec <dishuostec@gmail.com>"

ARG ALPINE_REPO=http://dl-cdn.alpinelinux.org

ENV USER=xxxxxxxx
ENV PASS=xxxxxxxx
ENV UID=1000

RUN ver=$(cat /etc/alpine-release | awk -F '.' '{printf "%s.%s", $1, $2;}') \
    && repos=/etc/apk/repositories \
    && mv -f ${repos} ${repos}_bk \
    && echo "${ALPINE_REPO}/alpine/v${ver}/main" > ${repos} \
    && echo "${ALPINE_REPO}/alpine/v${ver}/community" >> ${repos} \
    && apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
    \
    && apk add --no-cache openssh \
    && ssh-keygen -A \
    && mkdir /sftp \
    && chown root:root /sftp \
    && chmod 755 /sftp

COPY --chown=root:root docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-E", "/dev/stderr"]
