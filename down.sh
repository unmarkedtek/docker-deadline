#!/usr/bin/env bash
pushd `dirname $0` > /dev/null
DIRNAME=`pwd -P`

# This directory is available from within each Deadline slave
export SHARE=$DIRNAME/share

# Default image used with Docker Compose, defaults to a vanilla session
# You can override the image by setting an environment variable.
export IMAGE=${IMAGE:-deadline-client-maya2017}

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

docker-compose down

popd > /dev/null