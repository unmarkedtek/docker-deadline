#!/usr/bin/env bash
#
# Copy the Deadline Repository into an internal Docker volume


# installers_host_path is the location for installers on docker host
# nfs_deadline_volume_server_path is path of the existing nfs share
#  modify this for your ownpaths
if [[ $(uname -s) == "Linux" ]]; then
	installers_host_path="/disk1/george-s/playpen/dev/docker-deadline/installers"
	nfs_server_path="/disk1/george-s/playpen/dev/docker-deadline/nfs-deadline-volume"
elif [[ $(uname -s) == "Darwin" ]]; then
    /disk1/george-s/playpen/dev/docker-deadline/installers
	installers_host_path="/Volumes/disk1/george-s/playpen/dev/docker-deadline/installers"
	nfs_server_path="/Volumes/disk1/george-s/playpen/dev/docker-deadline/nfs-deadline-volume"
else
	exit "unknown host os"
fi

# Create docker NFS volume called nfs-deadline-volume 
docker volume create --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.0.64,rw \
    --opt device=:$nfs_server_path \
    nfs-deadline-volume

docker run -ti --rm \
	-v $installers_host_path:/installers" \
	--mount source=nfs-deadline-volume,target=/installdir \
	-w /installers \
	centos:7 bash -c "
		echo Installing Deadline Repository 10.0 into nfs-deadline-volume..;\
		./DeadlineRepository-10.*-linux-x64-installer.run \
	    --mode unattended \
	    --dbhost mongo \
	    --dbport 27017 \
	    --prefix /installdir \
	    --installmongodb false \
	    --prepackagedDB false; \
	echo Finished successfully"