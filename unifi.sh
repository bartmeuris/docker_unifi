#!/bin/bash

if [ "$(ls /var/lib/unifi | wc -l)" -eq 0 ]; then
	cp -R /usr/lib/unifi/data_orig /usr/lib/unifi/data
fi

chown -R ${UNIFI_USER:-unifi}:${UNIFI_USER:-unifi} /var/lib/unifi/
exec su --preserve-environment --command "/usr/bin/java -Xmx${JAVA_XMX:-1024M} -jar /usr/lib/unifi/lib/ace.jar $*" ${UNIFI_USER:-unifi}