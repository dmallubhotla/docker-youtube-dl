FROM alpine:3.12

# https://github.com/Yelp/dumb-init/releases
ARG DUMB_INIT_VERSION=1.2.2

RUN set -x \
 && apk add --no-cache \
        ca-certificates \
        curl \
        dumb-init \
        ffmpeg \
        gnupg \
        python3 \
 && curl -Lo /usr/local/bin/youtube-dl https://github.com/yt-dlp/yt-dlp/releases/download/2024.11.18/yt-dlp \
 && gpg --keyserver keyserver.ubuntu.com --recv-keys '7D33D762FD6C35130481347FDB4B54CBA4826A18' \
 && gpg --keyserver keyserver.ubuntu.com --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' \
 && chmod a+rx /usr/local/bin/youtube-dl \
    # Requires python -> python3.
 && ln -s /usr/bin/python3 /usr/bin/python \
    # Clean-up
 && apk del curl gnupg \
    # Create directory to hold downloads.
 && mkdir /.cache \
 && chmod 777 /.cache

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Basic check.
RUN dumb-init youtube-dl --version

ENTRYPOINT ["dumb-init", "youtube-dl"]
CMD ["--help"]
