#!/bin/bash

export UID
export GID=`id -g`
export PWD
export DISPLAY
export PULSE_SERVER=unix:/run/user/1000/pulse/native

xhost +"local:docker@"

docker compose run -it --rm -e REAL_HOST=${HOSTNAME} --name openscad openscad
#docker compose up -d
