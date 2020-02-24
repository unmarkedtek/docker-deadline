#
# run.sh is used by deadlinemonitor and deadlinewebservice
#
#
# generic gui example
#docker run -d --name firefox -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix jess/firefox




# Add docker host ip to access control list 
if [[ $(uname -s) == "Darwin" ]]; then
	ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 10.110 | cut -d\  -f2)
elif [[ $(uname -s) == "Linux" ]]; then
	ip=$(hostname -i)
else
	exit "unknown host os"
fi

xhost + $ip


# Set display for OSX and Linux differently
if [[ $(uname -s) == "Darwin" ]]; then
	display=$ip:0
elif [[ $(uname -s) == "Linux" ]]; then
	display=:0
else
	exit "unknown host os"
fi

# Set volumes for OSX and Linux differently - modify this for your own
if [[ $(uname -s) == "Darwin" ]]; then
	share_volume="/Volumes/disk1/george-s/playpen/dev/docker-deadline/share:/share"
elif [[ $(uname -s) == "Linux" ]]; then
	share_volume="/disk1/george-s/playpen/dev/docker-deadline/share:/share"
else
	exit "unknown host os"
fi


# Set the container name and the executable from the wrapper script
NAME=$1
EXECUTABLE=$2

# Run the container on osx or Linux docker host
docker run -ti --rm \
	--name $NAME \
	-h $NAME \
	-e DISPLAY=$display \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v deadline-volume:/mnt/DeadlineRepository10 \
	-v $share_volume  \
	-v deadline-samba:/share2 \
	--network="docker-deadline_dockernet" \
	--entrypoint $EXECUTABLE \
	deadline10-client
#--network="docker-deadline_default" \

