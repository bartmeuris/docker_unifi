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
git checkout master
if git branch -a -q | grep -q "${GIT_BRANCH}"; then
	echo "Branch ${GIT_BRANCH} for version ${UNIFI_VERSION} in ${UNIFI_REPO} repository already exist"
	if [ "${2}" != "force" ]; then
		echo "Skipping"
		exit 0
	fi
	echo "Doing a forced update..."
fi

echo "Updating Dockerfile to version ${UNIFI_VERSION} from ${UNIFI_REPO} repo..."
OLDVER=$(date +%Y%m%d%H%M%S)
if ! git branch -a -q | grep -q "${GIT_BRANCH}"; then
	git branch --track "${GIT_BRANCH}"
fi
sed --in-place=.${OLDVER} "s/^ARG UNIFI_VERSION=\".*\"$/ARG UNIFI_VERSION=\"${UNIFI_VERSION}\"/;s/^ARG UNIFI_REPO=\".*\"$/ARG UNIFI_REPO=\"${UNIFI_REPO}\"/" Dockerfile
git checkout "${GIT_BRANCH}"
git commit Dockerfile -m "Added version ${UNIFI_VERSION} from ${UNIFI_REPO} repo"
