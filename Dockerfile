FROM alpine:3

ENV TZ "UTC"
ENV ENABLE_V6 "no"
ENV HOSTS "public:localhost"
ENV USERID "100"
ENV GROUPID "101"
ENV REGENERATEHTML "yes"
ENV INDEXMAKEROPTIONS ""

RUN apk add --update --no-cache \
      bash \
      dcron \
      font-space-mono-nerd \
      lighttpd \
      mrtg \
      net-snmp-tools \
      perl-cgi \
      perl-rrd \
      rrdtool \
      rrdtool-cgi \
      shadow \
      tzdata

RUN apk upgrade --no-cache \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/mrtg/conf.d \
    && mkdir -p /mrtg/cgi-bin /mrtg/html /mrtg/fonts

COPY files/mrtg.sh /usr/sbin/mrtg.sh
COPY files/mrtg.cron /etc/crontabs/root
COPY files/14all.cgi /mrtg/cgi-bin/14all.cgi
COPY files/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY files/mrtg.cfg /etc/mrtg/mrtg.cfg
COPY files/opensans.ttf /mrtg/fonts/opensans.ttf
COPY files/icons /mrtg/icons

CMD ["/usr/sbin/mrtg.sh"]

ARG BUILD_DATE
ARG VCS_REF
ARG VENDOR
ARG VERSION
ARG AUTHOR

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="MRTG" \
      org.label-schema.description="Multi\ Router\ Traffic\ Grapher." \
      org.label-schema.url="https://fboaventura.dev" \
      org.label-schema.vcs-url="https://github.com/haotseng/dckr-mrtg" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="$VENDOR" \
      org.label-schema.version="$VERSION" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.author="$AUTHOR" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT"
