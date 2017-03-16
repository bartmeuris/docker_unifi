FROM ubuntu:14.04
MAINTAINER Bart Meuris <bart.meuris@gmail.com>

# Based on: https://github.com/jacobalberty/unifi-docker/tree/master/unifi4

# See https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu
RUN echo "deb http://www.ubnt.com/downloads/unifi/debian unifi5  ubiquiti"  > /etc/apt/sources.list.d/20ubiquiti.list &&\
    echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > /etc/apt/sources.list.d/21mongodb.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

RUN apt-get -q update &&\
    apt-get install --no-install-recommends -qy --force-yes execstack default-jre-headless unifi=5.4.11-9184 &&\
    execstack -c /usr/lib/unifi/lib/native/Linux/amd64/libubnt_webrtc_jni.so &&\
    apt-get -q clean && rm -rf /var/lib/apt/lists/* &&\
    useradd -d /var/lib/unifi unifi &&\
    mkdir -p /var/lib/unifi /var/log/unifi /var/run/unifi &&\
    chown -R unifi:unifi /usr/lib/unifi /var/lib/unifi /var/log/unifi /var/run/unifi &&\
    ln -s /var/lib/unifi /usr/lib/unifi/data &&\
    cp -R /usr/lib/unifi/data /usr/lib/unifi/data_orig

#USER unifi
ENV UNIFI_USER unifi

WORKDIR /var/lib/unifi
# https://community.ubnt.com/t5/UniFi-Frequently-Asked-Questions/UniFi-What-are-the-default-ports-used-by-UniFi/ta-p/412439
EXPOSE 6789/tcp 8843/tcp 8880/tcp 8080/tcp 8443/tcp 3478/udp 10001/udp
VOLUME ["/var/lib/unifi"]

ADD unifi.sh /unifi.sh
RUN chmod a+x /unifi.sh
#ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
ENTRYPOINT ["/unifi.sh"]
CMD ["start"]

