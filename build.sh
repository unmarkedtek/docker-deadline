#!/usr/bin/env bash
docker build -f maya2019-base-centos7.Dockerfile -t maya2019-base-centos7 .
docker build -f deadline10.Dockerfile -t deadline10-client .
docker build -f maya2019.Dockerfile -t deadline-client-maya2019 .

# for newer deadline with maya 2020 
#docker build -f maya2020.Dockerfile -t deadline-client-maya2020 .
