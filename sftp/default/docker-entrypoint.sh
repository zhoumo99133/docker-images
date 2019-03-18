#!/bin/ash

if [ "$1" = '/usr/sbin/sshd' ]; then

    addgroup -g ${UID} -S ${USER}
    adduser -u ${UID} -H -s /sbin/nologin -D -G ${USER} ${USER}

    sed -i 's/^Subsystem/#Subsystem/' /etc/ssh/sshd_config
    sed -i '/^#Subsystem/ i Subsystem sftp internal-sftp' /etc/ssh/sshd_config
    sed -i '/^#Subsystem/ i Match User ${USER}' /etc/ssh/sshd_config
    sed -i '/^#Subsystem/ i \    ChrootDirectory /sftp' /etc/ssh/sshd_config
    sed -i '/^#Subsystem/ i \    AllowTcpForwarding no' /etc/ssh/sshd_config
    sed -i '/^#Subsystem/ i \    X11Forwarding no' /etc/ssh/sshd_config
    sed -i '/^#Subsystem/ i \    ForceCommand internal-sftp' /etc/ssh/sshd_config


    echo -e ${USER}:${PASS} | chpasswd

fi

exec "$@"
