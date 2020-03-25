# Multi-staged build of Spotifyd on Alpine Linux

FROM arm32v7/alpine:latest AS build
WORKDIR /tmp
RUN apk update && apk add alsa-lib libvorbis libgcc openssl-dev alsa-lib-dev rust cargo && \
	wget https://github.com/Spotifyd/spotifyd/archive/master.zip && \
	unzip master.zip && cd spotifyd-master && cargo build --release

FROM arm32v7/alpine:latest
LABEL maintainer="np@bitbox.io"
RUN apk update && apk upgrade && apk add --no-cache alsa-lib libvorbis libgcc && rm -f /var/cache/apk/* && \
	addgroup daemon audio && mkdir /var/cache/spotifyd && chown daemon.audio /var/cache/spotifyd
COPY --from=build /tmp/spotifyd-master/target/release/spotifyd /usr/bin/.
USER daemon
ENTRYPOINT ["/usr/bin/spotifyd", "--no-daemon"]
