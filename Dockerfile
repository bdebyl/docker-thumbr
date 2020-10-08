FROM alpine:latest
MAINTAINER Bastian de Byl <bastian@bdebyl.net>

RUN apk -v --update add \
    imagemagick \
    file \
    && rm /var/cache/apk/*

COPY thumbr.sh /usr/bin
RUN chmod +x /usr/bin/thumbr.sh

WORKDIR /src
VOLUME ["/src"]

ENTRYPOINT ["thumbr.sh"]
