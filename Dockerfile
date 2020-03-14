FROM arm32v7/debian:stable-slim

LABEL maintainer="np@bitbox.io"

RUN apt-get -qq update && apt-get -qq upgrade && apt-get -qq install locales curl libasound2 libvorbisfile3 && \
	rm -rf /var/lib/apt/lists/* && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN curl -L `curl --silent https://api.github.com/repos/spotifyd/spotifyd/releases/latest | /usr/bin/awk '/browser_download_url/ { print $2 }'|egrep "armv6.*tar.gz"|/bin/sed 's/"//g'` > /tmp/spotifyd.tgz && \
	cd /usr/bin && tar -xzf /tmp/spotifyd.tgz && rm /tmp/spotifyd.tgz && \
	apt-get -qq purge curl && apt-get clean && \
	usermod -a -G audio daemon

USER daemon
ENTRYPOINT ["/usr/bin/spotifyd", "--no-daemon", "-c", "/etc/spotifyd/spotifyd.conf"]