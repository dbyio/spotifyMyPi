FROM arm32v7/alpine:latest

LABEL maintainer="np@bitbox.io"

RUN apk update && apk add --no-cache libc6-compat libgcc curl alsa-lib libvorbis && \
	RUN apk add --no-cache libc6-compat libgcc curl alsa-lib libvorbis && \
	curl -L `curl --silent https://api.github.com/repos/spotifyd/spotifyd/releases/latest | \
	/usr/bin/awk '/browser_download_url/ { print $2 }' | \
	egrep "armv6.*tar.gz" | /bin/sed 's/"//g'` > /tmp/spotifyd.tgz && \
	cd /usr/bin && tar -xzf /tmp/spotifyd.tgz && rm /tmp/spotifyd.tgz && \
	apk del curl
RUN addgroup daemon audio

USER daemon
ENTRYPOINT ["/usr/bin/spotifyd", "--no-daemon"]
