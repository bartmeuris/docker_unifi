#!/bin/bash

if [ "$(ls /var/lib/unifi | wc -l)" -eq 0 ]; then
	echo "Copying original data..."
	[ -d "/usr/lib/unifi/data_orig" ] && cp -R /usr/lib/unifi/data_orig/* /usr/lib/unifi/data/
fi

echo "Creating directories..."
mkdir -p /var/lib/unifi/
mkdir -p /var/lib/unifi/logs
mkdir -p /var/lib/unifi/run

echo "Fixing permissions..."
chown -R ${UNIFI_USER:-unifi}:${UNIFI_USER:-unifi} /var/lib/unifi/
chown -R ${UNIFI_USER:-unifi}:${UNIFI_USER:-unifi} /usr/lib/unifi/
chmod -R 0664 /var/lib/unifi/*
echo "Starting Unifi controller..."
exec su --preserve-environment --command "/usr/bin/java -Xmx${JAVA_XMX:-1024M} -jar /usr/lib/unifi/lib/ace.jar $*" ${UNIFI_USER:-unifi}
