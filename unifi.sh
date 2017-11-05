#!/bin/bash

if [ "$(ls /var/lib/unifi | wc -l)" -eq 0 ]; then
	[ -d "/usr/lib/unifi/data_orig" ] && cp -R /usr/lib/unifi/data_orig /usr/lib/unifi/data
fi

mkdir -p /var/lib/unifi/logs
mkdir -p /var/lib/unifi/run
mkdir -p /var/lib/unifi/data

chown -R ${UNIFI_USER:-unifi}:${UNIFI_USER:-unifi} /var/lib/unifi/
chown -R ${UNIFI_USER:-unifi}:${UNIFI_USER:-unifi} /usr/lib/unifi/
exec su --preserve-environment --command "/usr/bin/java -Xmx${JAVA_XMX:-1024M} -jar /usr/lib/unifi/lib/ace.jar $*" ${UNIFI_USER:-unifi}
