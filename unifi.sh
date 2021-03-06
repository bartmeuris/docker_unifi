#!/bin/bash

if [ "$(ls /var/lib/unifi | wc -l)" -eq 0 ]; then
	echo "Copying original data..."
	[ -d "/usr/lib/unifi/data_orig" ] && cp -R /usr/lib/unifi/data_orig/* /usr/lib/unifi/data/
fi

echo "Fixing permissions..."
chown -R ${UNIFI_USER:-unifi} /var/lib/unifi/
chmod -R u+Xwr,g+Xwr,o+Xr /var/lib/unifi/ /usr/lib/unifi/
echo "Starting Unifi controller..."
cd /usr/lib/unifi
exec su --preserve-environment --command "/usr/bin/java -Xmx${JAVA_XMX:-1024M} -jar /usr/lib/unifi/lib/ace.jar $*" ${UNIFI_USER:-unifi}
