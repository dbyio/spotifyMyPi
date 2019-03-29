FROM arm32v7/debian:stretch-slim

LABEL maintainer="np@bitbox.io"

RUN apt-get -qq update && apt-get -qq upgrade && apt-get -qq install curl unzip libasound2 libvorbisfile3 
RUN curl -L `curl --silent https://api.github.com/repos/spotifyd/spotifyd/releases/latest | /usr/bin/awk '/browser_download_url/ { print $2 }' | grep armv6 | /bin/sed 's/"//g'` > /tmp/spotifyd.zip && \
	unzip /tmp/spotifyd.zip -d /usr/bin && rm /tmp/spotifyd.zip && apt-get purge -qq unzip curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN usermod -a -G audio daemon

USER daemon
ENTRYPOINT ["/usr/bin/spotifyd", "--no-daemon", "-c", "/etc/spotifyd/spotifyd.conf"]
