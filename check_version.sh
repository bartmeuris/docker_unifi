#!/bin/bash

#UNIFI_VERSION_URL="http://dl-origin.ubnt.com/unifi/debian/dists/unifi5/ubiquiti/binary-amd64/Packages"

echo "You can provide a repository as the first parameter. Possible options are:"
echo " - oldstable (unifi-5.4)"
echo " - stable (unifi-5.5) - Default"
echo " - testing (unifi-5.6)"

UNIFI_REPO=${1:-stable}
UNIFI_VERSION_URL="http://dl.ubnt.com/unifi/debian/dists/${UNIFI_REPO}/ubiquiti/binary-amd64/Packages"
UNIFI_VERSION=$(wget -q  -O - ${UNIFI_VERSION_URL}  | grep "^Version: " | sed -e 's/.*: \(.*\)$/\1/')
SDIR=$(dirname $0)

GIT_BRANCH="v${UNIFI_VERSION}"
if [ "${UNIFI_REPO}" != "stable" ]; then
	GIT_BRANCH="${GIT_BRANCH}-${UNIFI_REPO}"
fi

if git branch -a -q | grep -q "${GIT_BRANCH}"; then
	echo "Branch ${GIT_BRANCH} for version ${UNIFI_VERSION} in ${UNIFI_REPO} repository already exist - skipping"
	exit 0
fi
# Get current values from the Dockerfile
UNIFI_DOCKER_REPO=$(cat ${SDIR}/Dockerfile | grep "^ARG UNIFI_REPO=" | sed -e 's/^ARG UNIFI_REPO="\(.*\)"$/\1/')
UNIFI_DOCKER_VERSION=$(cat ${SDIR}/Dockerfile | grep "^ARG UNIFI_VERSION=" | sed -e 's/^ARG UNIFI_VERSION="\(.*\)"$/\1/')

if [ "${UNIFI_DOCKER_REPO}:${UNIFI_DOCKER_VERSION}" != "${UNIFI_REPO}:${UNIFI_VERSION}" ]; then
	echo "New version: ${UNIFI_VERSION} (from ${UNIFI_REPO} repository)"
	echo "Old version: ${UNIFI_DOCKER_VERSION} (from ${UNIFI_DOCKER_REPO} repository)"
	echo "Updating Dockerfile..."
	OLDVER=$(date +%Y%m%d%H%M%S)
	sed --in-place=.${OLDVER} "s/^ARG UNIFI_VERSION=\".*\"$/ARG UNIFI_VERSION=\"${UNIFI_VERSION}\"/;s/^ARG UNIFI_REPO=\".*\"$/ARG UNIFI_REPO=\"${UNIFI_REPO}\"/" Dockerfile
	if ! git branch -a -q | grep -q "${GIT_BRANCH}"; then
		echo "Git branch ${GIT_BRANCH} doesn't exist yet - creating and committing..."
		git branch "${GIT_BRANCH}"
		git checkout "${GIT_BRANCH}"
		git commit Dockerfile -m "Added version ${UNIFI_VERSION} in ${UNIFI_REPO}"
	fi
else
	echo "No new version (latest = ${UNIFI_DOCKER_VERSION} in ${UNIFI_DOCKER_REPO} repository)"
fi
