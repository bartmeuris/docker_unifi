FROM ubuntu:16.04
MAINTAINER Bart Meuris <bart.meuris@gmail.com>

# Based on: https://github.com/jacobalberty/unifi-docker/tree/master/unifi4

# See https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu
ARG UNIFI_REPO="stable"

RUN echo "deb deb http://www.ubnt.com/downloads/unifi/debian ${UNIFI_REPO} ubiquiti" /etc/apt/sources.list.d/20ubiquiti.list &&\
    echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > /etc/apt/sources.list.d/21mongodb.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10


# For the latest version, see:
#  http://dl-origin.ubnt.com/unifi/debian/dists/unifi5/ubiquiti/binary-amd64/Packages
ARG UNIFI_VERSION="5.5.24-9806"
#ARG UNIFI_VERSION="5.5.24-9806"

ENV UNIFI_USER unifi

RUN    apt-get -q update \
    && apt-get install --no-install-recommends -qy default-jre-headless unifi=${UNIFI_VERSION} \
    && apt-get -q clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN    useradd -d /var/lib/unifi ${UNIFI_USER} \
    && mkdir -p /var/lib/unifi/data /var/lib/unifi/logs /var/lib/unifi/run \
    && [ -f /usr/lib/unifi/data ] && cp -R /usr/lib/unifi/data /usr/lib/unifi/data_orig || true \
    && ln -s /var/lib/unifi/data /usr/lib/unifi/data \
    && ln -s /var/lib/unifi/logs /usr/lib/unifi/logs \
    && ln -s /var/lib/unifi/run /usr/lib/unifi/run \
    && chown -R ${UNIFI_USER}:${UNIFI_USER} /usr/lib/unifi /var/lib/unifi


WORKDIR /var/lib/unifi
# https://community.ubnt.com/t5/UniFi-Frequently-Asked-Questions/UniFi-What-are-the-default-ports-used-by-UniFi/ta-p/412439
EXPOSE 6789/tcp 8843/tcp 8880/tcp 8080/tcp 8443/tcp 3478/udp 10001/udp
VOLUME ["/var/lib/unifi"]

ADD unifi.sh /unifi.sh
RUN chmod a+x /unifi.sh
#ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
ENTRYPOINT ["/unifi.sh"]
CMD ["start"]

