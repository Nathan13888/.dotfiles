#!/usr/bin/env bash

docker rm -f $(docker ps -a -q)
docker container prune
docker volume prune

docker ps
