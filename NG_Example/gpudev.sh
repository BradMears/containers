#!/bin/bash
# Start the GPU development container

#docker run -it -v ${HOME}:${HOME}  \
#           -h brads-gpudev gpudev-container:latest

#           -v ${HOME}:/home/developer -v ${HOME}:${HOME} \
#export UID=$(id -u)
export GID=$(id -g)
docker run --rm -it \
           -h gpudev \
           -e USER=${USER} \
           -e HOME=${HOME} \
           --user=${UID}:${GID} \
           --workdir=${HOME} \
           --volume=${HOME}:${HOME} \
           gpudev-image bash


#PREFERRED_NAME=bmears
#docker run -it -u ${UID}:`id -g` -e USER=${PREFERRED_NAME} -e HOME=/home/developer \
#            -v ${HOME}:/home/developer -v ${HOME}:${HOME} \
#           --rm -h ${USER}-gpudev gpudev-container:latest bash

#docker run -it -u ${UID}:`id -g` -e USER=${USER} -e HOME=/home/developer \
#       -v ${HOME}:/home/developer -v ${HOME}:${HOME} \
#       --rm -h ${USER}-gpudev gpudev-container:latest