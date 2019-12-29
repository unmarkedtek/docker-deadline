#!/usr/bin/env bash

docker build -f centos7-base-server.Dockerfile -t centos7-base-server .
docker build -f deadline10-client.Dockerfile -t deadline10-client .
docker build -f deadline10-client-maya2019.Dockerfile -t deadline10-client-maya2019 .

# for newer deadline with maya 2020 
#docker build -f maya2020.Dockerfile -t deadline-client-maya2020 .
