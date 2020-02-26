LINE="/Users -alldirs -mapall=$(id -u):$(id -g) localhost"
FILE=/etc/exports
grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE

LINE="/Volumes/disk1/george-s/playpen/dev/docker-deadline/nfs-deadline-volume -alldirs -mapall=$(id -u):$(id -g) localhost"
FILE=/etc/exports
grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE

LINE="nfs.server.mount.require_resv_port = 0"
FILE=/etc/nfs.conf
grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE > /dev/null

sudo nfsd restart




