#!/usr/bin/env bash


docker network create --driver bridge --ipv6 --subnet fd15:555::/64 --subnet 172.16.238.0/24 docker-deadline_dockernet  --attachable


# docker run \
# 	-ti \
# 	--rm \
# 	-p 139:139 \
# 	-p 445:445 \
# 	--name deadline-samba \
# 	-v deadline-volume:/share \
# 	-d dperson/samba -p \
# 	-u "example;badpass" \
# 	-w "DEV"
# 	-s "users;/srv;no;no;no;example" \
# 	-s "DeadlineRepository10;/share;yes;no;yes;all;none;all" \
		
# docker run -it -p 139:139 -p 445:445 --name deadline-samba -d dperson/samba -p \
# 			-w "DEV" \
# 			-u "example1;badpass" \
#             -u "example2;badpass" \
#             -s "DeadlineRepository10;/share;yes;no;yes;all;none;all" \
# 			-s "public;/share" \
#             -s "users;/srv;no;no;no;example1,example2" \
#             -s "example1 private share;/example1;no;no;no;example1" \
#             -s "example2 private share;/example2;no;no;no;example2"

docker run \
	-ti \
	--rm \
	-p 139:139 \
	-p 445:445 \
	--name deadline-samba \
	-v deadline-volume:/share \
	-d dperson/samba -p \
	-s "DeadlineRepository10;/share;yes;no;yes;all;none;all" \
