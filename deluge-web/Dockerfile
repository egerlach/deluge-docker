FROM debian:jessie

RUN apt-get update && apt-get install -y \
	deluge-common
RUN apt-get install -y \
	deluge-web
EXPOSE 8112
ENTRYPOINT ["deluge-web"]
CMD ["-Ldebug"]

