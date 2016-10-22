FROM debian:jessie

RUN apt-get update && apt-get install -y \
	deluge-common
RUN apt-get install -y \
	deluged
EXPOSE 32395 58846
ENTRYPOINT ["deluged"]
CMD ["-d", "-Ldebug"]
