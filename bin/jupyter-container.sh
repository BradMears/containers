#!/bin/bash

#export UID=$(id -u)
export GID=$(id -g)



docker run -i -t -p 8888:8888 continuumio/anaconda3 /bin/bash -c "\
    conda install jupyter -y --quiet && \
    mkdir -p /opt/notebooks && \
    jupyter notebook \
    --notebook-dir=/opt/notebooks --ip='*' --port=8888 \
    --no-browser --allow-root"

exit

docker run -i -t -p 8888:8888 \
--user $UID:$GID \
--workdir=/home/$USER/containers \
--mount type=volume,src=notebooks,dst=/opt/notebooks/volume \
continuumio/anaconda3 /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && \
mkdir -p /opt/notebooks && /opt/conda/bin/jupyter notebook \
--notebook-dir=/opt/notebooks --ip='*' --port=8888 \
--no-browser --allow-root \
"

