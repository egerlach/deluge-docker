FROM debian:jessie

ENV GOSU_VERSION=1.10 \
    DELUGE_VERSION="1.3.13+git20161130.48cedf63-1" \
    DELUGE_USER_ID=1000 \
    DELUGE_GROUP_ID=1000

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y \
        deluge-common \
        deluged \
        jq \
        moreutils \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /tmp/deluge-common.deb "http://deb.debian.org/debian/pool/main/d/deluge/deluge-common_${DELUGE_VERSION}_all.deb" \
    && wget -O /tmp/deluged.deb "http://deb.debian.org/debian/pool/main/d/deluge/deluged_${DELUGE_VERSION}_all.deb" \
    && dpkg -i /tmp/deluge-common.deb /tmp/deluged.deb \
    && rm /tmp/deluge-common.deb /tmp/deluged.deb \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

COPY start.sh /
COPY core.conf /

VOLUME "/var/lib/deluged/config"
VOLUME "/srv"

EXPOSE 32395 58846
CMD ["/bin/bash", "/start.sh"]
