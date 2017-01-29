FROM debian:jessie

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
        deluge-common \
        deluge-web \
        jq \
        moreutils

COPY entrypoint.sh /
COPY hostlist.conf.1.2 /
COPY web.conf /

VOLUME "/var/lib/deluged/web-config"

EXPOSE 8112

CMD ["/bin/bash", "/entrypoint.sh"]

