#!/usr/bin/env bash
pushd `dirname $0` > /dev/null
DIRNAME=`pwd -P`

# This directory is available from within each Deadline slave
export SHARE=$DIRNAME/share

# Default image used with Docker Compose, defaults to a vanilla session
# You can override the image by setting an environment variable.
# $ export IMAGE=deadline-client-maya2017
# $ ./up
export IMAGE=${IMAGE:-deadline10-client}
#export DEADLINE-IMAGE=${IMAGE:-deadline10-client}
#export MAYA_DEADLINE_IMAGE=${IMAGE:-deadline-client-maya2020}

# Workaround to start ipv6 network in a docker compose like way
# https://stackoverflow.com/questions/55737196/how-to-enable-ipv6-in-docker-compose-version-3


docker network create --driver bridge --ipv6 --subnet fd15:555::/64 --subnet 172.16.238.0/24 docker-deadline_dockernet  --attachable

# Set installer path for OSX and Linux differently
if [[ $(uname -s) == "Darwin" ]]; then
	export DOCKER_HOST_DOCKER_DEADLINE_INSTALLER_PATH="/Volumes/disk1/george-s/playpen/dev/docker-deadline/installers"
elif [[ $(uname -s) == "Linux" ]]; then
	export DOCKER_HOST_DOCKER_DEADLINE_INSTALLER_PATH="/disk1/george-s/playpen/dev/docker-deadline/installers"
else
	exit "unknown host os"
fi


# Set scripts path for OSX and Linux differently
if [[ $(uname -s) == "Darwin" ]]; then
	export DOCKER_HOST_DOCKER_DEADLINE_SCRIPTS_PATH="/Volumes/disk1/george-s/playpen/dev/docker-deadline/scripts"
elif [[ $(uname -s) == "Linux" ]]; then
	export DOCKER_HOST_DOCKER_DEADLINE_SCRIPTS_PATH="/disk1/george-s/playpen/dev/docker-deadline/scripts"
else
	exit "unknown host os"
fi

docker-compose up

popd > /dev/null