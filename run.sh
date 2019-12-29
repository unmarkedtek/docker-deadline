#
# run.sh is used by deadlinemonitor and deadlinewebservice
#

# Add docker host ip to access control list 
if [[ $(uname -s) == "Darwin" ]]; then
	ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2)
elif [[ $(uname -s) == "Linux" ]]; then
	ip=$(hostname -i)
else
	exit "unknown host os"
fi
xhost + $ip



NAME=$1
EXECUTABLE=$2

docker run -ti --rm \
	--name $NAME \
	-h $NAME \
    -e DISPLAY=$ip:0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
  	-v deadline-volume:/mnt/DeadlineRepository10 \
	-v /Volumes/disk1/george-s/playpen/dev/docker-deadline/share:/share  \
	--network="docker-deadline_default" \
	--entrypoint $EXECUTABLE \
	deadline10-client
	
	
# gui example
#docker run -d --name firefox -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix jess/firefox
