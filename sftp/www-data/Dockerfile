FROM alpine:3.7

LABEL maintainer="dishuostec <dishuostec@gmail.com>"

ARG ALPINE_REPO=http://dl-cdn.alpinelinux.org

ENV PASS=xxxxxxxx

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
    && chmod 755 /sftp \
# 82 is the standard uid/gid for "www-data" in Alpine
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -h /sftp/app -s /sbin/nologin -D -G www-data www-data \
    \
    && sed -i 's/^Subsystem/#Subsystem/' /etc/ssh/sshd_config \
    && sed -i '/^#Subsystem/ i Subsystem sftp internal-sftp' /etc/ssh/sshd_config \
    && sed -i '/^#Subsystem/ i Match User www-data' /etc/ssh/sshd_config \
    && sed -i '/^#Subsystem/ i \    ChrootDirectory /sftp' /etc/ssh/sshd_config \
    && sed -i '/^#Subsystem/ i \    AllowTcpForwarding no' /etc/ssh/sshd_config \
    && sed -i '/^#Subsystem/ i \    X11Forwarding no' /etc/ssh/sshd_config \
    && sed -i '/^#Subsystem/ i \    ForceCommand internal-sftp' /etc/ssh/sshd_config

EXPOSE 22

CMD ["ash", "-c", "echo -e www-data:${PASS} | chpasswd; /usr/sbin/sshd -D -E /dev/stderr"]
