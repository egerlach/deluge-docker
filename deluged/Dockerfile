FROM debian:jessie

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
        deluge-common \
        deluged \
        jq \
        moreutils

COPY start.sh /

USER debian-deluged
COPY core.conf /var/lib/deluged/config

VOLUME "/var/lib/deluged/config"

EXPOSE 32395 58846
CMD ["/bin/bash", "/start.sh"]
