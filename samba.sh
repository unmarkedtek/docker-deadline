#!/usr/bin/env bash

docker network create --driver bridge --ipv6 --subnet fd15:555::/64 --subnet 172.16.238.0/24 docker-deadline_dockernet  --attachable

# Set volumes for OSX and Linux differently - modify this for your own
if [[ $(uname -s) == "Darwin" ]]; then
	installers_volume="/Volumes/disk1/george-s/playpen/dev/docker-deadline/installers:/installers"
elif [[ $(uname -s) == "Linux" ]]; then
	installers_volume="/disk1/george-s/playpen/dev/docker-deadline/installers:/installers"
else
	exit "unknown host os"
fi

# Share repository and installers folder via samba server - expose port on docker host
docker run \
	-ti \
	--rm \
	-p 139:139 \
	-p 445:445 \
	--name deadline-samba \
	-v deadline-volume:/share \
	-v ${installers_volume} \
	-d dperson/samba -p \
	-s "DeadlineRepository10;/share;yes;no;yes;all;none;all" \
	-s "Deadline10installers;/installers;yes;no;yes;all;none;all" \

#-s "DeadlineRepository10;/share;yes;no;yes;all;none;all" \