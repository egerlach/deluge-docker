FROM debian:jessie

RUN apt-get update && apt-get install -y \
	deluge-common deluged jq
EXPOSE 32395 58846
ENTRYPOINT ["deluged"]
CMD ["-d", "-Ldebug"]
