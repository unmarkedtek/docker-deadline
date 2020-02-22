#!/usr/bin/env bash
#
# Copy the Deadline Repository into an internal Docker volume
#
docker run -ti --rm \
	-v /Volumes/disk1/george-s/playpen/dev/docker-deadline/installers:/installers \
	-v deadline-volume:/installdir \
	-w /installers \
	centos:7 bash -c "
		echo Installing Deadline Repository 10.0 into deadline-volume..;\
		./DeadlineRepository-10.*-linux-x64-installer.run \
	    --mode unattended \
	    --dbhost mongo \
	    --dbport 27017 \
	    --prefix /installdir \
	    --installmongodb false \
		--network=host \
	    --prepackagedDB false; \
	echo Finished successfully"
