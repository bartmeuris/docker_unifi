#!/bin/bash

UNIFI_VERSION_URL="http://dl-origin.ubnt.com/unifi/debian/dists/unifi5/ubiquiti/binary-amd64/Packages"
UNIFI_CHECK_VERSION=$(wget -q  -O - ${UNIFI_VERSION_URL}  | grep "^Version: " | sed -e 's/.*: \(.*\)$/\1/')
SDIR=$(dirname $0)

#. ${SDIR}/unifi_version.env

UNIFI_VERSION=$(cat ${SDIR}/Dockerfile | grep "^ARG UNIFI_VERSION=" | sed -e 's/^ARG UNIFI_VERSION="\(.*\)"$/\1/')

if [ "${UNIFI_VERSION}" != "${UNIFI_CHECK_VERSION}" ]; then
	echo "New version: ${UNIFI_CHECK_VERSION}"
	echo "Old version: ${UNIFI_VERSION}"
	echo "Updating Dockerfile..."
	OLDVER=$(date +%Y%m%d%H%M%S)
	sed --in-place=.${OLDVER} "s/^ARG UNIFI_VERSION=\".*\"$/ARG UNIFI_VERSION=\"${UNIFI_CHECK_VERSION}\"/" Dockerfile
else
	echo "No new version (latest = ${UNIFI_VERSION})"
fi
