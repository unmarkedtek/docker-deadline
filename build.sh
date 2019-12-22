#!/usr/bin/env bash
docker build -f deadline10.Dockerfile -t deadline10-client .
docker build -f maya2020.Dockerfile -t deadline-client-maya2020 .
