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

docker-compose up

sleep 30
docker-compose exec deadline-slave1 /opt/Thinkbox/Deadline10/bin/deadlinecommand addpool spot
docker-compose exec deadline-slave1 /opt/Thinkbox/Deadline10/bin/deadlinecommand addgroup spot-fleet
docker-compose exec deadline-slave1 /opt/Thinkbox/Deadline10/bin/deadlinecommand AddPoolToSlave maya-slave1 spot


popd > /dev/null