FROM alpine:3.12
MAINTAINER Bastian de Byl <bastian@bdebyl.net>

RUN apk -v --update add imagemagick

RUN rm /var/cache/apk/*

COPY thumbr.sh /usr/bin
RUN chmod +x /usr/bin/thumbr.sh

WORKDIR /src
VOLUME /src

ENTRYPOINT ["thumbr.sh"]
