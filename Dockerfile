FROM ubuntu:14.04
MAINTAINER Bart Meuris <bart.meuris@gmail.com>

# Based on: https://github.com/jacobalberty/unifi-docker/tree/master/unifi4

RUN echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti"  > /etc/apt/sources.list.d/20ubiquiti.list &&\
    echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > /etc/apt/sources.list.d/21mongodb.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

RUN apt-get -q update &&\
    apt-get install --no-install-recommends -qy --force-yes default-jre-headless unifi=4.8.15-7440 &&\
    apt-get -q clean && rm -rf /var/lib/apt/lists/* &&\
    useradd -d /var/lib/unifi unifi &&\
    mkdir -p /var/lib/unifi /var/log/unifi /var/run/unifi &&\
    chown -R unifi:unifi /usr/lib/unifi /var/lib/unifi /var/log/unifi /var/run/unifi &&\
    ln -s /var/lib/unifi /usr/lib/unifi/data # Update 2016/02/03

USER unifi
WORKDIR /var/lib/unifi
# https://community.ubnt.com/t5/UniFi-Frequently-Asked-Questions/UniFi-What-are-the-default-ports-used-by-UniFi/ta-p/412439
EXPOSE 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp
VOLUME ["/var/lib/unifi"]

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]

